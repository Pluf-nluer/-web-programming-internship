package com.example.backend.dao;

import com.example.backend.model.Contact;
import com.example.backend.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.sql.Types;

public class ContactDAO {

    public boolean insert(Contact contact) {
        String sql = "INSERT INTO contact (user_id, name, email, content, status) VALUES (?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            if (contact.getUserId() == null) {
                ps.setNull(1, Types.INTEGER);
            } else {
                ps.setInt(1, contact.getUserId());
            }
            ps.setString(2, contact.getName());
            ps.setString(3, contact.getEmail());
            ps.setString(4, contact.getContent());
            ps.setString(5, contact.getStatus());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}
