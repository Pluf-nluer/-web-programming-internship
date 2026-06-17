package com.example.backend.dao;

import com.example.backend.model.Product;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import com.example.backend.util.DBConnection;

public class DashboardStatisticsDAO {

    public List<Product> getUnsoldProducts(String startDate, String endDate) {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT id, name, stock, price FROM products " +
                "WHERE id NOT IN (" +
                "    SELECT DISTINCT oi.product_id FROM order_items oi " +
                "    JOIN orders o ON oi.order_id = o.id " +
                "    WHERE o.order_status = 'Hoàn thành' AND o.created_at BETWEEN ? AND ?" +
                ") AND status = 'active'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, startDate + " 00:00:00");
            ps.setString(2, endDate + " 23:59:59");
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Product p = new Product();
                    p.setId(rs.getInt("id"));
                    p.setName(rs.getString("name"));
                    p.setStock(rs.getInt("stock"));
                    p.setPrice(rs.getDouble("price"));
                    list.add(p);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public double getActualMonthlyRevenue() {
        int currentMonth = LocalDate.now().getMonthValue();
        int currentYear = LocalDate.now().getYear();
        String sql = "SELECT SUM(total_amount) AS revenue FROM orders " +
                "WHERE (order_status = 'Hoàn thành' OR order_status = 'completed') " +
                "AND MONTH(created_at) = ? AND YEAR(created_at) = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, currentMonth);
            ps.setInt(2, currentYear);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getDouble("revenue");
            }
        } catch (Exception e) { e.printStackTrace(); }
        return 0;
    }

    public List<Double> getRevenueDataByYear(int year) {
        List<Double> monthlyRevenue = new ArrayList<>();
        for (int i = 0; i < 12; i++) monthlyRevenue.add(0.0);

        String sql = "SELECT MONTH(created_at) AS month, SUM(total_amount) AS total FROM orders " +
                "WHERE (order_status = 'Hoàn thành' OR order_status = 'completed') AND YEAR(created_at) = ? " +
                "GROUP BY MONTH(created_at)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, year);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    int month = rs.getInt("month");
                    double total = rs.getDouble("total");
                    monthlyRevenue.set(month - 1, total);
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
        return monthlyRevenue;
    }

    public double getRevenueByMonthAndYear(int month, int year) {
        String sql = "SELECT SUM(total_amount) AS total FROM orders " +
                "WHERE (order_status = 'Hoàn thành' OR order_status = 'completed') " +
                "AND MONTH(created_at) = ? AND YEAR(created_at) = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, month);
            ps.setInt(2, year);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getDouble("total");
            }
        } catch (Exception e) { e.printStackTrace(); }
        return 0;
    }

    public Map<String, Integer> getInventoryFlow(String startDate, String endDate) {
        Map<String, Integer> flowData = new HashMap<>();
        flowData.put("IMPORT", 0);
        flowData.put("ADJUSTMENT", 0);
        flowData.put("EXPORT", 0);

        String sql = "SELECT transaction_type, SUM(ABS(quantity)) AS total_qty FROM inventory_transactions " +
                "WHERE created_at BETWEEN ? AND ? GROUP BY transaction_type";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, startDate + " 00:00:00");
            ps.setString(2, endDate + " 23:59:59");
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    flowData.put(rs.getString("transaction_type"), rs.getInt("total_qty"));
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
        return flowData;
    }

    public int getTotalImportedQuantity() {
        String sql = "SELECT SUM(ABS(quantity)) AS total FROM inventory_transactions WHERE transaction_type = 'IMPORT'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt("total");
        } catch (Exception e) { e.printStackTrace(); }
        return 0;
    }

    public int getTotalExportedQuantity() {
        String sql = "SELECT SUM(ABS(quantity)) AS total FROM inventory_transactions WHERE transaction_type = 'EXPORT'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt("total");
        } catch (Exception e) { e.printStackTrace(); }
        return 0;
    }
}