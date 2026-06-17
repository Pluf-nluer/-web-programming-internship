package com.example.backend.controller.user;

import com.example.backend.dao.ProductDAO;
import com.example.backend.model.Product;
import com.example.backend.model.ProductAttribute;
import com.example.backend.model.ProductImage;
import com.example.backend.model.Review;
import com.example.backend.service.ProductService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Part;

import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.util.List;

@WebServlet(name = "ProductDetailServlet", value = "/productdetail")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2,
        maxFileSize = 1024 * 1024 * 10,
        maxRequestSize = 1024 * 1024 * 50
)
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

        List<Product> relatedProducts = productService.getRelatedProducts(product.getCategoryId(), pid);

        request.setAttribute("product", product);
        request.setAttribute("reviews", reviews);
        request.setAttribute("relatedProducts", relatedProducts);

        request.getRequestDispatcher("/productdetail.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");
        String name = request.getParameter("name");
        double price = Double.parseDouble(request.getParameter("price"));
        int stock = Integer.parseInt(request.getParameter("stock"));
        int categoryId = Integer.parseInt(request.getParameter("category_id"));
        String fullDescription = request.getParameter("full_description");
        String status = request.getParameter("status");
        boolean isFeatured = "1".equals(request.getParameter("featured"));

        String finalImageUrl = request.getParameter("image_url");

        try {
            Part filePart = request.getPart("image_file");
            if (filePart != null && filePart.getSize() > 0) {
                String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
                if (!fileName.isEmpty()) {
                    String uniqueFileName = System.currentTimeMillis() + "_" + fileName;

                    String uploadDirName = "uploads";
                    String uploadPath = getServletContext().getRealPath("") + File.separator + uploadDirName;

                    File uploadDir = new File(uploadPath);
                    if (!uploadDir.exists()) {
                        uploadDir.mkdir();
                    }

                    filePart.write(uploadPath + File.separator + uniqueFileName);

                    finalImageUrl = uploadDirName + "/" + uniqueFileName;
                }
            }
        } catch (Exception e) {
            System.err.println("Xảy ra lỗi trong quá trình bóc tách tệp tải lên: " + e.getMessage());
        }

        Product product = new Product();
        product.setName(name);
        product.setPrice(price);
        product.setStock(stock);
        product.setCategoryId(categoryId);
        product.setFullDescription(fullDescription);
        product.setStatus(status);
        product.setFeatured(isFeatured);

        ProductImage productImage = new ProductImage();
        productImage.setImageUrl(finalImageUrl);
        product.setImage(productImage);

        ProductAttribute attribute = new ProductAttribute();
        attribute.setMaterial(request.getParameter("material"));
        attribute.setOrigin(request.getParameter("origin"));
        attribute.setSize(request.getParameter("dimensions"));
        attribute.setWeight(request.getParameter("weight"));
        attribute.setColor(request.getParameter("manufacturer"));

        if ("insert".equals(action)) {
            productService.insertFullProduct(product, attribute, productImage);
        } else if ("update".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            product.setId(id);
            productService.updateProduct(product, attribute, productImage);
        }

        response.sendRedirect(request.getContextPath() + "/admin/products");
    }

}