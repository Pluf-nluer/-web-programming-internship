package com.example.backend.controller.user;

import com.example.backend.service.AuthService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet(name = "ForgotPasswordServlet", urlPatterns = "/forgot-password")
public class ForgotPasswordServlet extends HttpServlet {

    private AuthService authService = new AuthService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("/forgot-password.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email = request.getParameter("email");
        String message;

        if (email == null || email.trim().isEmpty()) {
            message = "Vui lòng nhập địa chỉ email của bạn.";
            request.setAttribute("errorMessage", message);
            request.getRequestDispatcher("/forgot-password.jsp").forward(request, response);
            return;
        }

        boolean success = authService.handleForgotPassword(email);

        if (success) {
            message = "Mật khẩu mới đã được gửi đến email của bạn. Vui lòng kiểm tra hộp thư đến (và cả thư rác/spam) để nhận mật khẩu mới.";
            request.setAttribute("successMessage", message);
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        } else {
            message = "Email không tồn tại trong hệ thống hoặc có lỗi xảy ra. Vui lòng kiểm tra lại.";
            request.setAttribute("errorMessage", message);
            request.getRequestDispatcher("/forgot-password.jsp").forward(request, response);
        }
    }
}
