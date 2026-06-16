package com.example.backend.model;

import java.sql.Date;
import java.sql.Timestamp;

public class Order {
    private int id;
    private int payment_method_id;
    private int user_id;
    private String shipping_name;
    private String shipping_phone;
    private String shipping_address;
    private String note;
    private double shipping_fee;
    private double total_amount;
    private String order_status;
    private Date estimated_delivery_date;
    private Timestamp created_at;
    private Timestamp updated_at;

    public Order() {
    }

    public Order(int id, int user_id, int payment_method_id, String shipping_name, String shipping_phone, String shipping_address, String note, double shipping_fee, double total_amount, String order_status, Date estimated_delivery_date, Timestamp created_at, Timestamp updated_at) {
        this.id = id;
        this.user_id = user_id;
        this.payment_method_id = payment_method_id;
        this.shipping_name = shipping_name;
        this.shipping_phone = shipping_phone;
        this.shipping_address = shipping_address;
        this.note = note;
        this.shipping_fee = shipping_fee;
        this.total_amount = total_amount;
        this.order_status = order_status;
        this.estimated_delivery_date = estimated_delivery_date;
        this.created_at = created_at;
        this.updated_at = updated_at;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getPayment_method_id() {
        return payment_method_id;
    }

    public void setPayment_method_id(int payment_method_id) {
        this.payment_method_id = payment_method_id;
    }

    public int getUser_id() {
        return user_id;
    }

    public void setUser_id(int user_id) {
        this.user_id = user_id;
    }

    public String getShipping_name() {
        return shipping_name;
    }

    public void setShipping_name(String shipping_name) {
        this.shipping_name = shipping_name;
    }

    public String getShipping_phone() {
        return shipping_phone;
    }

    public void setShipping_phone(String shipping_phone) {
        this.shipping_phone = shipping_phone;
    }

    public String getShipping_address() {
        return shipping_address;
    }

    public void setShipping_address(String shipping_address) {
        this.shipping_address = shipping_address;
    }

    public double getShipping_fee() {
        return shipping_fee;
    }

    public void setShipping_fee(double shipping_fee) {
        this.shipping_fee = shipping_fee;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }

    public double getTotal_amount() {
        return total_amount;
    }

    public void setTotal_amount(double total_amount) {
        this.total_amount = total_amount;
    }

    public String getOrder_status() {
        return order_status;
    }

    public void setOrder_status(String order_status) {
        this.order_status = order_status;
    }
    public String getStatusClass() {
        return order_status == null ? "" : order_status.toLowerCase();
    }

    public String getStatusText() {
        if ("Pending".equalsIgnoreCase(order_status)) {
            return "Chờ xác nhận";
        }
        if ("Shipping".equalsIgnoreCase(order_status)) {
            return "Đang giao";
        }
        if ("Completed".equalsIgnoreCase(order_status)) {
            return "Hoàn thành";
        }
        if ("Cancelled".equalsIgnoreCase(order_status)) {
            return "Đã hủy";
        }
        return order_status == null ? "" : order_status;
    }

    public double getSubtotal() {
        return total_amount - shipping_fee;
    }

    public Timestamp getCreated_at() {
        return created_at;
    }

    public void setCreated_at(Timestamp created_at) {
        this.created_at = created_at;
    }

    public Timestamp getUpdated_at() {
        return updated_at;
    }

    public void setUpdated_at(Timestamp updated_at) {
        this.updated_at = updated_at;
    }

    public Date getEstimated_delivery_date() {
        return estimated_delivery_date;
    }

    public void setEstimated_delivery_date(Date estimated_delivery_date) {
        this.estimated_delivery_date = estimated_delivery_date;
    }
    @Override
    public String toString() {
        return "Order{" +
                "id=" + id +
                ", user_id=" + user_id +
                ", shipping_name='" + shipping_name + '\'' +
                ", shipping_phone='" + shipping_phone + '\'' +
                ", shipping_address='" + shipping_address + '\'' +
                ", shipping_fee=" + shipping_fee +
                ", note='" + note + '\'' +
                ", total_amount=" + total_amount +
                ", order_status='" + order_status + '\'' +
                ", estimated_delivery_date="+estimated_delivery_date+
                ", created_at=" + created_at +
                ", updated_at=" + updated_at +
                '}';
    }
}
