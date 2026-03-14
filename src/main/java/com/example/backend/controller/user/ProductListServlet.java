package com.example.backend.controller.user;

import com.example.backend.model.Category;
import com.example.backend.model.Product;
import com.example.backend.service.CategoryService;
import com.example.backend.service.ProductService;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.annotation.WebServlet;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "ProductListServlet", value = "/products")
public class ProductListServlet extends HttpServlet {

    private ProductService productService = new ProductService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String categoryIdStr = request.getParameter("category_id");
        String searchKeyword = request.getParameter("search");
        String sortType = request.getParameter("sort");
        String direction = request.getParameter("direction");
        int page = 1;
        int pageSize = 12;

        String pageStr = request.getParameter("page");
        if (pageStr != null && !pageStr.isEmpty()) {
            page = Integer.parseInt(pageStr);
        }
        int offset = (page - 1) * pageSize;

        List<Product> productList = productService.getAllProducts(page,pageSize);
        int totalPages = productService.getTotalPages(pageSize);

        try {
            if (searchKeyword != null && !searchKeyword.trim().isEmpty()) {
                productList = productService.searchProducts(searchKeyword);
                request.setAttribute("title", "Tìm kiếm: " + searchKeyword);
            } else if (categoryIdStr != null && !categoryIdStr.trim().isEmpty()) {
                try {
                    int cid = Integer.parseInt(categoryIdStr);
                    productList = productService.getProductsByCategory(cid, offset, pageSize);

                    int totalProducts = productService.getTotalProductsCountByCategory(cid);
                    totalPages = (int) Math.ceil((double) totalProducts / pageSize);

                    request.setAttribute("title", "Sản phẩm theo danh mục");
                } catch (NumberFormatException e) {
                    productList = productService.getAllProducts(page, pageSize);
                }

            } else if (sortType != null && !sortType.trim().isEmpty()) {
                productList = productService.getAllProductsSorted(sortType, direction);
                request.setAttribute("title", "Sắp xếp theo giá");

            } else {
                productList = productService.getAllProducts(page, pageSize);
                totalPages = productService.getTotalPages(pageSize);
                request.setAttribute("title", "Tất cả sản phẩm");
            }
        } catch (Exception e) {
            e.printStackTrace();
            productList = null;
        }
        CategoryService categoryService = new CategoryService();
        List<Category> categoryList = categoryService.getAllCategories();
        request.setAttribute("categoryList", categoryList);
        request.setAttribute("productList", productList);
        request.setAttribute("totalPages", totalPages);

        request.setAttribute("paramSearch", searchKeyword);
        request.setAttribute("paramCid", categoryIdStr);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);

        request.getRequestDispatcher("/products.jsp").forward(request, response);
    }
}