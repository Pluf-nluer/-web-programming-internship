package com.example.backend.dao;

import com.example.backend.model.Product;
import com.example.backend.model.ProductImage;
import com.example.backend.util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class InventoryDao {

    public List<Product> getInventoryList() {
        List<Product> list = new ArrayList<>();

        String sql = "SELECT p.id, p.name, p.price, p.stock, p.sold_quantity AS totalSold " +
                "FROM products p " +
                "ORDER BY p.stock ASC, p.id DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Product p = new Product();
                p.setId(rs.getInt("id"));
                p.setName(rs.getString("name"));
                p.setPrice(rs.getDouble("price"));
                p.setStock(rs.getInt("stock"));
                p.setTotalSold(rs.getInt("totalSold"));

                ProductImage img = new ProductImage();
                img.setImageUrl("admin/images/product-placeholder.png");
                p.setImage(img);

                list.add(p);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean importStockBatch(List<Integer> productIds, List<Integer> quantitiesAdded) {
        // 👉 ĐÃ SỬA: Cập nhật trực tiếp vào cột stock vật lý của bảng products
        String updateStockSql = "UPDATE products SET stock = stock + ? WHERE id = ?";
        String insertTxSql = "INSERT INTO inventory_transactions (product_id, transaction_type, quantity, reason) VALUES (?, 'IMPORT', ?, 'Import hàng loạt tập trung')";

        Connection conn = null;
        PreparedStatement psUpdate = null;
        PreparedStatement psTx = null;

        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            psUpdate = conn.prepareStatement(updateStockSql);
            psTx = conn.prepareStatement(insertTxSql);

            for (int i = 0; i < productIds.size(); i++) {
                int pId = productIds.get(i);
                int qAdded = quantitiesAdded.get(i);

                if (qAdded <= 0) continue;

                psUpdate.setInt(1, qAdded);
                psUpdate.setInt(2, pId);
                psUpdate.addBatch();

                psTx.setInt(1, pId);
                psTx.setInt(2, qAdded);
                psTx.addBatch();
            }

            psUpdate.executeBatch();
            psTx.executeBatch();

            conn.commit();
            return true;
        } catch (Exception e) {
            if (conn != null) {
                try { conn.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            }
            e.printStackTrace();
            return false;
        } finally {
            try {
                if (psUpdate != null) psUpdate.close();
                if (psTx != null) psTx.close();
                if (conn != null) conn.close();
            } catch (Exception e) { e.printStackTrace(); }
        }
    }
}