package com.example.backend.service;

import com.example.backend.dao.FeaturedProductDAO;
import com.example.backend.util.DBConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

public class FeaturedProductService {

    private final FeaturedProductDAO featuredDAO = new FeaturedProductDAO();

    public void generateFeaturedProductsForCurrentMonth() {
        LocalDate now = LocalDate.now();
        int currentMonth = now.getMonthValue();
        int currentYear = now.getYear();

        if (featuredDAO.isFeaturedGenerated(currentMonth, currentYear)) {
            return;
        }

        List<Integer> productIds = getTopSellingProducts(4, currentMonth, currentYear);

        if (productIds.isEmpty()) {
            productIds = getRandomProducts(4);
        }

        for (int productId : productIds) {
            featuredDAO.saveFeatured(productId, currentMonth, currentYear);
        }
    }

    private List<Integer> getTopSellingProducts(int limit, int month, int year) {
        List<Integer> list = new ArrayList<>();
        String sql = """
            SELECT oi.product_id, SUM(oi.quantity) as total_sold
            FROM order_items oi
            JOIN orders o ON oi.order_id = o.id
            WHERE o.order_status = 'COMPLETED' 
              AND (MONTH(o.created_at) = ? AND YEAR(o.created_at) = ?)
            GROUP BY oi.product_id
            ORDER BY total_sold DESC
            LIMIT ?
        """;
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, month);
            ps.setInt(2, year);
            ps.setInt(3, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(rs.getInt("product_id"));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    private List<Integer> getRandomProducts(int limit) {
        List<Integer> list = new ArrayList<>();
        String sql = "SELECT id FROM products WHERE status = 'active' ORDER BY RAND() LIMIT ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(rs.getInt("id"));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    private int getCategoryIdByProduct(int productId) {
        String sql = "SELECT category_id FROM products WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, productId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt("category_id");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }
}