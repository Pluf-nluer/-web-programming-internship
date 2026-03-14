package com.example.backend.model;

import java.sql.Timestamp;

public class Banner {
    private int id;
    private String title;
    private String image_url;
    private String position;
    private String status;
    private Timestamp start_date;
    private Timestamp end_date;
    private Timestamp created_at;

    public Banner() {

    }

    public Banner(int id, String title, String image_url, String position, String status, Timestamp start_date, Timestamp end_date, Timestamp created_at) {
        this.id = id;
        this.title = title;
        this.image_url = image_url;
        this.position = position;
        this.status = status;
        this.start_date = start_date;
        this.end_date = end_date;
        this.created_at = created_at;
    }

    public int getId() {
        return id;
    }

    public String getTitle() {
        return title;
    }

    public String getImage_url() {
        return image_url;
    }

    public String getPosition() {
        return position;
    }

    public String getStatus() {
        return status;
    }

    public Timestamp getStart_date() {
        return start_date;
    }

    public Timestamp getEnd_date() {
        return end_date;
    }

    public Timestamp getCreated_at() {
        return created_at;
    }

    public void setId(int id) {
        this.id = id;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public void setImage_url(String image_url) {
        this.image_url = image_url;
    }

    public void setPosition(String position) {
        this.position = position;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public void setStart_date(Timestamp start_date) {
        this.start_date = start_date;
    }

    public void setEnd_date(Timestamp end_date) {
        this.end_date = end_date;
    }

    public void setCreated_at(Timestamp created_at) {
        this.created_at = created_at;
    }
}
