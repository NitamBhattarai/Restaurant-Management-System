package com.restaurantManagementSystem.dao;

import com.restaurantManagementSystem.model.Category;
import com.restaurantManagementSystem.util.DBConnection;

import java.sql.*;
import java.util.*;

/**
 * CategoryDAO — manages menu categories (Starters, Mains, Drinks, Desserts).
 * MVC Role: Model (Data Access Layer)
 */
public class CategoryDAO {

    public List<Category> findAll() throws SQLException {
        List<Category> list = new ArrayList<>();
        String sql = "SELECT id, name, display_order, active FROM categories ORDER BY display_order";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(mapRow(rs));
        }
        return list;
    }

    public List<Category> findActive() throws SQLException {
        List<Category> list = new ArrayList<>();
        String sql = "SELECT id, name, display_order, active FROM categories WHERE active=1 ORDER BY display_order";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(mapRow(rs));
        }
        return list;
    }

    public Category findById(int id) throws SQLException {
        String sql = "SELECT id, name, display_order, active FROM categories WHERE id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapRow(rs);
            }
        }
        return null;
    }

    public int create(Category cat) throws SQLException {
        String sql = "INSERT INTO categories(name, display_order, active) VALUES(?,?,1)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, cat.getName());
            ps.setInt(2, cat.getDisplayOrder());
            ps.executeUpdate();
            try (ResultSet gk = ps.getGeneratedKeys()) {
                if (gk.next()) return gk.getInt(1);
            }
        }
        return -1;
    }

    public boolean update(Category cat) throws SQLException {
        String sql = "UPDATE categories SET name=?, display_order=?, active=? WHERE id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, cat.getName());
            ps.setInt(2, cat.getDisplayOrder());
            ps.setBoolean(3, cat.isActive());
            ps.setInt(4, cat.getId());
            return ps.executeUpdate() > 0;
        }
    }

    private Category mapRow(ResultSet rs) throws SQLException {
        Category c = new Category();
        c.setId(rs.getInt("id"));
        c.setName(rs.getString("name"));
        c.setDisplayOrder(rs.getInt("display_order"));
        c.setActive(rs.getBoolean("active"));
        return c;
    }
}

