package com.example.backend.controller.admin;

import com.example.backend.dao.OrderDao;
import com.example.backend.model.Order;
import com.example.backend.model.OrderItem;
import com.example.backend.model.User;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "AdminOrderServlet", value = "/admin/orders")
public class AdminOrderServlet extends HttpServlet {

    private OrderDao orderDao = new OrderDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if(user == null || user.getRoleId()!=1){
            response.sendRedirect(request.getContextPath()+"/login");
            return;
        }
        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }

        switch (action) {
            case "detail":
                viewOrderDetail(request, response);
                break;
            case "list":
            default:
                viewOrderList(request, response);
                break;
        }
    }


    private void viewOrderList(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int page = 1;
        int pageSize = 1000;

        List<Order> orders;
        String search = request.getParameter("search");
        if(search!=null && !search.trim().isEmpty()){
            orders = orderDao.searchOrdersByName(search);
            request.setAttribute("searchQuery",search.trim());
        }else{
            orders = orderDao.getAllOrders();
        }
        int totalOrders = orders.size();

        request.setAttribute("orders", orders);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", 1);
        request.setAttribute("pageSize", pageSize);
        request.setAttribute("totalOrders", totalOrders);

        request.getRequestDispatcher("/admin/orders/order-list.jsp").forward(request, response);
    }

    
    private void viewOrderDetail(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            Order order = orderDao.getOrderById(id); 
            List<OrderItem> details = orderDao.getOrderItems(id); 

            if (order != null) {
                request.setAttribute("order", order);
                request.setAttribute("details", details);
                
                request.getRequestDispatcher("/admin/orders/order-detail.jsp").forward(request, response);
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/orders");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/orders");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null || user.getRoleId() != 1) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        String action = request.getParameter("action");

        if ("updateStatus".equals(action)) {
            updateOrderStatus(request, response);
        } else {
            
            response.sendRedirect(request.getContextPath() + "/admin/orders");
        }
    }

    private void updateOrderStatus(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            int orderId = Integer.parseInt(request.getParameter("order_id"));
            String newStatus = request.getParameter("order_status");

            String updateOrderSql = "UPDATE orders SET order_status = ? WHERE id = ?";

            String updateStockSql = "UPDATE products p " +
                    "JOIN order_items oi ON p.id = oi.product_id " +
                    "SET p.stock = p.stock - oi.quantity, " +
                    "    p.sold_quantity = p.sold_quantity + oi.quantity " +
                    "WHERE oi.order_id = ?";

            String insertTransactionSql = "INSERT INTO inventory_transactions (product_id, transaction_type, quantity, reason) " +
                    "SELECT product_id, 'EXPORT', quantity, 'Xuất kho tự động từ đơn hàng thành công' " +
                    "FROM order_items WHERE order_id = ?";

            java.sql.Connection conn = null;
            java.sql.PreparedStatement psOrder = null;
            java.sql.PreparedStatement psUpdateStock = null;
            java.sql.PreparedStatement psInsertTx = null;
            boolean success = false;

            try {
                conn = com.example.backend.util.DBConnection.getConnection();
                conn.setAutoCommit(false);

                psOrder = conn.prepareStatement(updateOrderSql);
                psOrder.setString(1, newStatus);
                psOrder.setInt(2, orderId);
                psOrder.executeUpdate();

                if ("Hoàn thành".equalsIgnoreCase(newStatus) || "completed".equalsIgnoreCase(newStatus)) {

                    psUpdateStock = conn.prepareStatement(updateStockSql);
                    psUpdateStock.setInt(1, orderId);
                    psUpdateStock.executeUpdate();

                    psInsertTx = conn.prepareStatement(insertTransactionSql);
                    psInsertTx.setInt(1, orderId);
                    psInsertTx.executeUpdate();
                }

                conn.commit();
                success = true;
            } catch (Exception e) {
                if (conn != null) {
                    try {
                        conn.rollback();
                    } catch (java.sql.SQLException ex) {
                        ex.printStackTrace();
                    }
                }
                e.printStackTrace();
            } finally {
                try {
                    if (psOrder != null) psOrder.close();
                    if (psUpdateStock != null) psUpdateStock.close();
                    if (psInsertTx != null) psInsertTx.close();
                    if (conn != null) conn.close();
                } catch (Exception e) { e.printStackTrace(); }
            }

            if (success) {
                response.sendRedirect(request.getContextPath() + "/admin/orders?action=detail&id=" + orderId + "&status=updated");
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/orders?action=detail&id=" + orderId + "&status=error");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin/orders");
        }
    }
}