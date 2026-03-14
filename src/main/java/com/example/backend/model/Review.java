package com.example.backend.model;

import java.sql.Timestamp;

public class Review {
    private int id;
    private int userId;
    private int productId;
    private int rating;
    private String comment;
    private Timestamp createdAt;
    private String userName;

    public Review(int id, int userId, int productId, int rating, String comment, Timestamp createdAt) {
        this.id = id;
        this.userId = userId;
        this.productId = productId;
        this.rating = rating;
        this.comment = comment;
        this.createdAt = createdAt;
    }
    public Review() {

    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public String getUserName() {
        return userName;
    }

    public void setId(int id) {
        this.id = id;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public void setProductId(int productId) {
        this.productId = productId;
    }

    public void setRating(int rating) {
        this.rating = rating;
    }

    public void setComment(String comment) {
        this.comment = comment;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public String getComment() {
        return comment;
    }

    public int getRating() {
        return rating;
    }

    public int getProductId() {
        return productId;
    }

    public int getUserId() {
        return userId;
    }

    public int getId() {
        return id;
    }
}
