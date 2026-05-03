package com.restaurantManagementSystem.dao;

import com.restaurantManagementSystem.model.MenuItem;
import com.restaurantManagementSystem.util.DBConnection;

import java.sql.*;
import java.util.*;

/**
 * MenuItemDAO — CRUD operations for menu items.
 * MVC Role: Model (Data Access Layer)
 */
public class MenuItemDAO {

    // ── READ ──────────────────────────────────────────────

    /** All items (including unavailable) — for admin management. */
    public List<MenuItem> findAll() throws SQLException {
        List<MenuItem> list = new ArrayList<>();
        String sql = "SELECT m.*, c.name AS cat_name "
                   + "FROM menu_items m JOIN categories c ON m.category_id = c.id "
                   + "ORDER BY c.display_order, m.name";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(mapRow(rs));
        }
        return list;
    }

    /** Available items only — for customer menu. */
    public List<MenuItem> findAvailable() throws SQLException {
        List<MenuItem> list = new ArrayList<>();
        String sql = "SELECT m.*, c.name AS cat_name "
                   + "FROM menu_items m JOIN categories c ON m.category_id = c.id "
                   + "WHERE m.available = 1 ORDER BY c.display_order, m.name";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(mapRow(rs));
        }
        return list;
    }

    /**
     * Returns available items grouped by category name.
     * Used by CustomerController to pass ${menuByCategory} to menu.jsp.
     * Preserves category display order via LinkedHashMap.
     */
    public Map<String, List<MenuItem>> findGroupedByCategory() throws SQLException {
        Map<String, List<MenuItem>> map = new LinkedHashMap<>();
        for (MenuItem item : findAvailable()) {
            map.computeIfAbsent(item.getCategoryName(), k -> new ArrayList<>()).add(item);
        }
        return map;
    }

    /** Find a single item by ID. */
    public MenuItem findById(int id) throws SQLException {
        String sql = "SELECT m.*, c.name AS cat_name "
                   + "FROM menu_items m JOIN categories c ON m.category_id = c.id "
                   + "WHERE m.id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapRow(rs);
            }
        }
        return null;
    }

    // ── CREATE ────────────────────────────────────────────

    /** Insert a new menu item. Returns generated ID. */
    public int create(MenuItem item) throws SQLException {
        String sql = "INSERT INTO menu_items(category_id, name, description, price, emoji, image_url, available) "
                   + "VALUES(?, ?, ?, ?, ?, ?, 1)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, item.getCategoryId());
            ps.setString(2, item.getName());
            ps.setString(3, item.getDescription());
            ps.setBigDecimal(4, item.getPrice());
            ps.setString(5, item.getEmoji() != null ? item.getEmoji() : "Food");
            ps.setString(6, item.getImageUrl());
            ps.executeUpdate();
            try (ResultSet gk = ps.getGeneratedKeys()) {
                if (gk.next()) return gk.getInt(1);
            }
        }
        return -1;
    }

    // ── UPDATE ────────────────────────────────────────────

    /** Update an existing item's details. */
    public boolean update(MenuItem item) throws SQLException {
        String sql = "UPDATE menu_items "
                   + "SET category_id=?, name=?, description=?, price=?, emoji=?, image_url=?, available=? "
                   + "WHERE id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, item.getCategoryId());
            ps.setString(2, item.getName());
            ps.setString(3, item.getDescription());
            ps.setBigDecimal(4, item.getPrice());
            ps.setString(5, item.getEmoji());
            ps.setString(6, item.getImageUrl());
            ps.setBoolean(7, item.isAvailable());
            ps.setInt(8, item.getId());
            return ps.executeUpdate() > 0;
        }
    }

    // ── DELETE ─────────────────────────────────────

    /** Permanently remove a menu item from the system. */
    public boolean delete(int id) throws SQLException {
        String sql = "DELETE FROM menu_items WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        }
    }

    // ── MAPPER ────────────────────────────────────────────

    private MenuItem mapRow(ResultSet rs) throws SQLException {
        MenuItem m = new MenuItem();
        m.setId(rs.getInt("id"));
        m.setCategoryId(rs.getInt("category_id"));
        m.setCategoryName(rs.getString("cat_name"));
        m.setName(rs.getString("name"));
        m.setDescription(rs.getString("description"));
        m.setPrice(rs.getBigDecimal("price"));
        m.setEmoji(rs.getString("emoji"));
        m.setImageUrl(rs.getString("image_url"));
        m.setAvailable(rs.getBoolean("available"));
        return m;
    }
}

