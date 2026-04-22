package com.restaurantManagementSystem.model;

import java.time.LocalDateTime;

/**
 * Reservation — a guest's advance booking for a table.
 * MVC Role: Model — maps to reservations table
 */
public class Reservation {

    public enum Status { PENDING, CONFIRMED, CANCELLED, COMPLETED }

    private int id;
    private String guestName;
    private String guestPhone;
    private String guestEmail;
    private Integer tableId;
    private String tableNumber;
    private int partySize;
    private LocalDateTime reservedAt;
    private Status status;
    private String notes;
    private LocalDateTime createdAt;

    public Reservation() {}

    // ── Getters & Setters ──────────────────────────────────

    public int getId()                          { return id; }
    public void setId(int v)                    { this.id = v; }

    public String getGuestName()                { return guestName; }
    public void setGuestName(String v)          { this.guestName = v; }

    public String getGuestPhone()               { return guestPhone; }
    public void setGuestPhone(String v)         { this.guestPhone = v; }

    public String getGuestEmail()               { return guestEmail; }
    public void setGuestEmail(String v)         { this.guestEmail = v; }

    public Integer getTableId()                 { return tableId; }
    public void setTableId(Integer v)           { this.tableId = v; }

    public String getTableNumber()              { return tableNumber; }
    public void setTableNumber(String v)        { this.tableNumber = v; }

    public int getPartySize()                   { return partySize; }
    public void setPartySize(int v)             { this.partySize = v; }

    public LocalDateTime getReservedAt()        { return reservedAt; }
    public void setReservedAt(LocalDateTime v)  { this.reservedAt = v; }

    public Status getStatus()                   { return status; }
    public void setStatus(Status v)             { this.status = v; }

    public String getNotes()                    { return notes; }
    public void setNotes(String v)              { this.notes = v; }

    public LocalDateTime getCreatedAt()         { return createdAt; }
    public void setCreatedAt(LocalDateTime v)   { this.createdAt = v; }
}

