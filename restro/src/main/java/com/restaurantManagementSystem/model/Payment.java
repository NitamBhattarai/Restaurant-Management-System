package com.restaurantManagementSystem.model;

import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * Payment — records a payment transaction for a bill.
 * MVC Role: Model — maps to payments table
 */
public class Payment {

    public enum Method { CASH, ESEWA, KHALTI, CARD }
    public enum Status { PAID, UNPAID, PENDING }

    private int id;
    private int billId;
    private String orderCode;
    private String tableNumber;
    private BigDecimal amountPaid;
    private Method method;
    private Status status;
    private String transactionRef;
    private Integer processedById;
    private String processedByName;
    private LocalDateTime paidAt;
    private LocalDateTime createdAt;

    public Payment() {}

    // ── Getters & Setters ──────────────────────────────────

    public int getId()                          { return id; }
    public void setId(int v)                    { this.id = v; }

    public int getBillId()                      { return billId; }
    public void setBillId(int v)                { this.billId = v; }

    public String getOrderCode()                { return orderCode; }
    public void setOrderCode(String v)          { this.orderCode = v; }

    public String getTableNumber()              { return tableNumber; }
    public void setTableNumber(String v)        { this.tableNumber = v; }

    public BigDecimal getAmountPaid()           { return amountPaid; }
    public void setAmountPaid(BigDecimal v)     { this.amountPaid = v; }

    public Method getMethod()                   { return method; }
    public void setMethod(Method v)             { this.method = v; }

    public Status getStatus()                   { return status; }
    public void setStatus(Status v)             { this.status = v; }

    public String getTransactionRef()           { return transactionRef; }
    public void setTransactionRef(String v)     { this.transactionRef = v; }

    public Integer getProcessedById()           { return processedById; }
    public void setProcessedById(Integer v)     { this.processedById = v; }

    public String getProcessedByName()          { return processedByName; }
    public void setProcessedByName(String v)    { this.processedByName = v; }

    public LocalDateTime getPaidAt()            { return paidAt; }
    public void setPaidAt(LocalDateTime v)      { this.paidAt = v; }

    public LocalDateTime getCreatedAt()         { return createdAt; }
    public void setCreatedAt(LocalDateTime v)   { this.createdAt = v; }
}

