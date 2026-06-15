package com.example.backend.dao;

import com.example.backend.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class FeaturedProductDAO {

    public boolean isFeaturedGenerated(int month, int year) {
        String sql = "SELECT COUNT(*) FROM featured_products WHERE month=? AND year=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, month);
            ps.setInt(2, year);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1) > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public void saveFeatured(int productId, int month, int year) {
        String sql = """
        INSERT IGNORE INTO featured_products(product_id, month, year)
        VALUES (?, ?, ?)
    """;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, productId);
            ps.setInt(2, month);
            ps.setInt(3, year);
            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

}
