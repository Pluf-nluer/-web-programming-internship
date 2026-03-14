package com.example.backend.dao;

import com.example.backend.model.*;
import com.example.backend.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class OrderDao {

    
    public int saveOrder(Order order, Cart cart) {
        Connection con = null;
        PreparedStatement preOrder = null;
        PreparedStatement preDetail = null;
        ResultSet rs = null;
        int orderId = 0; 

        try {
            con = DBConnection.getConnection();
            
            con.setAutoCommit(false);

            
            String sqlOrder = "INSERT INTO orders (user_id, shipping_name, shipping_phone, shipping_address, shipping_fee, note, total_amount, order_status, created_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
            preOrder = con.prepareStatement(sqlOrder, Statement.RETURN_GENERATED_KEYS);
            preOrder.setInt(1, order.getUser_id());
            preOrder.setString(2, order.getShipping_name());
            preOrder.setString(3, order.getShipping_phone());
            preOrder.setString(4, order.getShipping_address());
            preOrder.setDouble(5, order.getShipping_fee());
            preOrder.setString(6, order.getNote());
            preOrder.setDouble(7, order.getTotal_amount());
            preOrder.setString(8, "Pending"); 
            preOrder.setTimestamp(9, new Timestamp(System.currentTimeMillis()));

            int affectedRows = preOrder.executeUpdate();

            
            if (affectedRows > 0) {
                rs = preOrder.getGeneratedKeys();
                if (rs.next()) {
                    
                    orderId = rs.getInt(1);
                    order.setId(orderId);
                }
            } else {
                con.rollback();
                return 0;
            }

            
            String sqlDetail = "INSERT INTO order_items (order_id, product_id, quantity, total_price) VALUES (?, ?, ?, ?)";
            preDetail = con.prepareStatement(sqlDetail);

            
            for (CartItem item : cart.getItems()) {
                preDetail.setInt(1, orderId); 
                preDetail.setInt(2, item.getProduct().getId());
                preDetail.setInt(3, item.getQuantity());
                preDetail.setDouble(4, item.getProduct().getPrice() * item.getQuantity());

                preDetail.addBatch();
            }
            preDetail.executeBatch();

            con.commit();

        } catch (SQLException e) {
            try {
                if (con != null) {
                    con.rollback();
                }
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
            e.printStackTrace();
            return 0; 
        } finally {
            
            try {
                if (rs != null) rs.close();
                if (preOrder != null) preOrder.close();
                if (preDetail != null) preDetail.close();
                if (con != null) {
                    con.setAutoCommit(true); 
                    con.close();
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        return orderId;
    }

    
    public List<Order> getAllOrders() {
        List<Order> list = new ArrayList<>();
        String sql = "select * from orders order by id desc";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pre = conn.prepareStatement(sql);
             ResultSet rs = pre.executeQuery()) {

            while (rs.next()) {
                Order o = new Order();
                o.setId(rs.getInt("id"));
                o.setUser_id(rs.getInt("user_id"));
                o.setShipping_name(rs.getString("shipping_name"));
                o.setShipping_phone(rs.getString("shipping_phone"));
                o.setShipping_address(rs.getString("shipping_address"));
                o.setNote(rs.getString("note"));
                o.setShipping_fee(rs.getDouble("shipping_fee"));
                o.setTotal_amount(rs.getDouble("total_amount"));
                o.setOrder_status(rs.getString("order_status"));
                o.setCreated_at(rs.getTimestamp("created_at"));
                o.setUpdated_at(rs.getTimestamp("updated_at"));

                list.add(o);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Order> getOrdersByUserId(int userId) {
        List<Order> list = new ArrayList<>();
        String sql = "select * from orders where user_id = ? order by id desc";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pre = conn.prepareStatement(sql)) {

            pre.setInt(1, userId);
            ResultSet rs = pre.executeQuery();

            while (rs.next()) {
                Order o = new Order();
                o.setId(rs.getInt("id"));
                o.setUser_id(rs.getInt("user_id"));
                o.setShipping_name(rs.getString("shipping_name"));
                o.setShipping_phone(rs.getString("shipping_phone"));
                o.setShipping_address(rs.getString("shipping_address"));
                o.setNote(rs.getString("note"));
                o.setShipping_fee(rs.getDouble("shipping_fee"));
                o.setTotal_amount(rs.getDouble("total_amount"));
                o.setOrder_status(rs.getString("order_status"));
                o.setCreated_at(rs.getTimestamp("created_at"));
                o.setUpdated_at(rs.getTimestamp("updated_at"));

                list.add(o);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    
    public Order getOrderById(int id) {
        String sql = "select * from orders where id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement pre = con.prepareStatement(sql)) {

            pre.setInt(1, id);
            ResultSet rs = pre.executeQuery();

            if (rs.next()) {
                Order o = new Order();
                o.setId(rs.getInt("id"));
                o.setUser_id(rs.getInt("user_id"));
                o.setShipping_name(rs.getString("shipping_name"));
                o.setShipping_phone(rs.getString("shipping_phone"));
                o.setShipping_address(rs.getString("shipping_address"));
                o.setNote(rs.getString("note"));
                o.setShipping_fee(rs.getDouble("shipping_fee"));
                o.setTotal_amount(rs.getDouble("total_amount"));
                o.setOrder_status(rs.getString("order_status"));
                o.setCreated_at(rs.getTimestamp("created_at"));
                return o;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<OrderItem> getOrderItems(int orderId) {
        List<OrderItem> list = new ArrayList<>();
        
        String sql = "SELECT oi.id AS item_id, oi.order_id, oi.product_id, oi.quantity, oi.total_price, " +
                "p.name AS product_name, p.price AS product_price, " +
                "(SELECT image_url FROM product_images WHERE product_id = p.id LIMIT 1) AS image_url " +
                "FROM order_items oi " +
                "JOIN products p ON oi.product_id = p.id " +
                "WHERE oi.order_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                OrderItem item = new OrderItem();
                item.setId(rs.getInt("item_id")); 
                item.setOrderId(rs.getInt("order_id"));
                item.setProductId(rs.getInt("product_id"));
                item.setQuantity(rs.getInt("quantity"));
                item.setTotalPrice(rs.getDouble("total_price"));

                Product p = new Product();
                p.setId(rs.getInt("product_id"));
                p.setName(rs.getString("product_name"));
                p.setPrice(rs.getDouble("product_price"));

                String url = rs.getString("image_url");
                ProductImage pi = new ProductImage();
                pi.setImageUrl(url != null ? url : "");
                p.setImage(pi);

                item.setProduct(p);
                list.add(item);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public Order getLatestOrderByUserId(int userId) {
        String sql = "SELECT * FROM orders WHERE user_id = ? ORDER BY created_at DESC LIMIT 1";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Order o = new Order();
                o.setId(rs.getInt("id"));
                o.setCreated_at(rs.getTimestamp("created_at"));
                o.setTotal_amount(rs.getDouble("total_amount"));
                return o;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean cancelOrder(int orderId, int userId) {
        String sql = "UPDATE orders SET order_status = 'Cancelled', updated_at = ? WHERE id = ? AND user_id = ? AND order_status = 'Pending'";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement pre = con.prepareStatement(sql)) {

            pre.setTimestamp(1, new Timestamp(System.currentTimeMillis()));
            pre.setInt(2, orderId);
            pre.setInt(3, userId);

            int affectedRows = pre.executeUpdate();
            return affectedRows > 0; 

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean updateOrderStatus(int orderId, String status) {
        String sql = "UPDATE orders SET order_status = ?, updated_at = ? WHERE id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement pre = con.prepareStatement(sql)) {

            pre.setString(1, status);
            pre.setTimestamp(2, new Timestamp(System.currentTimeMillis()));
            pre.setInt(3, orderId);

            return pre.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}