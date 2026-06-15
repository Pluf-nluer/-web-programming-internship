package com.example.backend.controller.user;

import com.example.backend.dao.UserDAO;
import com.example.backend.model.User;
import com.example.backend.util.PasswordUtil;
import com.example.backend.util.PasswordChangeTokenUtil;
import com.example.backend.util.GoogleTokenVerifier;
import com.google.api.client.googleapis.auth.oauth2.GoogleIdToken;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.security.GeneralSecurityException;

@WebServlet("/change-password")
public class ChangePasswordServlet extends HttpServlet {

    private static final String PASSWORD_CHANGE_TOKEN = "passwordChangeToken";
    private static final String PASSWORD_CHANGE_TOKEN_EXPIRES_AT = "passwordChangeTokenExpiresAt";
    private static final long PASSWORD_CHANGE_TOKEN_TTL_MS = 5 * 60 * 1000;

    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("user") : null;

        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        clearPasswordChangeToken(session);
        request.getRequestDispatcher("/account/account-change-password.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");
        if ("verifyGoogle".equals(action)) {
            handleGoogleVerification(request, response);
            return;
        }

        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("user") : null;

        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");
        String passwordChangeToken = request.getParameter("passwordChangeToken");

        boolean isGoogleVerified = consumePasswordChangeToken(session, passwordChangeToken);
        boolean usedGoogleToken = passwordChangeToken != null && !passwordChangeToken.trim().isEmpty();

        if (usedGoogleToken && !isGoogleVerified) {
            request.setAttribute("errorMessage", "Phiên xác thực Google đã hết hạn. Vui lòng xác thực lại.");
            request.getRequestDispatcher("/account/account-change-password.jsp").forward(request, response);
            return;
        }

        if (!isGoogleVerified && (currentPassword == null || currentPassword.trim().isEmpty())) {
            request.setAttribute("errorMessage", "Vui lòng nhập mật khẩu hiện tại.");
            request.getRequestDispatcher("/account/account-change-password.jsp").forward(request, response);
            return;
        }

        if (newPassword == null || newPassword.trim().isEmpty()
                || confirmPassword == null || confirmPassword.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Vui lòng nhập mật khẩu mới.");
            request.getRequestDispatcher("/account/account-change-password.jsp").forward(request, response);
            return;
        }

        if (!PasswordUtil.isValidPassword(newPassword)) {
            request.setAttribute("errorMessage", PasswordUtil.getPasswordRequirementMessage());
            request.getRequestDispatcher("/account/account-change-password.jsp").forward(request, response);
            return;
        }

        if (!newPassword.equals(confirmPassword)) {
            request.setAttribute("errorMessage", "Mật khẩu xác nhận không khớp.");
            request.getRequestDispatcher("/account/account-change-password.jsp").forward(request, response);
            return;
        }

        User userFromDb = userDAO.getUserById(currentUser.getId());
        if (userFromDb == null) {
            session.invalidate();
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        if (!isGoogleVerified) {
            String hashedCurrent = PasswordUtil.encrypt(currentPassword);
            if (!hashedCurrent.equals(userFromDb.getPassword())) {
                request.setAttribute("errorMessage", "Mật khẩu hiện tại không đúng.");
                request.getRequestDispatcher("/account/account-change-password.jsp").forward(request, response);
                return;
            }
        }

        String hashedNew = PasswordUtil.encrypt(newPassword);
        
        if (userFromDb.getPassword() != null && hashedNew.equals(userFromDb.getPassword())) {
            request.setAttribute("errorMessage", "Mật khẩu mới phải khác mật khẩu hiện tại.");
            request.getRequestDispatcher("/account/account-change-password.jsp").forward(request, response);
            return;
        }

        boolean updated = userDAO.updatePassword(userFromDb.getId(), hashedNew);
        if (updated) {
            userFromDb.setPassword(hashedNew);
            session.setAttribute("user", userFromDb);
            clearPasswordChangeToken(session);
            request.setAttribute("successMessage", "Đổi mật khẩu thành công.");
        } else {
            request.setAttribute("errorMessage", "Không thể đổi mật khẩu. Vui lòng thử lại.");
        }

        request.getRequestDispatcher("/account/account-change-password.jsp").forward(request, response);
    }

    private void handleGoogleVerification(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("application/json");
        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("user") : null;

        if (currentUser == null) {
            response.getWriter().write("{\"success\":false, \"message\":\"Chưa đăng nhập.\"}");
            return;
        }

        String idTokenString = request.getParameter("idToken");
        if (idTokenString == null || idTokenString.isEmpty()) {
            response.getWriter().write("{\"success\":false, \"message\":\"Thiếu token.\"}");
            return;
        }

        try {
            GoogleIdToken idToken = GoogleTokenVerifier.verify(idTokenString);
            if (idToken != null) {
                GoogleIdToken.Payload payload = idToken.getPayload();
                String googleId = payload.getSubject();

                if (googleId != null && googleId.equals(currentUser.getGoogleId())) {
                    String token = PasswordChangeTokenUtil.generateToken();
                    session.setAttribute(PASSWORD_CHANGE_TOKEN, token);
                    session.setAttribute(PASSWORD_CHANGE_TOKEN_EXPIRES_AT, System.currentTimeMillis() + PASSWORD_CHANGE_TOKEN_TTL_MS);
                    response.getWriter().write("{\"success\":true, \"token\":\"" + token + "\"}");
                } else {
                    response.getWriter().write("{\"success\":false, \"message\":\"Tài khoản Google không khớp với tài khoản hiện tại.\"}");
                }
            } else {
                response.getWriter().write("{\"success\":false, \"message\":\"Token không hợp lệ.\"}");
            }
        } catch (GeneralSecurityException e) {
            e.printStackTrace();
            response.getWriter().write("{\"success\":false, \"message\":\"Lỗi xác thực: " + e.getMessage() + "\"}");
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("{\"success\":false, \"message\":\"Lỗi hệ thống.\"}");
        }
    }

    private boolean isValidPasswordChangeToken(HttpSession session, String token) {
        if (session == null) {
            return false;
        }

        Object expectedToken = session.getAttribute(PASSWORD_CHANGE_TOKEN);
        Object expiresAt = session.getAttribute(PASSWORD_CHANGE_TOKEN_EXPIRES_AT);
        if (!(expectedToken instanceof String) || !(expiresAt instanceof Long)) {
            return false;
        }

        return PasswordChangeTokenUtil.isValid(token, (String) expectedToken, (Long) expiresAt, System.currentTimeMillis());
    }

    private boolean consumePasswordChangeToken(HttpSession session, String token) {
        boolean valid = isValidPasswordChangeToken(session, token);
        if (token != null && !token.trim().isEmpty()) {
            clearPasswordChangeToken(session);
        }
        return valid;
    }

    private void clearPasswordChangeToken(HttpSession session) {
        if (session == null) {
            return;
        }

        session.removeAttribute(PASSWORD_CHANGE_TOKEN);
        session.removeAttribute(PASSWORD_CHANGE_TOKEN_EXPIRES_AT);
        session.removeAttribute("passwordChangeVerified");
    }
}
