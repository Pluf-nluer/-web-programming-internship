<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<c:if test="${empty sessionScope.user}">
    <c:redirect url="${pageContext.request.contextPath}/login" />
</c:if>
<jsp:useBean id="orderDao" class="com.example.backend.dao.OrderDao" scope="request" />
<c:set var="orders" value="${orderDao.getOrdersByUserId(sessionScope.user.id)}" />
<c:set var="message" value="${sessionScope.message}" />
<c:set var="messageType" value="${sessionScope.messageType}" />
<c:remove var="message" scope="session" />
<c:remove var="messageType" scope="session" />
<fmt:setLocale value="vi_VN" />
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

<c:if test="${not empty message}">
    <div id="toast" class="toast-notification toast-${messageType}">
        <c:out value="${message}" />
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
</c:if>
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
                    <p class="orders-count">Tổng: <strong>${fn:length(orders)} đơn hàng</strong></p>
                </div>

                <div class="orders-list">
                    <c:if test="${empty orders}">
                        <div class="empty-state">
                            <i class="fa-solid fa-box-open"></i>
                            <h3>Bạn chưa có đơn hàng</h3>
                            <p>Hãy bắt đầu mua sắm để tạo đơn hàng mới.</p>
                            <a href="${pageContext.request.contextPath}/products.jsp" class="btn-shop">Mua sắm ngay</a>
                        </div>
                    </c:if>

                    <c:forEach var="order" items="${orders}">
                        <c:url var="reviewUrl" value="/order-review">
                            <c:param name="orderId" value="${order.id}" />
                        </c:url>
                        <c:url var="orderDetailUrl" value="/account/order-detail.jsp">
                            <c:param name="id" value="${order.id}" />
                        </c:url>

                        <div class="order-card" data-status="${order.statusClass}">
                            <div class="order-header">
                                <div class="order-id-date">
                                    <p class="order-code">
                                        <i class="fa-solid fa-hashtag"></i>
                                        #${order.id}
                                    </p>
                                    <p class="order-date">
                                        <i class="fa-regular fa-calendar"></i>
                                        Ngày đặt: <fmt:formatDate value="${order.created_at}" pattern="dd/MM/yyyy" />
                                    </p>
                                </div>
                                <span class="status-badge status-${order.statusClass}"><c:out value="${order.statusText}" /></span>
                            </div>

                            <div class="order-footer">
                                <div class="order-total">
                                    <span class="total-label">Tổng tiền:</span>
                                    <span class="total-amount"><fmt:formatNumber value="${order.total_amount}" type="currency" /></span>
                                </div>
                                <div class="order-actions">
                                    <c:if test="${order.statusClass == 'completed'}">
                                        <a href="${reviewUrl}" class="btn-action btn-detail">
                                            Đánh giá
                                        </a>
                                    </c:if>
                                    <a href="${orderDetailUrl}" class="btn-action btn-detail">
                                        <i class="fa-solid fa-eye"></i>
                                        Xem chi tiết
                                    </a>
                                    <c:if test="${order.statusClass == 'pending'}">
                                        <button onclick="confirmCancel(${order.id})" class="btn-action btn-cancel">
                                            <i class="fa-solid fa-times"></i>
                                            Hủy đơn
                                        </button>
                                    </c:if>
                                    <c:if test="${order.statusClass == 'completed'}">
                                        <a href="${pageContext.request.contextPath}/shopping-cart.jsp" class="btn-action btn-rebuy">
                                            <i class="fa-solid fa-refresh"></i>
                                            Mua lại
                                        </a>
                                    </c:if>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
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
