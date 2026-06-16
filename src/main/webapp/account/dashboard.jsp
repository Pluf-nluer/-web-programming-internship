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
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/header.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/footer.css">
    <title>Tài Khoản - Bảng điều khiển</title>
</head>
<body>

<jsp:include page="/compenents/header.jsp" />

<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }

    OrderDao orderDao = new OrderDao();
    List<Order> orders = orderDao.getOrdersByUserId(user.getId());
    int totalOrders = orders.size();

    List<Order> recentOrders = orders.size() > 3 ? orders.subList(0, 3) : orders;

    NumberFormat currencyFormat = NumberFormat.getCurrencyInstance(new Locale("vi", "VN"));
    SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");
%>
<main class="dashboard-main">
    <div class="dashboard-container">

        <jsp:include page="/compenents/sidebar.jsp" />

        <div class="dashboard-content">
            
            <div class="welcome-section">
                <div class="welcome-text">
                    <h1>Xin chào, ${sessionScope.user.fullName}!</h1>
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
                        <h3><%= totalOrders %></h3>
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
                    <% if (recentOrders == null || recentOrders.isEmpty()) { %>
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
