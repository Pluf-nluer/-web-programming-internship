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

@WebServlet(name="BlogServlet",value = "/news")
public class BlogServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        BlogDAO blogDAO = new BlogDAO();
        int pageSize = 6;
        int curPage = 1;
        String param = request.getParameter("page");
        if(param!=null && !param.trim().isEmpty()){
            try {
                curPage = Integer.parseInt(param);
            } catch (NumberFormatException e) {
                curPage =1;
            }
        }
        int totalBlog = blogDAO.getTotalPost();
        int totalPage = (int) Math.ceil((double) totalBlog / pageSize);
        if(totalPage==0){
            totalPage = 1;
        }
        if(curPage <1){
            curPage = 1;
        }else if(curPage>totalPage){
            curPage = totalPage;
        }
        List<BlogPost> post = blogDAO.getPostByPage(curPage,pageSize);
        List<BlogPost> feature = blogDAO.getFeaturedPosts(3);
        request.setAttribute("posts",post);
        request.setAttribute("featuredPosts",feature);
        request.setAttribute("currentPage",curPage);
        request.setAttribute("totalPages",totalPage);
        request.getRequestDispatcher("/news.jsp").forward(request,response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}
