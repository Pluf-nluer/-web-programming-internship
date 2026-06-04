package com.example.backend.controller.user;
import com.example.backend.dao.OrderDao;
import com.example.backend.model.Cart;
import com.example.backend.model.CartItem;
import com.example.backend.model.Order;
import com.example.backend.model.OrderItem;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet("/vnpay-return")
public class VnPayReturnServlet extends  HttpServlet{
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String vnPayRespone = request.getParameter("vnp_ResponseCode");
        if("00".equals(vnPayRespone)){
            String txnRef = request.getParameter("vnp_TxnRef");
            String amountStr = request.getParameter("vnp_Amount");
            String orderInfo = request.getParameter("vnp_OrderInfo");
            String bankCode = request.getParameter("vnp_BankCode");

            long amount = 0;
            if(amountStr!=null){
                amount = Long.parseLong(amountStr)/100;
            }
            try{
                OrderDao orderDao = new OrderDao();
                int orderId = Integer.parseInt(txnRef);
                Order order = orderDao.getOrderById(orderId);
                List<OrderItem> orderItems = orderDao.getOrderItems(orderId);
                orderDao.updateOrderStatus(orderId, "Đã thanh toán bằng VnPay");
                request.setAttribute("order",order);
                request.setAttribute("orderedItems",orderItems);

            } catch (Exception e) {
                e.printStackTrace();
            }

            request.setAttribute("orderId", txnRef);
            request.setAttribute("totalAmount",amount);
            request.setAttribute("paymentMethod","VnPay("+ bankCode+ ")");
            request.setAttribute("orderInfo",orderInfo);

            HttpSession session = request.getSession();
            Cart cart = (Cart) session.getAttribute("cart");
            List<CartItem> checkoutItems = (List<CartItem>) session.getAttribute("checkoutItems");
            if(cart != null && checkoutItems !=null){
                for (CartItem item: checkoutItems){
                    cart.remove(item.getProduct().getId());
                }
                if(cart.getItems().isEmpty()){
                    session.removeAttribute("cart");
                }else{
                    session.setAttribute("cart",cart);
                }
            }
            session.removeAttribute("checkoutItems");
            session.removeAttribute("totalCheckout");

            request.getRequestDispatcher("order-success.jsp").forward(request,response);
        }else{
            response.sendRedirect("shopping-cart.jsp");
        }
    }
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request,response);
    }
}
