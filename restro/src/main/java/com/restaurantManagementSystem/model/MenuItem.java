package com.restaurantManagementSystem.model;

import java.math.BigDecimal;

/**
 * MenuItem — represents a dish or drink on the menu.
 * MVC Role: Model — maps to menu_items table
 */
public class MenuItem {
    private int id;
    private int categoryId;
    private String categoryName;
    private String name;
    private String description;
    private BigDecimal price;
    private String emoji;
    private String imageUrl;
    private boolean available;

    public MenuItem() {}

    // ── Getters & Setters ──────────────────────────────────

    public int getId()                       { return id; }
    public void setId(int v)                 { this.id = v; }

    public int getCategoryId()               { return categoryId; }
    public void setCategoryId(int v)         { this.categoryId = v; }

    public String getCategoryName()          { return categoryName; }
    public void setCategoryName(String v)    { this.categoryName = v; }

    public String getName()                  { return name; }
    public void setName(String v)            { this.name = v; }

    public String getDescription()           { return description; }
    public void setDescription(String v)     { this.description = v; }

    public BigDecimal getPrice()             { return price; }
    public void setPrice(BigDecimal v)       { this.price = v; }

    public String getEmoji()                 { return emoji; }
    public void setEmoji(String v)           { this.emoji = v; }

    public String getImageUrl()              { return imageUrl; }
    public void setImageUrl(String v)        { this.imageUrl = v; }

    public boolean isAvailable()             { return available; }
    public void setAvailable(boolean v)      { this.available = v; }
}

