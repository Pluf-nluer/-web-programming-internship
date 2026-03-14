package com.example.backend.controller.user;

import com.example.backend.dao.UserDAO;
import com.example.backend.model.User;
import com.example.backend.util.GoogleOAuthConfig;
import com.example.backend.util.GoogleTokenVerifier;
import com.google.api.client.googleapis.auth.oauth2.GoogleIdToken;
import com.google.api.client.googleapis.auth.oauth2.GoogleIdToken.Payload;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.security.GeneralSecurityException;

@WebServlet("/oauth2/callback/google")
public class GoogleLoginServlet extends HttpServlet {
    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("application/json");

        if (!GoogleOAuthConfig.hasClientId()) {
            writeError(response, HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Google OAuth chua duoc cau hinh.");
            return;
        }

        String idTokenString = getTokenFromRequest(request);
        if (isNullOrEmpty(idTokenString)) {
            writeError(response, HttpServletResponse.SC_BAD_REQUEST,
                    "Thieu thong tin dang nhap Google.");
            return;
        }

        GoogleIdToken idToken;
        try {
            idToken = GoogleTokenVerifier.verify(idTokenString);
        } catch (GeneralSecurityException | IOException e) {
            System.err.println("Google token verify error: " + e.getMessage());
            writeError(response, HttpServletResponse.SC_UNAUTHORIZED,
                    "Xac thuc Google that bai.");
            return;
        }

        if (idToken == null) {
            writeError(response, HttpServletResponse.SC_UNAUTHORIZED,
                    "Xac thuc Google that bai.");
            return;
        }

        Payload payload = idToken.getPayload();
        String email = payload.getEmail();
        String googleId = payload.getSubject();
        String fullName = (String) payload.get("name");
        String avatarUrl = (String) payload.get("picture");

        if (isNullOrEmpty(email) || isNullOrEmpty(googleId)) {
            writeError(response, HttpServletResponse.SC_BAD_REQUEST,
                    "Thong tin tai khoan Google khong hop le.");
            return;
        }

        User user = userDAO.upsertGoogleUser(googleId, email, fullName, avatarUrl);
        if (user == null) {
            writeError(response, HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Khong the dang nhap bang Google.");
            return;
        }

        if (!user.isActive()) {
            writeError(response, HttpServletResponse.SC_FORBIDDEN,
                    "Tai khoan dang bi khoa.");
            return;
        }

        HttpSession session = request.getSession(true);
        applyUserSession(session, user);

        String redirectUrl = resolveRedirectUrl(request, session, user);
        writeSuccess(response, redirectUrl);
    }

    private String getTokenFromRequest(HttpServletRequest request) {
        String idToken = request.getParameter("idToken");
        if (!isNullOrEmpty(idToken)) {
            return idToken;
        }
        String credential = request.getParameter("credential");
        if (!isNullOrEmpty(credential)) {
            return credential;
        }
        return null;
    }

    private void applyUserSession(HttpSession session, User user) {
        session.setAttribute("user", user);
        session.setAttribute("userId", user.getId());
        session.setAttribute("userName", user.getFullName());
        session.setAttribute("userRole", user.getRole());
        session.setMaxInactiveInterval(30 * 60);
    }

    private String resolveRedirectUrl(HttpServletRequest request, HttpSession session, User user) {
        if (user.isAdmin()) {
            session.removeAttribute("postLoginRedirect");
            return request.getContextPath() + "/admin/dashboard";
        }

        String redirectUrl = (String) session.getAttribute("postLoginRedirect");
        if (redirectUrl != null && !redirectUrl.trim().isEmpty()) {
            session.removeAttribute("postLoginRedirect");
            return redirectUrl;
        }
        return request.getContextPath() + "/index";
    }

    private void writeSuccess(HttpServletResponse response, String redirectUrl) throws IOException {
        String safeRedirect = escapeJson(redirectUrl);
        writeJson(response, HttpServletResponse.SC_OK,
                "{\"success\":true,\"redirectUrl\":\"" + safeRedirect + "\"}");
    }

    private void writeError(HttpServletResponse response, int status, String message) throws IOException {
        String safeMessage = escapeJson(message);
        writeJson(response, status,
                "{\"success\":false,\"message\":\"" + safeMessage + "\"}");
    }

    private void writeJson(HttpServletResponse response, int status, String body) throws IOException {
        response.setStatus(status);
        response.getWriter().write(body);
    }

    private boolean isNullOrEmpty(String value) {
        return value == null || value.trim().isEmpty();
    }

    private String escapeJson(String value) {
        if (value == null) {
            return "";
        }
        return value.replace("\\", "\\\\").replace("\"", "\\\"");
    }
}
