package com.example.backend.service;

import com.example.backend.dao.FeaturedProductDAO;
import com.example.backend.dao.ProductDAO;
import com.example.backend.model.Category;

import java.util.Calendar;
import java.util.List;

public class FeaturedProductService {
    private FeaturedProductDAO featuredDAO = new FeaturedProductDAO();
    private ProductDAO productDAO = new ProductDAO();
    private CategoryService categoryService = new CategoryService();

    public void generateFeaturedProductsForCurrentMonth() {
        Calendar cal = Calendar.getInstance();
        int currentMonth = cal.get(Calendar.MONTH) + 1;
        int currentYear = cal.get(Calendar.YEAR);

        if (featuredDAO.isFeaturedGenerated(currentMonth, currentYear)) {
            return;
        }

        cal.add(Calendar.MONTH, -1);
        int lastMonth = cal.get(Calendar.MONTH) + 1;
        int lastYear = cal.get(Calendar.YEAR);

        List<Category> categories = categoryService.getAllCategories();

        for (Category cat : categories) {
            List<Integer> top10Ids = productDAO.getTop10BestSellingProductIdsByCategory(
                    cat.getId(), lastMonth, lastYear
            );

            for (Integer productId : top10Ids) {
                featuredDAO.saveFeatured(productId, cat.getId(), currentMonth, currentYear);
            }
        }
    }
}
