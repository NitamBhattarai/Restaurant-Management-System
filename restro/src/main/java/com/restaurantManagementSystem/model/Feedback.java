package com.restaurantManagementSystem.model;

import java.time.LocalDateTime;

public class Feedback {
    private int id;
    private String guestName;
    private String guestEmail;
    private String tableNumber;
    private int cuisineRating;
    private int serviceRating;
    private int ambienceRating;
    private int overallRating;
    private String comments;
    private String internalNote;
    private boolean flagged;
    private LocalDateTime createdAt;

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getGuestName() { return guestName; }
    public void setGuestName(String guestName) { this.guestName = guestName; }

    public String getGuestEmail() { return guestEmail; }
    public void setGuestEmail(String guestEmail) { this.guestEmail = guestEmail; }

    public String getTableNumber() { return tableNumber; }
    public void setTableNumber(String tableNumber) { this.tableNumber = tableNumber; }

    public int getCuisineRating() { return cuisineRating; }
    public void setCuisineRating(int cuisineRating) { this.cuisineRating = cuisineRating; }

    public int getServiceRating() { return serviceRating; }
    public void setServiceRating(int serviceRating) { this.serviceRating = serviceRating; }

    public int getAmbienceRating() { return ambienceRating; }
    public void setAmbienceRating(int ambienceRating) { this.ambienceRating = ambienceRating; }

    public int getOverallRating() { return overallRating; }
    public void setOverallRating(int overallRating) { this.overallRating = overallRating; }

    public String getComments() { return comments; }
    public void setComments(String comments) { this.comments = comments; }

    public String getInternalNote() { return internalNote; }
    public void setInternalNote(String internalNote) { this.internalNote = internalNote; }

    public boolean isFlagged() { return flagged; }
    public void setFlagged(boolean flagged) { this.flagged = flagged; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

    public String getInitials() {
        if (guestName == null || guestName.isBlank()) {
            return "G";
        }
        String[] parts = guestName.trim().split("\\s+");
        if (parts.length == 1) {
            return parts[0].substring(0, 1).toUpperCase();
        }
        return (parts[0].substring(0, 1) + parts[parts.length - 1].substring(0, 1)).toUpperCase();
    }

    public String getSentiment() {
        if (overallRating >= 4) {
            return "positive";
        }
        if (overallRating == 3) {
            return "neutral";
        }
        return "critical";
    }
}
