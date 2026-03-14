package com.example.backend.controller.user;

import com.example.backend.dao.BlogDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.*;

@WebServlet("/home")
public class HomeServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        BlogDAO blogDAO = new BlogDAO();

        request.setAttribute("featuredPosts", blogDAO.getFeaturedPosts(3));
        request.getRequestDispatcher("index.jsp").forward(request, response);
    }
}
