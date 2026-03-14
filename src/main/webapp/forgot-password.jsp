<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/login.css">
    <title>Quên mật khẩu</title>
</head>
<body>
<main class="login-main">
    <div class="login-container">
        <div class="login-decoration">
            <div class="decoration-content">
                <h2>Đồ thủ công mỹ nghệ Việt</h2>
                <p>Khôi phục quyền truy cập vào tài khoản của bạn</p>
                <div class="decoration-pattern">
                    <i class="fa-solid fa-key"></i>
                    <i class="fa-solid fa-lock-open"></i>
                    <i class="fa-solid fa-shield-halved"></i>
                </div>
            </div>
        </div>

        <div class="login-form-wrapper">
            <div class="login-form-container">
                <div class="login-header">
                    <h1>Quên Mật Khẩu</h1>
                    <p>Nhập email của bạn để nhận mật khẩu mới</p>
                </div>

                <c:if test="${not empty successMessage}">
                    <div class="alert alert-success">
                        <i class="fa-solid fa-check-circle"></i> ${successMessage}
                    </div>
                </c:if>
                <c:if test="${not empty errorMessage}">
                    <div class="alert alert-error">
                        <i class="fa-solid fa-exclamation-circle"></i> ${errorMessage}
                    </div>
                </c:if>

                <form class="login-form" action="${pageContext.request.contextPath}/forgot-password" method="post">
                    <div class="form-group">
                        <label for="email">
                            <i class="fa-solid fa-envelope"></i>
                            Email
                        </label>
                        <input type="email" id="email" name="email"
                               placeholder="Nhập địa chỉ email của bạn" required>
                    </div>

                    <button type="submit" class="btn-login">
                        <i class="fa-solid fa-paper-plane"></i> Gửi yêu cầu
                    </button>
                </form>

                <div class="register-link">
                    <p>Đã nhớ mật khẩu? <a href="${pageContext.request.contextPath}/login.jsp">Đăng nhập ngay</a></p>
                </div>
            </div>
        </div>
    </div>
</main>
</body>
</html>
