package com.restaurantManagementSystem.model;

import java.time.LocalDateTime;

/**
 * User — represents a system user (Admin, Staff, Kitchen).
 * MVC Role: Model
 */
public class User {
    private int id;
    private String fullName;
    private String email;
    private String username;
    private String password;  // BCrypt hash
    private Role role;
    private boolean active;
    private LocalDateTime createdAt;

    public enum Role { ADMIN, STAFF, KITCHEN }

    public User() {}

    public User(int id, String fullName, String email, String username, Role role, boolean active) {
        this.id = id; this.fullName = fullName; this.email = email;
        this.username = username; this.role = role; this.active = active;
    }

    // Getters & Setters
    public int getId()                  { return id; }
    public void setId(int id)           { this.id = id; }
    public String getFullName()         { return fullName; }
    public void setFullName(String v)   { this.fullName = v; }
    public String getEmail()            { return email; }
    public void setEmail(String v)      { this.email = v; }
    public String getUsername()         { return username; }
    public void setUsername(String v)   { this.username = v; }
    public String getPassword()         { return password; }
    public void setPassword(String v)   { this.password = v; }
    public Role getRole()               { return role; }
    public void setRole(Role v)         { this.role = v; }
    public boolean isActive()           { return active; }
    public void setActive(boolean v)    { this.active = v; }
    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime v) { this.createdAt = v; }

    /** Initials for avatar display (e.g. "Nitam Bhattarai" → "NB") */
    public String getInitials() {
        if (fullName == null || fullName.isBlank()) return "?";
        String[] parts = fullName.trim().split("\\s+");
        if (parts.length == 1) return parts[0].substring(0, 1).toUpperCase();
        return (parts[0].substring(0,1) + parts[parts.length-1].substring(0,1)).toUpperCase();
    }
}

