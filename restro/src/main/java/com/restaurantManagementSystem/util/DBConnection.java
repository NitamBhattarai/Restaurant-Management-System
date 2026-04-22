package com.restaurantManagementSystem.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * DBConnection — Utility class for obtaining JDBC connections.
 * In production this would use a connection pool (e.g. HikariCP).
 *
 * MVC Role: Utility / Infrastructure
 */
public class DBConnection {

    private static final String URL      = "jdbc:mysql://localhost:3306/restaurant_management_system";
    private static final String USER     = "root";
    private static final String PASSWORD = "1234"; // update for your environment

    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new RuntimeException("MySQL JDBC Driver not found", e);
        }
    }

    /**
     * Returns a new JDBC Connection.
     * Caller is responsible for closing it (use try-with-resources).
     */
    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }

    /** Silently close a connection (null-safe). */
    public static void close(Connection conn) {
        if (conn != null) {
            try { conn.close(); } catch (SQLException ignored) {}
        }
    }
}

