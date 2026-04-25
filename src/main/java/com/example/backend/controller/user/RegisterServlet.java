package com.example.backend.controller.user;

import com.example.backend.dao.UserDAO;
import com.example.backend.model.User;
import com.example.backend.service.EmailService;
import com.example.backend.util.EmailValidationUtil;
import com.example.backend.util.EmailVerificationUtil;
import com.example.backend.util.PasswordUtil;
import com.example.backend.util.PhoneNumberUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    private static final String VERIFY_EMAIL_ACTION = "verifyEmail";
    private static final String PENDING_FULL_NAME = "pendingRegisterFullName";
    private static final String PENDING_EMAIL = "pendingRegisterEmail";
    private static final String PENDING_PHONE = "pendingRegisterPhone";
    private static final String PENDING_PASSWORD = "pendingRegisterPassword";
    private static final String PENDING_CODE = "pendingRegisterCode";
    private static final String PENDING_EXPIRES_AT = "pendingRegisterExpiresAt";
    private static final String PENDING_ATTEMPTS = "pendingRegisterAttempts";
    private static final long VERIFICATION_CODE_TTL_MS = 10 * 60 * 1000;
    private static final int MAX_VERIFICATION_ATTEMPTS = 5;

    private UserDAO userDAO;
    private EmailService emailService;

    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
        emailService = new EmailService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        clearPendingRegistration(request.getSession());
        request.getRequestDispatcher("/register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");
        if (VERIFY_EMAIL_ACTION.equals(action)) {
            verifyEmailCode(request, response);
            return;
        }

        sendEmailVerificationCode(request, response);
    }

    private void sendEmailVerificationCode(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
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
        if (hashedPassword == null) {
            setErrorAndForward(request, response, "Không thể xử lý mật khẩu. Vui lòng thử lại.");
            return;
        }

        String verificationCode = EmailVerificationUtil.generateCode();
        boolean sent = emailService.sendVerificationCodeEmail(normalizedEmail, fullName.trim(), verificationCode);

        if (!sent) {
            setErrorAndForward(request, response, "Không thể gửi mã xác thực. Vui lòng thử lại sau.");
            return;
        }

        HttpSession session = request.getSession();
        session.setAttribute(PENDING_FULL_NAME, fullName.trim());
        session.setAttribute(PENDING_EMAIL, normalizedEmail);
        session.setAttribute(PENDING_PHONE, normalizedPhone);
        session.setAttribute(PENDING_PASSWORD, hashedPassword);
        session.setAttribute(PENDING_CODE, verificationCode);
        session.setAttribute(PENDING_EXPIRES_AT, System.currentTimeMillis() + VERIFICATION_CODE_TTL_MS);
        session.setAttribute(PENDING_ATTEMPTS, 0);

        request.setAttribute("successMessage", "Mã xác thực đã được gửi đến email của bạn.");
        showVerificationForm(request, response, normalizedEmail);
    }

    private void verifyEmailCode(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();

        if (!hasPendingRegistration(session)) {
            setErrorAndForward(request, response, "Phiên xác thực đã hết hạn. Vui lòng đăng ký lại.");
            return;
        }

        String code = request.getParameter("verificationCode");
        String trimmedCode = code == null ? "" : code.trim();
        String pendingEmail = (String) session.getAttribute(PENDING_EMAIL);

        if (isVerificationExpired(session)) {
            clearPendingRegistration(session);
            setErrorAndForward(request, response, "Mã xác thực đã hết hạn. Vui lòng đăng ký lại.");
            return;
        }

        if (!EmailVerificationUtil.isValidCode(trimmedCode)) {
            request.setAttribute("errorMessage", "Mã xác thực phải gồm 4-6 số.");
            showVerificationForm(request, response, pendingEmail);
            return;
        }

        String expectedCode = (String) session.getAttribute(PENDING_CODE);
        if (!trimmedCode.equals(expectedCode)) {
            int attempts = getVerificationAttempts(session) + 1;
            session.setAttribute(PENDING_ATTEMPTS, attempts);

            if (attempts >= MAX_VERIFICATION_ATTEMPTS) {
                clearPendingRegistration(session);
                setErrorAndForward(request, response, "Bạn đã nhập sai quá nhiều lần. Vui lòng đăng ký lại.");
                return;
            }

            request.setAttribute("errorMessage", "Mã xác thực không đúng. Vui lòng kiểm tra lại email.");
            showVerificationForm(request, response, pendingEmail);
            return;
        }

        String fullName = (String) session.getAttribute(PENDING_FULL_NAME);
        String phone = (String) session.getAttribute(PENDING_PHONE);
        String hashedPassword = (String) session.getAttribute(PENDING_PASSWORD);

        if (userDAO.isEmailExists(pendingEmail)) {
            clearPendingRegistration(session);
            setErrorAndForwardWithValues(request, response, "Email này đã được sử dụng!", fullName, pendingEmail, phone);
            return;
        }

        if (userDAO.isPhoneExists(phone)) {
            clearPendingRegistration(session);
            setErrorAndForwardWithValues(request, response, "Số điện thoại này đã được sử dụng!", fullName, pendingEmail, phone);
            return;
        }

        User newUser = new User(fullName, pendingEmail, phone, hashedPassword);
        boolean success = userDAO.register(newUser);

        if (!success) {
            setErrorAndForwardWithValues(request, response, "Đăng ký thất bại! Vui lòng thử lại.", fullName, pendingEmail, phone);
            return;
        }

        clearPendingRegistration(session);
        User user = userDAO.findByEmailOrPhone(pendingEmail);
        String redirectUrl = (String) session.getAttribute("postLoginRedirect");

        if (user != null) {
            session.setAttribute("user", user);
            session.setAttribute("userId", user.getId());
            session.setAttribute("userName", user.getFullName());
            session.setAttribute("userRole", user.getRole());
            session.setMaxInactiveInterval(30 * 60);
        }

        if (redirectUrl != null && !redirectUrl.trim().isEmpty()) {
            session.removeAttribute("postLoginRedirect");
            response.sendRedirect(redirectUrl);
            return;
        }

        response.sendRedirect(request.getContextPath() + "/index");
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

    private boolean hasPendingRegistration(HttpSession session) {
        return session.getAttribute(PENDING_FULL_NAME) != null &&
                session.getAttribute(PENDING_EMAIL) != null &&
                session.getAttribute(PENDING_PHONE) != null &&
                session.getAttribute(PENDING_PASSWORD) != null &&
                session.getAttribute(PENDING_CODE) != null &&
                session.getAttribute(PENDING_EXPIRES_AT) != null;
    }

    private boolean isVerificationExpired(HttpSession session) {
        Object value = session.getAttribute(PENDING_EXPIRES_AT);
        if (!(value instanceof Long)) {
            return true;
        }
        return System.currentTimeMillis() > (Long) value;
    }

    private int getVerificationAttempts(HttpSession session) {
        Object value = session.getAttribute(PENDING_ATTEMPTS);
        if (value instanceof Integer) {
            return (Integer) value;
        }
        return 0;
    }

    private void clearPendingRegistration(HttpSession session) {
        session.removeAttribute(PENDING_FULL_NAME);
        session.removeAttribute(PENDING_EMAIL);
        session.removeAttribute(PENDING_PHONE);
        session.removeAttribute(PENDING_PASSWORD);
        session.removeAttribute(PENDING_CODE);
        session.removeAttribute(PENDING_EXPIRES_AT);
        session.removeAttribute(PENDING_ATTEMPTS);
    }

    private void showVerificationForm(HttpServletRequest request,
                                      HttpServletResponse response,
                                      String email)
            throws ServletException, IOException {
        request.setAttribute("showVerificationForm", true);
        request.setAttribute("verificationEmail", email);
        request.getRequestDispatcher("/register.jsp").forward(request, response);
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

    private void setErrorAndForwardWithValues(HttpServletRequest request,
                                              HttpServletResponse response,
                                              String errorMessage,
                                              String fullName,
                                              String email,
                                              String phone)
            throws ServletException, IOException {
        request.setAttribute("errorMessage", errorMessage);
        request.setAttribute("fullName", fullName);
        request.setAttribute("email", email);
        request.setAttribute("phone", phone);
        request.getRequestDispatcher("/register.jsp").forward(request, response);
    }
}
