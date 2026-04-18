package com.example.backend.controller.admin;

import com.example.backend.dao.ProductDAO;
import com.example.backend.dao.ReviewDAO;
import com.example.backend.model.Product;
import com.example.backend.model.Review;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;
@WebServlet(name = "AdminReviewServlet", value = "/admin/review")
public class AdminReviewServlet extends HttpServlet {
    private ReviewDAO reviewDAO = new ReviewDAO();
    private ProductDAO productDAO = new ProductDAO();

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if (action == null) action = "list";

        try {
            switch (action) {
                case "updateStatus":
                    int upId = Integer.parseInt(request.getParameter("id"));
                    String status = request.getParameter("status");
                    reviewDAO.updateStatus(upId, status);
                    response.sendRedirect(request.getContextPath() + "/admin/review?action=list");
                    return;

                case "delete":
                    int delId = Integer.parseInt(request.getParameter("id"));
                    reviewDAO.deleteReview(delId);
                    response.sendRedirect(request.getContextPath() + "/admin/review?action=list");
                    return;

                case "detail":
                    int detId = Integer.parseInt(request.getParameter("id"));
                    Review review = reviewDAO.getReviewById(detId);
                    if (review != null) {
                        request.setAttribute("review", review);
                        request.setAttribute("product", productDAO.getProductById(review.getProductId()));
                        request.getRequestDispatcher("/admin/review-detail.jsp").forward(request, response);
                    } else {
                        response.sendRedirect("review?action=list");
                    }
                    return;

                default:
                    List<Review> list = reviewDAO.getAllReviews();
                    request.setAttribute("reviewList", list);
                    request.setAttribute("totalReviews", list.size());
                    request.getRequestDispatcher("/admin/review/list.jsp").forward(request, response);
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("review?action=list");
        }
    }
}