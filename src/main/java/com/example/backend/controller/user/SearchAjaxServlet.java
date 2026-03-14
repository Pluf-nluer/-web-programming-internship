package com.example.backend.controller.user;

import com.example.backend.dao.ProductDAO;
import com.example.backend.model.Product;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

@WebServlet("/search-ajax")
public class SearchAjaxServlet extends HttpServlet {
    private ProductDAO productDAO = new ProductDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        String keyword = request.getParameter("keyword");

        
        List<Product> list = productDAO.searchProductsByName(keyword);
        PrintWriter out = response.getWriter();

        if (list == null || list.isEmpty()) {
            out.println("<p style='padding: 20px; color: #888;'>Không tìm thấy sản phẩm phù hợp.</p>");
        } else {
            
            for (Product p : list) {
                out.println("<a href='" + request.getContextPath() + "/productdetail?id=" + p.getId() + "' class='search-result-item'>");
                out.println("    <div class='search-item-image'>");

                
                String imgUrl = (p.getImage() != null) ? p.getImage().getImageUrl() : "https://via.placeholder.com/60";
                out.println("        <img src='" + imgUrl + "' alt='" + p.getName() + "'>");

                out.println("    </div>");
                out.println("    <div class='search-item-info'>");
                out.println("        <p class='product-name'>" + p.getName() + "</p>");
                out.println("        <p class='product-price'>" + String.format("%,.0f đ", p.getPrice()) + "</p>");
                out.println("    </div>");
                out.println("</a>");
            }
        }
    }
}