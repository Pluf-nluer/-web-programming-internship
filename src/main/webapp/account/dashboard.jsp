<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<c:if test="${empty sessionScope.user}">
    <c:redirect url="${pageContext.request.contextPath}/login" />
</c:if>
<jsp:useBean id="orderDao" class="com.example.backend.dao.OrderDao" scope="request" />
<c:set var="orders" value="${orderDao.getOrdersByUserId(sessionScope.user.id)}" />
<fmt:setLocale value="vi_VN" />
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/header.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/footer.css">
    <title>Tài Khoản - Bảng điều khiển</title>
</head>
<body>

<jsp:include page="/compenents/header.jsp" />

<main class="dashboard-main">
    <div class="dashboard-container">

        <jsp:include page="/compenents/sidebar.jsp" />

        <div class="dashboard-content">

            <div class="welcome-section">
                <div class="welcome-text">
                    <h1>Xin chào, <c:out value="${sessionScope.user.fullName}" />!</h1>
                    <p>Chào mừng bạn trở lại với cửa hàng đồ thủ công mỹ nghệ</p>
                </div>
                <div class="welcome-image">
                    <i class="fa-solid fa-hand-holding-heart"></i>
                </div>
            </div>


            <div class="stats-grid">
                <div class="stat-card card-orders">
                    <div class="stat-icon">
                        <i class="fa-solid fa-shopping-bag"></i>
                    </div>
                    <div class="stat-info">
                        <h3>${fn:length(orders)}</h3>
                        <p>Đơn hàng</p>
                    </div>
                    <div class="stat-decoration">
                        <i class="fa-solid fa-certificate"></i>
                    </div>
                </div>
            </div>


            <div class="section-container">
                <div class="section-header">
                    <h2>
                        <i class="fa-solid fa-clock-rotate-left"></i>
                        Đơn hàng gần đây
                    </h2>
                    <a href="${pageContext.request.contextPath}/account/order.jsp" class="view-all">Xem tất cả <i class="fa-solid fa-arrow-right"></i></a>
                </div>
                <div class="orders-list">
                    <c:if test="${empty orders}">
                        <div class="empty-state">
                            <i class="fa-solid fa-box-open"></i>
                            <p>Bạn chưa có đơn hàng nào</p>
                            <a href="${pageContext.request.contextPath}/products" class="btn-shop">Mua sắm ngay</a>
                        </div>
                    </c:if>
                    <c:forEach var="order" items="${orders}" end="2">
                        <c:url var="orderDetailUrl" value="/account/order-detail.jsp">
                            <c:param name="id" value="${order.id}" />
                        </c:url>
                        <div class="order-item">
                            <div class="order-info">
                                <h4>Đơn hàng #${order.id}</h4>
                                <p class="order-date">
                                    <i class="fa-regular fa-calendar"></i>
                                    Ngày đặt: <fmt:formatDate value="${order.created_at}" pattern="dd/MM/yyyy" />
                                </p>
                            </div>
                            <div class="order-status">
                                <span class="status-badge status-${order.statusClass}"><c:out value="${order.statusText}" /></span>
                                <p class="order-price"><fmt:formatNumber value="${order.total_amount}" type="currency" /></p>
                            </div>
                            <div class="order-actions">
                                <a href="${orderDetailUrl}" class="btn-detail">Chi tiết</a>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </div>
        </div>
    </div>
</main>


<jsp:include page="/compenents/footer.jsp" />
</body>
</html>
