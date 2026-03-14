package com.example.backend.model;

public class ProductAttribute {

    private int id;
    private int productId;

    private String origin;
    private String material;
    private String size;
    private String weight;
    private String color;


    public ProductAttribute() {
    }

    public ProductAttribute(int id, int productId, String origin, String material, String size, String weight, String color) {
        this.id = id;
        this.productId = productId;
        this.origin = origin;
        this.material = material;
        this.size = size;
        this.weight = weight;
        this.color = color;
    }

    public ProductAttribute(int productId, String origin, String material, String size, String weight, String color) {
        this.productId = productId;
        this.origin = origin;
        this.material = material;
        this.size = size;
        this.weight = weight;
        this.color = color;
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

    public String getOrigin() {
        return origin;
    }

    public void setOrigin(String origin) {
        this.origin = origin;
    }

    public String getMaterial() {
        return material;
    }

    public void setMaterial(String material) {
        this.material = material;
    }

    public String getSize() {
        return size;
    }

    public void setSize(String size) {
        this.size = size;
    }

    public String getWeight() {
        return weight;
    }

    public void setWeight(String weight) {
        this.weight = weight;
    }

    public String getColor() {
        return color;
    }

    public void setColor(String color) {
        this.color = color;
    }

    @Override
    public String toString() {
        return "ProductAttribute{" +
                "productId='" + productId + '\'' +
                ", material='" + material + '\'' +
                ", size='" + size + '\'' +
                '}';
    }
}