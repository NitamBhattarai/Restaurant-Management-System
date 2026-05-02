package com.restaurantManagementSystem.dao;

import com.restaurantManagementSystem.model.Reservation;
import com.restaurantManagementSystem.util.DBConnection;

import java.sql.*;
import java.util.*;

/**
 * ReservationDAO — CRUD operations for table reservations.
 * MVC Role: Model (Data Access Layer)
 */
public class ReservationDAO {

    // ── READ ──────────────────────────────────────────────

    /** All upcoming reservations (not cancelled), ordered by reserved_at ASC. */
    public List<Reservation> findUpcoming() throws SQLException {
        List<Reservation> list = new ArrayList<>();
        String sql = "SELECT r.*, t.table_number "
                + "FROM reservations r "
                + "LEFT JOIN dining_tables t ON r.table_id = t.id "
                + "WHERE r.status != 'CANCELLED' AND r.reserved_at >= NOW() "
                + "ORDER BY r.reserved_at ASC LIMIT 100";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {
            while (rs.next())
                list.add(mapRow(rs));
        }
        return list;
    }

    /** All reservations including past ones — for admin history. */
    public List<Reservation> findAll() throws SQLException {
        List<Reservation> list = new ArrayList<>();
        String sql = "SELECT r.*, t.table_number "
                + "FROM reservations r "
                + "LEFT JOIN dining_tables t ON r.table_id = t.id "
                + "ORDER BY r.reserved_at DESC LIMIT 200";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {
            while (rs.next())
                list.add(mapRow(rs));
        }
        return list;
    }

    /** Find by primary key. */
    public Reservation findById(int id) throws SQLException {
        String sql = "SELECT r.*, t.table_number "
                + "FROM reservations r "
                + "LEFT JOIN dining_tables t ON r.table_id = t.id "
                + "WHERE r.id = ?";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next())
                    return mapRow(rs);
            }
        }
        return null;
    }

    // ── CREATE ────────────────────────────────────────────

    /** Insert a new reservation. Returns generated ID. */
    public int create(Reservation res) throws SQLException {
        String sql = "INSERT INTO reservations(table_id, party_size, reserved_at, status, notes) "
                + "VALUES(?, ?, ?, 'PENDING', ?)";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            if (res.getTableId() != null)
                ps.setInt(1, res.getTableId());
            else
                ps.setNull(1, Types.INTEGER);
            ps.setInt(2, res.getPartySize());
            ps.setTimestamp(3, res.getReservedAt() != null
                    ? Timestamp.valueOf(res.getReservedAt())
                    : null);
            ps.setString(4, res.getNotes());
            ps.executeUpdate();
            try (ResultSet gk = ps.getGeneratedKeys()) {
                if (gk.next())
                    return gk.getInt(1);
            }
        }
        return -1;
    }

    // ── UPDATE ────────────────────────────────────────────

    /** Update reservation status. */
    public boolean updateStatus(int id, Reservation.Status status) throws SQLException {
        String sql = "UPDATE reservations SET status = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status.name());
            ps.setInt(2, id);
            return ps.executeUpdate() > 0;
        }
    }

    /** Update full reservation details. */
    public boolean update(Reservation res) throws SQLException {
        String sql = "UPDATE reservations SET table_id=?, party_size=?, reserved_at=?, status=?, notes=? WHERE id=?";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            if (res.getTableId() != null)
                ps.setInt(1, res.getTableId());
            else
                ps.setNull(1, Types.INTEGER);
            ps.setInt(2, res.getPartySize());
            ps.setTimestamp(3, res.getReservedAt() != null
                    ? Timestamp.valueOf(res.getReservedAt())
                    : null);
            ps.setString(4, res.getStatus().name());
            ps.setString(5, res.getNotes());
            ps.setInt(6, res.getId());
            return ps.executeUpdate() > 0;
        }
    }

    // ── DELETE ────────────────────────────────────────────

    /** Soft-delete: mark as CANCELLED. */
    public boolean cancel(int id) throws SQLException {
        return updateStatus(id, Reservation.Status.CANCELLED);
    }

    // ── MAPPER ────────────────────────────────────────────

    private Reservation mapRow(ResultSet rs) throws SQLException {
        Reservation r = new Reservation();
        r.setId(rs.getInt("id"));
        int tid = rs.getInt("table_id");
        r.setTableId(rs.wasNull() ? null : tid);
        r.setTableNumber(rs.getString("table_number"));
        r.setPartySize(rs.getInt("party_size"));
        Timestamp rat = rs.getTimestamp("reserved_at");
        if (rat != null)
            r.setReservedAt(rat.toLocalDateTime());
        r.setStatus(Reservation.Status.valueOf(rs.getString("status")));
        r.setNotes(rs.getString("notes"));
        Timestamp cat = rs.getTimestamp("created_at");
        if (cat != null)
            r.setCreatedAt(cat.toLocalDateTime());
        return r;
    }
}
