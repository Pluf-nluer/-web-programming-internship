package com.example.backend.dao;

import com.example.backend.model.Review;
import com.example.backend.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;

public class ReviewDAO {
    public boolean insertReview(Review review) {
        String sql = "INSERT INTO review (user_id, pid, rating, comment, create_at) VALUES (?, ?, ?, ?, NOW())";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, review.getUserId());
            ps.setInt(2, review.getProductId());
            ps.setInt(3, review.getRating());
            ps.setString(4, review.getComment());

            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
}