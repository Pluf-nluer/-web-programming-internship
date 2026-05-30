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
        response.sendRedirect(request.getContextPath() + "/login");
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
        <jsp:include page="/compenents/sidebar.jsp" />

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
                            Chi tiết hóa đơn
                        </h1>
                        <p class="order-code">
                            <i class="fa-solid fa-hashtag"></i>
                            <strong><%= order.getId() %></strong>
                        </p>
                    </div>
                    <span class="status-badge status-<%= statusClass %>"><%= statusText %></span>
                </div>
            </div>

            <div class="invoice-document">
                <div class="invoice-data-grid">
                    <section class="invoice-data-card">
                        <h3><i class="fa-solid fa-calendar-check"></i> Thông tin hóa đơn</h3>
                        <div class="invoice-data-row">
                            <span>Mã hóa đơn</span>
                            <strong>#<%= order.getId() %></strong>
                        </div>
                        <div class="invoice-data-row">
                            <span>Ngày đặt</span>
                            <strong><%= dateFormat.format(order.getCreated_at()) %></strong>
                        </div>
                        <div class="invoice-data-row">
                            <span>Phương thức</span>
                            <strong>Thanh toán khi nhận hàng</strong>
                        </div>
                    </section>

                    <section class="invoice-data-card">
                        <h3><i class="fa-solid fa-truck"></i> Người nhận</h3>
                        <div class="invoice-data-row">
                            <span>Họ tên</span>
                            <strong><%= order.getShipping_name() %></strong>
                        </div>
                        <div class="invoice-data-row">
                            <span>Số điện thoại</span>
                            <strong><%= order.getShipping_phone() %></strong>
                        </div>
                        <div class="invoice-data-row invoice-address-row">
                            <span>Địa chỉ</span>
                            <strong><%= order.getShipping_address() %></strong>
                        </div>
                    </section>
                </div>

                <div class="invoice-table-section">
                    <div class="section-header">
                        <h2>
                            <i class="fa-solid fa-table-list"></i>
                            Dữ liệu sản phẩm
                        </h2>
                    </div>
                    <div class="invoice-table-wrapper">
                        <table class="invoice-table">
                            <thead>
                            <tr>
                                <th>STT</th>
                                <th>Sản phẩm</th>
                                <th>Đơn giá</th>
                                <th>SL</th>
                                <th>Thành tiền</th>
                            </tr>
                            </thead>
                            <tbody>
                            <%
                                int rowIndex = 1;
                                for (OrderItem item : orderItems) {
                            %>
                            <tr>
                                <td class="invoice-index"><%= rowIndex++ %></td>
                                <td>
                                    <div class="invoice-product">
                                        <img src="<%= item.getProduct().getImageUrl() %>" alt="<%= item.getProduct().getName() %>">
                                        <div>
                                            <strong><%= item.getProduct().getName() %></strong>
                                            <span>SP-<%= item.getProduct().getId() %></span>
                                        </div>
                                    </div>
                                </td>
                                <td><%= currencyFormat.format(item.getProduct().getPrice()) %></td>
                                <td><%= item.getQuantity() %></td>
                                <td class="invoice-line-total"><%= currencyFormat.format(item.getTotalPrice()) %></td>
                            </tr>
                            <% } %>
                            </tbody>
                        </table>
                    </div>
                </div>

                <div class="invoice-footer-grid">
                    <div class="invoice-note-box">
                        <h3><i class="fa-solid fa-note-sticky"></i> Ghi chú hóa đơn</h3>
                        <% if (order.getNote() != null && !order.getNote().isEmpty()) { %>
                        <p><%= order.getNote() %></p>
                        <% } else { %>
                        <p>Không có ghi chú thêm cho đơn hàng này.</p>
                        <% } %>
                        <span>Khách hàng thanh toán khi nhận hàng. Vui lòng kiểm tra sản phẩm trước khi hoàn tất thanh toán.</span>
                    </div>

                    <div class="summary-content invoice-summary">
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
                            <span class="summary-label">Tổng thanh toán:</span>
                            <span class="summary-value"><%= currencyFormat.format(order.getTotal_amount()) %></span>
                        </div>
                        <div class="payment-note">
                            <i class="fa-solid fa-circle-info"></i>
                            <span>Thanh toán khi nhận hàng</span>
                        </div>
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