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
        .orders-container .pagination-area {
            display: flex;
            justify-content: center;
            margin-top: 30px;
            margin-bottom: 20px;
            width: 100%;
        }

        .orders-container .pagination {
            display: flex;
            flex-direction: row;
            list-style: none !important;
            gap: 5px;
            padding: 0;
            margin: 0;
        }

        .orders-container .page-item .page-link {
            display: flex;
            align-items: center;
            justify-content: center;
            min-width: 36px;
            height: 36px;
            padding: 0 12px;
            border: 1px solid #ddd;
            color: #333;
            text-decoration: none !important;
            border-radius: 6px;
            font-size: 14px;
            font-weight: 500;
            transition: all 0.3s ease;
        }

        .orders-container .page-item.active .page-link {
            background-color: #8b572a;
            color: white;
            border-color: #8b572a;
        }

        .orders-container .page-item.disabled .page-link {
            border: none;
            background: transparent;
            cursor: default;
            color: #999;
        }

        .orders-container .page-item:hover:not(.active):not(.disabled) .page-link {
            background-color: #f5f5f5;
            color: #c97a3a;
            border-color: #c97a3a;
        }
    </style>
</head>
<body>
<jsp:include page="/compenents/header.jsp" />

<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }


    List<Order> orders = (List<Order>) request.getAttribute("orders");
    Integer totalOrder = (Integer) request.getAttribute("totalOrders");
    Integer totalPage = (Integer) request.getAttribute("totalPages");
    Integer currPage = (Integer) request.getAttribute("currentPageNumber");
    NumberFormat currencyFormat = NumberFormat.getCurrencyInstance(new Locale("vi", "VN"));
    SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");

    if (orders == null) {
        response.sendRedirect(request.getContextPath() + "/user-orders");
        return;
    }
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
        <jsp:include page="/compenents/sidebar.jsp" />

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
                    <p class="orders-count">Tổng: <strong><%= totalOrder %> đơn hàng</strong></p>
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
                                    <a href="order-review?id=<%= order.getId() %>" class="btn-action btn-detail">
                                        Đánh giá
                                    </a>
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
                <% if (totalPage != null && totalPage > 1) { %>
                <div class="pagination-area">
                    <nav aria-label="Page navigation">
                        <ul class="pagination">
                            <% if (currPage > 1) { %>
                            <li class="page-item">
                                <a class="page-link" href="${pageContext.request.contextPath}/user-orders?page=<%= currPage - 1 %>">&laquo;</a>
                            </li>
                            <% } %>

                            <% for (int i = 1; i <= totalPage; i++) {
                                if (i == 1 || i == totalPage || (i >= currPage - 2 && i <= currPage + 2)) {
                            %>
                            <li class="page-item <%= (currPage == i) ? "active" : "" %>">
                                <a class="page-link" href="${pageContext.request.contextPath}/user-orders?page=<%= i %>"><%= i %></a>
                            </li>
                            <%  } else if (i == currPage - 3 || i == currPage + 3) { %>
                            <li class="page-item disabled"><span class="page-link">...</span></li>
                            <%  }
                            } %>

                            <% if (currPage < totalPage) { %>
                            <li class="page-item">
                                <a class="page-link" href="${pageContext.request.contextPath}/user-orders?page=<%= currPage + 1 %>">&raquo;</a>
                            </li>
                            <% } %>
                        </ul>
                    </nav>
                </div>
                <% } %>
            </div>
        </div>
    </div>
</main>

<form id="cancelOrderForm" action="${pageContext.request.contextPath}/cancel-order" method="post" style="display: none;">
    <input type="hidden" name="orderId" id="cancelOrderId">
    <input type="hidden" name="page" value="<%= currPage != null ? currPage : 1 %>">
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
