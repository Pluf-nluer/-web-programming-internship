<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/login.css">
    <title>Đăng nhập</title>
</head>
<body>
<main class="login-main">
    <div class="login-container">
        
        <div class="login-decoration">
            <div class="decoration-content">
                <h2>Đồ thủ công mỹ nghệ Việt</h2>
                <p>Tinh tế trong từng chi tiết, mang đậm bản sắc Việt</p>
                <div class="decoration-pattern">
                    <i class="fa-solid fa-leaf"></i>
                    <i class="fa-solid fa-spa"></i>
                    <i class="fa-solid fa-leaf"></i>
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
                    <h1>Đăng Nhập</h1>
                    <p>Chào mừng bạn quay trở lại</p>
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
                <div class="error-message" id="googleError"></div>

                <form class="login-form" id="loginForm" action="${pageContext.request.contextPath}/login" method="post">
                    <div class="form-group">
                        <label for="emailOrPhone">
                            <i class="fa-solid fa-envelope"></i>
                            Email hoặc Số điện thoại
                        </label>
                        <input type="text" id="emailOrPhone" name="emailOrPhone"
                               placeholder="Nhập email hoặc số điện thoại" required>
                    </div>

                    <div class="form-group">
                        <label for="password">
                            <i class="fa-solid fa-lock"></i>
                            Mật khẩu
                        </label>
                        <div class="password-input-wrapper">
                            <input type="password" id="password" name="password"
                                   placeholder="Nhập mật khẩu" required>
                            <button type="button" class="toggle-password">
                                <i class="fa-solid fa-eye" id="toggleIcon"></i>
                            </button>
                        </div>
                    </div>

                    <div class="form-options form-options-single">
                        <a href="${pageContext.request.contextPath}/forgot-password" class="forgot-password">Quên mật khẩu?</a>
                    </div>

                    <button type="submit" class="btn-login">
                        <i class="fa-solid fa-right-to-bracket"></i> Đăng nhập
                    </button>
                </form>

                <div class="divider">
                    <span>Hoặc đăng nhập bằng</span>
                </div>

                <div class="social-login">
                    <c:if test="${not empty applicationScope.googleClientId}">
                        <div id="googleButton" class="google-signin"></div>
                    </c:if>
                    <c:if test="${empty applicationScope.googleClientId}">
                        <button type="button" class="btn-social btn-google" disabled title="Google chưa được cấu hình">
                            <i class="fa-brands fa-google"></i> Đăng nhập với Google
                        </button>
                    </c:if>
                </div>

                <div class="register-link">
                    <p>Chưa có tài khoản? <a href="${pageContext.request.contextPath}/register">Đăng ký ngay</a></p>
                </div>

            </div>
        </div>
    </div>
</main>

<script>
    
    document.querySelector('.toggle-password').addEventListener('click', function() {
        const passwordInput = document.getElementById('password');
        const toggleIcon = document.getElementById('toggleIcon');

        if (passwordInput.type === 'password') {
            passwordInput.type = 'text';
            toggleIcon.classList.remove('fa-eye');
            toggleIcon.classList.add('fa-eye-slash');
        } else {
            passwordInput.type = 'password';
            toggleIcon.classList.remove('fa-eye-slash');
            toggleIcon.classList.add('fa-eye');
        }
    });
</script>
<c:if test="${not empty applicationScope.googleClientId}">
    <script src="https://accounts.google.com/gsi/client" async defer></script>
    <script>
        const googleClientId = "${applicationScope.googleClientId}";
        const googleAuthUrl = "${pageContext.request.contextPath}/oauth2/callback/google";

        function showGoogleError(message) {
            const errorEl = document.getElementById('googleError');
            if (!errorEl) {
                alert(message);
                return;
            }
            errorEl.textContent = message;
            errorEl.classList.add('show');
        }

        function handleGoogleCredentialResponse(response) {
            if (!response || !response.credential) {
                showGoogleError('Dang nhap Google that bai.');
                return;
            }
            const body = new URLSearchParams();
            body.append('idToken', response.credential);

            fetch(googleAuthUrl, {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: body.toString(),
                credentials: 'same-origin'
            })
                .then(res => res.json())
                .then(data => {
                    if (data && data.success && data.redirectUrl) {
                        window.location.href = data.redirectUrl;
                        return;
                    }
                    const message = (data && data.message) ? data.message : 'Dang nhap Google that bai.';
                    showGoogleError(message);
                })
                .catch(() => showGoogleError('Khong the ket noi den may chu.'));
        }

        window.addEventListener('load', () => {
            if (!window.google || !googleClientId) {
                return;
            }
            google.accounts.id.initialize({
                client_id: googleClientId,
                callback: handleGoogleCredentialResponse,
                locale: 'vi'
            });
            const container = document.getElementById('googleButton');
            if (container) {
                const width = Math.min(container.offsetWidth || 360, 360);
                google.accounts.id.renderButton(container, {
                    theme: 'outline',
                    size: 'large',
                    width: width,
                    text: 'signin_with',
                    shape: 'rectangular',
                    logo_alignment: 'left'
                });
            }
        });
    </script>
</c:if>
</body>
</html>
