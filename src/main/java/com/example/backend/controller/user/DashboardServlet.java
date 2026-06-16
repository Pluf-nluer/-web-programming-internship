package com.example.backend.controller.user;

import com.example.backend.dao.OrderDao;
import com.example.backend.model.Order;
import com.example.backend.model.User;
import jakarta.servlet.ServletConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;

@WebServlet("/dashboard")
public class DashboardServlet extends HttpServlet {
    private OrderDao orderDao;

    @Override
    public void init() throws ServletException {
        orderDao = new OrderDao();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if(user ==null){
            response.sendRedirect(request.getContextPath()+"/login");
            return;
        }
        List<Order> list = orderDao.getOrdersByUserId(user.getId());
        int totalOrder = (list!=null)?list.size():0;
        double totalMonth = 0;
        Calendar now = Calendar.getInstance();
        int currMonth = now.get(Calendar.MONTH);
        int currYear = now.get(Calendar.YEAR);
        if(list!=null){
            Calendar orderCal = Calendar.getInstance();
            for (Order order: list){
                if("Completed".equalsIgnoreCase(order.getOrder_status())){
                    orderCal.setTime(order.getCreated_at());
                    if(orderCal.get(Calendar.MONTH) == currMonth && orderCal.get(Calendar.YEAR)==currYear){
                        totalMonth += order.getTotal_amount();
                    }
                }
            }
        }
        request.setAttribute("orders",list);
        request.setAttribute("totalOrders",totalOrder);
        request.setAttribute("totalSpentThisMonth",totalMonth);
        request.setAttribute("currentMonth",currMonth+1);

        request.getRequestDispatcher("/account/dashboard.jsp").forward(request,response);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        doGet(req,resp);
    }
}
