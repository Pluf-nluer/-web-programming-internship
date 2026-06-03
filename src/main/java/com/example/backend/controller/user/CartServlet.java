package com.example.backend.controller.user;

import com.example.backend.model.Cart;
import com.example.backend.model.CartItem;
import com.example.backend.model.Product;
import com.example.backend.service.ProductService;
import com.google.gson.JsonObject;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import org.checkerframework.checker.units.qual.C;

import java.io.IOException;

@WebServlet(name = "CartServlet", value = "/cart")
public class CartServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        if(action == null){
            action = "view"; 
        }

        try {
            switch (action){
            case "add":
                addToCart(request,response);
                break;
                case "update":
                    updateCart(request,response);
                    break;
                case "remove":
                    removeFromCart(request,response);
                    break;
                case "updateAjax":
                    updateAjax(request,response);
                    break;
                case "view":
                default:
                    viewCart(request,response);
                    break;
            }
        } catch (NumberFormatException e) {
            e.getStackTrace();
            response.sendRedirect("shopping-cart.jsp");
        }
    }

    private void updateAjax(HttpServletRequest request,HttpServletResponse response) throws ServletException,IOException{
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        JsonObject json = new JsonObject();
        try {
            int productId = Integer.parseInt(request.getParameter("productId"));
            int quantity = Integer.parseInt(request.getParameter("quantity"));
            HttpSession session = request.getSession();
            Cart cart = (Cart) session.getAttribute("cart");
            if(cart!=null){
                boolean isUpdate = cart.update(productId,quantity);
                if(isUpdate){
                    session.setAttribute("cart",cart);
                    double total = 0;
                    for (CartItem item: cart.getItems()){
                        if(item.getProduct().getId() == productId){
                            total+= item.getProduct().getPrice() * item.getQuantity();
                            break;
                        }
                    }
                    // đóng dữ liệu trả về jsp
                    json.addProperty("success",true);
                    json.addProperty("newQuantity",quantity);
                    json.addProperty("rowTotal",total);
                    json.addProperty("totalCartQuantity",cart.getTotalQuantity());
                }else{
                    json.addProperty("success",false);
                    json.addProperty("message","Sản phẩm không có trong giỏ");
                }
            }else{
                json.addProperty("success",false);
                json.addProperty("message","Giỏ hàng trống");
            }
        }catch (Exception e){
            e.printStackTrace();
            json.addProperty("success", false);
            json.addProperty("message", "Lỗi hệ thống");
        }
        response.getWriter().write(json.toString());
    }
    private void viewCart(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("shopping-cart.jsp").forward(request,response);
    }

    private void removeFromCart(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int productId = Integer.parseInt(request.getParameter("productId"));

        HttpSession session = request.getSession();
        Cart cart=(Cart) session.getAttribute("cart");

        
        if(cart != null){
            cart.remove(productId);
            session.setAttribute("cart",cart);
        }

        response.sendRedirect("shopping-cart.jsp");

    }

    private void updateCart(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int productId = Integer.parseInt(request.getParameter("productId"));
        int quantity = Integer.parseInt(request.getParameter("quantity"));

        HttpSession session = request.getSession();
        Cart cart = (Cart) session.getAttribute("cart");

        
        if(cart!=null){
            cart.update(productId,quantity);
            session.setAttribute("cart",cart);
        }

        response.sendRedirect("shopping-cart.jsp");

    }


    private void addToCart(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            int productId = Integer.parseInt(request.getParameter("productId"));
            int quantity = Integer.parseInt(request.getParameter("quantity"));

            HttpSession session = request.getSession();
            Cart cart = (Cart) session.getAttribute("cart");

            
            if (cart == null) {
                cart = new Cart();
                session.setAttribute("cart",cart);
            }

            ProductService productService = new ProductService();
            Product product = productService.getProduct(productId);

            if (product != null) {
                cart.add(product, quantity);
                session.setAttribute("cart", cart);
                response.sendRedirect("shopping-cart.jsp");
                return;
            }

            request.setAttribute("msg", "Product not found");
            request.getRequestDispatcher("shopping-cart.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            
            e.printStackTrace();
            response.sendRedirect("products.jsp");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("shopping-cart.jsp");
        }
    }
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request,response);
    }
}