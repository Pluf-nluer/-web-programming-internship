package com.example.backend.service;

import com.example.backend.dao.CategoryDAO;
import com.example.backend.model.Category;

import java.util.List;

public class CategoryService {
    private CategoryDAO categoryDAO = new CategoryDAO();

    public List<Category> getAllCategories() {
        return categoryDAO.getCategories();
    }
}
