<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đánh giá thành công</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/review-success.css">
</head>
<body>

<main class="success-page-container">
    <div class="success-card">
        <div class="icon-wrapper">
            <i class="fa-solid fa-check"></i>
        </div>

        <h1 class="success-title">Cảm ơn bạn đã đánh giá!</h1>

        <div class="success-message">
            <p>Ý kiến của bạn đã được hệ thống ghi nhận thành công.</p>

            
            <c:if test="${not empty orderId}">
                <p class="sub-text">Đơn hàng: <strong>#${orderId}</strong></p>
            </c:if>

            <p class="sub-text">Đánh giá sẽ được hiển thị sau khi quản trị viên phê duyệt.</p>
        </div>

        <div class="action-buttons">
            
            <a href="${pageContext.request.contextPath}/products" class="btn-continue">
                <i class="fa-solid fa-arrow-left"></i> Tiếp tục mua hàng
            </a>

            
            <c:if test="${not empty orderId}">
                <a href="${pageContext.request.contextPath}/order-review?orderId=${orderId}"
                   class="btn-continue" style="background-color: #f39c12; margin-top: 10px;">
                    <i class="fa-solid fa-star"></i> Đánh giá sản phẩm khác
                </a>
            </c:if>
        </div>
    </div>
</main>

</body>
</html>
