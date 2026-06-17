package com.example.backend.dao;

import com.example.backend.model.User;
import com.example.backend.util.DBConnection;
import com.example.backend.util.PasswordUtil;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;

public class UserDAO {
    





    public boolean register(User user) {
        String sql = "INSERT INTO users (full_name, email, phone, password, role_id, status, created_at) " +
                "VALUES (?, ?, ?, ?, COALESCE((SELECT id FROM role WHERE name = ?), 1), ?, NOW())";
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        
        try {
            conn = DBConnection.getConnection();
            pstmt = conn.prepareStatement(sql);
            
            pstmt.setString(1, user.getFullName());
            pstmt.setString(2, user.getEmail());
            pstmt.setString(3, user.getPhone());
            pstmt.setString(4, user.getPassword());
            String status = user.isActive() ? "active" : "inactive";
            pstmt.setString(5, user.getRole());
            pstmt.setString(6, status);
            
            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            System.err.println("Lỗi khi đăng ký user: " + e.getMessage());
            return false;
        } finally {
            closeResources(conn, pstmt, null);
        }
    }

    





    public User checkLogin(String emailOrPhone, String password) {
        String sql = "SELECT u.*, r.name AS role " +
                "FROM users u " +
                "LEFT JOIN role r ON u.role_id = r.id " +
                "WHERE (u.email = ? OR u.phone = ?) AND u.password = ?";
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBConnection.getConnection();
            pstmt = conn.prepareStatement(sql);
            
            
            pstmt.setString(1, emailOrPhone);
            pstmt.setString(2, emailOrPhone);
            pstmt.setString(3, password);
            
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return extractUserFromResultSet(rs);
            }
        } catch (SQLException e) {
            System.err.println("Lỗi khi đăng nhập: " + e.getMessage());
        } finally {
            closeResources(conn, pstmt, rs);
        }
        return null;
    }

    public User upsertGoogleUser(String googleId, String email, String fullName, String avatarUrl) {
        if (isNullOrEmpty(googleId) || isNullOrEmpty(email)) {
            return null;
        }

        String normalizedEmail = email.trim().toLowerCase();
        User byGoogleId = findByGoogleId(googleId);
        if (byGoogleId != null) {
            User refreshed = refreshGoogleProfile(byGoogleId, fullName, avatarUrl);
            return refreshed != null ? refreshed : byGoogleId;
        }

        User byEmail = findByEmail(normalizedEmail);
        if (byEmail != null) {
            if (!isNullOrEmpty(byEmail.getGoogleId()) && !googleId.equals(byEmail.getGoogleId())) {
                System.err.println("Google ID mismatch for email: " + normalizedEmail);
                return null;
            }
            if (!updateGoogleUser(byEmail, googleId, fullName, avatarUrl)) {
                return null;
            }
            return getUserById(byEmail.getId());
        }

        return createGoogleUser(googleId, normalizedEmail, fullName, avatarUrl);
    }

    
    public User findByEmailOrPhone(String emailOrPhone) {
        String sql = "SELECT u.*, r.name AS role " +
                "FROM users u " +
                "LEFT JOIN role r ON u.role_id = r.id " +
                "WHERE u.email = ? OR u.phone = ?";

        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = DBConnection.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, emailOrPhone);
            pstmt.setString(2, emailOrPhone);

            rs = pstmt.executeQuery();
            if (rs.next()) {
                return extractUserFromResultSet(rs);
            }
        } catch (SQLException e) {
            System.err.println("Lỗi khi tìm user theo email/phone: " + e.getMessage());
        } finally {
            closeResources(conn, pstmt, rs);
        }
        return null;
    }

    private User findByGoogleId(String googleId) {
        String sql = "SELECT u.*, r.name AS role " +
                "FROM users u " +
                "LEFT JOIN role r ON u.role_id = r.id " +
                "WHERE u.google_id = ?";

        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = DBConnection.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, googleId);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                return extractUserFromResultSet(rs);
            }
        } catch (SQLException e) {
            System.err.println("Lỗi khi tìm user theo google_id: " + e.getMessage());
        } finally {
            closeResources(conn, pstmt, rs);
        }
        return null;
    }

    private User refreshGoogleProfile(User user, String fullName, String avatarUrl) {
        String updatedFullName = user.getFullName();
        String updatedAvatarUrl = user.getAvatarUrl();
        boolean needsUpdate = false;

        if (isNullOrEmpty(updatedFullName) && !isNullOrEmpty(fullName)) {
            updatedFullName = fullName.trim();
            needsUpdate = true;
        }
        if (isNullOrEmpty(updatedAvatarUrl) && !isNullOrEmpty(avatarUrl)) {
            updatedAvatarUrl = avatarUrl.trim();
            needsUpdate = true;
        }

        if (!needsUpdate) {
            return user;
        }

        boolean updated = updateGoogleUserFields(user.getId(), null, updatedFullName, updatedAvatarUrl);
        if (!updated) {
            return null;
        }
        return getUserById(user.getId());
    }

    private boolean updateGoogleUser(User user, String googleId, String fullName, String avatarUrl) {
        String updatedFullName = user.getFullName();
        String updatedAvatarUrl = user.getAvatarUrl();
        String updatedGoogleId = user.getGoogleId();
        boolean needsUpdate = false;

        if (isNullOrEmpty(updatedGoogleId) && !isNullOrEmpty(googleId)) {
            updatedGoogleId = googleId;
            needsUpdate = true;
        }
        if (isNullOrEmpty(updatedFullName) && !isNullOrEmpty(fullName)) {
            updatedFullName = fullName.trim();
            needsUpdate = true;
        }
        if (isNullOrEmpty(updatedAvatarUrl) && !isNullOrEmpty(avatarUrl)) {
            updatedAvatarUrl = avatarUrl.trim();
            needsUpdate = true;
        }

        if (!needsUpdate) {
            return true;
        }

        return updateGoogleUserFields(user.getId(), updatedGoogleId, updatedFullName, updatedAvatarUrl);
    }

    private boolean updateGoogleUserFields(int userId, String googleId, String fullName, String avatarUrl) {
        List<String> updates = new ArrayList<>();
        List<Object> params = new ArrayList<>();

        if (!isNullOrEmpty(googleId)) {
            updates.add("google_id = ?");
            params.add(googleId);
        }
        if (!isNullOrEmpty(fullName)) {
            updates.add("full_name = ?");
            params.add(fullName);
        }
        if (!isNullOrEmpty(avatarUrl)) {
            updates.add("avatar_url = ?");
            params.add(avatarUrl);
        }

        if (updates.isEmpty()) {
            return true;
        }

        String sql = "UPDATE users SET " + String.join(", ", updates) + " WHERE id = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            conn = DBConnection.getConnection();
            pstmt = conn.prepareStatement(sql);
            int index = 1;
            for (Object param : params) {
                pstmt.setObject(index++, param);
            }
            pstmt.setInt(index, userId);
            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            System.err.println("Lỗi khi cập nhật google user: " + e.getMessage());
            return false;
        } finally {
            closeResources(conn, pstmt, null);
        }
    }

    private User createGoogleUser(String googleId, String email, String fullName, String avatarUrl) {
        String safeFullName = normalizeFullName(fullName, email);
        String randomPassword = PasswordUtil.generateRandomPassword(16);
        String hashedPassword = PasswordUtil.encrypt(randomPassword);
        if (hashedPassword == null) {
            return null;
        }

        String sql = "INSERT INTO users (full_name, email, phone, password, role_id, status, created_at, google_id, avatar_url) " +
                "VALUES (?, ?, ?, ?, COALESCE((SELECT id FROM role WHERE name = ?), 1), ?, NOW(), ?, ?)";

        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            conn = DBConnection.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, safeFullName);
            pstmt.setString(2, email);
            pstmt.setString(3, null);
            pstmt.setString(4, hashedPassword);
            pstmt.setString(5, "user");
            pstmt.setString(6, "active");
            pstmt.setString(7, googleId);
            pstmt.setString(8, avatarUrl);

            int rowsAffected = pstmt.executeUpdate();
            if (rowsAffected > 0) {
                return findByEmail(email);
            }
        } catch (SQLException e) {
            System.err.println("Lỗi khi tạo user Google: " + e.getMessage());
        } finally {
            closeResources(conn, pstmt, null);
        }
        return null;
    }

    private String normalizeFullName(String fullName, String email) {
        if (!isNullOrEmpty(fullName)) {
            return fullName.trim();
        }
        if (!isNullOrEmpty(email)) {
            int atIndex = email.indexOf('@');
            if (atIndex > 0) {
                return email.substring(0, atIndex);
            }
        }
        return "User";
    }

    private boolean isNullOrEmpty(String value) {
        return value == null || value.trim().isEmpty();
    }

    
    public boolean updatePassword(int userId, String hashedPassword) {
        String sql = "UPDATE users SET password = ? WHERE id = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            conn = DBConnection.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, hashedPassword);
            pstmt.setInt(2, userId);

            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            System.err.println("Lỗi khi cập nhật mật khẩu: " + e.getMessage());
            return false;
        } finally {
            closeResources(conn, pstmt, null);
        }
    }

    


    public boolean isEmailExists(String email) {
        return findByEmail(email) != null;
    }

    private User findByEmail(String email) {
        String sql = "SELECT u.*, r.name AS role " +
                "FROM users u " +
                "LEFT JOIN role r ON u.role_id = r.id " +
                "WHERE u.email = ?";

        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = DBConnection.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, email);

            rs = pstmt.executeQuery();

            if (rs.next()) {
                return extractUserFromResultSet(rs);
            }
            return null;

        } catch (SQLException e) {
            System.err.println("Lỗi khi tìm user theo email: " + e.getMessage());
            return null;
        } finally {
            closeResources(conn, pstmt, rs);
        }
    }

    


    public boolean isPhoneExists(String phone) {
        return findByPhone(phone) != null;
    }

    public boolean isPhoneExistsForOtherUser(String phone, int userId) {
        String sql = "SELECT COUNT(*) FROM users WHERE phone = ? AND id <> ?";

        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = DBConnection.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, phone);
            pstmt.setInt(2, userId);

            rs = pstmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            System.err.println("Lỗi khi kiểm tra số điện thoại trùng: " + e.getMessage());
        } finally {
            closeResources(conn, pstmt, rs);
        }
        return false;
    }

    private User findByPhone(String phone) {
        String sql = "SELECT u.*, r.name AS role " +
                "FROM users u " +
                "LEFT JOIN role r ON u.role_id = r.id " +
                "WHERE u.phone = ?";

        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = DBConnection.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, phone);

            rs = pstmt.executeQuery();

            if (rs.next()) {
                return extractUserFromResultSet(rs);
            }
            return null;

        } catch (SQLException e) {
            System.err.println("Lỗi khi tìm user theo phone: " + e.getMessage());
            return null;
        } finally {
            closeResources(conn, pstmt, rs);
        }
    }

    
    public User getUserById(int id) {
        String sql = "SELECT u.*, r.name AS role " +
                "FROM users u " +
                "LEFT JOIN role r ON u.role_id = r.id " +
                "WHERE u.id = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = DBConnection.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, id);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                return extractUserFromResultSet(rs);
            }
        } catch (SQLException e) {
            System.err.println("Lỗi khi lấy user theo id: " + e.getMessage());
        } finally {
            closeResources(conn, pstmt, rs);
        }
        return null;
    }

    
    public boolean updateProfile(User user) {
        String sql = "UPDATE users SET full_name = ?, phone = ? WHERE id = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            conn = DBConnection.getConnection();
            pstmt = conn.prepareStatement(sql);

            pstmt.setString(1, user.getFullName());
            pstmt.setString(2, user.getPhone());
            pstmt.setInt(3, user.getId());

            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException e) {
            System.err.println("Lỗi khi cập nhật profile: " + e.getMessage());
            return false;
        } finally {
            closeResources(conn, pstmt, null);
        }
    }

    
    public List<User> getUsers(String keyword, int offset, int limit) {
        return getUsers(keyword, "", "", "", "", offset, limit);
    }

    public List<User> getUsers(String keyword, String status, String role, String createdFrom, String createdTo, int offset, int limit) {
        List<User> users = new ArrayList<>();
        String trimmedKeyword = keyword == null ? "" : keyword.trim();
        String trimmedStatus = status == null ? "" : status.trim();
        String trimmedRole = role == null ? "" : role.trim().toLowerCase(Locale.ROOT);
        String trimmedCreatedFrom = createdFrom == null ? "" : createdFrom.trim();
        String trimmedCreatedTo = createdTo == null ? "" : createdTo.trim();
        boolean hasKeyword = !trimmedKeyword.isEmpty();
        boolean hasStatus = !trimmedStatus.isEmpty();
        boolean hasRole = !trimmedRole.isEmpty();
        boolean hasCreatedFrom = !trimmedCreatedFrom.isEmpty();
        boolean hasCreatedTo = !trimmedCreatedTo.isEmpty();
        int safeOffset = Math.max(0, offset);
        int safeLimit = Math.max(1, limit);

        StringBuilder sql = new StringBuilder("SELECT u.*, r.name AS role ");
        sql.append("FROM users u ");
        sql.append("LEFT JOIN role r ON u.role_id = r.id ");
        sql.append("WHERE 1 = 1 ");
        if (hasKeyword) {
            sql.append("AND (u.full_name LIKE ? OR u.email LIKE ? OR u.phone LIKE ?) ");
        }
        if (hasStatus) {
            sql.append("AND u.status = ? ");
        }
        if (hasRole) {
            sql.append("AND LOWER(r.name) = ? ");
        }
        if (hasCreatedFrom) {
            sql.append("AND DATE(u.created_at) >= ? ");
        }
        if (hasCreatedTo) {
            sql.append("AND DATE(u.created_at) <= ? ");
        }
        sql.append("ORDER BY u.created_at DESC ");
        sql.append("LIMIT ? OFFSET ?");

        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = DBConnection.getConnection();
            pstmt = conn.prepareStatement(sql.toString());

            int index = 1;
            if (hasKeyword) {
                String pattern = "%" + trimmedKeyword + "%";
                pstmt.setString(index++, pattern);
                pstmt.setString(index++, pattern);
                pstmt.setString(index++, pattern);
            }
            if (hasStatus) {
                pstmt.setString(index++, trimmedStatus);
            }
            if (hasRole) {
                pstmt.setString(index++, trimmedRole);
            }
            if (hasCreatedFrom) {
                pstmt.setString(index++, trimmedCreatedFrom);
            }
            if (hasCreatedTo) {
                pstmt.setString(index++, trimmedCreatedTo);
            }
            pstmt.setInt(index++, safeLimit);
            pstmt.setInt(index, safeOffset);

            rs = pstmt.executeQuery();
            while (rs.next()) {
                users.add(extractUserFromResultSet(rs));
            }
        } catch (SQLException e) {
            System.err.println("Lỗi khi lấy danh sách user: " + e.getMessage());
        } finally {
            closeResources(conn, pstmt, rs);
        }
        return users;
    }

    
    public int countUsers(String keyword) {
        return countUsers(keyword, "", "", "", "");
    }

    public int countUsers(String keyword, String status, String role, String createdFrom, String createdTo) {
        String trimmedKeyword = keyword == null ? "" : keyword.trim();
        String trimmedStatus = status == null ? "" : status.trim();
        String trimmedRole = role == null ? "" : role.trim().toLowerCase(Locale.ROOT);
        String trimmedCreatedFrom = createdFrom == null ? "" : createdFrom.trim();
        String trimmedCreatedTo = createdTo == null ? "" : createdTo.trim();
        boolean hasKeyword = !trimmedKeyword.isEmpty();
        boolean hasStatus = !trimmedStatus.isEmpty();
        boolean hasRole = !trimmedRole.isEmpty();
        boolean hasCreatedFrom = !trimmedCreatedFrom.isEmpty();
        boolean hasCreatedTo = !trimmedCreatedTo.isEmpty();

        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM users u ");
        sql.append("LEFT JOIN role r ON u.role_id = r.id ");
        sql.append("WHERE 1 = 1 ");
        if (hasKeyword) {
            sql.append("AND (u.full_name LIKE ? OR u.email LIKE ? OR u.phone LIKE ?) ");
        }
        if (hasStatus) {
            sql.append("AND u.status = ? ");
        }
        if (hasRole) {
            sql.append("AND LOWER(r.name) = ? ");
        }
        if (hasCreatedFrom) {
            sql.append("AND DATE(u.created_at) >= ? ");
        }
        if (hasCreatedTo) {
            sql.append("AND DATE(u.created_at) <= ? ");
        }

        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = DBConnection.getConnection();
            pstmt = conn.prepareStatement(sql.toString());

            int index = 1;
            if (hasKeyword) {
                String pattern = "%" + trimmedKeyword + "%";
                pstmt.setString(index++, pattern);
                pstmt.setString(index++, pattern);
                pstmt.setString(index++, pattern);
            }
            if (hasStatus) {
                pstmt.setString(index++, trimmedStatus);
            }
            if (hasRole) {
                pstmt.setString(index++, trimmedRole);
            }
            if (hasCreatedFrom) {
                pstmt.setString(index++, trimmedCreatedFrom);
            }
            if (hasCreatedTo) {
                pstmt.setString(index, trimmedCreatedTo);
            }

            rs = pstmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.err.println("Lỗi khi đếm user: " + e.getMessage());
        } finally {
            closeResources(conn, pstmt, rs);
        }
        return 0;
    }

    
    public boolean updateUserStatus(int userId, boolean isActive) {
        String status = isActive ? "active" : "inactive";
        String sql = "UPDATE users u " +
                "LEFT JOIN role r ON u.role_id = r.id " +
                "SET u.status = ? " +
                "WHERE u.id = ? AND (r.name IS NULL OR LOWER(r.name) <> 'admin')";

        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            conn = DBConnection.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, status);
            pstmt.setInt(2, userId);

            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            System.err.println("Lỗi khi cập nhật trạng thái user: " + e.getMessage());
            return false;
        } finally {
            closeResources(conn, pstmt, null);
        }
    }

    public List<String> getAssignableRoles() {
        return getRoleNames(true);
    }

    public List<String> getFilterableRoles() {
        return getRoleNames(true);
    }

    private List<String> getRoleNames(boolean includeAdmin) {
        List<String> roles = new ArrayList<>();
        String sql = includeAdmin
                ? "SELECT name FROM role ORDER BY id"
                : "SELECT name FROM role WHERE LOWER(name) <> 'admin' ORDER BY id";

        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = DBConnection.getConnection();
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();
            while (rs.next()) {
                roles.add(rs.getString("name"));
            }
        } catch (SQLException e) {
            System.err.println("Lỗi khi lấy danh sách quyền: " + e.getMessage());
        } finally {
            closeResources(conn, pstmt, rs);
        }
        return roles;
    }

    public boolean updateUserRole(int userId, String roleName) {
        if (roleName == null || roleName.trim().isEmpty()) {
            return false;
        }

        String normalizedRole = roleName.trim().toLowerCase(Locale.ROOT);
        String sql = "UPDATE users u " +
                "LEFT JOIN role current_role ON u.role_id = current_role.id " +
                "JOIN role new_role ON LOWER(new_role.name) = ? " +
                "SET u.role_id = new_role.id " +
                "WHERE u.id = ? " +
                "AND (current_role.name IS NULL OR LOWER(current_role.name) <> 'admin')";

        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            conn = DBConnection.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, normalizedRole);
            pstmt.setInt(2, userId);

            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            System.err.println("Lỗi khi cập nhật quyền user: " + e.getMessage());
            return false;
        } finally {
            closeResources(conn, pstmt, null);
        }
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

    private User extractUserFromResultSet(ResultSet rs) throws SQLException {
        User user = new User();
        
        try {
            
            if (hasColumn(rs, "id")) user.setId(rs.getInt("id"));
            if (hasColumn(rs, "full_name")) user.setFullName(rs.getString("full_name"));
            if (hasColumn(rs, "email")) user.setEmail(rs.getString("email"));
            if (hasColumn(rs, "phone")) user.setPhone(rs.getString("phone"));
            if (hasColumn(rs, "password")) user.setPassword(rs.getString("password"));
            if (hasColumn(rs, "google_id")) user.setGoogleId(rs.getString("google_id"));
            if (hasColumn(rs, "avatar_url")) user.setAvatarUrl(rs.getString("avatar_url"));
            if (hasColumn(rs, "role_id")) user.setRoleId(rs.getInt("role_id"));
            if (hasColumn(rs, "role")) user.setRole(rs.getString("role"));
            if (hasColumn(rs, "created_at")) user.setCreatedAt(rs.getTimestamp("created_at"));
            if (hasColumn(rs, "updated_at")) user.setUpdatedAt(rs.getTimestamp("updated_at"));
            if (hasColumn(rs, "is_active")) {
                user.setActive(rs.getBoolean("is_active"));
            } else if (hasColumn(rs, "status")) {
                String status = rs.getString("status");
                user.setActive("active".equalsIgnoreCase(status));
            }
        } catch (SQLException e) {
             System.err.println("Lỗi mapping user: " + e.getMessage());
        }
        return user;
    }

    private boolean hasColumn(ResultSet rs, String columnName) throws SQLException {
        ResultSetMetaData rsmd = rs.getMetaData();
        int columns = rsmd.getColumnCount();
        for (int x = 1; x <= columns; x++) {
            if (columnName.equals(rsmd.getColumnLabel(x))) {
                return true;
            }
        }
        return false;
    }
}
