package com.example.backend.controller.user;

import com.example.backend.dao.OrderDao;
import com.example.backend.model.*;
import com.example.backend.util.VnPayConfig;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.text.SimpleDateFormat;
import java.util.*;

@WebServlet(name = "CheckoutServlet", value = "/checkout")
public class CheckoutServlet extends HttpServlet {
    private static final String POST_LOGIN_REDIRECT_KEY = "postLoginRedirect";
    private static final String CHECKOUT_FORM_SESSION_KEY = "checkoutForm";
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            
            session.setAttribute(POST_LOGIN_REDIRECT_KEY, request.getContextPath() + "/checkout");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Cart cart = (Cart) session.getAttribute("cart");
        if (cart == null || cart.getTotalQuantity() == 0) {
            response.sendRedirect(request.getContextPath() + "/shopping-cart.jsp");
            return;
        }
        String[] selectedId = request.getParameterValues("selectedId");
        if(selectedId == null || selectedId.length == 0){
            response.sendRedirect(request.getContextPath()+"/shopping-cart.jsp");
            return;
        }
        List<CartItem> checkoutItems = new ArrayList<>();
        double totalCheckout = 0;
        for(String stringId: selectedId){
            for (CartItem item: cart.getItems()){
                if(String.valueOf(item.getProduct().getId()).equals(stringId)){
                    checkoutItems.add(item);
                    totalCheckout += (item.getProduct().getPrice()*item.getQuantity());
                    break;
                }
            }
        }
        session.setAttribute("checkoutItems", checkoutItems);
        session.setAttribute("totalCheckout" , totalCheckout);
        request.setAttribute("checkoutItems",checkoutItems);
        request.setAttribute("totalCheckout",totalCheckout);
        request.getRequestDispatcher("checkout.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession();
        Cart cart = (Cart) session.getAttribute("cart");
        List<CartItem> checkoutItems = (List<CartItem>) session.getAttribute("checkoutItems");
        Double totalCheckout = (Double) session.getAttribute("totalCheckout");
        if(cart == null || cart.getTotalQuantity() == 0) {
            response.sendRedirect(request.getContextPath() + "/shopping-cart.jsp");
            return;
        }

        
        String email = request.getParameter("email");
        String fullName = request.getParameter("fullname");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        String province = request.getParameter("province");
        String district = request.getParameter("district");
        String ward = request.getParameter("ward");
        String note = request.getParameter("note");
        String paymentMethod = request.getParameter("paymentMethod");
        cacheCheckoutForm(session, email, fullName, phone, address, province, district, ward, note);

        User user = (User) session.getAttribute("user");
        if(user ==null){
            session.setAttribute(POST_LOGIN_REDIRECT_KEY, request.getContextPath() + "/checkout");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String fullAddress = address;
        if (ward != null) fullAddress += ", " + ward;
        if (district != null) fullAddress += ", " + district;
        if (province != null) fullAddress += ", " + province;

        Order order = new Order();
        order.setUser_id(user.getId());
        order.setShipping_name(fullName);
        order.setShipping_phone(phone);
        order.setShipping_address(fullAddress);
        order.setShipping_fee(30000);
        order.setNote(note);
        order.setTotal_amount(totalCheckout + 30000);
        Cart tempCart = new Cart();
        tempCart.setItems(checkoutItems);
        OrderDao orderDao = new OrderDao();

        try {
            int orderId = orderDao.saveOrder(order, tempCart);


            if (orderId > 0) {
                if ("VnPay".equals(paymentMethod)) {
                    //
                    long amount = (long)((totalCheckout + 30000)*100);
                    String vnp_TxnRef = String.valueOf(orderId);
                    Map<String,String> vnp_Params = new HashMap<>();
                    vnp_Params.put("vnp_Version", "2.1.0");
                    vnp_Params.put("vnp_Command","pay");
                    vnp_Params.put("vnp_TmnCode", VnPayConfig.vnp_TmnCode);
                    vnp_Params.put("vnp_Amount",String.valueOf(amount));
                    vnp_Params.put("vnp_CurrCode","VND");
                    vnp_Params.put("vnp_TxnRef",vnp_TxnRef);
                    vnp_Params.put("vnp_OrderInfo","Thanh toan don hang: "+vnp_TxnRef);
                    vnp_Params.put("vnp_OrderType", "other");
                    vnp_Params.put("vnp_Locale","vn");
                    vnp_Params.put("vnp_ReturnUrl",VnPayConfig.vnp_ReturnUrl);
                    vnp_Params.put("vnp_IpAddr",VnPayConfig.getIpAddress(request));
                    // Tính toán ngày giờ
                    Calendar cl = Calendar.getInstance(TimeZone.getTimeZone("Etc/GMT+7"));
                    SimpleDateFormat format = new SimpleDateFormat("yyyyMMddHHmmss");
                    String vnp_CreateDate = format.format(cl.getTime());
                    vnp_Params.put("vnp_CreateDate", vnp_CreateDate);

                    cl.add(Calendar.MINUTE,15);
                    String vnp_ExpireDate = format.format(cl.getTime());
                    vnp_Params.put("vnp_ExpireDate",vnp_ExpireDate);

                    // xếp param và tạo chuỗi hash
                    List<String> fieldName = new ArrayList<>(vnp_Params.keySet());
                    Collections.sort(fieldName);
                    StringBuilder data = new StringBuilder();
                    StringBuilder query = new StringBuilder();
                    Iterator<String> iterator= fieldName.iterator();
                    while(iterator.hasNext()){
                        String fieldNames = iterator.next();
                        String fieldValue = vnp_Params.get(fieldNames);
                        if((fieldValue!=null)&&(fieldValue.length()>0)){
                            data.append(fieldNames).append('=').append(URLEncoder.encode(fieldValue, StandardCharsets.US_ASCII.toString()));
                            query.append(URLEncoder.encode(fieldNames,StandardCharsets.US_ASCII.toString())).append('=').append(URLEncoder.encode(fieldValue,StandardCharsets.US_ASCII.toString()));
                            if(iterator.hasNext()){
                                query.append('&');
                                data.append('&');
                            }
                        }
                    }

                    String queryUrl = query.toString();
                    String vnp_Secure = VnPayConfig.hmacSHA512(VnPayConfig.vnp_HashSecret, data.toString());
                    queryUrl += "&vnp_SecureHash=" + vnp_Secure;
                    String paymentUrl = VnPayConfig.vnp_PayUrl + "?" +queryUrl;

                    cart.getItems().removeAll(checkoutItems);
                    if(cart.getItems().isEmpty()){
                        session.removeAttribute("cart");
                    }
                    session.removeAttribute("checkoutItems");
                    session.removeAttribute("totalCheckout");
                    session.removeAttribute(CHECKOUT_FORM_SESSION_KEY);
                    response.sendRedirect(paymentUrl);

//                    request.setAttribute("Error", "VnPay");
//                    request.getRequestDispatcher("/checkout.jsp").forward(request, response);
                } else {

                    List<OrderItem> orderItems = orderDao.getOrderItems(orderId);
                    cart.getItems().removeAll(checkoutItems);
                    if (cart.getItems().isEmpty()) {
                        session.removeAttribute("cart");
                    }
                    session.removeAttribute("checkoutItems");
                    session.removeAttribute("totalCheckout");
                    session.removeAttribute(CHECKOUT_FORM_SESSION_KEY);

                    request.setAttribute("order", order);
                    request.setAttribute("orderId", orderId);
                    request.setAttribute("orderedItems", orderItems);
                    request.setAttribute("customerEmail", email);


                    request.getRequestDispatcher("/order-success.jsp").forward(request,response);
                    }
                }
            else{
                    request.setAttribute("ERROR", "Đặt hàng thất bại");
                    request.getRequestDispatcher("/checkout.jsp").forward(request,response);

                }

            } catch(Exception e){
                e.printStackTrace();
                request.setAttribute("ERROR", "Lỗi hệ thống: " + e.getMessage());
                request.getRequestDispatcher("/checkout.jsp").forward(request,response);

            }
    }

    private void cacheCheckoutForm(HttpSession session, String email, String fullName, String phone,
                                   String address, String province, String district, String ward, String note) {
        Map<String, String> formData = new HashMap<>();
        putIfPresent(formData, "email", email);
        putIfPresent(formData, "fullname", fullName);
        putIfPresent(formData, "phone", phone);
        putIfPresent(formData, "address", address);
        putIfPresent(formData, "province", province);
        putIfPresent(formData, "district", district);
        putIfPresent(formData, "ward", ward);
        putIfPresent(formData, "note", note);

        if (!formData.isEmpty()) {
            session.setAttribute(CHECKOUT_FORM_SESSION_KEY, formData);
        }
    }

    private void putIfPresent(Map<String, String> formData, String key, String value) {
        if (value != null) {
            String trimmed = value.trim();
            if (!trimmed.isEmpty()) {
                formData.put(key, trimmed);
            }
        }
    }
}