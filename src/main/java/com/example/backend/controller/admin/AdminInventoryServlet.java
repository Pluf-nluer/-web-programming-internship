package com.example.backend.controller.admin;

import com.example.backend.dao.InventoryDao;
import com.example.backend.model.Product;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "AdminInventoryServlet", value = "/admin/inventory")
public class AdminInventoryServlet extends HttpServlet {
    private final InventoryDao inventoryDao = new InventoryDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<Product> inventoryList = inventoryDao.getInventoryList();
        request.setAttribute("inventoryList", inventoryList);
        request.getRequestDispatcher("/admin/inventory/inventory-list.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        String[] productIdsStr = request.getParameterValues("productIds");
        String[] stockAddsStr = request.getParameterValues("stockAdds");

        if (productIdsStr != null && stockAddsStr != null) {
            List<Integer> productIds = new ArrayList<>();
            List<Integer> quantitiesAdded = new ArrayList<>();

            for (int i = 0; i < productIdsStr.length; i++) {
                try {
                    int pId = Integer.parseInt(productIdsStr[i]);
                    int qAdd = stockAddsStr[i].trim().isEmpty() ? 0 : Integer.parseInt(stockAddsStr[i].trim());

                    if (qAdd > 0) {
                        productIds.add(pId);
                        quantitiesAdded.add(qAdd);
                    }
                } catch (NumberFormatException e) {
                }
            }

            if (!productIds.isEmpty()) {
                boolean success = inventoryDao.importStockBatch(productIds, quantitiesAdded);
                if (success) {
                    response.sendRedirect(request.getContextPath() + "/admin/inventory?status=success");
                    return;
                }
            }
        }
        response.sendRedirect(request.getContextPath() + "/admin/inventory?status=error");
    }
}