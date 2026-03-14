<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chi tiết khách hàng</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/admin/css/admin-dashboard.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/admin/css/customers-detail.css">
</head>
<body>
<main class="admin-dashboard-main">
    <div class="admin-dashboard-container">
        <jsp:include page="/admin/components/sidebar.jsp">
            <jsp:param name="active" value="customers" />
        </jsp:include>

        <div class="admin-content">
            <div class="page-header-detail">
                <div class="header-left">
                    <a href="${pageContext.request.contextPath}/admin/customers" class="back-link">
                        <i class="fa-solid fa-arrow-left"></i> Quay lại danh sách
                    </a>
                    <div class="customer-header-info">
                        <h1>${customer.fullName}</h1>
                        <span class="customer-id">ID: ${customer.id}</span>
                    </div>
                </div>
                <div class="header-actions">
                    <c:choose>
                        <c:when test="${customer.active}">
                            <span class="status-badge active">
                                <i class="fa-solid fa-circle-check"></i> Hoạt động
                            </span>
                        </c:when>
                        <c:otherwise>
                            <span class="status-badge inactive">
                                <i class="fa-solid fa-circle-xmark"></i> Bị khóa
                            </span>
                        </c:otherwise>
                    </c:choose>
                    <span class="customer-badge regular">
                        <i class="fa-solid fa-user"></i> Khách hàng
                    </span>
                </div>
            </div>

            <div class="customer-detail-layout">
                <div class="customer-main-column">
                    <div class="detail-card">
                        <div class="card-header">
                            <h3>
                                <i class="fa-solid fa-user"></i>
                                Thông tin cá nhân
                            </h3>
                        </div>
                        <div class="card-body">
                            <div class="info-grid">
                                <div class="info-item">
                                    <label><i class="fa-solid fa-id-badge"></i> Họ và tên</label>
                                    <p>${customer.fullName}</p>
                                </div>
                                <div class="info-item">
                                    <label><i class="fa-solid fa-envelope"></i> Email</label>
                                    <p>
                                        <a href="mailto:${customer.email}">${customer.email}</a>
                                    </p>
                                </div>
                                <div class="info-item">
                                    <label><i class="fa-solid fa-phone"></i> Số điện thoại</label>
                                    <p>
                                        <a href="tel:${customer.phone}">${customer.phone}</a>
                                    </p>
                                </div>
                                <div class="info-item">
                                    <label><i class="fa-solid fa-id-card"></i> Mã khách hàng</label>
                                    <p>${customer.id}</p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="customer-sidebar-column">
                    <div class="detail-card">
                        <div class="card-header">
                            <h3>
                                <i class="fa-solid fa-shield-halved"></i>
                                Thông tin tài khoản
                            </h3>
                        </div>
                        <div class="card-body">
                            <div class="info-grid">
                                <div class="info-item">
                                    <label><i class="fa-solid fa-user-tag"></i> Vai trò</label>
                                    <p>${customer.role}</p>
                                </div>
                                <div class="info-item">
                                    <label><i class="fa-solid fa-circle-info"></i> Trạng thái</label>
                                    <p>
                                        <c:choose>
                                            <c:when test="${customer.active}">
                                                <span class="status-badge active">Hoạt động</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="status-badge inactive">Bị khóa</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </p>
                                </div>
                                <div class="info-item">
                                    <label><i class="fa-solid fa-calendar-plus"></i> Ngày tạo</label>
                                    <p>
                                        <fmt:formatDate value="${customer.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
                                    </p>
                                </div>
                                <div class="info-item">
                                    <label><i class="fa-solid fa-calendar-check"></i> Cập nhật gần nhất</label>
                                    <p>
                                        <c:choose>
                                            <c:when test="${not empty customer.updatedAt}">
                                                <fmt:formatDate value="${customer.updatedAt}" pattern="dd/MM/yyyy HH:mm"/>
                                            </c:when>
                                            <c:otherwise>Chưa cập nhật</c:otherwise>
                                        </c:choose>
                                    </p>
                                </div>
                                <div class="info-item" style="grid-column: 1 / -1;">
                                    <label><i class="fa-solid fa-lock"></i> Mật khẩu (đã mã hóa)</label>
                                    <p style="overflow-wrap: anywhere;">${customer.password}</p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</main>
</body>
</html>
