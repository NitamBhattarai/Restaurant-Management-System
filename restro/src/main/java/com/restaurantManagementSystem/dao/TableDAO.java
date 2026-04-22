package com.restaurantManagementSystem.dao;

import com.restaurantManagementSystem.model.DiningTable;
import com.restaurantManagementSystem.util.DBConnection;

import java.sql.*;
import java.util.*;

/**
 * TableDAO — CRUD operations for dining tables.
 * MVC Role: Model (Data Access Layer)
 */
public class TableDAO {

    // ── READ ──────────────────────────────────────────────

    /** All tables ordered by table number. */
    public List<DiningTable> findAll() throws SQLException {
        List<DiningTable> list = new ArrayList<>();
        String sql = "SELECT id, table_number, capacity, status, qr_token "
                   + "FROM dining_tables ORDER BY table_number";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(mapRow(rs));
        }
        return list;
    }

    /** Find table by its QR token — used on customer menu page. */
    public DiningTable findByQrToken(String token) throws SQLException {
        String sql = "SELECT id, table_number, capacity, status, qr_token "
                   + "FROM dining_tables WHERE qr_token = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, token);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapRow(rs);
            }
        }
        return null;
    }

    /** Find table by primary key. */
    public DiningTable findById(int id) throws SQLException {
        String sql = "SELECT id, table_number, capacity, status, qr_token "
                   + "FROM dining_tables WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapRow(rs);
            }
        }
        return null;
    }

    /** Count tables by status — used for dashboard stats. */
    public int countByStatus(DiningTable.Status status) throws SQLException {
        String sql = "SELECT COUNT(*) FROM dining_tables WHERE status = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status.name());
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getInt(1) : 0;
            }
        }
    }

    // ── UPDATE ────────────────────────────────────────────

    /** Update table status (FREE / OCCUPIED / RESERVED). */
    public boolean updateStatus(int id, DiningTable.Status status) throws SQLException {
        String sql = "UPDATE dining_tables SET status = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status.name());
            ps.setInt(2, id);
            return ps.executeUpdate() > 0;
        }
    }

    // ── CREATE ────────────────────────────────────────────

    /** Add a new table. Returns generated ID. */
    public int create(String tableNumber, int capacity) throws SQLException {
        String token = "tok_" + tableNumber.toLowerCase() + "_gkb2024";
        String sql = "INSERT INTO dining_tables(table_number, capacity, status, qr_token) "
                   + "VALUES(?, ?, 'FREE', ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, tableNumber);
            ps.setInt(2, capacity);
            ps.setString(3, token);
            ps.executeUpdate();
            try (ResultSet gk = ps.getGeneratedKeys()) {
                if (gk.next()) return gk.getInt(1);
            }
        }
        return -1;
    }

    // ── MAPPER ────────────────────────────────────────────

    private DiningTable mapRow(ResultSet rs) throws SQLException {
        return new DiningTable(
            rs.getInt("id"),
            rs.getString("table_number"),
            rs.getInt("capacity"),
            DiningTable.Status.valueOf(rs.getString("status")),
            rs.getString("qr_token")
        );
    }
}

