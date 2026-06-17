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
import java.time.LocalDate;
import java.time.format.DateTimeParseException;
import java.util.List;
import java.util.Locale;

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
        String status = normalizeStatus(request.getParameter("status"));
        String role = normalizeRole(request.getParameter("role"));
        String createdFrom = normalizeDate(request.getParameter("createdFrom"));
        String createdTo = normalizeDate(request.getParameter("createdTo"));
        if (!createdFrom.isEmpty() && !createdTo.isEmpty() && createdFrom.compareTo(createdTo) > 0) {
            String temp = createdFrom;
            createdFrom = createdTo;
            createdTo = temp;
        }

        int page = parseIntOrDefault(request.getParameter("page"), 1);
        if (page < 1) {
            page = 1;
        }

        int totalCustomers = userDAO.countUsers(keyword, status, role, createdFrom, createdTo);
        int totalPages = (int) Math.ceil((double) totalCustomers / PAGE_SIZE);
        if (totalPages == 0) {
            totalPages = 1;
        }
        if (page > totalPages) {
            page = totalPages;
        }

        int offset = (page - 1) * PAGE_SIZE;
        List<User> customers = userDAO.getUsers(keyword, status, role, createdFrom, createdTo, offset, PAGE_SIZE);

        request.setAttribute("customers", customers);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalCustomers", totalCustomers);
        request.setAttribute("pageSize", PAGE_SIZE);
        request.setAttribute("keyword", keyword);
        request.setAttribute("statusFilter", status);
        request.setAttribute("roleFilter", role);
        request.setAttribute("createdFrom", createdFrom);
        request.setAttribute("createdTo", createdTo);
        request.setAttribute("filterRoles", userDAO.getFilterableRoles());
        request.setAttribute("assignableRoles", userDAO.getAssignableRoles());

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

        if (userId <= 0 || (!"lock".equals(action) && !"unlock".equals(action) && !"setRole".equals(action))) {
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
            setFlashMessage(session, "Không thể cập nhật tài khoản admin.", "error");
            response.sendRedirect(buildRedirectUrl(request));
            return;
        }

        if ("setRole".equals(action)) {
            updateUserRole(request, response, session, user);
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

    private String normalizeStatus(String value) {
        if (value == null) {
            return "";
        }
        String status = value.trim().toLowerCase();
        if ("active".equals(status) || "inactive".equals(status)) {
            return status;
        }
        return "";
    }

    private String normalizeRole(String value) {
        if (value == null) {
            return "";
        }
        String role = value.trim().toLowerCase(Locale.ROOT);
        if (role.isEmpty()) {
            return "";
        }
        return role;
    }

    private String normalizeAssignableRole(String value) {
        if (value == null) {
            return "";
        }
        return value.trim().toLowerCase(Locale.ROOT);
    }

    private String normalizeDate(String value) {
        if (value == null || value.trim().isEmpty()) {
            return "";
        }
        try {
            return LocalDate.parse(value.trim()).toString();
        } catch (DateTimeParseException e) {
            return "";
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
        String status = request.getParameter("status");
        String role = request.getParameter("role");
        String createdFrom = request.getParameter("createdFrom");
        String createdTo = request.getParameter("createdTo");
        String separator = "?";

        separator = appendQueryParam(url, separator, "page", page);
        separator = appendQueryParam(url, separator, "q", keyword);
        separator = appendQueryParam(url, separator, "status", normalizeStatus(status));
        separator = appendQueryParam(url, separator, "role", normalizeRole(role));
        separator = appendQueryParam(url, separator, "createdFrom", normalizeDate(createdFrom));
        appendQueryParam(url, separator, "createdTo", normalizeDate(createdTo));

        return url.toString();
    }

    private String appendQueryParam(StringBuilder url, String separator, String name, String value) {
        if (value == null || value.trim().isEmpty()) {
            return separator;
        }
        url.append(separator)
                .append(name)
                .append("=")
                .append(URLEncoder.encode(value.trim(), StandardCharsets.UTF_8));
        return "&";
    }

    private void updateUserRole(HttpServletRequest request, HttpServletResponse response, HttpSession session, User user)
            throws IOException {
        String newRole = normalizeAssignableRole(request.getParameter("newRole"));
        if (newRole.isEmpty()) {
            setFlashMessage(session, "Quyền người dùng không hợp lệ.", "error");
            response.sendRedirect(buildRedirectUrl(request));
            return;
        }

        if (newRole.equalsIgnoreCase(user.getRole())) {
            setFlashMessage(session, "Quyền người dùng không thay đổi.", "info");
            response.sendRedirect(buildRedirectUrl(request));
            return;
        }

        boolean updated = userDAO.updateUserRole(user.getId(), newRole);
        if (updated) {
            setFlashMessage(session, "Cập nhật quyền người dùng thành công.", "success");
        } else {
            setFlashMessage(session, "Không thể cập nhật quyền người dùng.", "error");
        }

        response.sendRedirect(buildRedirectUrl(request));
    }
}
