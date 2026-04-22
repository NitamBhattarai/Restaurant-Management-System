package com.restaurantManagementSystem.dao;

import com.restaurantManagementSystem.model.Bill;
import com.restaurantManagementSystem.util.DBConnection;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.sql.*;

/**
 * BillDAO — read and update bill records.
 * MVC Role: Model (Data Access Layer)
 */
public class BillDAO {

    /** Find the bill for a given order ID. */
    public Bill findByOrderId(int orderId) throws SQLException {
        String sql = "SELECT b.*, o.order_code, t.table_number "
                   + "FROM bills b "
                   + "JOIN orders o ON b.order_id = o.id "
                   + "JOIN dining_tables t ON o.table_id = t.id "
                   + "WHERE b.order_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapRow(rs);
            }
        }
        return null;
    }

    /** Find bill by bill ID. */
    public Bill findById(int billId) throws SQLException {
        String sql = "SELECT b.*, o.order_code, t.table_number "
                   + "FROM bills b "
                   + "JOIN orders o ON b.order_id = o.id "
                   + "JOIN dining_tables t ON o.table_id = t.id "
                   + "WHERE b.id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, billId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapRow(rs);
            }
        }
        return null;
    }

    /**
     * Apply a percentage discount to a bill and recalculate totals.
     * Recalculates VAT and service charge on the discounted subtotal.
     */
    public boolean applyDiscount(int billId, BigDecimal discountPct) throws SQLException {
        // Fetch current bill data
        String getSql = "SELECT subtotal, vat_rate, service_rate FROM bills WHERE id = ?";
        BigDecimal subtotal, vatRate, svcRate;
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(getSql)) {
            ps.setInt(1, billId);
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) return false;
                subtotal = rs.getBigDecimal("subtotal");
                vatRate  = rs.getBigDecimal("vat_rate");
                svcRate  = rs.getBigDecimal("service_rate");
            }
        }

        // Recalculate
        BigDecimal discAmt    = subtotal.multiply(discountPct)
                                        .divide(BigDecimal.valueOf(100), 2, RoundingMode.HALF_UP);
        BigDecimal discounted = subtotal.subtract(discAmt);
        BigDecimal vatAmt     = discounted.multiply(vatRate)
                                          .divide(BigDecimal.valueOf(100), 2, RoundingMode.HALF_UP);
        BigDecimal svcAmt     = discounted.multiply(svcRate)
                                          .divide(BigDecimal.valueOf(100), 2, RoundingMode.HALF_UP);
        BigDecimal total      = discounted.add(vatAmt).add(svcAmt);

        String updSql = "UPDATE bills SET discount_pct=?, discount_amt=?, "
                      + "vat_amount=?, service_amount=?, total=? WHERE id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(updSql)) {
            ps.setBigDecimal(1, discountPct);
            ps.setBigDecimal(2, discAmt);
            ps.setBigDecimal(3, vatAmt);
            ps.setBigDecimal(4, svcAmt);
            ps.setBigDecimal(5, total);
            ps.setInt(6, billId);
            return ps.executeUpdate() > 0;
        }
    }

    // ── MAPPER ────────────────────────────────────────────

    private Bill mapRow(ResultSet rs) throws SQLException {
        Bill b = new Bill();
        b.setId(rs.getInt("id"));
        b.setOrderId(rs.getInt("order_id"));
        b.setOrderCode(rs.getString("order_code"));
        b.setTableNumber(rs.getString("table_number"));
        b.setSubtotal(rs.getBigDecimal("subtotal"));
        b.setVatRate(rs.getBigDecimal("vat_rate"));
        b.setVatAmount(rs.getBigDecimal("vat_amount"));
        b.setServiceRate(rs.getBigDecimal("service_rate"));
        b.setServiceAmount(rs.getBigDecimal("service_amount"));
        b.setDiscountPct(rs.getBigDecimal("discount_pct"));
        b.setDiscountAmt(rs.getBigDecimal("discount_amt"));
        b.setTotal(rs.getBigDecimal("total"));
        Timestamp ts = rs.getTimestamp("generated_at");
        if (ts != null) b.setGeneratedAt(ts.toLocalDateTime());
        return b;
    }
}

