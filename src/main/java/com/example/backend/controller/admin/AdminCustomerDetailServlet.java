package com.example.backend.controller.admin;

import com.example.backend.dao.UserDAO;
import com.example.backend.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/admin/customers/detail")
public class AdminCustomerDetailServlet extends HttpServlet {

    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        int userId = parseIntOrDefault(request.getParameter("id"), -1);
        if (userId <= 0) {
            setFlashMessage(request.getSession(true), "ID khách hàng không hợp lệ.", "error");
            response.sendRedirect(request.getContextPath() + "/admin/customers");
            return;
        }

        User customer = userDAO.getUserById(userId);
        if (customer == null || customer.isAdmin()) {
            setFlashMessage(request.getSession(true), "Không tìm thấy khách hàng.", "error");
            response.sendRedirect(request.getContextPath() + "/admin/customers");
            return;
        }

        request.setAttribute("customer", customer);
        request.getRequestDispatcher("/admin/customers/customer-detail.jsp").forward(request, response);
    }

    private int parseIntOrDefault(String value, int defaultValue) {
        if (value == null) {
            return defaultValue;
        }
        try {
            return Integer.parseInt(value);
        } catch (NumberFormatException e) {
            return defaultValue;
        }
    }

    private void setFlashMessage(HttpSession session, String message, String type) {
        session.setAttribute("adminCustomerMessage", message);
        session.setAttribute("adminCustomerMessageType", type);
    }
}
