package com.example.backend.controller.user;

import com.example.backend.dao.UserDAO;
import com.example.backend.model.User;
import com.example.backend.util.PasswordUtil;
import com.example.backend.util.RememberMeUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    private UserDAO userDAO;
    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
    }
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session != null) {
            Object sessionUser = session.getAttribute("user");
            if (sessionUser instanceof User) {
                User user = (User) sessionUser;
                if (user.isAdmin()) {
                    response.sendRedirect(request.getContextPath() + "/admin/dashboard");
                    return;
                }
                response.sendRedirect(request.getContextPath() + "/index");
                return;
            }
        }
        request.getRequestDispatcher("/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        String emailOrPhone = request.getParameter("emailOrPhone");
        String password = request.getParameter("password");
        String rememberMe = request.getParameter("rememberMe");

        if (emailOrPhone == null || emailOrPhone.trim().isEmpty() ||
                password == null || password.trim().isEmpty()) {
            showLoginError(request, response, "Vui lòng nhập đầy đủ thông tin!", emailOrPhone, rememberMe);
            return;
        }

        String hashedPassword = PasswordUtil.encrypt(password);
        User user = userDAO.checkLogin(emailOrPhone, hashedPassword);

        if (user != null && !user.isActive()) {
            showLoginError(request, response, "Tài khoản đang bị khóa!", emailOrPhone, rememberMe);
            return;
        }

        if (user == null) {
            showLoginError(request, response, "Email/SĐT hoặc mật khẩu không đúng!", emailOrPhone, rememberMe);
            return;
        }

        HttpSession session = request.getSession(true);
        session.setAttribute("user", user);
        session.setAttribute("userId", user.getId());
        session.setAttribute("userName", user.getFullName());
        session.setAttribute("userRole", user.getRole());

        boolean rememberLogin = "on".equals(rememberMe) && !user.isAdmin();
        session.setMaxInactiveInterval(rememberLogin ? RememberMeUtil.MAX_AGE_SECONDS : 30 * 60);

        if (rememberLogin) {
            response.addCookie(RememberMeUtil.createCookie(user, request.isSecure()));
        } else {
            response.addCookie(RememberMeUtil.clearCookie(request.isSecure()));
        }

        if (user.isAdmin()) {
            session.removeAttribute("postLoginRedirect");
            response.sendRedirect(request.getContextPath() + "/admin/dashboard");
            return;
        }

        String redirectUrl = (String) session.getAttribute("postLoginRedirect");
        if (redirectUrl != null && !redirectUrl.trim().isEmpty()) {
            session.removeAttribute("postLoginRedirect");
            response.sendRedirect(redirectUrl);
            return;
        }

        response.sendRedirect(request.getContextPath() + "/");
    }

    private void showLoginError(HttpServletRequest request, HttpServletResponse response, String message,
                                String emailOrPhone, String rememberMe) throws ServletException, IOException {
        request.setAttribute("errorMessage", message);
        request.setAttribute("emailOrPhone", emailOrPhone);
        request.setAttribute("rememberMe", rememberMe);
        request.getRequestDispatcher("/login.jsp").forward(request, response);
    }
}