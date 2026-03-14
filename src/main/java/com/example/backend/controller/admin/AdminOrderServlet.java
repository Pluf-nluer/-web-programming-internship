package com.example.backend.controller.admin;

import com.example.backend.dao.OrderDao;
import com.example.backend.model.Order;
import com.example.backend.model.OrderItem;
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
        int pageSize = 8;
        try {
            if (request.getParameter("page") != null) {
                page = Integer.parseInt(request.getParameter("page"));
            }
            if (request.getParameter("pageSize") != null) {
                pageSize = Integer.parseInt(request.getParameter("pageSize"));
            }
        } catch (NumberFormatException e) {
            page = 1;
        }
        List<Order> orders = orderDao.getAllOrders(); 

        int totalOrders = orders.size(); 
        int totalPages = (int) Math.ceil((double) totalOrders / pageSize);

        request.setAttribute("orders", orders);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("pageSize", pageSize);
        request.setAttribute("totalOrders", totalOrders);

        request.getRequestDispatcher("/admin/orders/order-list.jsp").forward(request, response);    }

    
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

            
            boolean success = orderDao.updateOrderStatus(orderId, newStatus);

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