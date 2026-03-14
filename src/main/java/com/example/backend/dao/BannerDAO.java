package com.example.backend.dao;

import com.example.backend.model.Banner;
import com.example.backend.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class BannerDAO {
    public List<Banner> getBannerDefault() {
        List<Banner> list = new ArrayList<>();
        String sql = "SELECT * FROM banners WHERE status = 'active' " +
                "AND ((start_date IS NULL AND end_date IS NULL) " +
                "OR (NOW() BETWEEN start_date AND end_date))";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapResultSetToBanner(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public Banner mapResultSetToBanner(ResultSet rs) throws Exception {
        Banner b = new Banner();
        b.setId(rs.getInt("id"));
        b.setTitle(rs.getString("title"));
        b.setImage_url(rs.getString("image_url"));
        b.setStatus(rs.getString("status"));
        b.setStart_date(rs.getTimestamp("start_date"));
        b.setEnd_date(rs.getTimestamp("end_date"));
        b.setCreated_at(rs.getTimestamp("created_at"));
        return b;
    }
}
