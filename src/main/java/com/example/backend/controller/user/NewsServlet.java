package com.example.backend.controller.user;

import com.example.backend.dao.BlogDAO;
import com.example.backend.model.BlogCategory;
import com.example.backend.model.BlogPost;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "NewsServlet", value = "/news")
public class NewsServlet extends HttpServlet {

    private BlogDAO blogDAO = new BlogDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<BlogPost> postList = blogDAO.getAllPosts();
        List<BlogPost> featuredList = blogDAO.getFeaturedPosts(5);
        List<BlogCategory> categoryList = blogDAO.getAllCategories();

        request.setAttribute("posts", postList);
        request.setAttribute("featuredPosts", featuredList);
        request.setAttribute("blogCategories", categoryList);

        request.getRequestDispatcher("news.jsp").forward(request, response);
    }
}