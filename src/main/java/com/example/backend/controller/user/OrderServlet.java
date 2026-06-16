package com.example.backend.controller.user;

import com.example.backend.dao.OrderDao;
import com.example.backend.model.Order;
import com.example.backend.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet("/user-orders")
public class OrderServlet extends HttpServlet {
    private OrderDao order;

    @Override
    public void init() throws ServletException{
        order = new OrderDao();
    }
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException{
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if(user == null){
            response.sendRedirect(request.getContextPath()+"/login");
            return;
        }
        int pageSize = 6;
        int currPage = 1;
        String param = request.getParameter("page");
        if(param!=null&&!param.trim().isEmpty()){
            try {
                currPage = Integer.parseInt(param);
            }catch (NumberFormatException e){
                currPage = 1;
            }
        }
        int totalOrder = order.getTotalOrder(user.getId());
        int totalPage = (int) Math.ceil((double) totalOrder/pageSize);
        int offset = (currPage-1)*pageSize;
        List<Order> orders = order.getOrdersByUserId(user.getId(),offset,pageSize);
        request.setAttribute("orders",orders);
        request.setAttribute("totalOrders",totalOrder);
        request.setAttribute("totalPages",totalPage);
        request.setAttribute("currentPageNumber",currPage);

        request.getRequestDispatcher("/account/order.jsp").forward(request,response);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        doGet(req,resp);
    }
}
