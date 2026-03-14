package com.example.backend.controller.user;

import com.example.backend.dao.UserDAO;
import com.example.backend.model.User;
import com.example.backend.util.PasswordUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String agreeTerms = request.getParameter("agreeTerms");

        if (isNullOrEmpty(fullName) || isNullOrEmpty(email) ||
                isNullOrEmpty(phone) || isNullOrEmpty(password)) {
            setErrorAndForward(request, response, "Vui lòng nhập đầy đủ thông tin!");
            return;
        }

        if (agreeTerms == null) {
            setErrorAndForward(request, response, "Bạn cần đồng ý với điều khoản sử dụng!");
            return;
        }

        if (!isValidEmail(email)) {
            setErrorAndForward(request, response, "Email không hợp lệ!");
            return;
        }

        if (!isValidPhone(phone)) {
            setErrorAndForward(request, response, "Số điện thoại không hợp lệ (10-11 số)!");
            return;
        }

        if (!PasswordUtil.isValidPassword(password)) {
            setErrorAndForward(request, response, "Mật khẩu phải có ít nhất 6 ký tự!");
            return;
        }

        if (!password.equals(confirmPassword)) {
            setErrorAndForward(request, response, "Mật khẩu xác nhận không khớp!");
            return;
        }

        if (userDAO.isEmailExists(email.trim())) {
            setErrorAndForward(request, response, "Email này đã được sử dụng!");
            return;
        }

        if (userDAO.isPhoneExists(phone.trim())) {
            setErrorAndForward(request, response, "Số điện thoại này đã được sử dụng!");
            return;
        }

        String hashedPassword = PasswordUtil.encrypt(password);
        User newUser = new User(
                fullName.trim(),
                email.trim().toLowerCase(),
                phone.trim(),
                hashedPassword
        );

        boolean success = userDAO.register(newUser);

        if (success) {
            HttpSession session = request.getSession();
            String redirectUrl = (String) session.getAttribute("postLoginRedirect");
            
            
            User user = userDAO.findByEmailOrPhone(email.trim().toLowerCase());
            
            if (user != null) {
                session.setAttribute("user", user);
                session.setAttribute("userId", user.getId());
                session.setAttribute("userName", user.getFullName());
                session.setAttribute("userRole", user.getRole());
                session.setMaxInactiveInterval(30 * 60);

                if (redirectUrl != null && !redirectUrl.trim().isEmpty()) {
                    session.removeAttribute("postLoginRedirect");
                    response.sendRedirect(redirectUrl);
                    return;
                }
            }

            request.setAttribute("successMessage", "Đăng ký thành công! Chào mừng bạn.");
            response.sendRedirect(request.getContextPath() + "/index");

        } else {
            setErrorAndForward(request, response, "Đăng ký thất bại! Vui lòng thử lại.");
        }
    }

    private boolean isNullOrEmpty(String str) {
        return str == null || str.trim().isEmpty();
    }

    private boolean isValidEmail(String email) {
        if (email == null) return false;
        return email.matches("^[\\w.-]+@[\\w.-]+\\.[a-zA-Z]{2,}$");
    }

    private boolean isValidPhone(String phone) {
        if (phone == null) return false;
        return phone.matches("^[0-9]{10,11}$");
    }

    private void setErrorAndForward(HttpServletRequest request,
                                    HttpServletResponse response,
                                    String errorMessage)
            throws ServletException, IOException {
        request.setAttribute("errorMessage", errorMessage);
        request.setAttribute("fullName", request.getParameter("fullName"));
        request.setAttribute("email", request.getParameter("email"));
        request.setAttribute("phone", request.getParameter("phone"));
        request.getRequestDispatcher("/register.jsp").forward(request, response);
    }
}
