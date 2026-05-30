package com.example.backend.dao;

import com.example.backend.model.UserAddress;
import com.example.backend.util.DBConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

public class UserAddressDAO {

    public UserAddress getByUserId(int userId) {
        createTableIfNeeded();
        String sql = "SELECT * FROM user_addresses WHERE user_id = ?";

        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = DBConnection.getConnection();
            if (conn == null) {
                return null;
            }
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, userId);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                return mapAddress(rs);
            }
        } catch (SQLException e) {
            System.err.println("Lỗi khi lấy địa chỉ giao hàng: " + e.getMessage());
        } finally {
            closeResources(conn, pstmt, rs);
        }
        return null;
    }

    public boolean save(UserAddress address) {
        createTableIfNeeded();
        String sql = "INSERT INTO user_addresses " +
                "(user_id, receiver_name, phone, address_line, province, district, ward, note) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?) " +
                "ON DUPLICATE KEY UPDATE receiver_name = VALUES(receiver_name), phone = VALUES(phone), " +
                "address_line = VALUES(address_line), province = VALUES(province), district = VALUES(district), " +
                "ward = VALUES(ward), note = VALUES(note), updated_at = CURRENT_TIMESTAMP";

        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            conn = DBConnection.getConnection();
            if (conn == null) {
                return false;
            }
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, address.getUserId());
            pstmt.setString(2, address.getReceiverName());
            pstmt.setString(3, address.getPhone());
            pstmt.setString(4, address.getAddressLine());
            pstmt.setString(5, address.getProvince());
            pstmt.setString(6, address.getDistrict());
            pstmt.setString(7, address.getWard());
            pstmt.setString(8, address.getNote());
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Lỗi khi lưu địa chỉ giao hàng: " + e.getMessage());
            return false;
        } finally {
            closeResources(conn, pstmt, null);
        }
    }

    private void createTableIfNeeded() {
        String sql = "CREATE TABLE IF NOT EXISTS user_addresses (" + "id INT AUTO_INCREMENT PRIMARY KEY, " + "user_id INT NOT NULL UNIQUE, " + "receiver_name VARCHAR(100) NOT NULL, " +
                "phone VARCHAR(20) NOT NULL, " + "address_line VARCHAR(255) NOT NULL, " + "province VARCHAR(100) NOT NULL, " +
                "district VARCHAR(100) NOT NULL, " + "ward VARCHAR(100) NOT NULL, " + "note VARCHAR(255), " +
                "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, " + "updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP" + ")";

        Connection conn = null;
        Statement stmt = null;

        try {
            conn = DBConnection.getConnection();
            if (conn == null) {
                return;
            }
            stmt = conn.createStatement();
            stmt.execute(sql);
        } catch (SQLException e) {
            System.err.println("Lỗi khi tạo bảng địa chỉ giao hàng: " + e.getMessage());
        } finally {
            closeResources(conn, stmt, null);
        }
    }

    private UserAddress mapAddress(ResultSet rs) throws SQLException {
        UserAddress address = new UserAddress();
        address.setId(rs.getInt("id"));
        address.setUserId(rs.getInt("user_id"));
        address.setReceiverName(rs.getString("receiver_name"));
        address.setPhone(rs.getString("phone"));
        address.setAddressLine(rs.getString("address_line"));
        address.setProvince(rs.getString("province"));
        address.setDistrict(rs.getString("district"));
        address.setWard(rs.getString("ward"));
        address.setNote(rs.getString("note"));
        address.setCreatedAt(rs.getTimestamp("created_at"));
        address.setUpdatedAt(rs.getTimestamp("updated_at"));
        return address;
    }

    private void closeResources(Connection conn, Statement stmt, ResultSet rs) {
        if (rs != null) {
            try {
                rs.close();
            } catch (SQLException e) {
                System.err.println("Lỗi khi đóng ResultSet: " + e.getMessage());
            }
        }

        if (stmt != null) {
            try {
                stmt.close();
            } catch (SQLException e) {
                System.err.println("Lỗi khi đóng Statement: " + e.getMessage());
            }
        }

        if (conn != null) {
            try {
                conn.close();
            } catch (SQLException e) {
                System.err.println("Lỗi khi đóng Connection: " + e.getMessage());
            }
        }
    }
}