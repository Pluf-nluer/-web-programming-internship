<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.example.backend.model.User" %>
<%@ page import="com.example.backend.model.Order" %>
<%@ page import="com.example.backend.dao.OrderDao" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>
<%@ page import="java.text.SimpleDateFormat" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/orders.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/header.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/footer.css">
    <title>Đơn hàng của tôi</title>
    <style>
        .toast-notification {
            position: fixed;
            top: 20px;
            right: 20px;
            padding: 15px 25px;
            border-radius: 8px;
            color: white;
            font-weight: 600;
            z-index: 1000;
            opacity: 0;
            transform: translateY(-20px);
            transition: all 0.3s ease;
            box-shadow: 0 4px 12px rgba(0,0,0,0.15);
        }

        .toast-notification.show {
            opacity: 1;
            transform: translateY(0);
        }

        .toast-success {
            background-color: #2ecc71;
        }

        .toast-error {
            background-color: #e74c3c;
        }
    </style>
</head>
<body>
<jsp:include page="/compenents/header.jsp" />

<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    OrderDao orderDao = new OrderDao();
    List<Order> orders = orderDao.getOrdersByUserId(user.getId());
    NumberFormat currencyFormat = NumberFormat.getCurrencyInstance(new Locale("vi", "VN"));
    SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");

    String message = (String) session.getAttribute("message");
    String messageType = (String) session.getAttribute("messageType");
    if (message != null) {
        session.removeAttribute("message");
        session.removeAttribute("messageType");
    }
%>

<% if (message != null) { %>
    <div id="toast" class="toast-notification toast-<%= messageType %>">
        <%= message %>
    </div>
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const toast = document.getElementById('toast');
            toast.classList.add('show');
            setTimeout(() => {
                toast.classList.remove('show');
            }, 3000);
        });
    </script>
<% } %>
<main class="dashboard-main">
    <div class="dashboard-container">
        <aside class="dashboard-sidebar">
            <div class="sidebar-header">
                <div class="user-avatar">
                    <i class="fa-solid fa-user"></i>
                </div>
                <h3>${sessionScope.user.fullName}</h3>
                <p>${sessionScope.user.email}</p>
            </div>

            <nav class="sidebar-menu">
                <a href="${pageContext.request.contextPath}/account/dashboard.jsp" class="menu-item">
                    <i class="fa-solid fa-gauge"></i>
                    <span>Bảng điều khiển</span>
                </a>
                <a href="${pageContext.request.contextPath}/account/order.jsp" class="menu-item active">
                    <i class="fa-solid fa-box"></i>
                    <span>Đơn hàng</span>
                </a>
                <a href="${pageContext.request.contextPath}/account/account-profile.jsp" class="menu-item">
                    <i class="fa-solid fa-user-circle"></i>
                    <span>Thông tin</span>
                </a>
                <a href="${pageContext.request.contextPath}/change-password" class="menu-item">
                    <i class="fa-solid fa-key"></i>
                    <span>Đổi mật khẩu</span>
                </a>
                <a href="${pageContext.request.contextPath}/logout" class="menu-item logout">
                    <i class="fa-solid fa-right-from-bracket"></i>
                    <span>Đăng xuất</span>
                </a>
            </nav>

            <div class="sidebar-decoration">
                <div class="pattern-circle"></div>
                <div class="pattern-circle"></div>
                <div class="pattern-circle"></div>
            </div>
        </aside>

        <div class="dashboard-content">
            <div class="page-header">
                <h1>
                    <i class="fa-solid fa-box"></i>
                    Đơn hàng của tôi
                </h1>
                <p>Quản lý và theo dõi đơn hàng của bạn</p>
            </div>
            <input type="radio" name="status-filter" id="filter-all" checked>
            <input type="radio" name="status-filter" id="filter-pending">
            <input type="radio" name="status-filter" id="filter-shipping">
            <input type="radio" name="status-filter" id="filter-completed">
            <input type="radio" name="status-filter" id="filter-cancelled">
            <div class="filter-section">
                <div class="filter-tabs">
                    <label for="filter-all" class="filter-label">
                        <i class="fa-solid fa-list"></i>
                        Tất cả
                    </label>

                    <label for="filter-pending" class="filter-label">
                        <i class="fa-solid fa-clock"></i>
                        Chờ xác nhận
                    </label>

                    <label for="filter-shipping" class="filter-label">
                        <i class="fa-solid fa-truck"></i>
                        Đang giao
                    </label>

                    <label for="filter-completed" class="filter-label">
                        <i class="fa-solid fa-check-circle"></i>
                        Hoàn thành
                    </label>

                    <label for="filter-cancelled" class="filter-label">
                        <i class="fa-solid fa-times-circle"></i>
                        Đã hủy
                    </label>
                </div>
            </div>

            <div class="orders-container">
                <div class="orders-header">
                    <h2>Danh sách đơn hàng</h2>
                    <p class="orders-count">Tổng: <strong><%= orders.size() %> đơn hàng</strong></p>
                </div>

                <div class="orders-list">
                    <% if (orders == null || orders.isEmpty()) { %>
                        <div class="empty-state">
                            <i class="fa-solid fa-box-open"></i>
                            <h3>Bạn chưa có đơn hàng</h3>
                            <p>Hãy bắt đầu mua sắm để tạo đơn hàng mới.</p>
                            <a href="${pageContext.request.contextPath}/products.jsp" class="btn-shop">Mua sắm ngay</a>
                        </div>
                    <% } else { %>
                        <% for (Order order : orders) {
                            String statusClass = "";
                            String statusText = order.getOrder_status();
                            if ("Pending".equalsIgnoreCase(statusText)) {
                                statusClass = "pending";
                                statusText = "Chờ xác nhận";
                            } else if ("Shipping".equalsIgnoreCase(statusText)) {
                                statusClass = "shipping";
                                statusText = "Đang giao";
                            } else if ("Completed".equalsIgnoreCase(statusText)) {
                                statusClass = "completed";
                                statusText = "Hoàn thành";
                            } else if ("Cancelled".equalsIgnoreCase(statusText)) {
                                statusClass = "cancelled";
                                statusText = "Đã hủy";
                            }
                        %>
                        <div class="order-card" data-status="<%= statusClass %>">
                            <div class="order-header">
                                <div class="order-id-date">
                                    <p class="order-code">
                                        <i class="fa-solid fa-hashtag"></i>
                                        #<%= order.getId() %>
                                    </p>
                                    <p class="order-date">
                                        <i class="fa-regular fa-calendar"></i>
                                        Ngày đặt: <%= dateFormat.format(order.getCreated_at()) %>
                                    </p>
                                </div>
                                <span class="status-badge status-<%= statusClass %>"><%= statusText %></span>
                            </div>

                            <div class="order-footer">
                                <div class="order-total">
                                    <span class="total-label">Tổng tiền:</span>
                                    <span class="total-amount"><%= currencyFormat.format(order.getTotal_amount()) %></span>
                                </div>
                                <div class="order-actions">
                                    <a href="order-detail.jsp?id=<%= order.getId() %>" class="btn-action btn-detail">
                                        <i class="fa-solid fa-eye"></i>
                                        Xem chi tiết
                                    </a>
                                    <% if ("Pending".equalsIgnoreCase(order.getOrder_status())) { %>
                                        <button onclick="confirmCancel(<%= order.getId() %>)" class="btn-action btn-cancel">
                                            <i class="fa-solid fa-times"></i>
                                            Hủy đơn
                                        </button>
                                    <% } else if ("Completed".equalsIgnoreCase(order.getOrder_status())) { %>
                                        <a href="${pageContext.request.contextPath}/shopping-cart.jsp" class="btn-action btn-rebuy">
                                            <i class="fa-solid fa-refresh"></i>
                                            Mua lại
                                        </a>
                                    <% } %>
                                </div>
                            </div>
                        </div>
                        <% } %>
                    <% } %>
                </div>
            </div>
        </div>
    </div>
</main>

<form id="cancelOrderForm" action="${pageContext.request.contextPath}/cancel-order" method="post" style="display: none;">
    <input type="hidden" name="orderId" id="cancelOrderId">
</form>

<script>
    function confirmCancel(orderId) {
        if (confirm('Bạn có chắc chắn muốn hủy đơn hàng này không?')) {
            document.getElementById('cancelOrderId').value = orderId;
            document.getElementById('cancelOrderForm').submit();
        }
    }
</script>
<jsp:include page="/compenents/footer.jsp" />
</body>
</html>
