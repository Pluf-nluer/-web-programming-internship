package com.example.backend.model;

public class ProductImage {

    private int id;
    private int productId;
    private String imageUrl;


    public ProductImage() {
    }

    public ProductImage(int id, int productId, String imageUrl) {
        this.id = id;
        this.productId = productId;
        this.imageUrl = imageUrl;
    }


    public ProductImage(int productId, String imageUrl) {
        this.productId = productId;
        this.imageUrl = imageUrl;
    }


    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getProductId() {
        return productId;
    }

    public void setProductId(int productId) {
        this.productId = productId;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    @Override
    public String toString() {
        return "ProductImage{" +
                "id=" + id +
                ", productId='" + productId + '\'' +
                ", imageUrl='" + imageUrl + '\'' +
                '}';
    }
}