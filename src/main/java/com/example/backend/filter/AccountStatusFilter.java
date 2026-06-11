package com.example.backend.filter;

import com.example.backend.dao.UserDAO;
import com.example.backend.model.User;
import com.example.backend.util.RememberMeUtil;
import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.Locale;

@WebFilter("/*")
public class AccountStatusFilter implements Filter {

    private UserDAO userDAO;

    public AccountStatusFilter() {
    }

    AccountStatusFilter(UserDAO userDAO) {
        this.userDAO = userDAO;
    }
    @Override
    public void init(FilterConfig filterConfig) {
        if (userDAO == null) {
            userDAO = new UserDAO();
        }
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;
        String relativePath = getRelativePath(req);

        if (shouldSkip(relativePath)) {
            chain.doFilter(request, response);
            return;
        }

        HttpSession session = req.getSession(false);
        User user = getSessionUser(session);
        if (user == null) {
            user = loginByRememberMe(req, res);
            session = req.getSession(false);
        }

        if (user != null && session != null) {
            User userFromDb = userDAO.getUserById(user.getId());
            if (userFromDb != null) {
                boolean accountDisabled = !userFromDb.isActive() && !userFromDb.isAdmin();
                if (accountDisabled) {
                    res.addCookie(RememberMeUtil.clearCookie(req.isSecure()));
                    session.invalidate();
                    res.sendRedirect(req.getContextPath() + "/login?locked=true");
                    return;
                }
                setUserSession(session, userFromDb);
                session.removeAttribute("accountDisabled");
            }
        }

        chain.doFilter(request, response);
    }

    private User loginByRememberMe(HttpServletRequest request, HttpServletResponse response) {
        String token = RememberMeUtil.getCookieValue(request);
        Integer userId = RememberMeUtil.getUserId(token);
        if (userId == null) {
            return null;
        }

        User user = userDAO.getUserById(userId);
        if (user == null || !user.isActive() || !RememberMeUtil.isValidToken(token, user)) {
            response.addCookie(RememberMeUtil.clearCookie(request.isSecure()));
            return null;
        }

        HttpSession session = request.getSession(true);
        session.setMaxInactiveInterval(RememberMeUtil.MAX_AGE_SECONDS);
        setUserSession(session, user);
        return user;
    }

    private User getSessionUser(HttpSession session) {
        if (session == null) {
            return null;
        }
        Object sessionUser = session.getAttribute("user");
        if (sessionUser instanceof User) {
            return (User) sessionUser;
        }
        return null;
    }

    private void setUserSession(HttpSession session, User user) {
        session.setAttribute("user", user);
        session.setAttribute("userId", user.getId());
        session.setAttribute("userName", user.getFullName());
        session.setAttribute("userRole", user.getRole());
    }

    private String getRelativePath(HttpServletRequest req) {
        String path = req.getRequestURI();
        String contextPath = req.getContextPath();
        if (contextPath == null || contextPath.isEmpty()) {
            return path;
        }
        if (path.startsWith(contextPath)) {
            return path.substring(contextPath.length());
        }
        return path;
    }

    private boolean shouldSkip(String path) {
        if (path == null || path.isEmpty()) {
            return false;
        }
        if (path.startsWith("/admin")) {
            return true;
        }
        if (path.startsWith("/css/") || path.startsWith("/js/")
                || path.startsWith("/images/") || path.startsWith("/img/")
                || path.startsWith("/fonts/")) {
            return true;
        }
        String lowerPath = path.toLowerCase(Locale.ROOT);
        return lowerPath.endsWith(".css")
                || lowerPath.endsWith(".js")
                || lowerPath.endsWith(".png")
                || lowerPath.endsWith(".jpg")
                || lowerPath.endsWith(".jpeg")
                || lowerPath.endsWith(".gif")
                || lowerPath.endsWith(".svg")
                || lowerPath.endsWith(".ico")
                || lowerPath.endsWith(".webp")
                || lowerPath.endsWith(".woff")
                || lowerPath.endsWith(".woff2")
                || lowerPath.endsWith(".ttf")
                || lowerPath.endsWith(".eot")
                || lowerPath.endsWith(".map");
    }
}
