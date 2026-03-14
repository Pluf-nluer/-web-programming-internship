package com.example.backend.controller.user;

import com.example.backend.model.Banner;
import com.example.backend.service.BannerService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "BannerServlet", value = "/index")
public class BannerServlet extends HttpServlet {
    private BannerService bannerService = new BannerService();
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        try {
            List<Banner> banners = bannerService.getBannersDefaults();
            request.setAttribute("banners", banners);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("banners", null);
        }
        request.getRequestDispatcher("/index.jsp").forward(request, response);
    }
}
