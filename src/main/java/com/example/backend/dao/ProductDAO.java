package com.example.backend.dao;

import com.example.backend.model.Product;
import com.example.backend.model.ProductAttribute;
import com.example.backend.model.ProductImage;
import com.example.backend.model.Review;
import com.example.backend.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Set;

public class ProductDAO {

    public List<Product> getFeaturedProducts() {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT * FROM products WHERE is_featured = 1 AND status = 'active' LIMIT 8";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(mapResultSetToProduct(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }


    


    public List<Product> getSaleProducts() {
        List<Product> list = new ArrayList<>();

        String sql = "SELECT p.* FROM products p JOIN product_categories pc ON p.category_id = pc.id " +
                "JOIN sale s on pc.sale_id = s.id "+
                "WHERE NOW() BETWEEN s.start_sale AND s.end_sale AND p.status = 'active'";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(mapResultSetToProduct(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

//    public List<Product> getAllProducts(int offset, int limit) {
//        List<Product> list = new ArrayList<>();
//
//       String sql = "SELECT p.*, pi.image_url FROM products p " +
//                "LEFT JOIN product_images pi ON p.id = pi.product_id " +
//                "GROUP BY p.id ORDER BY p.id LIMIT ?, ?";
//
//
//        try (Connection conn = DBConnection.getConnection();
//        PreparedStatement ps = conn.prepareStatement(sql);) {
//            ps.setInt(1, offset);
//            ps.setInt(2, limit);
//            ResultSet rs = ps.executeQuery();
//            while(rs.next()) {
//                list.add(mapResultSetToProduct(rs));
//            }
//        } catch (Exception e) {
//            e.printStackTrace();
//        }
//        return list;
//    }
    public List<Product> getAllProducts(int offset, int limit) {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT p.*, " +
                "(SELECT pi.image_url FROM product_images pi WHERE pi.product_id = p.id LIMIT 1) AS image_url, " +
                "s.discount_percent " +
                "FROM products p " +
                "LEFT JOIN product_categories pc ON p.category_id = pc.id " +
                "LEFT JOIN sale s ON pc.sale_id = s.id AND (NOW() BETWEEN s.start_sale AND s.end_sale) " +
                "ORDER BY p.id LIMIT ?, ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, offset);
            ps.setInt(2, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Product p = mapResultSetToProduct(rs);
                    p.setDiscountPercent(rs.getDouble("discount_percent"));
                    list.add(p);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public int getTotalProductsCount() {
        String sql = "select count(*) from products where status = 'active'";
        try (Connection conn = DBConnection.getConnection();
        PreparedStatement ps = conn.prepareStatement(sql);
        ResultSet rs = ps.executeQuery()) {
            if (rs.next()) { return rs.getInt(1); }
        }
        catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public List<Product> getProductsByCategory(int categoryId, int offset, int limit) {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT p.*, " +
                "(SELECT pi.image_url FROM product_images pi WHERE pi.product_id = p.id LIMIT 1) AS image_url, " +
                "s.discount_percent " +
                "FROM products p " +
                "LEFT JOIN product_categories pc ON p.category_id = pc.id " +
                "LEFT JOIN sale s ON pc.sale_id = s.id AND (NOW() BETWEEN s.start_sale AND s.end_sale) " +
                "WHERE p.category_id = ? AND p.status = 'active' " +
                "ORDER BY p.id LIMIT ?, ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, categoryId);
            ps.setInt(2, offset);
            ps.setInt(3, limit);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Product p = mapResultSetToProduct(rs);
                    p.setDiscountPercent(rs.getDouble("discount_percent"));
                    list.add(p);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public int getTotalProductsCountByCategory(int categoryId) {
        String sql = "SELECT COUNT(*) FROM products WHERE category_id = ? AND status = 'active'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, categoryId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public List<Product> getRelatedProducts(int categoryId, int currentProductId, int limit) {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT p.*, " +
                "(SELECT pi.image_url FROM product_images pi WHERE pi.product_id = p.id LIMIT 1) AS image_url, " +
                "s.discount_percent " +
                "FROM products p " +
                "LEFT JOIN product_categories pc ON p.category_id = pc.id " +
                "LEFT JOIN sale s ON pc.sale_id = s.id AND (NOW() BETWEEN s.start_sale AND s.end_sale) " +
                "WHERE p.category_id = ? AND p.id != ? AND p.status = 'active' " +
                "LIMIT ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, categoryId);
            ps.setInt(2, currentProductId);
            ps.setInt(3, limit);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Product p = mapResultSetToProduct(rs);
                p.setDiscountPercent(rs.getDouble("discount_percent"));
                list.add(p);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public Product getProductById(int id) {
        Product product = null;
        String sql = "SELECT p.*, " +
                "(SELECT pi.image_url FROM product_images pi WHERE pi.product_id = p.id LIMIT 1) AS image_url, " +
                "s.discount_percent " +
                "FROM products p " +
                "LEFT JOIN product_categories pc ON p.category_id = pc.id " +
                "LEFT JOIN sale s ON pc.sale_id = s.id AND (NOW() BETWEEN s.start_sale AND s.end_sale) " +
                "WHERE p.id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                product = mapResultSetToProduct(rs);
                product.setDiscountPercent(rs.getDouble("discount_percent"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return product;
    }

    public List<Product> searchProductsByName(String keyword) {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT p.*, pi.image_url FROM products p " +
                "LEFT JOIN product_images pi ON p.id = pi.product_id " +
                "WHERE p.name LIKE ? AND p.status = 'active' " +
                "GROUP BY p.id";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, "%" + keyword + "%");
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapResultSetToProduct(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Product> getAllProductsSorted(String orderBy, String direction) {
        List<Product> list = new ArrayList<>();

        Set<String> allowedOrderBy = Set.of(
                "price", "name", "created_at", "stock"
        );
        if (!allowedOrderBy.contains(orderBy)) {
            orderBy = "price";
        }
        String sortDir = "ASC";
        if ("DESC".equalsIgnoreCase(direction)) {
            sortDir = "DESC";
        }

        String sql = "SELECT * FROM products WHERE status = 'active' ORDER BY "+ orderBy+ " " + sortDir;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(mapResultSetToProduct(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
    public boolean updateProductImage(int productId, ProductImage pi) {
        String updateSql = "UPDATE product_images SET image_url = ? WHERE product_id = ?";
        String insertSql = "INSERT INTO product_images (product_id, image_url) VALUES (?, ?)";

        try (Connection conn = DBConnection.getConnection()) {
            try (PreparedStatement ps = conn.prepareStatement(updateSql)) {
                ps.setString(1, pi.getImageUrl());
                ps.setInt(2, productId);
                int rows = ps.executeUpdate();
                if (rows > 0) return true;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateProductAttribute(int productId, ProductAttribute pa) {
        String updateSql = "UPDATE product_attributes SET origin = ?, material = ?, size = ?, weight = ?, color = ? WHERE product_id = ?";
        String insertSql = "INSERT INTO product_attributes (product_id, origin, material, size, weight, color, created_at) VALUES (?, ?, ?, ?, ?, ?, NOW())";

        try (Connection conn = DBConnection.getConnection()) {
            try (PreparedStatement ps = conn.prepareStatement(updateSql)) {
                ps.setString(1, pa.getOrigin());
                ps.setString(2, pa.getMaterial());
                ps.setString(3, pa.getSize());
                ps.setString(4, pa.getWeight());
                ps.setString(5, pa.getColor());
                ps.setInt(6, productId);
                int rows = ps.executeUpdate();
                if (rows > 0) return true;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public int updateProduct(Product p) {
        String sql = "UPDATE products SET name=?, price=?, stock=?, " +
                "full_description=?, status=?, is_featured=?, " +
                "category_id=?, updated_at=NOW() WHERE id=?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, p.getName());

            ps.setDouble(2, p.getPrice());

            ps.setInt(3, p.getStock());
            ps.setString(4, p.getFullDescription());
            ps.setString(5, p.getStatus());
            ps.setBoolean(6, p.isFeatured());
            ps.setInt(7, p.getCategoryId());
            ps.setInt(8, p.getId());

            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return p.getId();
    }

    public int insertProduct(Product p) {
        String sql = "INSERT INTO products (name, price, stock, category_id, full_description, status, is_featured, created_at) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, NOW())";

        int generatedId = -1;
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setString(1, p.getName());
            ps.setDouble(2, p.getPrice());
            ps.setInt(3, p.getStock());
            ps.setInt(4, p.getCategoryId());
            ps.setString(5, p.getFullDescription());
            ps.setString(6, p.getStatus());
            ps.setBoolean(7, p.isFeatured());

            int rows = ps.executeUpdate();
            if (rows > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        generatedId = rs.getInt(1);
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return generatedId;
    }

    public void insertProductAttributes(int productId, ProductAttribute pa) {
        String sql = "INSERT INTO product_attributes (product_id, material, origin, size, weight, color, created_ad) VALUES (?, ?, ?, ?, ?, ?, NOW())";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, productId);
            ps.setString(2, pa.getMaterial());
            ps.setString(3, pa.getOrigin());
            ps.setString(4, pa.getSize()); 
            ps.setString(5, pa.getWeight());
            ps.setString(6, pa.getColor());
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void insertProductImage(int productId, String imageUrl) {
        String sql = "INSERT INTO product_images (product_id, image_url) VALUES (?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, productId);
            ps.setString(2, imageUrl);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private Product mapResultSetToProduct(ResultSet rs) throws Exception {
        Product p = new Product();
        p.setId(rs.getInt("id"));
        p.setName(rs.getString("name"));
        p.setPrice(rs.getDouble("price"));
        p.setStock(rs.getInt("stock"));
        p.setFullDescription(rs.getString("full_description"));
        p.setStatus(rs.getString("status"));
        p.setFeatured(rs.getBoolean("is_featured"));
        p.setCategoryId(rs.getInt("category_id"));

        ProductImage img = new ProductImage();

        try {
            String url = rs.getString("image_url");
            img.setImageUrl(url);
        } catch (Exception e) {
            e.printStackTrace();
        }

        p.setImage(img);
        return p;
    }

    public ProductAttribute getAttributeByProductId(int productId) {
        ProductAttribute attr = null;
        String sql = "SELECT * FROM product_attributes WHERE product_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, productId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                attr = new ProductAttribute();
                attr.setOrigin(rs.getString("origin"));
                attr.setMaterial(rs.getString("material"));
                attr.setSize(rs.getString("size"));
                attr.setWeight(rs.getString("weight"));
                attr.setColor(rs.getString("color"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return attr;
    }

    public void deleteProduct(int id) {
        String sql = "update products set status = 'inactive' where id = ? ";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public List<Review> getReviewsByProductId(int productId) {
        List<Review> reviews = new ArrayList<>();
        String sql = "SELECT r.*, u.full_name FROM review r " +
                "JOIN users u ON r.user_id = u.id " +
                "WHERE r.pid = ? ORDER BY r.create_at DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, productId);
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

}