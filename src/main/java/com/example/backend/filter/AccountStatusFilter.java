package com.example.backend.filter;

import com.example.backend.dao.UserDAO;
import com.example.backend.model.User;
import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.Locale;

@WebFilter("/*")
public class AccountStatusFilter implements Filter {

    private UserDAO userDAO;

    @Override
    public void init(FilterConfig filterConfig) {
        userDAO = new UserDAO();
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        String relativePath = getRelativePath(req);

        if (shouldSkip(relativePath)) {
            chain.doFilter(request, response);
            return;
        }

        HttpSession session = req.getSession(false);
        if (session != null) {
            Object sessionUser = session.getAttribute("user");
            if (sessionUser instanceof User) {
                User user = (User) sessionUser;
                User userFromDb = userDAO.getUserById(user.getId());
                if (userFromDb != null) {
                    session.setAttribute("user", userFromDb);
                    session.setAttribute("userId", userFromDb.getId());
                    session.setAttribute("userName", userFromDb.getFullName());
                    session.setAttribute("userRole", userFromDb.getRole());

                    boolean accountDisabled = !userFromDb.isActive() && !userFromDb.isAdmin();
                    session.setAttribute("accountDisabled", accountDisabled);
                    request.setAttribute("accountDisabled", accountDisabled);
                }
            }
        }

        chain.doFilter(request, response);
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
