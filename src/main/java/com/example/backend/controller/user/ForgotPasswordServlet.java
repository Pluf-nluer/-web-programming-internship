package com.example.backend.controller.user;

import com.example.backend.dao.UserDAO;
import com.example.backend.model.User;
import com.example.backend.service.EmailService;
import com.example.backend.util.EmailValidationUtil;
import com.example.backend.util.EmailVerificationUtil;
import com.example.backend.util.PasswordUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet(name = "ForgotPasswordServlet", urlPatterns = "/forgot-password")
public class ForgotPasswordServlet extends HttpServlet {

    private static final String ACTION_SEND_OTP = "sendOtp";
    private static final String ACTION_VERIFY_OTP = "verifyOtp";
    private static final String ACTION_RESET_PASSWORD = "resetPassword";
    private static final String RESET_USER_ID = "resetPasswordUserId";
    private static final String RESET_EMAIL = "resetPasswordEmail";
    private static final String RESET_OTP = "resetPasswordOtp";
    private static final String RESET_EXPIRES_AT = "resetPasswordExpiresAt";
    private static final String RESET_ATTEMPTS = "resetPasswordAttempts";
    private static final String RESET_VERIFIED = "resetPasswordVerified";
    private static final long OTP_TTL_MS = 10 * 60 * 1000;
    private static final int MAX_ATTEMPTS = 5;
    private static final int FAKE_USER_ID = -1;
    private static final String RESET_GENERIC_MESSAGE = "Nếu email hợp lệ, hệ thống sẽ gửi hướng dẫn khôi phục.";

    private UserDAO userDAO;
    private EmailService emailService;

    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
        emailService = new EmailService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        clearResetSession(request.getSession());
        request.getRequestDispatcher("/forgot-password.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");
        if (ACTION_VERIFY_OTP.equals(action)) {
            verifyOtp(request, response);
            return;
        }
        if (ACTION_RESET_PASSWORD.equals(action)) {
            resetPassword(request, response);
            return;
        }
        sendOtp(request, response);
    }

    private void sendOtp(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email = EmailValidationUtil.normalize(request.getParameter("email"));

        if (email.isEmpty()) {
            showEmailForm(request, response, "Vui lòng nhập địa chỉ email của bạn.", email);
            return;
        }

        if (!EmailValidationUtil.isValidEmail(email)) {
            showEmailForm(request, response, "Email không hợp lệ. Vui lòng kiểm tra lại.", email);
            return;
        }

        User user = userDAO.findByEmailOrPhone(email);
        String otp = EmailVerificationUtil.generateCode();

        if (user == null) {
            prepareResetSession(request.getSession(), FAKE_USER_ID, email, otp);
            request.setAttribute("successMessage", RESET_GENERIC_MESSAGE);
            showOtpForm(request, response, email);
            return;
        }

        boolean sent = emailService.sendPasswordResetOtpEmail(user.getEmail(), user.getFullName(), otp);

        if (!sent) {
            prepareResetSession(request.getSession(), FAKE_USER_ID, email, EmailVerificationUtil.generateCode());
            request.setAttribute("successMessage", RESET_GENERIC_MESSAGE);
            showOtpForm(request, response, email);
            return;
        }

        prepareResetSession(request.getSession(), user.getId(), user.getEmail(), otp);
        request.setAttribute("successMessage", RESET_GENERIC_MESSAGE);
        showOtpForm(request, response, user.getEmail());
    }

    private void verifyOtp(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();

        if (!hasResetSession(session)) {
            showEmailForm(request, response, "Phiên xác nhận đã hết hạn. Vui lòng nhập email lại.", "");
            return;
        }

        String email = (String) session.getAttribute(RESET_EMAIL);

        if (isOtpExpired(session)) {
            clearResetSession(session);
            showEmailForm(request, response, "Mã OTP đã hết hạn. Vui lòng gửi lại mã mới.", email);
            return;
        }

        String otpCode = request.getParameter("otpCode");
        String trimmedCode = otpCode == null ? "" : otpCode.trim();

        if (!EmailVerificationUtil.isValidCode(trimmedCode)) {
            request.setAttribute("errorMessage", "Mã OTP phải gồm 4-6 số.");
            showOtpForm(request, response, email);
            return;
        }

        String expectedOtp = (String) session.getAttribute(RESET_OTP);
        if (!trimmedCode.equals(expectedOtp)) {
            int attempts = getAttempts(session) + 1;
            session.setAttribute(RESET_ATTEMPTS, attempts);

            if (attempts >= MAX_ATTEMPTS) {
                clearResetSession(session);
                showEmailForm(request, response, "Bạn đã nhập sai quá nhiều lần. Vui lòng gửi lại mã OTP.", email);
                return;
            }

            request.setAttribute("errorMessage", "Mã OTP không đúng. Vui lòng kiểm tra lại email.");
            showOtpForm(request, response, email);
            return;
        }

        if (isFakeResetSession(session)) {
            clearResetSession(session);
            showEmailFormSuccess(request, response, email);
            return;
        }

        session.setAttribute(RESET_VERIFIED, true);
        showPasswordForm(request, response);
    }

    private void resetPassword(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();

        if (!hasResetSession(session) || !Boolean.TRUE.equals(session.getAttribute(RESET_VERIFIED))) {
            showEmailForm(request, response, "Phiên đổi mật khẩu đã hết hạn. Vui lòng thực hiện lại.", "");
            return;
        }

        if (isOtpExpired(session)) {
            clearResetSession(session);
            showEmailForm(request, response, "Phiên đổi mật khẩu đã hết hạn. Vui lòng gửi lại mã OTP.", "");
            return;
        }

        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        if (newPassword == null || newPassword.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Vui lòng nhập mật khẩu mới.");
            showPasswordForm(request, response);
            return;
        }

        if (!PasswordUtil.isValidPassword(newPassword)) {
            request.setAttribute("errorMessage", PasswordUtil.getPasswordRequirementMessage());
            showPasswordForm(request, response);
            return;
        }

        if (!newPassword.equals(confirmPassword)) {
            request.setAttribute("errorMessage", "Mật khẩu xác nhận không khớp.");
            showPasswordForm(request, response);
            return;
        }

        String hashedPassword = PasswordUtil.encrypt(newPassword);
        if (hashedPassword == null) {
            request.setAttribute("errorMessage", "Không thể xử lý mật khẩu mới. Vui lòng thử lại.");
            showPasswordForm(request, response);
            return;
        }

        Object userIdValue = session.getAttribute(RESET_USER_ID);
        if (!(userIdValue instanceof Integer) || (Integer) userIdValue <= 0) {
            clearResetSession(session);
            showEmailFormSuccess(request, response, "");
            return;
        }

        boolean updated = userDAO.updatePassword((Integer) userIdValue, hashedPassword);

        if (!updated) {
            request.setAttribute("errorMessage", "Cập nhật mật khẩu thất bại. Vui lòng thử lại.");
            showPasswordForm(request, response);
            return;
        }

        clearResetSession(session);
        session.setAttribute("successMessage", "Mật khẩu đã được cập nhật. Vui lòng đăng nhập lại.");
        response.sendRedirect(request.getContextPath() + "/login");
    }

    private void prepareResetSession(HttpSession session, int userId, String email, String otp) {
        session.setAttribute(RESET_USER_ID, userId);
        session.setAttribute(RESET_EMAIL, email);
        session.setAttribute(RESET_OTP, otp);
        session.setAttribute(RESET_EXPIRES_AT, System.currentTimeMillis() + OTP_TTL_MS);
        session.setAttribute(RESET_ATTEMPTS, 0);
        session.setAttribute(RESET_VERIFIED, false);
    }

    private boolean hasResetSession(HttpSession session) {
        return session.getAttribute(RESET_USER_ID) != null &&
                session.getAttribute(RESET_EMAIL) != null &&
                session.getAttribute(RESET_OTP) != null &&
                session.getAttribute(RESET_EXPIRES_AT) != null;
    }

    private boolean isOtpExpired(HttpSession session) {
        Object expiresAt = session.getAttribute(RESET_EXPIRES_AT);
        if (!(expiresAt instanceof Long)) {
            return true;
        }
        return System.currentTimeMillis() > (Long) expiresAt;
    }

    private boolean isFakeResetSession(HttpSession session) {
        Object userId = session.getAttribute(RESET_USER_ID);
        return userId instanceof Integer && (Integer) userId <= 0;
    }

    private int getAttempts(HttpSession session) {
        Object attempts = session.getAttribute(RESET_ATTEMPTS);
        if (attempts instanceof Integer) {
            return (Integer) attempts;
        }
        return 0;
    }

    private void clearResetSession(HttpSession session) {
        session.removeAttribute(RESET_USER_ID);
        session.removeAttribute(RESET_EMAIL);
        session.removeAttribute(RESET_OTP);
        session.removeAttribute(RESET_EXPIRES_AT);
        session.removeAttribute(RESET_ATTEMPTS);
        session.removeAttribute(RESET_VERIFIED);
    }

    private void showEmailForm(HttpServletRequest request, HttpServletResponse response, String errorMessage, String email)
            throws ServletException, IOException {
        request.setAttribute("errorMessage", errorMessage);
        request.setAttribute("email", email);
        request.getRequestDispatcher("/forgot-password.jsp").forward(request, response);
    }

    private void showEmailFormSuccess(HttpServletRequest request, HttpServletResponse response, String email)
            throws ServletException, IOException {
        request.setAttribute("successMessage", RESET_GENERIC_MESSAGE);
        request.setAttribute("email", email);
        request.getRequestDispatcher("/forgot-password.jsp").forward(request, response);
    }

    private void showOtpForm(HttpServletRequest request, HttpServletResponse response, String email)
            throws ServletException, IOException {
        request.setAttribute("resetStep", "otp");
        request.setAttribute("resetEmail", email);
        request.getRequestDispatcher("/forgot-password.jsp").forward(request, response);
    }

    private void showPasswordForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("resetStep", "password");
        request.getRequestDispatcher("/forgot-password.jsp").forward(request, response);
    }
}
