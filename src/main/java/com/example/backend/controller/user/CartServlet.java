package com.example.backend.controller.user;

import com.example.backend.dao.CartDAO;
import com.example.backend.model.Cart;
import com.example.backend.model.CartItem;
import com.example.backend.model.Product;
import com.example.backend.model.User;
import com.example.backend.service.ProductService;
import com.google.gson.JsonObject;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import org.checkerframework.checker.units.qual.C;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "CartServlet", value = "/cart")
public class CartServlet extends HttpServlet {
    private CartDAO cartDAO;
    private ProductService productService;

    @Override
    public void init() throws ServletException {
        cartDAO = new CartDAO();
        productService = new ProductService();
    }

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
                case "removeAjax":
                    removeAjax(request,response);
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


    private void updateAjax(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        JsonObject json = new JsonObject();

        try {
            int productId = Integer.parseInt(request.getParameter("productId"));
            int quantity = Integer.parseInt(request.getParameter("quantity"));

            HttpSession session = request.getSession();
            User user = (User) session.getAttribute("user");

            double rowTotal = 0;
            int totalCartQuantity = 0;

            if (user != null) {

                boolean isUpdated = cartDAO.updateCartItemQuantity(user.getId(), productId, quantity);
                if (isUpdated) {
                    List<CartItem> currentCart = cartDAO.getCartItemsByUserId(user.getId());
                    for (CartItem item : currentCart) {
                        totalCartQuantity += item.getQuantity();
                        if (item.getProduct().getId() == productId) {
                            rowTotal = item.getPrice() * item.getQuantity();
                        }
                    }
                    json.addProperty("success", true);
                    json.addProperty("newQuantity", quantity);
                    json.addProperty("rowTotal", rowTotal);
                    json.addProperty("totalCartQuantity", totalCartQuantity);
                } else {
                    json.addProperty("success", false);
                    json.addProperty("message", "Cập nhật Database thất bại");
                }
            } else {
                Cart cart = (Cart) session.getAttribute("cart");
                if (cart != null && cart.update(productId, quantity)) {
                    session.setAttribute("cart", cart);
                    for (CartItem item : cart.getItems()) {
                        if (item.getProduct().getId() == productId) {
                            rowTotal = item.getProduct().getPrice() * item.getQuantity();
                            break;
                        }
                    }
                    json.addProperty("success", true);
                    json.addProperty("newQuantity", quantity);
                    json.addProperty("rowTotal", rowTotal);
                    json.addProperty("totalCartQuantity", cart.getTotalQuantity());
                } else {
                    json.addProperty("success", false);
                    json.addProperty("message", "Sản phẩm không có trong giỏ");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            json.addProperty("success", false);
            json.addProperty("message", "Lỗi hệ thống");
        }
        response.getWriter().write(json.toString());
    }

    private void removeAjax(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        JsonObject json = new JsonObject();

        try {
            int productId = Integer.parseInt(request.getParameter("productId"));
            HttpSession session = request.getSession();
            User user = (User) session.getAttribute("user");

            int totalCartQuantity = 0;

            if (user != null) {
                cartDAO.deleteCartItem(user.getId(), productId);

                List<CartItem> currentCart = cartDAO.getCartItemsByUserId(user.getId());
                for (CartItem item : currentCart) {
                    totalCartQuantity += item.getQuantity();
                }
                json.addProperty("success", true);
                json.addProperty("totalCartQuantity", totalCartQuantity);
            } else {
                Cart cart = (Cart) session.getAttribute("cart");
                if (cart != null) {
                    cart.remove(productId);
                    session.setAttribute("cart", cart);
                    json.addProperty("success", true);
                    json.addProperty("totalCartQuantity", cart.getTotalQuantity());
                } else {
                    json.addProperty("success", false);
                    json.addProperty("message", "Giỏ hàng trống");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            json.addProperty("success", false);
            json.addProperty("message", "Lỗi hệ thống");
        }
        response.getWriter().write(json.toString());
    }

    private void viewCart(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user != null) {
            List<CartItem> dbCartItems = cartDAO.getCartItemsByUserId(user.getId());
            request.setAttribute("cartItems", dbCartItems);
        } else {
            Cart cart = (Cart) session.getAttribute("cart");
            if (cart != null) {
                request.setAttribute("cartItems", cart.getItems());
            } else {
                request.setAttribute("cartItems", new ArrayList<CartItem>());
            }
        }
        request.getRequestDispatcher("shopping-cart.jsp").forward(request, response);
    }

    private void removeFromCart(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int productId = Integer.parseInt(request.getParameter("productId"));
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user != null) {
            cartDAO.deleteCartItem(user.getId(), productId);
        } else {
            Cart cart = (Cart) session.getAttribute("cart");
            if (cart != null) {
                cart.remove(productId);
                session.setAttribute("cart", cart);
            }
        }
        response.sendRedirect("shopping-cart.jsp");
    }

    private void updateCart(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int productId = Integer.parseInt(request.getParameter("productId"));
        int quantity = Integer.parseInt(request.getParameter("quantity"));
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user != null) {
            cartDAO.updateCartItemQuantity(user.getId(), productId, quantity);
        } else {
            Cart cart = (Cart) session.getAttribute("cart");
            if (cart != null) {
                cart.update(productId, quantity);
                session.setAttribute("cart", cart);
            }
        }
        response.sendRedirect("shopping-cart.jsp");
    }


    private void addToCart(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            int productId = Integer.parseInt(request.getParameter("productId"));
            int quantity = Integer.parseInt(request.getParameter("quantity"));

            HttpSession session = request.getSession();
            User user = (User) session.getAttribute("user");
            Product product = productService.getProduct(productId);

            if (product == null) {
                request.setAttribute("msg", "Product not found");
                request.getRequestDispatcher("shopping-cart.jsp").forward(request, response);
                return;
            }

            if (user != null) {
                CartItem item = new CartItem(product, quantity, product.getPrice());
                cartDAO.saveOrUpdateCartItem(user.getId(), item);
            } else {
                Cart cart = (Cart) session.getAttribute("cart");
                if (cart == null) {
                    cart = new Cart();
                    session.setAttribute("cart", cart);
                }
                cart.add(product, quantity);
                session.setAttribute("cart", cart);
            }

            response.sendRedirect(request.getContextPath() + "/cart");

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