package com.example.backend.controller.user;

import com.example.backend.dao.BlogDAO;
import com.example.backend.model.BlogPost;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet(name="NewsDetailServlet", value = "/news-detail")
public class NewsDetailServlet  extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String param = request.getParameter("id");
        BlogDAO blogDAO = new BlogDAO();
        List<BlogPost> feature = blogDAO.getFeaturedPosts(5);
        request.setAttribute("featuredPosts",feature);
        if(param==null||param.trim().isEmpty()){
            request.setAttribute("errorMessage","Không tìm thấy bài viết");
            request.getRequestDispatcher("/news-detail.jsp").forward(request,response);
            return;
        }
        try {
            int id = Integer.parseInt(param);
            BlogPost post = blogDAO.getPostById(id);
            if(post == null){
                request.setAttribute("errorMessage" , "Bài viết không tồn tại");
            }else{
                request.setAttribute("post",post);
            }
            request.getRequestDispatcher("/news-detail.jsp").forward(request,response);
        }catch (NumberFormatException e){
            request.setAttribute("errorMessage","Lỗi đường dẫn");
            request.getRequestDispatcher("/news-detail.jsp").forward(request,response);
        }

    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request,response);
    }
}
