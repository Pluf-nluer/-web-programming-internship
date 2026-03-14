<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.example.backend.model.User" %>
<%@ page import="com.example.backend.model.Order" %>
<%@ page import="com.example.backend.model.OrderItem" %>
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
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/order-detail.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/header.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/footer.css">
    <title>Chi tiết đơn hàng</title>
</head>
<body>
<jsp:include page="/compenents/header.jsp" />
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    String orderIdStr = request.getParameter("id");
    if (orderIdStr == null || orderIdStr.isEmpty()) {
        response.sendRedirect("order.jsp");
        return;
    }
    int orderId = Integer.parseInt(orderIdStr);
    OrderDao orderDao = new OrderDao();
    Order order = orderDao.getOrderById(orderId);
    if (order == null || order.getUser_id() != user.getId()) {
        response.sendRedirect("order.jsp");
        return;
    }
    List<OrderItem> orderItems = orderDao.getOrderItems(orderId);
    NumberFormat currencyFormat = NumberFormat.getCurrencyInstance(new Locale("vi", "VN"));
    SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy HH:mm");

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
                <div class="header-top">
                    <a href="${pageContext.request.contextPath}/account/order.jsp" class="btn-back">
                        <i class="fa-solid fa-arrow-left"></i>
                        <span>Quay lại danh sách</span>
                    </a>
                    <button class="btn-print" onclick="window.print()">
                        <i class="fa-solid fa-print"></i>
                        <span>In đơn hàng</span>
                    </button>
                </div>
                <div class="header-content">
                    <div class="header-info">
                        <h1>
                            <i class="fa-solid fa-file-invoice"></i>
                            Chi tiết đơn hàng
                        </h1>
                        <p class="order-code">
                            <i class="fa-solid fa-hashtag"></i>
                            <strong>#<%= order.getId() %></strong>
                        </p>
                    </div>
                    <span class="status-badge status-<%= statusClass %>"><%= statusText %></span>
                </div>
            </div>

            <div class="info-grid">
                <div class="info-card">
                    <div class="card-header">
                        <i class="fa-solid fa-calendar-check"></i>
                        <h3>Thông tin đơn hàng</h3>
                    </div>
                    <div class="info-content">
                        <div class="info-row">
                            <span class="info-label">Mã đơn hàng:</span>
                            <span class="info-value">#<%= order.getId() %></span>
                        </div>
                        <div class="info-row">
                            <span class="info-label">Ngày đặt hàng:</span>
                            <span class="info-value"><%= dateFormat.format(order.getCreated_at()) %></span>
                        </div>
                        <div class="info-row">
                            <span class="info-label">Trạng thái:</span>
                            <span class="status-badge status-<%= statusClass %>"><%= statusText %></span>
                        </div>
                    </div>
                </div>

                <div class="info-card">
                    <div class="card-header">
                        <i class="fa-solid fa-user"></i>
                        <h3>Thông tin người nhận</h3>
                    </div>
                    <div class="info-content">
                        <div class="info-row">
                            <span class="info-label">Họ và tên:</span>
                            <span class="info-value"><%= order.getShipping_name() %></span>
                        </div>
                        <div class="info-row">
                            <span class="info-label">Số điện thoại:</span>
                            <span class="info-value"><%= order.getShipping_phone() %></span>
                        </div>
                    </div>
                </div>

                <div class="info-card">
                    <div class="card-header">
                        <i class="fa-solid fa-location-dot"></i>
                        <h3>Địa chỉ giao hàng</h3>
                    </div>
                    <div class="info-content">
                        <p class="address-text"><%= order.getShipping_address() %></p>
                        <% if (order.getNote() != null && !order.getNote().isEmpty()) { %>
                        <div class="address-note">
                            <i class="fa-solid fa-note-sticky"></i>
                            <span>Ghi chú: <%= order.getNote() %></span>
                        </div>
                        <% } %>
                    </div>
                </div>

                <div class="info-card">
                    <div class="card-header">
                        <i class="fa-solid fa-credit-card"></i>
                        <h3>Phương thức thanh toán</h3>
                    </div>
                    <div class="info-content">
                        <div class="info-row">
                            <span class="info-label">Thanh toán:</span>
                            <span class="info-value">
                                <i class="fa-solid fa-money-bill-wave"></i>
                                Thanh toán khi nhận hàng (COD)
                            </span>
                        </div>
                    </div>
                </div>
            </div>

            <div class="products-section">
                <div class="section-header">
                    <h2>
                        <i class="fa-solid fa-bag-shopping"></i>
                        Sản phẩm trong đơn hàng
                    </h2>
                </div>
                <div class="products-list">
                    <% for (OrderItem item : orderItems) { %>
                    <div class="product-item">
                        <div class="product-image">
                            <img src="<%= item.getProduct().getImageUrl() %>" alt="<%= item.getProduct().getName() %>">
                        </div>
                        <div class="product-info">
                            <h4 class="product-name"><%= item.getProduct().getName() %></h4>
                            <div class="product-meta">
                                <span class="product-qty">x <%= item.getQuantity() %></span>
                            </div>
                        </div>
                        <div class="product-price-info">
                            <p class="product-price"><%= currencyFormat.format(item.getProduct().getPrice()) %></p>
                        </div>
                    </div>
                    <% } %>
                </div>
            </div>

            <div class="summary-section">
                <div class="section-header">
                    <h2>
                        <i class="fa-solid fa-receipt"></i>
                        Chi tiết thanh toán
                    </h2>
                </div>
                <div class="summary-content">
                    <div class="summary-row">
                        <span class="summary-label">Tạm tính:</span>
                        <span class="summary-value"><%= currencyFormat.format(order.getTotal_amount() - order.getShipping_fee()) %></span>
                    </div>
                    <div class="summary-row">
                        <span class="summary-label">Phí vận chuyển:</span>
                        <span class="summary-value"><%= currencyFormat.format(order.getShipping_fee()) %></span>
                    </div>
                    <div class="summary-divider"></div>
                    <div class="summary-row total">
                        <span class="summary-label">Tổng cộng:</span>
                        <span class="summary-value"><%= currencyFormat.format(order.getTotal_amount()) %></span>
                    </div>
                    <div class="payment-note">
                        <i class="fa-solid fa-circle-info"></i>
                        <span>Thanh toán khi nhận hàng</span>
                    </div>
                </div>
            </div>

            <div class="action-section">
                <a href="${pageContext.request.contextPath}/account/order.jsp" class="btn-secondary">
                    <i class="fa-solid fa-arrow-left"></i>
                    Quay lại
                </a>
                <a href="${pageContext.request.contextPath}/contact.jsp" class="btn-support">
                    <i class="fa-solid fa-headset"></i>
                    Liên hệ hỗ trợ
                </a>
            </div>
        </div>
    </div>
</main>

<jsp:include page="/compenents/footer.jsp" />
</body>
</html>
