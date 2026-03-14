package com.example.backend.controller.user;

import com.example.backend.dao.OrderDao;
import com.example.backend.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/cancel-order")
public class CancelOrderServlet extends HttpServlet {

    private OrderDao orderDao;

    @Override
    public void init() throws ServletException {
        orderDao = new OrderDao();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String orderIdStr = request.getParameter("orderId");
        if (orderIdStr != null && !orderIdStr.isEmpty()) {
            try {
                int orderId = Integer.parseInt(orderIdStr);
                boolean success = orderDao.cancelOrder(orderId, user.getId());

                if (success) {
                    session.setAttribute("message", "Hủy đơn hàng thành công!");
                    session.setAttribute("messageType", "success");
                } else {
                    session.setAttribute("message", "Không thể hủy đơn hàng. Vui lòng thử lại!");
                    session.setAttribute("messageType", "error");
                }
            } catch (NumberFormatException e) {
                e.printStackTrace();
                session.setAttribute("message", "Mã đơn hàng không hợp lệ!");
                session.setAttribute("messageType", "error");
            }
        }
        response.sendRedirect(request.getContextPath() + "/account/order.jsp");
    }
}
