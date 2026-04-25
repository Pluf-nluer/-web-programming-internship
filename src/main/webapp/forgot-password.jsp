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
                    <a href="${pageContext.request.contextPath}/" class="auth-logo-link" aria-label="Về trang chủ">
                        <img src="https://suncraft.com.vn/wp-content/uploads/2025/09/suncraft-new-logo.svg"
                             alt="Logo Suncraft" class="auth-logo">
                    </a>
                    <c:choose>
                        <c:when test="${resetStep == 'otp'}">
                            <h1>Xác Nhận OTP</h1>
                            <p>Nhập mã đã gửi đến ${resetEmail}</p>
                        </c:when>
                        <c:when test="${resetStep == 'password'}">
                            <h1>Tạo Mật Khẩu Mới</h1>
                            <p>Nhập mật khẩu mới cho tài khoản của bạn</p>
                        </c:when>
                        <c:otherwise>
                            <h1>Quên Mật Khẩu</h1>
                            <p>Nhập email để nhận mã OTP xác nhận</p>
                        </c:otherwise>
                    </c:choose>
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

                <c:choose>
                    <c:when test="${resetStep == 'otp'}">
                        <form class="login-form reset-form" action="${pageContext.request.contextPath}/forgot-password" method="post" novalidate>
                            <input type="hidden" name="action" value="verifyOtp">
                            <div class="reset-box">
                                <div class="reset-icon">
                                    <i class="fa-solid fa-envelope-open-text"></i>
                                </div>
                                <h2>Kiểm tra email của bạn</h2>
                                <p>Mã OTP gồm 4-6 số và sẽ hết hạn sau vài phút.</p>
                            </div>

                            <div class="form-group">
                                <label for="otpCode">
                                    <i class="fa-solid fa-shield-halved"></i>
                                    Mã OTP
                                </label>
                                <input type="text" id="otpCode" name="otpCode"
                                       placeholder="Nhập mã OTP" inputmode="numeric" maxlength="6" pattern="[0-9]{4,6}" required autofocus>
                            </div>

                            <button type="submit" class="btn-login">
                                <i class="fa-solid fa-circle-check"></i> Xác nhận OTP
                            </button>
                        </form>
                    </c:when>
                    <c:when test="${resetStep == 'password'}">
                        <form class="login-form reset-form" action="${pageContext.request.contextPath}/forgot-password" method="post" novalidate>
                            <input type="hidden" name="action" value="resetPassword">
                            <div class="form-group">
                                <label for="newPassword">
                                    <i class="fa-solid fa-lock"></i>
                                    Mật khẩu mới
                                </label>
                                <div class="password-input-wrapper">
                                    <input type="password" id="newPassword" name="newPassword"
                                           placeholder="Tối thiểu 8 ký tự, có chữ hoa, chữ thường, số và ký tự đặc biệt" minlength="8" required>
                                    <button type="button" class="toggle-password" data-target="newPassword">
                                        <i class="fa-solid fa-eye"></i>
                                    </button>
                                </div>
                            </div>

                            <div class="form-group">
                                <label for="confirmPassword">
                                    <i class="fa-solid fa-lock"></i>
                                    Xác nhận mật khẩu
                                </label>
                                <div class="password-input-wrapper">
                                    <input type="password" id="confirmPassword" name="confirmPassword"
                                           placeholder="Nhập lại mật khẩu mới" minlength="8" required>
                                    <button type="button" class="toggle-password" data-target="confirmPassword">
                                        <i class="fa-solid fa-eye"></i>
                                    </button>
                                </div>
                            </div>

                            <button type="submit" class="btn-login">
                                <i class="fa-solid fa-key"></i> Cập nhật mật khẩu
                            </button>
                        </form>
                    </c:when>
                    <c:otherwise>
                        <form class="login-form" action="${pageContext.request.contextPath}/forgot-password" method="post">
                            <input type="hidden" name="action" value="sendOtp">
                            <div class="form-group">
                                <label for="email">
                                    <i class="fa-solid fa-envelope"></i>
                                    Email
                                </label>
                                <input type="email" id="email" name="email" value="${email}"
                                       placeholder="Nhập địa chỉ email của bạn" required>
                            </div>

                            <button type="submit" class="btn-login">
                                <i class="fa-solid fa-paper-plane"></i> Gửi mã OTP
                            </button>
                        </form>
                    </c:otherwise>
                </c:choose>

                <div class="register-link">
                    <p>Đã nhớ mật khẩu? <a href="${pageContext.request.contextPath}/login">Đăng nhập ngay</a></p>
                </div>
            </div>
        </div>
    </div>
</main>

<script>
    document.querySelectorAll('.toggle-password').forEach(button => {
        button.addEventListener('click', function() {
            const targetId = this.getAttribute('data-target');
            const input = document.getElementById(targetId);
            const icon = this.querySelector('i');

            if (input.type === 'password') {
                input.type = 'text';
                icon.classList.remove('fa-eye');
                icon.classList.add('fa-eye-slash');
            } else {
                input.type = 'password';
                icon.classList.remove('fa-eye-slash');
                icon.classList.add('fa-eye');
            }
        });
    });

    const otpInput = document.getElementById('otpCode');
    if (otpInput) {
        otpInput.addEventListener('input', function() {
            this.value = this.value.replace(/[^0-9]/g, '').slice(0, 6);
        });
    }
</script>
</body>
</html>
