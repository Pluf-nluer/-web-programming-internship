package com.example.backend.model;

import java.sql.Timestamp;

public class Sale {
    private int id;
    private double discountPercent;
    private Timestamp startSale;
    private Timestamp endSale;

    public Sale() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public double getDiscountPercent() { return discountPercent; }
    public void setDiscountPercent(double discountPercent) { this.discountPercent = discountPercent; }

    public Timestamp getStartSale() { return startSale; }
    public void setStartSale(Timestamp startSale) { this.startSale = startSale; }

    public Timestamp getEndSale() { return endSale; }
    public void setEndSale(Timestamp endSale) { this.endSale = endSale; }
}