package com.restaurantManagementSystem.dao;

import com.restaurantManagementSystem.model.Payment;
import com.restaurantManagementSystem.util.DBConnection;

import java.math.BigDecimal;
import java.sql.*;
import java.util.*;

/**
 * PaymentDAO — record and query payment transactions.
 * MVC Role: Model (Data Access Layer)
 */
public class PaymentDAO {

    // ── CREATE ────────────────────────────────────────────

    /**
     * Record a new payment for a bill.
     * Sets paid_at to NOW() on the database side.
     * @return generated payment ID, or -1 on failure
     */
    public int create(Payment payment) throws SQLException {
        String sql = "INSERT INTO payments(bill_id, amount_paid, method, status, "
                   + "transaction_ref, processed_by, paid_at) "
                   + "VALUES(?, ?, ?, 'PAID', ?, ?, NOW())";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, payment.getBillId());
            ps.setBigDecimal(2, payment.getAmountPaid());
            ps.setString(3, payment.getMethod().name());
            ps.setString(4, payment.getTransactionRef());
            if (payment.getProcessedById() != null) ps.setInt(5, payment.getProcessedById());
            else                                     ps.setNull(5, Types.INTEGER);
            ps.executeUpdate();
            try (ResultSet gk = ps.getGeneratedKeys()) {
                if (gk.next()) return gk.getInt(1);
            }
        }
        return -1;
    }

    // ── READ ──────────────────────────────────────────────

    /** All payment records — for admin payments page. */
    public List<Payment> findAll() throws SQLException {
        List<Payment> list = new ArrayList<>();
        String sql = "SELECT p.*, o.order_code, t.table_number, u.full_name AS staff_name "
                   + "FROM payments p "
                   + "JOIN bills b ON p.bill_id = b.id "
                   + "JOIN orders o ON b.order_id = o.id "
                   + "JOIN dining_tables t ON o.table_id = t.id "
                   + "LEFT JOIN users u ON p.processed_by = u.id "
                   + "ORDER BY p.created_at DESC LIMIT 200";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(mapRow(rs));
        }
        return list;
    }

    /** Today's total amount paid. */
    public BigDecimal getTodayTotal() throws SQLException {
        String sql = "SELECT COALESCE(SUM(amount_paid), 0) FROM payments "
                   + "WHERE DATE(paid_at) = CURDATE() AND status = 'PAID'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            return rs.next() ? rs.getBigDecimal(1) : BigDecimal.ZERO;
        }
    }

    /** Payment method breakdown as percentages for reports. */
    public Map<String, Long> getMethodCounts() throws SQLException {
        Map<String, Long> counts = new LinkedHashMap<>();
        String sql = "SELECT method, COUNT(*) AS cnt FROM payments "
                   + "WHERE status='PAID' GROUP BY method ORDER BY cnt DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                counts.put(rs.getString("method"), rs.getLong("cnt"));
            }
        }
        return counts;
    }

    // ── MAPPER ────────────────────────────────────────────

    private Payment mapRow(ResultSet rs) throws SQLException {
        Payment p = new Payment();
        p.setId(rs.getInt("id"));
        p.setBillId(rs.getInt("bill_id"));
        p.setOrderCode(rs.getString("order_code"));
        p.setTableNumber(rs.getString("table_number"));
        p.setAmountPaid(rs.getBigDecimal("amount_paid"));
        p.setMethod(Payment.Method.valueOf(rs.getString("method")));
        p.setStatus(Payment.Status.valueOf(rs.getString("status")));
        p.setTransactionRef(rs.getString("transaction_ref"));
        p.setProcessedByName(rs.getString("staff_name"));
        Timestamp ts = rs.getTimestamp("paid_at");
        if (ts != null) p.setPaidAt(ts.toLocalDateTime());
        Timestamp cts = rs.getTimestamp("created_at");
        if (cts != null) p.setCreatedAt(cts.toLocalDateTime());
        return p;
    }
}

