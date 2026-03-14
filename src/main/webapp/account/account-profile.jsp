<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/profile.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/header.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/footer.css">
    <title>Thông tin tài khoản</title>
</head>
<body>
<jsp:include page="/compenents/header.jsp" />

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
                <a href="${pageContext.request.contextPath}/account/order.jsp" class="menu-item">
                    <i class="fa-solid fa-box"></i>
                    <span>Đơn hàng</span>
                </a>
                <a href="${pageContext.request.contextPath}/account/account-profile.jsp" class="menu-item active">
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
                <div class="header-content">
                    <h1>
                        <i class="fa-solid fa-user-circle"></i>
                        Thông tin tài khoản
                    </h1>
                    <p>Quản lý thông tin cá nhân của bạn</p>
                </div>
                <div class="header-decoration">
                    <i class="fa-solid fa-palette"></i>
                </div>
            </div>

            <c:set var="profileUser" value="${not empty user ? user : sessionScope.user}" />

            <div class="profile-container">
                <c:if test="${not empty successMessage}">
                    <div class="success-message show">
                        <i class="fa-solid fa-circle-check"></i>
                        <span>${successMessage}</span>
                    </div>
                </c:if>
                <c:if test="${not empty errorMessage}">
                    <div class="success-message show" style="background: #f8d7da; border-left-color: #dc3545; color: #721c24;">
                        <i class="fa-solid fa-circle-exclamation"></i>
                        <span>${errorMessage}</span>
                    </div>
                </c:if>

                <form class="profile-form" action="${pageContext.request.contextPath}/profile" method="post">
                    <div class="form-section">
                        <div class="section-title">
                            <i class="fa-solid fa-id-card"></i>
                            <h2>Thông tin cá nhân</h2>
                        </div>

                        <div class="form-grid">
                            <div class="form-group">
                                <label for="fullName">
                                    <i class="fa-solid fa-user"></i>
                                    Họ và tên
                                    <span class="required">*</span>
                                </label>
                                <input type="text" id="fullName" name="fullName" value="${profileUser.fullName}" required>
                            </div>

                            <div class="form-group">
                                <label for="email">
                                    <i class="fa-solid fa-envelope"></i>
                                    Email
                                    <span class="info-badge">Không thể sửa</span>
                                </label>
                                <input type="email" id="email" name="email" value="${profileUser.email}" readonly disabled>
                            </div>

                            <div class="form-group">
                                <label for="phone">
                                    <i class="fa-solid fa-phone"></i>
                                    Số điện thoại
                                    <span class="required">*</span>
                                </label>
                                <input type="tel" id="phone" name="phone" value="${profileUser.phone}" required>
                            </div>
                        </div>
                    </div>

                    <div class="form-actions">
                        <button type="reset" class="btn-cancel">
                            <i class="fa-solid fa-rotate-left"></i>
                            Đặt lại
                        </button>
                        <button type="submit" class="btn-submit">
                            <i class="fa-solid fa-floppy-disk"></i>
                            Cập nhật thông tin
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</main>

<jsp:include page="/compenents/footer.jsp" />
</body>
</html>
