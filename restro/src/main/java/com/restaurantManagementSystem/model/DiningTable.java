package com.restaurantManagementSystem.model;

/**
 * DiningTable — represents a physical restaurant table.
 * MVC Role: Model
 */
public class DiningTable {
    private int id;
    private String tableNumber;
    private int capacity;
    private Status status;
    private String qrToken;

    public enum Status { FREE, OCCUPIED, RESERVED }

    public DiningTable() {}
    public DiningTable(int id, String tableNumber, int capacity, Status status, String qrToken) {
        this.id = id; this.tableNumber = tableNumber; this.capacity = capacity;
        this.status = status; this.qrToken = qrToken;
    }

    public int getId()               { return id; }
    public void setId(int v)         { this.id = v; }
    public String getTableNumber()   { return tableNumber; }
    public void setTableNumber(String v) { this.tableNumber = v; }
    public int getCapacity()         { return capacity; }
    public void setCapacity(int v)   { this.capacity = v; }
    public Status getStatus()        { return status; }
    public void setStatus(Status v)  { this.status = v; }
    public String getQrToken()       { return qrToken; }
    public void setQrToken(String v) { this.qrToken = v; }
}

