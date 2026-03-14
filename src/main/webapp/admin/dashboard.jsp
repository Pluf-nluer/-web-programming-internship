<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Bảng điều khiển</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/admin/css/admin-dashboard.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/admin/css/admin-home.css">
</head>
<body>
<main class="admin-dashboard-main">
    <div class="admin-dashboard-container">
        <jsp:include page="/admin/components/sidebar.jsp">
            <jsp:param name="active" value="dashboard" />
        </jsp:include>

        <div class="admin-content">
            <div class="page-header">
                <div class="header-left">
                    <h1>Tổng quan hệ thống</h1>
                    <p>Theo dõi nhanh tình trạng cửa hàng</p>
                </div>
                <div class="header-right">
                    <a href="${pageContext.request.contextPath}/" class="btn btn-secondary">
                        <i class="fa-solid fa-globe"></i> Website
                    </a>
                    <a href="${pageContext.request.contextPath}/admin/products?action=new" class="btn btn-primary">
                        <i class="fa-solid fa-plus"></i> Thêm sản phẩm
                    </a>
                </div>
            </div>

            <section class="stats-grid">
                <div class="stat-card">
                    <div class="stat-header">
                        <div class="stat-icon info"><i class="fa-solid fa-boxes-stacked"></i></div>
                        <span class="badge info">Sản phẩm</span>
                    </div>
                    <div class="stat-value">${totalProducts}</div>
                    <div class="stat-label">Tổng số sản phẩm</div>
                    <div class="stat-meta">Cập nhật gần nhất: hôm nay</div>
                </div>

                <div class="stat-card">
                    <div class="stat-header">
                        <div class="stat-icon"><i class="fa-solid fa-cart-shopping"></i></div>
                        <span class="badge info">Đơn hàng</span>
                    </div>
                    <div class="stat-value">${ordersToday}</div>
                    <div class="stat-label">Đơn hàng hôm nay</div>
                    <div class="stat-meta">Chưa có dữ liệu đồng bộ</div>
                </div>

                <div class="stat-card">
                    <div class="stat-header">
                        <div class="stat-icon warning"><i class="fa-solid fa-clock"></i></div>
                        <span class="badge warning">Chờ xử lý</span>
                    </div>
                    <div class="stat-value">${pendingOrders}</div>
                    <div class="stat-label">Đơn chờ xác nhận</div>
                    <div class="stat-meta">Theo dõi trạng thái mới</div>
                </div>

                <div class="stat-card">
                    <div class="stat-header">
                        <div class="stat-icon success"><i class="fa-solid fa-sack-dollar"></i></div>
                        <span class="badge success">Doanh thu</span>
                    </div>
                    <div class="stat-value"><fmt:formatNumber value="${monthlyRevenue}" type="currency" currencySymbol="đ" /></div>
                    <div class="stat-label">Doanh thu tháng</div>
                    <div class="stat-meta">Chưa có báo cáo</div>
                </div>
            </section>

            <section class="dashboard-panels">
                <div class="panel">
                    <div class="panel-header">
                        <h2>Hoạt động gần đây</h2>
                        <a href="${pageContext.request.contextPath}/admin/products" class="btn btn-ghost">
                            Xem sản phẩm
                        </a>
                    </div>
                    <div class="activity-list">
                        <c:forEach var="order" items="${recentOrders}">
                            <div class="activity-item">
                                <div>
                                    <p class="activity-title">Đơn hàng #${order.id} - ${order.shipping_name}</p>
                                    <span class="activity-time">
                        <fmt:formatDate value="${order.created_at}" pattern="dd/MM/yyyy HH:mm"/>
                    </span>
                                </div>
                                <c:choose>
                                    <c:when test="${order.order_status == 'pending'}">
                                        <span class="badge warning">Chờ xử lý</span>
                                    </c:when>
                                    <c:when test="${order.order_status == 'completed'}">
                                        <span class="badge success">Hoàn tất</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge info">${order.order_status}</span>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </c:forEach>

                        <c:if test="${empty recentOrders}">
                            <div class="activity-item">
                                <p class="activity-title">Chưa có đơn hàng nào mới</p>
                            </div>
                        </c:if>
                    </div>
                </div>

                <div class="panel">
                    <div class="panel-header">
                        <h2>Lối tắt</h2>
                    </div>
                    <div class="action-grid">
                        <a class="action-card" href="${pageContext.request.contextPath}/admin/products?action=new">
                            <i class="fa-solid fa-plus"></i>
                            <strong>Thêm sản phẩm</strong>
                            <span>Tạo sản phẩm mới</span>
                        </a>
                        <a class="action-card" href="${pageContext.request.contextPath}/admin/orders/order-list.jsp">
                            <i class="fa-solid fa-shopping-cart"></i>
                            <strong>Danh sách đơn hàng</strong>
                            <span>Theo dõi giao dịch</span>
                        </a>
                        <a class="action-card" href="${pageContext.request.contextPath}/admin/products">
                            <i class="fa-solid fa-box"></i>
                            <strong>Danh sách sản phẩm</strong>
                            <span>Quản lý hàng hóa</span>
                        </a>
                        <a class="action-card" href="${pageContext.request.contextPath}/admin/customers">
                            <i class="fa-solid fa-users"></i>
                            <strong>Danh sách khách hàng</strong>
                            <span>Quay lại khách hàng</span>
                        </a>
                    </div>
                </div>
            </section>
        </div>
    </div>
</main>
</body>
</html>
