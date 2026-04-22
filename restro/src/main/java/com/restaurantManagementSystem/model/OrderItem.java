package com.restaurantManagementSystem.model;

import java.math.BigDecimal;

/**
 * OrderItem — one line in an order (item + quantity + price snapshot).
 * MVC Role: Model — maps to order_items table
 */
public class OrderItem {
    private int id;
    private int orderId;
    private int menuItemId;
    private String menuItemName;
    private String menuItemEmoji;
    private int quantity;
    private BigDecimal unitPrice;
    private String specialNote;

    public OrderItem() {}

    public int getId()                         { return id; }
    public void setId(int v)                   { this.id = v; }

    public int getOrderId()                    { return orderId; }
    public void setOrderId(int v)              { this.orderId = v; }

    public int getMenuItemId()                 { return menuItemId; }
    public void setMenuItemId(int v)           { this.menuItemId = v; }

    public String getMenuItemName()            { return menuItemName; }
    public void setMenuItemName(String v)      { this.menuItemName = v; }

    public String getMenuItemEmoji()           { return menuItemEmoji; }
    public void setMenuItemEmoji(String v)     { this.menuItemEmoji = v; }

    public int getQuantity()                   { return quantity; }
    public void setQuantity(int v)             { this.quantity = v; }

    public BigDecimal getUnitPrice()           { return unitPrice; }
    public void setUnitPrice(BigDecimal v)     { this.unitPrice = v; }

    public String getSpecialNote()             { return specialNote; }
    public void setSpecialNote(String v)       { this.specialNote = v; }

    /** Computed line total = unit price × quantity */
    public BigDecimal getLineTotal() {
        if (unitPrice == null) return BigDecimal.ZERO;
        return unitPrice.multiply(BigDecimal.valueOf(quantity));
    }
}

