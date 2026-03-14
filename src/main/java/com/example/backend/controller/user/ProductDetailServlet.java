package com.example.backend.controller.user;

import com.example.backend.dao.ProductDAO;
import com.example.backend.model.Product;
import com.example.backend.model.Review;
import com.example.backend.service.ProductService;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.annotation.WebServlet;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "ProductDetailServlet", value = "/productdetail")
public class ProductDetailServlet extends HttpServlet {

    private ProductService productService = new ProductService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        String idStr = request.getParameter("id");
        int pid;

        if (idStr == null || idStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/products");
            return;
        }

        try {
            pid = Integer.parseInt(idStr);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/products");
            return;
        }

        Product product = productService.getFullProductDetail(pid);

        if (product == null) {
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }

        ProductDAO productDAO = new ProductDAO();
        List<Review> reviews = productDAO.getReviewsByProductId(pid);
        System.out.println("Số lượng review lấy được: " + (reviews != null ? reviews.size() : 0));

        List<Product> relatedProducts = productService.getRelatedProducts(product.getCategoryId(), pid);

        request.setAttribute("product", product);
        request.setAttribute("reviews", reviews);
        request.setAttribute("relatedProducts", relatedProducts);

        request.getRequestDispatcher("/productdetail.jsp").forward(request, response);
    }
}