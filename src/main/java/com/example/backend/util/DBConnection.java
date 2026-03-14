package com.example.backend.util;

import java.sql.*;

public class DBConnection {

    private static final String URL = "jdbc:mysql://localhost:3306/webshop_db";
    private static final String USER = "root";
    private static final String PASS = "";

    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }
    }

    public static Connection getConnection() {
        try {
            return DriverManager.getConnection(URL, USER, PASS);
        } catch (SQLException e) {
            System.err.println("Kết nối thất bại: " + e.getMessage());
            return null;
        }
    }

    public static void closeConnection(Connection conn) {
        if (conn != null) {
            try {
                conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    public static void runUpdate(String sql) {
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            if (conn != null) {
                int rowsAffected = stmt.executeUpdate();
                System.out.println("Đã cập nhật: " + rowsAffected + " dòng.");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    public static void runQuery(String sql) {
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            System.out.println("--- Kết quả Query ---");
            while (rs.next()) {
                System.out.println("Sản phẩm: " + rs.getString("image_url"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public static void main(String[] args) {
        String sql = "SELECT * FROM banners WHERE status = 'active' " +
                "AND ((start_date IS NULL AND end_date IS NULL) " +
                "OR (DATE_FORMAT(NOW(), '%m-%d') BETWEEN DATE_FORMAT(start_date, '%m-%d') AND DATE_FORMAT(end_date, '%m-%d')))";
        runQuery(sql);
    }
}