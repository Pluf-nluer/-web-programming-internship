package com.example.backend.service;

import com.example.backend.dao.ProductDAO;
import com.example.backend.model.Product;
import com.example.backend.model.ProductAttribute;
import com.example.backend.model.ProductImage;

import java.util.List;

public class ProductService {

    private ProductDAO productDAO = new ProductDAO();


    public List<Product> getFeaturedProducts() {
        return productDAO.getFeaturedProducts();
    }


    public List<Product> getSaleProducts() {
        return productDAO.getSaleProducts();
    }

    public Product getProduct(int id) {
        return productDAO.getProductById(id);
    }


    public void updateProduct(Product product, ProductAttribute attribute, ProductImage image) {
        productDAO.updateProduct(product);

        productDAO.updateProductAttribute(product.getId(), attribute);

        if (image.getImageUrl() != null && !image.getImageUrl().isEmpty()) {
            productDAO.updateProductImage(product.getId(), image);
        }
    }

    public int calculateDiscountPercentage(double originalPrice, double salePrice) {
        if (originalPrice == 0) return 0;
        double percent = ((originalPrice - salePrice) / originalPrice) * 100;
        return (int) Math.round(percent);
    }

    public List<Product> getAllProducts(int page, int pageSize) {
        int offset = (page - 1) * pageSize;
        return productDAO.getAllProducts(offset, pageSize);
    }
    public List<Product> getAllProductsForAdmin(int offset, int limit) {
        return productDAO.getAllProducts(offset, limit);
    }

    public int getTotalPages(int pageSize) {
        int totalRecords = productDAO.getTotalProductsCount();
        return (int) Math.ceil((double) totalRecords/pageSize);
    }

    public List<Product> searchProducts(String keyword) {
        return productDAO.searchProductsByName(keyword);
    }

    public List<Product> getProductsByCategory(int cid, int offset, int limit) {
        return productDAO.getProductsByCategory(cid, offset, limit);
    }

    public int getTotalProductsCountByCategory(int cid) {
        return productDAO.getTotalProductsCountByCategory(cid);
    }

    public List<Product> getAllProductsSorted(String sortType, String direction) {
        return productDAO.getAllProductsSorted(sortType, direction);
    }

    public Product getFullProductDetail(int id) {
        Product product = productDAO.getProductById(id);

        if (product != null) {
            ProductAttribute attr = productDAO.getAttributeByProductId(id);
            product.setAttribute(attr);
        }
        return product;
    }

    public List<Product> getRelatedProducts(int categoryId, int currentProductId) {
        return productDAO.getRelatedProducts(categoryId, currentProductId, 4);
    }

    public void insertFullProduct(Product p, ProductAttribute pa) {
        
        int productId = productDAO.insertProduct(p);

        if (productId > 0) {
            
            if (p.getImage() != null && p.getImage().getImageUrl() != null) {
                productDAO.insertProductImage(productId, p.getImage().getImageUrl());
            }

            
            productDAO.insertProductAttributes(productId, pa);
        }
    }

    public void deleteProduct(int id) {
        productDAO.deleteProduct(id);
    }


}