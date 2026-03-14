package com.example.backend.controller.admin;

import com.example.backend.dao.OrderDao;
import com.example.backend.model.Order;
import com.example.backend.service.ProductService;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "AdminDashboardServlet", value = "/admin/dashboard")
public class AdminDashboardServlet extends HttpServlet {

    private final ProductService productService = new ProductService();
    private final OrderDao orderDao = new OrderDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        int totalProducts = productService.getAllProductsForAdmin(0, 10000).size();

        List<Order> allOrders = orderDao.getAllOrders();

        long pendingOrders = 0;
        double monthlyRevenue = 0;

        for (Order o : allOrders) {
            if ("pending".equalsIgnoreCase(o.getOrder_status())) {
                pendingOrders++;
            }
            monthlyRevenue += o.getTotal_amount();
        }

        
        request.setAttribute("totalProducts", totalProducts);
        request.setAttribute("ordersToday", allOrders.size()); 
        request.setAttribute("pendingOrders", pendingOrders);
        request.setAttribute("monthlyRevenue", monthlyRevenue);
        
        List<Order> recentOrders = allOrders.stream().limit(5).toList();
        request.setAttribute("recentOrders", recentOrders);

        request.getRequestDispatcher("/admin/dashboard.jsp").forward(request, response);
    }
}
