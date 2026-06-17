package com.example.backend.controller.admin;

import com.example.backend.dao.DashboardStatisticsDAO;
import com.example.backend.dao.OrderDao;
import com.example.backend.model.Order;
import com.example.backend.service.ProductService;
import com.google.gson.Gson;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.time.LocalDate;
import java.util.List;
import java.util.Map;

@WebServlet(name = "AdminDashboardServlet", value = "/admin/dashboard")
public class AdminDashboardServlet extends HttpServlet {

    private final ProductService productService = new ProductService();
    private final OrderDao orderDao = new OrderDao();
    private final DashboardStatisticsDAO statsDAO = new DashboardStatisticsDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        int totalProducts = productService.getAllProductsForAdmin(0, 10000).size();
        List<Order> allOrders = orderDao.getAllOrders();
        long pendingOrders = allOrders.stream().filter(o -> "pending".equalsIgnoreCase(o.getOrder_status())).count();

        double monthlyRevenue = statsDAO.getActualMonthlyRevenue();

        int currentYear = LocalDate.now().getYear();
        List<Double> currentYearRevenue = statsDAO.getRevenueDataByYear(currentYear);
        List<Double> lastYearRevenue = statsDAO.getRevenueDataByYear(currentYear - 1);

        double totalCurrentSum = currentYearRevenue.stream().mapToDouble(Double::doubleValue).sum();
        double totalLastSum = lastYearRevenue.stream().mapToDouble(Double::doubleValue).sum();
        double growthRate = 0;
        if (totalLastSum > 0) {
            growthRate = ((totalCurrentSum - totalLastSum) / totalLastSum) * 100;
        }

        Gson gson = new Gson();
        request.setAttribute("currentYearRevenueJson", gson.toJson(currentYearRevenue));
        request.setAttribute("lastYearRevenueJson", gson.toJson(lastYearRevenue));
        request.setAttribute("growthRate", Math.round(growthRate * 100.0) / 100.0);
        request.setAttribute("currentYear", currentYear);

        request.setAttribute("totalProducts", totalProducts);
        request.setAttribute("ordersToday", allOrders.size());
        request.setAttribute("pendingOrders", pendingOrders);
        request.setAttribute("monthlyRevenue", monthlyRevenue);

        List<Order> recentOrders = allOrders.stream().limit(5).toList();
        request.setAttribute("recentOrders", recentOrders);

        String compareMonthA = request.getParameter("monthA");
        String compareYearA = request.getParameter("yearA");
        String compareMonthB = request.getParameter("monthB");
        String compareYearB = request.getParameter("yearB");

        int mA = (compareMonthA != null) ? Integer.parseInt(compareMonthA) : 1;
        int yA = (compareYearA != null) ? Integer.parseInt(compareYearA) : 2025;
        int mB = (compareMonthB != null) ? Integer.parseInt(compareMonthB) : LocalDate.now().getMonthValue();
        int yB = (compareYearB != null) ? Integer.parseInt(compareYearB) : 2026;

        double revenueMocA = statsDAO.getRevenueByMonthAndYear(mA, yA);
        double revenueMocB = statsDAO.getRevenueByMonthAndYear(mB, yB);
        double comparisonGrowth = 0;
        if (revenueMocA > 0) {
            comparisonGrowth = ((revenueMocB - revenueMocA) / revenueMocA) * 100;
        }

        request.setAttribute("revenueMocA", revenueMocA);
        request.setAttribute("revenueMocB", revenueMocB);
        request.setAttribute("comparisonGrowth", Math.round(comparisonGrowth * 100.0) / 100.0);
        request.setAttribute("mA", mA); request.setAttribute("yA", yA);
        request.setAttribute("mB", mB); request.setAttribute("yB", yB);

        String startDate = request.getParameter("startDate");
        String endDate = request.getParameter("endDate");
        if (startDate == null || startDate.trim().isEmpty()) {
            startDate = LocalDate.now().minusMonths(1).toString();
        }
        if (endDate == null || endDate.trim().isEmpty()) {
            endDate = LocalDate.now().toString();
        }

        Map<String, Integer> invFlow = statsDAO.getInventoryFlow(startDate, endDate);
        request.setAttribute("invFlow", invFlow);
        request.setAttribute("startDate", startDate);
        request.setAttribute("endDate", endDate);

        int totalAllImport = statsDAO.getTotalImportedQuantity();
        int totalAllExport = statsDAO.getTotalExportedQuantity();

        double salesToImportRatio = 0.0;
        if (totalAllImport > 0) {
            salesToImportRatio = ((double) totalAllExport / totalAllImport) * 100;
        }

        salesToImportRatio = Math.round(salesToImportRatio * 10.0) / 10.0;

        request.setAttribute("totalAllImport", totalAllImport);
        request.setAttribute("totalAllExport", totalAllExport);
        request.setAttribute("salesToImportRatio", salesToImportRatio);

        request.getRequestDispatcher("/admin/dashboard.jsp").forward(request, response);
    }
}