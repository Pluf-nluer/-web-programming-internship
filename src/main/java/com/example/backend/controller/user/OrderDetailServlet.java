package com.example.backend.controller.user;

import com.example.backend.dao.OrderDao;
import com.example.backend.model.Order;
import com.example.backend.model.OrderItem;
import com.example.backend.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/order-detail")
public class OrderDetailServlet extends HttpServlet {
    private OrderDao orderDao;
    @Override
    public void init() throws ServletException {
        orderDao = new OrderDao();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if(user==null){
            response.sendRedirect(request.getContextPath()+"/login");
            return;
        }
        String orderId = request.getParameter("id");
        if(orderId == null || orderId.isEmpty()){
            response.sendRedirect(request.getContextPath()+"/user-orders");
            return;
        }
        try {
            int id = Integer.parseInt(orderId);
            Order order = orderDao.getOrderById(id);
            if(order == null || order.getUser_id() != user.getId()){
                response.sendRedirect(request.getContextPath()+"/user-orders");
                return;
            }
            List<OrderItem> orderItems = orderDao.getOrderItems(id);
            request.setAttribute("order",order);
            request.setAttribute("orderItems",orderItems);
            request.getRequestDispatcher("/account/order-detail.jsp").forward(request,response);

        }catch (NumberFormatException e){
            response.sendRedirect(request.getContextPath()+"/user-orders");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request,response);
    }
}
