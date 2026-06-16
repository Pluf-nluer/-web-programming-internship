package com.example.backend.servlet;

import com.example.backend.dao.ProductDAO;
import com.example.backend.dao.WishlistDAO;
import com.example.backend.model.Product;
import com.example.backend.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/wishlist")
public class WishlistServlet extends HttpServlet {
    private WishlistDAO wishlistDao = new WishlistDAO();
    private ProductDAO productDao = new ProductDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        List<Product> wishlistProducts = productDao.getWishlistProductsByUserId(user.getId());

        request.setAttribute("wishlistProducts", wishlistProducts);
        request.setAttribute("wishlistCount", wishlistProducts.size());

        request.getRequestDispatcher("/account/wishlist.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.getWriter().write("unauthorized");
            return;
        }

        String action = request.getParameter("action");
        int productId = Integer.parseInt(request.getParameter("productId"));
        boolean success = false;

        if ("add".equals(action)) {
            success = wishlistDao.addToWishlist(user.getId(), productId);
        } else if ("remove".equals(action)) {
            success = wishlistDao.removeFromWishlist(user.getId(), productId);
        }

        response.setContentType("text/plain");
        response.getWriter().write(success ? "success" : "error");
    }
}