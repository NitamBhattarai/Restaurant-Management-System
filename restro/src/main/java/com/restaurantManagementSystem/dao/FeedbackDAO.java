package com.restaurantManagementSystem.dao;

import com.restaurantManagementSystem.model.Feedback;
import com.restaurantManagementSystem.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class FeedbackDAO {

    public List<Feedback> findAll() throws SQLException {
        List<Feedback> feedback = new ArrayList<>();
        String sql = "SELECT * FROM guest_feedback ORDER BY created_at DESC, id DESC LIMIT 200";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                feedback.add(mapRow(rs));
            }
        }
        return feedback;
    }

    public int create(Feedback feedback) throws SQLException {
        String sql = "INSERT INTO guest_feedback(guest_name, guest_email, table_number, "
                + "cuisine_rating, service_rating, ambience_rating, overall_rating, comments) "
                + "VALUES(?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, feedback.getGuestName());
            ps.setString(2, feedback.getGuestEmail());
            ps.setString(3, feedback.getTableNumber());
            ps.setInt(4, feedback.getCuisineRating());
            ps.setInt(5, feedback.getServiceRating());
            ps.setInt(6, feedback.getAmbienceRating());
            ps.setInt(7, feedback.getOverallRating());
            ps.setString(8, feedback.getComments());
            ps.executeUpdate();
            try (ResultSet keys = ps.getGeneratedKeys()) {
                if (keys.next()) {
                    return keys.getInt(1);
                }
            }
        }
        return -1;
    }

    public int countPositive(List<Feedback> feedback) {
        int count = 0;
        for (Feedback item : feedback) {
            if ("positive".equals(item.getSentiment())) {
                count++;
            }
        }
        return count;
    }

    public double averageRating(List<Feedback> feedback) {
        if (feedback.isEmpty()) {
            return 0;
        }
        int total = 0;
        for (Feedback item : feedback) {
            total += item.getOverallRating();
        }
        return (double) total / feedback.size();
    }

    private Feedback mapRow(ResultSet rs) throws SQLException {
        Feedback feedback = new Feedback();
        feedback.setId(rs.getInt("id"));
        feedback.setGuestName(rs.getString("guest_name"));
        feedback.setGuestEmail(rs.getString("guest_email"));
        feedback.setTableNumber(rs.getString("table_number"));
        feedback.setCuisineRating(rs.getInt("cuisine_rating"));
        feedback.setServiceRating(rs.getInt("service_rating"));
        feedback.setAmbienceRating(rs.getInt("ambience_rating"));
        feedback.setOverallRating(rs.getInt("overall_rating"));
        feedback.setComments(rs.getString("comments"));
        feedback.setInternalNote(rs.getString("internal_note"));
        feedback.setFlagged(rs.getBoolean("flagged"));
        Timestamp created = rs.getTimestamp("created_at");
        if (created != null) {
            feedback.setCreatedAt(created.toLocalDateTime());
        }
        return feedback;
    }
}
