package com.example.backend.controller.user;

import com.example.backend.dao.UserDAO;
import com.example.backend.model.User;
import com.example.backend.util.PhoneNumberUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;





@WebServlet("/profile")
public class UserProfileServlet extends HttpServlet {

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

        
        User userFromDB = userDAO.getUserById(currentUser.getId());
        
        if (userFromDB != null) {
            
            session.setAttribute("user", userFromDB);
            request.setAttribute("user", userFromDB);
        } else {
            
            session.invalidate();
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        request.getRequestDispatcher("/account/account-profile.jsp").forward(request, response);
    }

    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("user") : null;

        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        
        String fullName = request.getParameter("fullName");
        String phone = request.getParameter("phone");
        String trimmedFullName = fullName == null ? "" : fullName.trim();
        String normalizedPhone = PhoneNumberUtil.normalize(phone);
        
        
        if (trimmedFullName.isEmpty() || normalizedPhone.isEmpty()) {
            
            request.setAttribute("user", currentUser);
            request.setAttribute("errorMessage", "Vui lòng không để trống họ tên và số điện thoại!");
            request.getRequestDispatcher("/account/account-profile.jsp").forward(request, response);
            return;
        }
        if (!PhoneNumberUtil.isValidVietnamMobileNumber(normalizedPhone)) {
            request.setAttribute("user", currentUser);
            request.setAttribute("errorMessage", "Số điện thoại không hợp lệ!");
            request.getRequestDispatcher("/account/account-profile.jsp").forward(request, response);
            return;
        }

        if (userDAO.isPhoneExistsForOtherUser(normalizedPhone, currentUser.getId())) {
            request.setAttribute("user", currentUser);
            request.setAttribute("errorMessage", "Số điện thoại này đã được sử dụng!");
            request.getRequestDispatcher("/account/account-profile.jsp").forward(request, response);
            return;
        }
        
        
        currentUser.setFullName(trimmedFullName);
        currentUser.setPhone(normalizedPhone);

        
        boolean success = userDAO.updateProfile(currentUser);

        if (success) {
            
            session.setAttribute("user", currentUser);
            session.setAttribute("userName", currentUser.getFullName());
            
            request.setAttribute("successMessage", "Cập nhật thông tin thành công!");
        } else {
            request.setAttribute("errorMessage", "Đã có lỗi xảy ra. Vui lòng thử lại!");
        }

        request.getRequestDispatcher("/account/account-profile.jsp").forward(request, response);
    }
}
