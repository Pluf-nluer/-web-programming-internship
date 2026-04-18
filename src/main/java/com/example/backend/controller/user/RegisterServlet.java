package com.example.backend.controller.user;

import com.example.backend.dao.UserDAO;
import com.example.backend.model.User;
import com.example.backend.util.PhoneNumberUtil;
import com.example.backend.util.PasswordUtil;
import com.example.backend.util.EmailValidationUtil;
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
        String normalizedEmail = EmailValidationUtil.normalize(email);
        String phone = request.getParameter("phone");
        String normalizedPhone = PhoneNumberUtil.normalize(phone);
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String agreeTerms = request.getParameter("agreeTerms");

        if (isNullOrEmpty(fullName) || isNullOrEmpty(normalizedEmail) ||
                isNullOrEmpty(normalizedPhone) || isNullOrEmpty(password)) {
            setErrorAndForward(request, response, "Vui lòng nhập đầy đủ thông tin!");
            return;
        }

        if (agreeTerms == null) {
            setErrorAndForward(request, response, "Bạn cần đồng ý với điều khoản sử dụng!");
            return;
        }

        if (!isValidEmail(normalizedEmail)) {
            setErrorAndForward(request, response, "Email không hợp lệ. Vui lòng nhập email thật và đúng định dạng.");
            return;
        }

        if (!isValidPhone(phone)) {
            setErrorAndForward(request, response, "Số điện thoại không hợp lệ. Vui lòng nhập số di động Việt Nam đúng đầu số.");
            return;
        }

        if (!PasswordUtil.isValidPassword(password)) {
            setErrorAndForward(request, response, PasswordUtil.getPasswordRequirementMessage());
            return;
        }

        if (!password.equals(confirmPassword)) {
            setErrorAndForward(request, response, "Mật khẩu xác nhận không khớp!");
            return;
        }

        if (userDAO.isEmailExists(normalizedEmail)) {
            setErrorAndForward(request, response, "Email này đã được sử dụng!");
            return;
        }

        if (userDAO.isPhoneExists(normalizedPhone)) {
            setErrorAndForward(request, response, "Số điện thoại này đã được sử dụng!");
            return;
        }

        String hashedPassword = PasswordUtil.encrypt(password);
        User newUser = new User(
                fullName.trim(),
                normalizedEmail,
                normalizedPhone,
                hashedPassword
        );

        boolean success = userDAO.register(newUser);

        if (success) {
            HttpSession session = request.getSession();
            String redirectUrl = (String) session.getAttribute("postLoginRedirect");

            User user = userDAO.findByEmailOrPhone(normalizedEmail);

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
        return EmailValidationUtil.isValidEmail(email);
    }

    private boolean isValidPhone(String phone) {
        return PhoneNumberUtil.isValidVietnamMobileNumber(phone);
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
