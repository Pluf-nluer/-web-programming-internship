package com.example.backend.dao;

import com.example.backend.model.Category;
import com.example.backend.model.Sale;
import com.example.backend.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class CategoryDAO {
    public List<Category> getCategories() {
        List<Category> categories = new ArrayList<>();

        String sql = "select * from product_categories";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);) {
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Category category = new Category();
                    category.setId(rs.getString("id"));
                    category.setName(rs.getString("name"));
                    category.setDescription(rs.getString("description"));
                    category.setImageUrl(rs.getString("image_url"));
                    category.setStatus(rs.getString("status"));
                    category.setSale_id(rs.getInt("sale_id"));
                    category.setCreatedAt(rs.getTimestamp("created_at"));
                    category.setParentId(rs.getInt("parent_id"));
                    if (category.getParentId() == 0) { categories.add(category);}
                }
            }


        } catch (Exception e) {
            e.printStackTrace();
        }
        return categories;
    }
    public List<Category> getAllCategories() {
        List<Category> categories = new ArrayList<>();

        String sql = "select * from product_categories";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);) {
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Category category = new Category();
                    category.setId(rs.getString("id"));
                    category.setName(rs.getString("name"));
                    category.setDescription(rs.getString("description"));
                    category.setImageUrl(rs.getString("image_url"));
                    category.setStatus(rs.getString("status"));
                    category.setSale_id(rs.getInt("sale_id"));
                    category.setCreatedAt(rs.getTimestamp("created_at"));
                    category.setParentId(rs.getInt("parent_id"));
                    categories.add(category);
                }
            }


        } catch (Exception e) {
            e.printStackTrace();
        }
        return categories;
    }

    public List<Sale> getAllSales() {
        List<Sale> sales = new ArrayList<>();
        String sql = "SELECT * FROM sale";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Sale s = new Sale();
                s.setId(rs.getInt("id"));
                s.setDiscountPercent(rs.getDouble("discount_percent"));
                sales.add(s);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return sales;
    }
    public Category getCategoryById(String id) {
        String sql = "SELECT * FROM product_categories WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Category category = new Category();
                    category.setId(rs.getString("id"));
                    category.setName(rs.getString("name"));
                    category.setDescription(rs.getString("description"));
                    category.setImageUrl(rs.getString("image_url"));
                    category.setStatus(rs.getString("status"));
                    category.setSale_id(rs.getInt("sale_id"));
                    category.setCreatedAt(rs.getTimestamp("created_at"));
                    category.setParentId(rs.getInt("parent_id"));
                    return category;
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
        return null;
    }

    public void insertSale(Sale sale) {
        
        String sql = "INSERT INTO sale (id, discount_percent, start_sale, end_sale) VALUES (?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            
            ps.setInt(1, sale.getId());

            
            ps.setDouble(2, sale.getDiscountPercent());

            
            if (sale.getStartSale() != null) {
                ps.setTimestamp(3, sale.getStartSale());
            } else {
                ps.setNull(3, java.sql.Types.TIMESTAMP);
            }

            
            if (sale.getEndSale() != null) {
                ps.setTimestamp(4, sale.getEndSale());
            } else {
                ps.setNull(4, java.sql.Types.TIMESTAMP);
            }

            ps.executeUpdate();
            System.out.println("Đã chèn mã sale mới thành công: " + sale.getId());

        } catch (Exception e) {
            System.err.println("Lỗi insertSale: " + e.getMessage());
            e.printStackTrace();
        }
    }

    public void updateCategorySale(int categoryId, String name, int saleId) {
        System.out.println("DEBUG: Dang update Category ID " + categoryId + " voi Sale ID " + saleId);
        String sql = "UPDATE product_categories SET name = ?, sale_id = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, name);
            
            if (saleId == 0) {
                ps.setNull(2, java.sql.Types.INTEGER);
            } else {
                ps.setInt(2, saleId);
            }
            ps.setInt(3, categoryId);

            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
