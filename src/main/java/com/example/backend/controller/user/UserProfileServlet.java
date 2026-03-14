package com.example.backend.controller.user;

import com.example.backend.dao.UserDAO;
import com.example.backend.model.User;
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
            
            
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        
        User userFromDB = userDAO.getUserById(currentUser.getId());
        
        if (userFromDB != null) {
            
            session.setAttribute("user", userFromDB);
            request.setAttribute("user", userFromDB);
        } else {
            
            session.invalidate();
            response.sendRedirect(request.getContextPath() + "/login.jsp");
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
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        
        String fullName = request.getParameter("fullName");
        String phone = request.getParameter("phone");
        
        
        if (fullName == null || fullName.trim().isEmpty() || 
            phone == null || phone.trim().isEmpty()) {
            
            request.setAttribute("errorMessage", "Vui lòng không để trống họ tên và số điện thoại!");
            request.getRequestDispatcher("/account/account-profile.jsp").forward(request, response);
            return;
        }

        
        
        currentUser.setFullName(fullName.trim());
        currentUser.setPhone(phone.trim());

        
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
