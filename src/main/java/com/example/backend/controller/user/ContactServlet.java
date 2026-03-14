package com.example.backend.controller.user;

import com.example.backend.dao.ContactDAO;
import com.example.backend.model.Contact;
import com.example.backend.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/contact")
public class ContactServlet extends HttpServlet {

    private ContactDAO contactDAO;

    @Override
    public void init() throws ServletException {
        contactDAO = new ContactDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("/contact.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String name = trim(request.getParameter("name"));
        String email = trim(request.getParameter("email"));
        String message = trim(request.getParameter("message"));

        if (name == null || email == null || message == null) {
            request.setAttribute("errorMessage", "Vui lòng nhập đầy đủ thông tin.");
            setFormValues(request, name, email, message);
            request.getRequestDispatcher("/contact.jsp").forward(request, response);
            return;
        }

        Contact contact = new Contact();
        contact.setUserId(getUserId(request.getSession(false)));
        contact.setName(name);
        contact.setEmail(email);
        contact.setContent(message);
        contact.setStatus("pending");

        boolean success = contactDAO.insert(contact);
        if (success) {
            request.setAttribute("successMessage", "Gửi liên hệ thành công.");
            request.setAttribute("clearForm", true);
        } else {
            request.setAttribute("errorMessage", "Không thể gửi liên hệ. Vui lòng thử lại.");
            setFormValues(request, name, email, message);
        }

        request.getRequestDispatcher("/contact.jsp").forward(request, response);
    }

    private Integer getUserId(HttpSession session) {
        if (session == null) {
            return null;
        }
        User user = (User) session.getAttribute("user");
        return user != null ? user.getId() : null;
    }

    private String trim(String value) {
        if (value == null) {
            return null;
        }
        String trimmed = value.trim();
        return trimmed.isEmpty() ? null : trimmed;
    }

    private void setFormValues(HttpServletRequest request, String name, String email, String message) {
        request.setAttribute("formName", name);
        request.setAttribute("formEmail", email);
        request.setAttribute("formMessage", message);
    }
}
