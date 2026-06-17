package com.example.backend.dao;

import com.example.backend.model.CartItem;
import com.example.backend.model.Product;
import com.example.backend.model.ProductImage;
import com.example.backend.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class CartDAO {
    public boolean saveOrUpdateCartItem(int userId, CartItem item) {
        String sql = "INSERT INTO cart_items (user_id, product_id, quantity) VALUES (?, ?, ?) " +
                "ON DUPLICATE KEY UPDATE quantity = quantity + ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ps.setInt(2, item.getProduct().getId());
            ps.setInt(3, item.getQuantity());
            ps.setInt(4, item.getQuantity());

            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<CartItem> getCartItemsByUserId(int userId) {
        List<CartItem> cartList = new ArrayList<>();

        String sql = "SELECT c.quantity, p.id AS prod_id, p.name AS prod_name, p.price AS prod_price, " +
                "p.stock AS prod_stock, p.category_id, " +
                "s.discount_percent AS prod_discount, s.end_sale AS prod_endsale, " +
                "(SELECT pi.image_url FROM product_images pi WHERE pi.product_id = p.id LIMIT 1) AS image_url " +
                "FROM cart_items c " +
                "JOIN products p ON c.product_id = p.id " +
                "LEFT JOIN product_categories pc ON p.category_id = pc.id " +
                "LEFT JOIN sale s ON pc.sale_id = s.id AND (NOW() BETWEEN s.start_sale AND s.end_sale) " +
                "WHERE c.user_id = ? " +
                "ORDER BY c.created_at DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {

                    Product product = new Product();
                    product.setId(rs.getInt("prod_id"));
                    product.setName(rs.getString("prod_name"));
                    product.setPrice(rs.getDouble("prod_price"));
                    product.setStock(rs.getInt("prod_stock"));
                    product.setCategoryId(rs.getInt("category_id"));

                    product.setDiscountPercent(rs.getDouble("prod_discount"));
                    product.setEndSale(rs.getTimestamp("prod_endsale"));

                    String imageUrl = rs.getString("image_url");
                    if (imageUrl != null) {
                        ProductImage imgObj = new ProductImage();
                        imgObj.setImageUrl(imageUrl);
                        product.setImage(imgObj);
                    }

                    int quantity = rs.getInt("quantity");

                    double displayPrice = (product.getDiscountPercent() > 0) ? product.getSalePrice() : product.getPrice();

                    CartItem item = new CartItem(product, quantity, displayPrice);
                    cartList.add(item);
                }
            }
        } catch (Exception e) {
            System.err.println("Lỗi nghiêm trọng khi lấy danh sách giỏ hàng: " + e.getMessage());
            e.printStackTrace();
        }

        return cartList;
    }

    public boolean updateCartItemQuantity(int userId, int productId, int quantity) {
        String sql = "UPDATE cart_items SET quantity = ? WHERE user_id = ? AND product_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, quantity);
            ps.setInt(2, userId);
            ps.setInt(3, productId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean deleteCartItem(int userId, int productId) {
        String sql = "DELETE FROM cart_items WHERE user_id = ? AND product_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, productId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
}
