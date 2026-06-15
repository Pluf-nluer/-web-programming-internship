package com.example.backend.controller.user;

import com.example.backend.dao.BannerDAO;
import com.example.backend.dao.BlogDAO;
import com.example.backend.dao.ProductDAO;
import com.example.backend.model.Product;
import com.example.backend.service.FeaturedProductService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.*;

@WebServlet(name = "HomeServlet", value = {"/home", ""})
public class HomeServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        BannerDAO bannerDAO = new BannerDAO();
        request.setAttribute("banners", bannerDAO.getBannerDefault());

        FeaturedProductService featuredService = new FeaturedProductService();
        featuredService.generateFeaturedProductsForCurrentMonth();

        ProductDAO productDAO = new ProductDAO();
        request.setAttribute("featuredProducts", productDAO.getFeaturedProductsForCurrentMonth());

        BlogDAO blogDAO = new BlogDAO();

        request.setAttribute("featuredPosts", blogDAO.getFeaturedPosts(3));

        request.getRequestDispatcher("index.jsp").forward(request, response);
    }
}
