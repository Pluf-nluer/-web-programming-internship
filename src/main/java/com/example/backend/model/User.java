package com.example.backend.model;

import java.sql.Timestamp;





public class User {
    private int id;                    
    private String fullName;           
    private String email;              
    private String phone;              
    private String password;           
    private String googleId;           
    private String avatarUrl;          
    private String role;               
    private int roleId;                
    private boolean isActive;          
    private Timestamp createdAt;       
    private Timestamp updatedAt;       
    private static final int ADMIN_ROLE_ID = 1;

    
    public User() {
    }

    
    public User(int id, String fullName, String email, String phone,
                String password, String role, boolean isActive,
                Timestamp createdAt, Timestamp updatedAt) {
        this.id = id;
        this.fullName = fullName;
        this.email = email;
        this.phone = phone;
        this.password = password;
        this.role = role;
        this.isActive = isActive;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
    }

    


    public User(String fullName, String email, String phone, String password) {
        this.fullName = fullName;
        this.email = email;
        this.phone = phone;
        this.password = password;
        this.role = "user";        
        this.isActive = true;      
    }

    

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getGoogleId() {
        return googleId;
    }

    public void setGoogleId(String googleId) {
        this.googleId = googleId;
    }

    public String getAvatarUrl() {
        return avatarUrl;
    }

    public void setAvatarUrl(String avatarUrl) {
        this.avatarUrl = avatarUrl;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }

    public int getRoleId() {
        return roleId;
    }

    public void setRoleId(int roleId) {
        this.roleId = roleId;
    }

    public boolean isActive() {
        return isActive;
    }

    public void setActive(boolean active) {
        isActive = active;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public Timestamp getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Timestamp updatedAt) {
        this.updatedAt = updatedAt;
    }

    
    @Override
    public String toString() {
        return "User{" +
                "id=" + id +
                ", fullName='" + fullName + '\'' +
                ", email='" + email + '\'' +
                ", phone='" + phone + '\'' +
                ", googleId='" + googleId + '\'' +
                ", avatarUrl='" + avatarUrl + '\'' +
                ", role='" + role + '\'' +
                ", roleId=" + roleId +
                ", isActive=" + isActive +
                '}';
    }

    



    public boolean isAdmin() {
        return roleId == ADMIN_ROLE_ID && "admin".equalsIgnoreCase(this.role);
    }
}
