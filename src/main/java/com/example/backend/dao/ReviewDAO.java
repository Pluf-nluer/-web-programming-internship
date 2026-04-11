package com.example.backend.dao;

import com.example.backend.model.Review;
import com.example.backend.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

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

    public boolean updateStatus(int id, String status) {
        String sql = "UPDATE review SET status = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, id);
            return ps.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); }
        return false;
    }

    public boolean deleteReview(int id) {
        String sql = "DELETE FROM review WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); }
        return false;
    }

    public List<Review> getAllReviews() {
        List<Review> reviews = new ArrayList<>();
        String sql = "SELECT r.*, u.full_name, p.name as product_name FROM review r " +
                "JOIN users u ON r.user_id = u.id " +
                "JOIN products p ON r.pid = p.id " +
                "ORDER BY r.create_at DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Review review = new Review();
                review.setId(rs.getInt("id"));
                review.setUserId(rs.getInt("user_id"));
                review.setProductId(rs.getInt("pid"));
                review.setRating(rs.getInt("rating"));
                review.setComment(rs.getString("comment"));
                review.setCreatedAt(rs.getTimestamp("create_at"));

                review.setUserName(rs.getString("full_name"));

                reviews.add(review);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return reviews;
    }

    public Review getReviewById(int id) {
        String sql = "SELECT r.*, u.full_name FROM review r " +
                "JOIN users u ON r.user_id = u.id " +
                "WHERE r.id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Review review = new Review();
                review.setId(rs.getInt("id"));
                review.setUserId(rs.getInt("user_id"));
                review.setProductId(rs.getInt("pid"));
                review.setRating(rs.getInt("rating"));
                review.setComment(rs.getString("comment"));
                review.setCreatedAt(rs.getTimestamp("create_at"));
                review.setUserName(rs.getString("full_name"));
                return review;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }


    private Review mapRStoReview(ResultSet rs) throws Exception {
        Review review = new Review();
        review.setUserId(rs.getInt("user_id"));
        review.setId(rs.getInt("id"));
        review.setComment(rs.getString("comment"));
        review.setRating(rs.getInt("rating"));
        review.setProductId(rs.getInt("product_id"));
        review.setCreatedAt(rs.getTimestamp("created_at"));
        return review;
    }
}