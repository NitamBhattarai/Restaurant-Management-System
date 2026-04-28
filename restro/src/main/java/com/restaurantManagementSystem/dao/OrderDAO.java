package com.restaurantManagementSystem.dao;

import com.restaurantManagementSystem.model.*;
import com.restaurantManagementSystem.util.DBConnection;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.sql.*;
import java.time.LocalDate;
import java.util.*;

/**
 * OrderDAO — all database operations for orders and order items.
 * Handles transactional order creation (order + items + bill in one tx).
 * MVC Role: Model (Data Access Layer)
 */
public class OrderDAO {

    // ── CREATE ────────────────────────────────────────────

    /**
     * Create a new order with its items inside a single transaction.
     * Also marks the table as OCCUPIED and auto-generates the bill.
     *
     * @param order Order object with tableId and items populated
     * @return generated order ID, or -1 on failure
     */
    public int createOrder(Order order) throws SQLException {
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            // 1. Generate unique order code (e.g. ORD-20241215-007)
            String code = generateOrderCode(conn);

            // 2. Insert order header
            int orderId;
            String orderSql = "INSERT INTO orders(order_code, table_id, waiter_id, status, notes, ordered_at) "
                    + "VALUES(?, ?, ?, 'PENDING', ?, NOW())";
            try (PreparedStatement ps = conn.prepareStatement(orderSql, Statement.RETURN_GENERATED_KEYS)) {
                ps.setString(1, code);
                ps.setInt(2, order.getTableId());
                if (order.getWaiterId() != null)
                    ps.setInt(3, order.getWaiterId());
                else
                    ps.setNull(3, Types.INTEGER);
                ps.setString(4, order.getNotes());
                ps.executeUpdate();
                try (ResultSet gk = ps.getGeneratedKeys()) {
                    if (!gk.next())
                        throw new SQLException("Failed to get order ID");
                    orderId = gk.getInt(1);
                }
            }

            // 3. Insert order items (batch for performance)
            String itemSql = "INSERT INTO order_items(order_id, menu_item_id, quantity, unit_price, special_note) "
                    + "VALUES(?, ?, ?, ?, ?)";
            try (PreparedStatement ps = conn.prepareStatement(itemSql)) {
                for (OrderItem item : order.getItems()) {
                    ps.setInt(1, orderId);
                    ps.setInt(2, item.getMenuItemId());
                    ps.setInt(3, item.getQuantity());
                    ps.setBigDecimal(4, item.getUnitPrice());
                    ps.setString(5, item.getSpecialNote());
                    ps.addBatch();
                }
                ps.executeBatch();
            }

            // 4. Mark table as OCCUPIED
            try (PreparedStatement ps = conn.prepareStatement(
                    "UPDATE dining_tables SET status='OCCUPIED' WHERE id=?")) {
                ps.setInt(1, order.getTableId());
                ps.executeUpdate();
            }

            // 5. Auto-generate bill
            autoGenerateBill(conn, orderId);

            conn.commit();
            return orderId;

        } catch (SQLException e) {
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ignored) {
                }
            }
            throw e;
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                } catch (SQLException ignored) {
                }
                DBConnection.close(conn);
            }
        }
    }

    // ── READ ──────────────────────────────────────────────

    /**
     * All active (non-served, non-cancelled) orders — for kitchen and admin
     * overview.
     */
    public List<Order> findActive() throws SQLException {
        String sql = BASE_SQL + " WHERE o.status NOT IN ('SERVED','CANCELLED') ORDER BY o.ordered_at";
        return executeQuery(sql);
    }

    /** All orders — for admin management page. */
    public List<Order> findAll() throws SQLException {
        String sql = BASE_SQL + " ORDER BY o.ordered_at DESC LIMIT 500";
        return executeQuery(sql);
    }

    /** Orders for a specific table that are not served/cancelled. */
    public List<Order> findActiveByTableId(int tableId) throws SQLException {
        String sql = BASE_SQL + " WHERE o.table_id=? AND o.status NOT IN ('SERVED','CANCELLED') "
                + "ORDER BY o.ordered_at DESC";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, tableId);
            return mapResultSet(ps.executeQuery());
        }
    }

    /** Served orders awaiting payment — for billing page. */
    public List<Order> findServed() throws SQLException {
        String sql = BASE_SQL + " WHERE o.status = 'SERVED' ORDER BY o.ordered_at DESC";
        return executeQuery(sql);
    }

    /** Single order with all items loaded. */
    public Order findByIdWithItems(int orderId) throws SQLException {
        String sql = BASE_SQL + " WHERE o.id=?";
        Order order = null;
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            List<Order> results = mapResultSet(ps.executeQuery());
            if (!results.isEmpty())
                order = results.get(0);
        }
        if (order != null)
            order.setItems(findOrderItems(orderId));
        return order;
    }

    /** Load items for a given order ID. Used by KitchenController. */
    public List<OrderItem> findOrderItems(int orderId) throws SQLException {
        List<OrderItem> items = new ArrayList<>();
        String sql = "SELECT oi.*, m.name AS item_name, m.emoji "
                + "FROM order_items oi JOIN menu_items m ON oi.menu_item_id = m.id "
                + "WHERE oi.order_id = ?";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    OrderItem oi = new OrderItem();
                    oi.setId(rs.getInt("id"));
                    oi.setOrderId(orderId);
                    oi.setMenuItemId(rs.getInt("menu_item_id"));
                    oi.setMenuItemName(rs.getString("item_name"));
                    oi.setMenuItemEmoji(rs.getString("emoji"));
                    oi.setQuantity(rs.getInt("quantity"));
                    oi.setUnitPrice(rs.getBigDecimal("unit_price"));
                    oi.setSpecialNote(rs.getString("special_note"));
                    items.add(oi);
                }
            }
        }
        return items;
    }

    // ── UPDATE ────────────────────────────────────────────

    /** Update order status. Used by admin and kitchen AJAX. */
    public boolean updateStatus(int orderId, Order.Status status) throws SQLException {
        String sql = "UPDATE orders SET status = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status.name());
            ps.setInt(2, orderId);
            return ps.executeUpdate() > 0;
        }
    }

    // ── REPORTING ─────────────────────────────────────────

    /** Today's total revenue from served orders. */
    public BigDecimal getTodayRevenue() throws SQLException {
        String sql = "SELECT COALESCE(SUM(b.total), 0) FROM bills b "
                + "JOIN orders o ON b.order_id = o.id "
                + "WHERE DATE(o.ordered_at) = CURDATE() AND o.status = 'SERVED'";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {
            return rs.next() ? rs.getBigDecimal(1) : BigDecimal.ZERO;
        }
    }

    /** Count of all orders today (excluding cancelled). */
    public int getTodayOrderCount() throws SQLException {
        String sql = "SELECT COUNT(*) FROM orders "
                + "WHERE DATE(ordered_at) = CURDATE() AND status != 'CANCELLED'";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {
            return rs.next() ? rs.getInt(1) : 0;
        }
    }

    /** Count orders in PENDING status. */
    public int getPendingCount() throws SQLException {
        String sql = "SELECT COUNT(*) FROM orders WHERE status = 'PENDING'";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {
            return rs.next() ? rs.getInt(1) : 0;
        }
    }

    // ── PRIVATE HELPERS ───────────────────────────────────

    private static final String BASE_SQL = "SELECT o.*, t.table_number, u.full_name AS waiter_name "
            + "FROM orders o "
            + "JOIN dining_tables t ON o.table_id = t.id "
            + "LEFT JOIN users u ON o.waiter_id = u.id";

    private List<Order> executeQuery(String sql) throws SQLException {
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {
            return mapResultSet(rs);
        }
    }

    private List<Order> mapResultSet(ResultSet rs) throws SQLException {
        List<Order> list = new ArrayList<>();
        while (rs.next())
            list.add(mapOrderRow(rs));
        return list;
    }

    private Order mapOrderRow(ResultSet rs) throws SQLException {
        Order o = new Order();
        o.setId(rs.getInt("id"));
        o.setOrderCode(rs.getString("order_code"));
        o.setTableId(rs.getInt("table_id"));
        o.setTableNumber(rs.getString("table_number"));
        int wid = rs.getInt("waiter_id");
        o.setWaiterId(rs.wasNull() ? null : wid);
        o.setWaiterName(rs.getString("waiter_name"));
        o.setStatus(Order.Status.valueOf(rs.getString("status")));
        o.setNotes(rs.getString("notes"));
        Timestamp ts = rs.getTimestamp("ordered_at");
        if (ts != null)
            o.setOrderedAt(ts.toLocalDateTime());
        return o;
    }

    private String generateOrderCode(Connection conn) throws SQLException {
        String dateStr = LocalDate.now().toString().replace("-", "");
        String sql = "SELECT COUNT(*) + 1 FROM orders WHERE DATE(ordered_at) = CURDATE()";
        try (PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {
            int seq = rs.next() ? rs.getInt(1) : 1;
            return String.format("ORD-%s-%03d", dateStr, seq);
        }
    }

    private void autoGenerateBill(Connection conn, int orderId) throws SQLException {
        // Calculate subtotal from order items
        String sumSql = "SELECT COALESCE(SUM(quantity * unit_price), 0) FROM order_items WHERE order_id = ?";
        BigDecimal subtotal;
        try (PreparedStatement ps = conn.prepareStatement(sumSql)) {
            ps.setInt(1, orderId);
            try (ResultSet rs = ps.executeQuery()) {
                subtotal = rs.next() ? rs.getBigDecimal(1) : BigDecimal.ZERO;
            }
        }

        BigDecimal vatRate = new BigDecimal("13.00");
        BigDecimal serviceRate = new BigDecimal("10.00");
        BigDecimal vatAmt = subtotal.multiply(vatRate)
                .divide(BigDecimal.valueOf(100), 2, RoundingMode.HALF_UP);
        BigDecimal svcAmt = subtotal.multiply(serviceRate)
                .divide(BigDecimal.valueOf(100), 2, RoundingMode.HALF_UP);
        BigDecimal total = subtotal.add(vatAmt).add(svcAmt);

        String billSql = "INSERT INTO bills(order_id, subtotal, vat_rate, vat_amount, "
                + "service_rate, service_amount, total) VALUES(?,?,?,?,?,?,?)";
        try (PreparedStatement ps = conn.prepareStatement(billSql)) {
            ps.setInt(1, orderId);
            ps.setBigDecimal(2, subtotal);
            ps.setBigDecimal(3, vatRate);
            ps.setBigDecimal(4, vatAmt);
            ps.setBigDecimal(5, serviceRate);
            ps.setBigDecimal(6, svcAmt);
            ps.setBigDecimal(7, total);
            ps.executeUpdate();
        }
    }
}
