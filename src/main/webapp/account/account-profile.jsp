<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<%
    if (request.getAttribute("jakarta.servlet.forward.request_uri") == null) {
        response.sendRedirect(request.getContextPath() + "/profile");
        return;
    }
%>
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
        <jsp:include page="/compenents/sidebar.jsp" />

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

                    <div class="form-section profile-address-section">
                        <div class="section-title">
                            <i class="fa-solid fa-location-dot"></i>
                            <h2>Địa chỉ giao hàng</h2>
                        </div>

                        <div class="form-grid">
                            <div class="form-group">
                                <label for="receiverName">
                                    <i class="fa-solid fa-user-check"></i>
                                    Người nhận
                                </label>
                                <input type="text" id="receiverName" name="receiverName" value="${shippingAddress.receiverName}">
                            </div>

                            <div class="form-group">
                                <label for="shippingPhone">
                                    <i class="fa-solid fa-phone-volume"></i>
                                    SĐT nhận hàng
                                </label>
                                <input type="tel" id="shippingPhone" name="shippingPhone" value="${shippingAddress.phone}">
                            </div>

                            <div class="form-group full-width">
                                <label for="addressLine">
                                    <i class="fa-solid fa-house"></i>
                                    Địa chỉ cụ thể
                                </label>
                                <input type="text" id="addressLine" name="addressLine" value="${shippingAddress.addressLine}" placeholder="Số nhà, tên đường...">
                            </div>

                            <div class="form-group">
                                <label for="province">
                                    <i class="fa-solid fa-city"></i>
                                    Tỉnh / Thành phố
                                </label>
                                <input type="text" id="province" name="province" value="${shippingAddress.province}">
                            </div>

                            <div class="form-group">
                                <label for="district">
                                    <i class="fa-solid fa-map"></i>
                                    Quận / Huyện
                                </label>
                                <input type="text" id="district" name="district" value="${shippingAddress.district}">
                            </div>

                            <div class="form-group">
                                <label for="ward">
                                    <i class="fa-solid fa-location-crosshairs"></i>
                                    Phường / Xã
                                </label>
                                <input type="text" id="ward" name="ward" value="${shippingAddress.ward}">
                            </div>

                            <div class="form-group">
                                <label for="note">
                                    <i class="fa-solid fa-note-sticky"></i>
                                    Ghi chú
                                </label>
                                <input type="text" id="note" name="note" value="${shippingAddress.note}" placeholder="Ví dụ: giao giờ hành chính">
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
