package com.restaurantManagementSystem.model;

import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * Bill — auto-generated bill linked to an order.
 * Includes subtotal, VAT, service charge, discount, and grand total.
 * MVC Role: Model — maps to bills table
 */
public class Bill {
    private int id;
    private int orderId;
    private String orderCode;
    private String tableNumber;
    private BigDecimal subtotal     = BigDecimal.ZERO;
    private BigDecimal vatRate      = new BigDecimal("13.00");
    private BigDecimal vatAmount    = BigDecimal.ZERO;
    private BigDecimal serviceRate  = new BigDecimal("10.00");
    private BigDecimal serviceAmount= BigDecimal.ZERO;
    private BigDecimal discountPct  = BigDecimal.ZERO;
    private BigDecimal discountAmt  = BigDecimal.ZERO;
    private BigDecimal total        = BigDecimal.ZERO;
    private LocalDateTime generatedAt;

    public Bill() {}

    // ── Getters & Setters ──────────────────────────────────

    public int getId()                           { return id; }
    public void setId(int v)                     { this.id = v; }

    public int getOrderId()                      { return orderId; }
    public void setOrderId(int v)                { this.orderId = v; }

    public String getOrderCode()                 { return orderCode; }
    public void setOrderCode(String v)           { this.orderCode = v; }

    public String getTableNumber()               { return tableNumber; }
    public void setTableNumber(String v)         { this.tableNumber = v; }

    public BigDecimal getSubtotal()              { return subtotal; }
    public void setSubtotal(BigDecimal v)        { this.subtotal = v; }

    public BigDecimal getVatRate()               { return vatRate; }
    public void setVatRate(BigDecimal v)         { this.vatRate = v; }

    public BigDecimal getVatAmount()             { return vatAmount; }
    public void setVatAmount(BigDecimal v)       { this.vatAmount = v; }

    public BigDecimal getServiceRate()           { return serviceRate; }
    public void setServiceRate(BigDecimal v)     { this.serviceRate = v; }

    public BigDecimal getServiceAmount()         { return serviceAmount; }
    public void setServiceAmount(BigDecimal v)   { this.serviceAmount = v; }

    public BigDecimal getDiscountPct()           { return discountPct; }
    public void setDiscountPct(BigDecimal v)     { this.discountPct = v; }

    public BigDecimal getDiscountAmt()           { return discountAmt; }
    public void setDiscountAmt(BigDecimal v)     { this.discountAmt = v; }

    public BigDecimal getTotal()                 { return total; }
    public void setTotal(BigDecimal v)           { this.total = v; }

    public LocalDateTime getGeneratedAt()        { return generatedAt; }
    public void setGeneratedAt(LocalDateTime v)  { this.generatedAt = v; }
}

