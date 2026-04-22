package com.restaurantManagementSystem.dao;

import com.restaurantManagementSystem.model.User;
import com.restaurantManagementSystem.util.DBConnection;
import com.restaurantManagementSystem.util.PasswordUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * UserDAO — Data Access Object for User operations.
 * MVC Role: Model (Data Access Layer)
 */
public class UserDAO {

    // ── READ ──────────────────────────────────────────────────────────────

    /** Fetch user by username for login. */
    public User findByUsername(String username) throws SQLException {
        String sql = "SELECT id,full_name,email,username,password,role,active,created_at "
                   + "FROM users WHERE username=? AND active=1";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, username);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapRow(rs);
            }
        }
        return null;
    }

    /** Authenticate: returns User if credentials match, null otherwise. */
    public User authenticate(String username, String plainPassword) throws SQLException {
        User user = findByUsername(username);
        if (user != null && PasswordUtil.verify(plainPassword, user.getPassword())) {
            return user;
        }
        return null;
    }

    /** Get all users. */
    public List<User> findAll() throws SQLException {
        List<User> list = new ArrayList<>();
        String sql = "SELECT id,full_name,email,username,password,role,active,created_at FROM users ORDER BY role,full_name";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(mapRow(rs));
        }
        return list;
    }

    /** Get user by ID. */
    public User findById(int id) throws SQLException {
        String sql = "SELECT id,full_name,email,username,password,role,active,created_at FROM users WHERE id=?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapRow(rs);
            }
        }
        return null;
    }

    // ── CREATE ────────────────────────────────────────────────────────────

    /** Insert new user, returns generated ID. */
    public int create(User user) throws SQLException {
        String sql = "INSERT INTO users(full_name,email,username,password,role,active) VALUES(?,?,?,?,?,?)";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, user.getFullName());
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getUsername());
            ps.setString(4, PasswordUtil.hash(user.getPassword()));
            ps.setString(5, user.getRole().name());
            ps.setBoolean(6, user.isActive());
            ps.executeUpdate();
            try (ResultSet gk = ps.getGeneratedKeys()) {
                if (gk.next()) return gk.getInt(1);
            }
        }
        return -1;
    }

    // ── UPDATE ────────────────────────────────────────────────────────────

    /** Update user details (not password). */
    public boolean update(User user) throws SQLException {
        String sql = "UPDATE users SET full_name=?,email=?,role=?,active=? WHERE id=?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, user.getFullName());
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getRole().name());
            ps.setBoolean(4, user.isActive());
            ps.setInt(5, user.getId());
            return ps.executeUpdate() > 0;
        }
    }

    /** Update password for a user. */
    public boolean updatePassword(int userId, String newPlainPassword) throws SQLException {
        String sql = "UPDATE users SET password=? WHERE id=?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, PasswordUtil.hash(newPlainPassword));
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        }
    }

    // ── DELETE ────────────────────────────────────────────────────────────

    /** Soft-delete: mark user inactive. */
    public boolean deactivate(int userId) throws SQLException {
        String sql = "UPDATE users SET active=0 WHERE id=?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, userId);
            return ps.executeUpdate() > 0;
        }
    }

    // ── VALIDATION ────────────────────────────────────────────────────────

    public boolean usernameExists(String username) throws SQLException {
        String sql = "SELECT 1 FROM users WHERE username=?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, username);
            try (ResultSet rs = ps.executeQuery()) { return rs.next(); }
        }
    }

    public boolean emailExists(String email) throws SQLException {
        String sql = "SELECT 1 FROM users WHERE email=?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) { return rs.next(); }
        }
    }

    // ── MAPPER ────────────────────────────────────────────────────────────

    private User mapRow(ResultSet rs) throws SQLException {
        User u = new User();
        u.setId(rs.getInt("id"));
        u.setFullName(rs.getString("full_name"));
        u.setEmail(rs.getString("email"));
        u.setUsername(rs.getString("username"));
        u.setPassword(rs.getString("password"));
        u.setRole(User.Role.valueOf(rs.getString("role")));
        u.setActive(rs.getBoolean("active"));
        Timestamp ts = rs.getTimestamp("created_at");
        if (ts != null) u.setCreatedAt(ts.toLocalDateTime());
        return u;
    }
}

