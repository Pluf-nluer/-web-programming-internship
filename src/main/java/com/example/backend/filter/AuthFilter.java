package com.example.backend.filter;

import com.example.backend.model.User;
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





@WebFilter("/admin/*")
public class AuthFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;

        String path = req.getRequestURI();
        HttpSession session = req.getSession(false);

        User user = null;
        if (session != null) {
            Object sessionUser = session.getAttribute("user");
            if (sessionUser instanceof User) {
                user = (User) sessionUser;
            }
        }

        if (user != null && user.isAdmin()) {
            chain.doFilter(request, response);
            return;
        }

        System.out.println("Chặn truy cập trái phép: " + path);
        res.sendRedirect(req.getContextPath() + "/");
    }

    @Override
    public void destroy() {
        
    }
}
