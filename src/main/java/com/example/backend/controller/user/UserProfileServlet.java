package com.example.backend.controller.user;

import com.example.backend.dao.UserDAO;
import com.example.backend.dao.UserAddressDAO;
import com.example.backend.model.User;
import com.example.backend.model.UserAddress;
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
    private UserAddressDAO addressDAO;

    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
        addressDAO = new UserAddressDAO();
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
            request.setAttribute("shippingAddress", addressDAO.getByUserId(userFromDB.getId()));
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
        UserAddress shippingAddress = buildAddress(request, currentUser.getId());
        boolean hasShippingAddress = hasAddressValue(shippingAddress);
        
        
        if (trimmedFullName.isEmpty() || normalizedPhone.isEmpty()) {
            
            request.setAttribute("user", currentUser);
            request.setAttribute("shippingAddress", shippingAddress);
            request.setAttribute("errorMessage", "Vui lòng không để trống họ tên và số điện thoại!");
            request.getRequestDispatcher("/account/account-profile.jsp").forward(request, response);
            return;
        }
        if (!PhoneNumberUtil.isValidVietnamMobileNumber(normalizedPhone)) {
            request.setAttribute("user", currentUser);
            request.setAttribute("shippingAddress", shippingAddress);
            request.setAttribute("errorMessage", "Số điện thoại không hợp lệ!");
            request.getRequestDispatcher("/account/account-profile.jsp").forward(request, response);
            return;
        }

        if (userDAO.isPhoneExistsForOtherUser(normalizedPhone, currentUser.getId())) {
            request.setAttribute("user", currentUser);
            request.setAttribute("shippingAddress", shippingAddress);
            request.setAttribute("errorMessage", "Số điện thoại này đã được sử dụng!");
            request.getRequestDispatcher("/account/account-profile.jsp").forward(request, response);
            return;
        }

        if (hasShippingAddress && !isCompleteAddress(shippingAddress)) {
            request.setAttribute("user", currentUser);
            request.setAttribute("shippingAddress", shippingAddress);
            request.setAttribute("errorMessage", "Vui lòng nhập đầy đủ thông tin địa chỉ giao hàng!");
            request.getRequestDispatcher("/account/account-profile.jsp").forward(request, response);
            return;
        }

        if (hasShippingAddress && !PhoneNumberUtil.isValidVietnamMobileNumber(shippingAddress.getPhone())) {
            request.setAttribute("user", currentUser);
            request.setAttribute("shippingAddress", shippingAddress);
            request.setAttribute("errorMessage", "SĐT nhận hàng không hợp lệ!");
            request.getRequestDispatcher("/account/account-profile.jsp").forward(request, response);
            return;
        }
        
        
        currentUser.setFullName(trimmedFullName);
        currentUser.setPhone(normalizedPhone);

        
        boolean success = userDAO.updateProfile(currentUser);

        if (success) {
            if (hasShippingAddress && !addressDAO.save(shippingAddress)) {
                request.setAttribute("user", currentUser);
                request.setAttribute("shippingAddress", shippingAddress);
                request.setAttribute("errorMessage", "Không thể lưu địa chỉ giao hàng. Vui lòng thử lại!");
                request.getRequestDispatcher("/account/account-profile.jsp").forward(request, response);
                return;
            }
            
            session.setAttribute("user", currentUser);
            session.setAttribute("userName", currentUser.getFullName());
            
            request.setAttribute("successMessage", "Cập nhật thông tin thành công!");
            request.setAttribute("shippingAddress", hasShippingAddress ? shippingAddress : addressDAO.getByUserId(currentUser.getId()));
        } else {
            request.setAttribute("shippingAddress", shippingAddress);
            request.setAttribute("errorMessage", "Đã có lỗi xảy ra. Vui lòng thử lại!");
        }

        request.getRequestDispatcher("/account/account-profile.jsp").forward(request, response);
    }

    private UserAddress buildAddress(HttpServletRequest request, int userId) {
        UserAddress address = new UserAddress();
        address.setUserId(userId);
        address.setReceiverName(trim(request.getParameter("receiverName")));
        address.setPhone(PhoneNumberUtil.normalize(request.getParameter("shippingPhone")));
        address.setAddressLine(trim(request.getParameter("addressLine")));
        address.setProvince(trim(request.getParameter("province")));
        address.setDistrict(trim(request.getParameter("district")));
        address.setWard(trim(request.getParameter("ward")));
        address.setNote(trim(request.getParameter("note")));
        return address;
    }

    private boolean hasAddressValue(UserAddress address) {
        return !address.getReceiverName().isEmpty() || !address.getPhone().isEmpty() ||
                !address.getAddressLine().isEmpty() || !address.getProvince().isEmpty() ||
                !address.getDistrict().isEmpty() || !address.getWard().isEmpty() ||
                !address.getNote().isEmpty();
    }

    private boolean isCompleteAddress(UserAddress address) {
        return !address.getReceiverName().isEmpty() && !address.getPhone().isEmpty() &&
                !address.getAddressLine().isEmpty() && !address.getProvince().isEmpty() &&
                !address.getDistrict().isEmpty() && !address.getWard().isEmpty();
    }

    private String trim(String value) {
        return value == null ? "" : value.trim();
    }
}
