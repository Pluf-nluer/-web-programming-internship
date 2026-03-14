package com.example.backend.controller.admin;

import com.example.backend.dao.UserDAO;
import com.example.backend.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.List;

@WebServlet("/admin/customers")
public class AdminUserServlet extends HttpServlet {

    private static final int PAGE_SIZE = 10;
    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String keyword = request.getParameter("q");
        int page = parseIntOrDefault(request.getParameter("page"), 1);
        if (page < 1) {
            page = 1;
        }

        int totalCustomers = userDAO.countUsers(keyword);
        int totalPages = (int) Math.ceil((double) totalCustomers / PAGE_SIZE);
        if (totalPages == 0) {
            totalPages = 1;
        }
        if (page > totalPages) {
            page = totalPages;
        }

        int offset = (page - 1) * PAGE_SIZE;
        List<User> customers = userDAO.getUsers(keyword, offset, PAGE_SIZE);

        request.setAttribute("customers", customers);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalCustomers", totalCustomers);
        request.setAttribute("pageSize", PAGE_SIZE);
        request.setAttribute("keyword", keyword);

        HttpSession session = request.getSession(false);
        if (session != null) {
            Object message = session.getAttribute("adminCustomerMessage");
            Object messageType = session.getAttribute("adminCustomerMessageType");
            if (message != null) {
                request.setAttribute("adminCustomerMessage", message);
                request.setAttribute("adminCustomerMessageType", messageType);
                session.removeAttribute("adminCustomerMessage");
                session.removeAttribute("adminCustomerMessageType");
            }
        }

        request.getRequestDispatcher("/admin/customers/customer-list.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");
        int userId = parseIntOrDefault(request.getParameter("userId"), -1);
        HttpSession session = request.getSession(true);

        if (userId <= 0 || (!"lock".equals(action) && !"unlock".equals(action))) {
            setFlashMessage(session, "Dữ liệu không hợp lệ.", "error");
            response.sendRedirect(buildRedirectUrl(request));
            return;
        }

        User user = userDAO.getUserById(userId);
        if (user == null) {
            setFlashMessage(session, "Không tìm thấy tài khoản.", "error");
            response.sendRedirect(buildRedirectUrl(request));
            return;
        }

        if (user.isAdmin()) {
            setFlashMessage(session, "Không thể khóa tài khoản admin.", "error");
            response.sendRedirect(buildRedirectUrl(request));
            return;
        }

        boolean activate = "unlock".equals(action);
        if (activate == user.isActive()) {
            setFlashMessage(session, "Trạng thái tài khoản không thay đổi.", "info");
            response.sendRedirect(buildRedirectUrl(request));
            return;
        }

        boolean updated = userDAO.updateUserStatus(userId, activate);
        if (updated) {
            String message = activate ? "Mở khóa tài khoản thành công." : "Khóa tài khoản thành công.";
            setFlashMessage(session, message, "success");
        } else {
            setFlashMessage(session, "Không thể cập nhật trạng thái tài khoản.", "error");
        }

        response.sendRedirect(buildRedirectUrl(request));
    }

    private int parseIntOrDefault(String value, int defaultValue) {
        if (value == null) {
            return defaultValue;
        }
        try {
            return Integer.parseInt(value);
        } catch (NumberFormatException e) {
            return defaultValue;
        }
    }

    private void setFlashMessage(HttpSession session, String message, String type) {
        session.setAttribute("adminCustomerMessage", message);
        session.setAttribute("adminCustomerMessageType", type);
    }

    private String buildRedirectUrl(HttpServletRequest request) {
        StringBuilder url = new StringBuilder(request.getContextPath()).append("/admin/customers");
        String page = request.getParameter("page");
        String keyword = request.getParameter("q");
        String separator = "?";

        if (page != null && !page.trim().isEmpty()) {
            url.append(separator)
                    .append("page=")
                    .append(URLEncoder.encode(page.trim(), StandardCharsets.UTF_8));
            separator = "&";
        }

        if (keyword != null && !keyword.trim().isEmpty()) {
            url.append(separator)
                    .append("q=")
                    .append(URLEncoder.encode(keyword.trim(), StandardCharsets.UTF_8));
        }

        return url.toString();
    }
}
