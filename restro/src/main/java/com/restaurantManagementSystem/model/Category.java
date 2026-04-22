package com.restaurantManagementSystem.model;

/**
 * Category — represents a menu category (Starters, Mains, etc.)
 * MVC Role: Model — maps to categories table
 */
public class Category {
    private int id;
    private String name;
    private int displayOrder;
    private boolean active;

    public Category() {}

    public Category(int id, String name, int displayOrder) {
        this.id = id;
        this.name = name;
        this.displayOrder = displayOrder;
        this.active = true;
    }

    public int getId()                 { return id; }
    public void setId(int v)           { this.id = v; }
    public String getName()            { return name; }
    public void setName(String v)      { this.name = v; }
    public int getDisplayOrder()       { return displayOrder; }
    public void setDisplayOrder(int v) { this.displayOrder = v; }
    public boolean isActive()          { return active; }
    public void setActive(boolean v)   { this.active = v; }
}

