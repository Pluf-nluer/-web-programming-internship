package com.example.backend.controller.user;
import com.example.backend.dao.OrderDao;
import com.example.backend.model.Cart;
import com.example.backend.model.CartItem;
import com.example.backend.model.Order;
import com.example.backend.model.OrderItem;
import com.example.backend.util.VnPayConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.*;

@WebServlet("/vnpay-return")
public class VnPayReturnServlet extends  HttpServlet{
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Map<String,String> field = new HashMap<>();
        for(Enumeration<String> params = request.getParameterNames(); params.hasMoreElements();){
            String filedName = params.nextElement();
            String filedValue = request.getParameter(filedName);
            if((filedValue!=null)&&(filedValue.length()>0)){
                field.put(filedName,filedValue);
            }
        }
        String vnp_SecureHash = request.getParameter("vnp_SecureHash");
        if(field.containsKey("vnp_SecureHashType")){
            field.remove("vnp_SecureHashType");
        }
        if(field.containsKey("vnp_SecureHash")){
            field.remove("vnp_SecureHash");
        }

        List<String> fieldNames = new ArrayList<>(field.keySet());
        Collections.sort(fieldNames);
        StringBuilder br = new StringBuilder();
        Iterator<String> itr = fieldNames.iterator();
        while(itr.hasNext()){
            String fieldName = itr.next();
            String fieldValue =field.get(fieldName);
            if((fieldValue!=null)&& (fieldValue.length()>0)){
                br.append(fieldName);
                br.append('=');
                br.append(URLEncoder.encode(fieldValue, StandardCharsets.US_ASCII));
                if(itr.hasNext()){
                    br.append('&');
                }
            }
        }

        String signValue = VnPayConfig.hmacSHA512(VnPayConfig.vnp_HashSecret,br.toString());

        if(signValue.equals(vnp_SecureHash)){
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
        }}else{
            System.out.println("Chữ ký VnPay không hợp lệ");
            response.sendRedirect("shopping-cart.jsp?error=invalid_signature");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request,response);
    }
}
