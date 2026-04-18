package com.example.backend.controller.user;

import com.example.backend.dao.UserDAO;
import com.example.backend.model.User;
import com.example.backend.util.PasswordUtil;
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

        boolean isGoogleVerified = Boolean.TRUE.equals(session.getAttribute("passwordChangeVerified"));

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
            session.removeAttribute("passwordChangeVerified"); 
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
                    session.setAttribute("passwordChangeVerified", true);
                    response.getWriter().write("{\"success\":true}");
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
}
