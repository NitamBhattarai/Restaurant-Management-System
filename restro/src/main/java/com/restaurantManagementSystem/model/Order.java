package com.restaurantManagementSystem.model;

import java.time.LocalDateTime;
import java.util.List;

/**
 * Order — represents a customer order placed at a table.
 * MVC Role: Model — maps to orders table
 */
public class Order {

    public enum Status {
        PENDING, PREPARING, READY, SERVED, CANCELLED
    }

    private int id;
    private String orderCode;
    private int tableId;
    private String tableNumber;
    private Integer waiterId;
    private String waiterName;
    private Status status;
    private String notes;
    private LocalDateTime orderedAt;
    private List<OrderItem> items; // loaded via JOIN in DAO

    public Order() {
    }

    // ── Getters & Setters ──────────────────────────────────

    public int getId() {
        return id;
    }

    public void setId(int v) {
        this.id = v;
    }

    public String getOrderCode() {
        return orderCode;
    }

    public void setOrderCode(String v) {
        this.orderCode = v;
    }

    public int getTableId() {
        return tableId;
    }

    public void setTableId(int v) {
        this.tableId = v;
    }

    public String getTableNumber() {
        return tableNumber;
    }

    public void setTableNumber(String v) {
        this.tableNumber = v;
    }

    public Integer getWaiterId() {
        return waiterId;
    }

    public void setWaiterId(Integer v) {
        this.waiterId = v;
    }

    public String getWaiterName() {
        return waiterName;
    }

    public void setWaiterName(String v) {
        this.waiterName = v;
    }

    public Status getStatus() {
        return status;
    }

    public void setStatus(Status v) {
        this.status = v;
    }

    public String getNotes() {
        return notes;
    }

    public void setNotes(String v) {
        this.notes = v;
    }

    public LocalDateTime getOrderedAt() {
        return orderedAt;
    }

    public void setOrderedAt(LocalDateTime v) {
        this.orderedAt = v;
    }

    public List<OrderItem> getItems() {
        return items;
    }

    public void setItems(List<OrderItem> v) {
        this.items = v;
    }

    /** Total quantity of items across all order lines. */
    public int getTotalItemCount() {
        if (items == null)
            return 0;
        return items.stream().mapToInt(OrderItem::getQuantity).sum();
    }

    /** Minutes elapsed since order was placed. */
    public long getMinutesElapsed() {
        if (orderedAt == null)
            return 0;
        return java.time.Duration.between(orderedAt, LocalDateTime.now()).toMinutes();
    }

    /** True if order has been waiting more than 5 minutes and is still PENDING. */
    public boolean isUrgent() {
        return status == Status.PENDING && getMinutesElapsed() >= 5;
    }
}

