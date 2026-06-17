package com.example.backend.controller.user;

import com.example.backend.dao.CartDAO;
import com.example.backend.dao.UserDAO;
import com.example.backend.model.Cart;
import com.example.backend.model.CartItem;
import com.example.backend.model.User;
import com.example.backend.util.PasswordUtil;
import com.example.backend.util.RememberMeUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;
import java.util.Map;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    private static final String INVALID_LOGIN_MESSAGE = "Thông tin đăng nhập không hợp lệ hoặc tài khoản không thể truy cập.";
    private UserDAO userDAO;
    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
    }
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session != null) {
            Object sessionUser = session.getAttribute("user");
            if (sessionUser instanceof User) {
                User user = (User) sessionUser;
                if (user.isAdmin()) {
                    response.sendRedirect(request.getContextPath() + "/admin/dashboard");
                    return;
                }
                response.sendRedirect(request.getContextPath() + "/index");
                return;
            }
        }
        request.getRequestDispatcher("/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        String emailOrPhone = request.getParameter("emailOrPhone");
        String password = request.getParameter("password");
        String rememberMe = request.getParameter("rememberMe");

        if (emailOrPhone == null || emailOrPhone.trim().isEmpty() ||
                password == null || password.trim().isEmpty()) {
            showLoginError(request, response, "Vui lòng nhập đầy đủ thông tin!", emailOrPhone, rememberMe);
            return;
        }

        String hashedPassword = PasswordUtil.encrypt(password);
        if (hashedPassword == null) {
            showLoginError(request, response, INVALID_LOGIN_MESSAGE, emailOrPhone, rememberMe);
            return;
        }

        User user = userDAO.checkLogin(emailOrPhone, hashedPassword);

        if (user == null || !user.isActive()) {
            showLoginError(request, response, INVALID_LOGIN_MESSAGE, emailOrPhone, rememberMe);
            return;
        }

        Cart temporaryCart = null;
        HttpSession oldSession = request.getSession(false);
        if (oldSession != null) {
            java.util.Enumeration<String> attributeNames = oldSession.getAttributeNames();

            temporaryCart = (Cart) oldSession.getAttribute("cart");
        }

        HttpSession session = request.getSession(true);
        session.setAttribute("user", user);
        session.setAttribute("userId", user.getId());
        session.setAttribute("userName", user.getFullName());
        session.setAttribute("userRole", user.getRole());

        boolean rememberLogin = "on".equals(rememberMe) && !user.isAdmin();
        session.setMaxInactiveInterval(rememberLogin ? RememberMeUtil.MAX_AGE_SECONDS : 30 * 60);

        if (rememberLogin) {
            response.addCookie(RememberMeUtil.createCookie(user, request.isSecure()));
        } else {
            response.addCookie(RememberMeUtil.clearCookie(request.isSecure()));
        }

        if (user.isAdmin()) {
            session.removeAttribute("postLoginRedirect");
            response.sendRedirect(request.getContextPath() + "/admin/dashboard");
            return;
        }

        try {
            // SỬA TẠI ĐÂY: Sử dụng temporaryCart đã bốc từ trước thay vì gọi session.getAttribute
            if (temporaryCart != null && temporaryCart.getItems() != null && !temporaryCart.getItems().isEmpty()) {
                CartDAO cartDAO = new CartDAO();

                for (CartItem item : temporaryCart.getItems()) {
                    if (item.getProduct() != null) {
                        cartDAO.saveOrUpdateCartItem(user.getId(), item);
                    }
                }
                System.out.println("=> [DEBUG SUCCESS] Đã gộp thành công giỏ tạm từ biến bảo toàn xuống DB!");
            } else {
                System.out.println("=> [DEBUG WARNING] Không gộp được vì temporaryCart bị rỗng hoặc null!");
            }
        } catch (Exception e) {
            System.err.println("Lỗi nghiêm trọng trong quá trình gộp giỏ hàng (Merge Cart): " + e.getMessage());
            e.printStackTrace();
        }

        // Đồng bộ lại con số vòng tròn đỏ trên Header sau khi gộp xong
        try {
            CartDAO cartDAO = new CartDAO();
            List<CartItem> dbCartItems = cartDAO.getCartItemsByUserId(user.getId());
            int totalQty = 0;
            for (CartItem item : dbCartItems) {
                totalQty += item.getQuantity();
            }
            session.setAttribute("cartTotalQuantity", totalQty);
        } catch (Exception e) {
            session.setAttribute("cartTotalQuantity", 0);
        }

        String redirectUrl = (String) session.getAttribute("postLoginRedirect");
        if (redirectUrl != null && !redirectUrl.trim().isEmpty()) {
            session.removeAttribute("postLoginRedirect");
            response.sendRedirect(redirectUrl);
            return;
        }

        response.sendRedirect(request.getContextPath() + "/cart");
    }

    private void showLoginError(HttpServletRequest request, HttpServletResponse response, String message,
                                String emailOrPhone, String rememberMe) throws ServletException, IOException {
        request.setAttribute("errorMessage", message);
        request.setAttribute("emailOrPhone", emailOrPhone);
        request.setAttribute("rememberMe", rememberMe);
        request.getRequestDispatcher("/login.jsp").forward(request, response);
    }
}