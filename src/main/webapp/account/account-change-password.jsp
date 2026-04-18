<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/change-password.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/header.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/footer.css">
    <title>Đổi mật khẩu</title>
    <style>
        .verification-method-selector {
            margin-bottom: 20px;
            display: flex;
            gap: 20px;
        }
        .verification-method-selector label {
            display: flex;
            align-items: center;
            gap: 8px;
            cursor: pointer;
            font-weight: 500;
        }
        .google-verify-container {
            margin-bottom: 20px;
            padding: 15px;
            border: 1px solid #e0e0e0;
            border-radius: 8px;
            background-color: #f9f9f9;
        }
        .verify-success {
            color: #28a745;
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 8px;
            margin-top: 10px;
        }
        .verify-error {
            color: #dc3545;
            margin-top: 5px;
            font-size: 0.9em;
        }
    </style>
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
                <a href="${pageContext.request.contextPath}/account/account-profile.jsp" class="menu-item">
                    <i class="fa-solid fa-user-circle"></i>
                    <span>Thông tin</span>
                </a>
                <a href="${pageContext.request.contextPath}/change-password" class="menu-item active">
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
                        <i class="fa-solid fa-shield-halved"></i>
                        Đổi mật khẩu
                    </h1>
                    <p>Bảo mật tài khoản của bạn bằng mật khẩu mạnh</p>
                </div>
                <div class="header-decoration">
                    <i class="fa-solid fa-lock"></i>
                </div>
            </div>

            <div class="password-container">
                <div class="password-form-wrapper">
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
                    <form class="password-form" action="${pageContext.request.contextPath}/change-password" method="post">

                        <c:if test="${not empty sessionScope.user.googleId}">
                            <div class="verification-method-selector">
                                <label>
                                    <input type="radio" name="verifyMethod" value="password" checked onchange="toggleVerifyMethod()">
                                    Mật khẩu hiện tại
                                </label>
                                <label>
                                    <input type="radio" name="verifyMethod" value="google" onchange="toggleVerifyMethod()">
                                    Xác thực Google
                                </label>
                            </div>
                        </c:if>

                        <div id="passwordAuthSection">
                            <div class="form-group">
                                <label for="currentPassword">
                                    <i class="fa-solid fa-lock"></i>
                                    Mật khẩu hiện tại
                                    <span class="required">*</span>
                                </label>
                                <div class="password-input-wrapper">
                                    <input type="password" id="currentPassword" name="currentPassword" placeholder="Nhập mật khẩu hiện tại" required>
                                    <label class="toggle-password" for="showCurrentPassword">
                                        <input type="checkbox" id="showCurrentPassword" hidden>
                                        <i class="fa-solid fa-eye"></i>
                                    </label>
                                </div>
                                <a href="${pageContext.request.contextPath}/forgot-password" class="forgot-password">Quên mật khẩu?</a>
                            </div>
                        </div>

                        <div id="googleAuthSection" style="display: none;">
                            <div class="form-group google-verify-container">
                                <label style="margin-bottom: 10px; display: block;">Xác thực bằng tài khoản Google</label>
                                <div id="googleVerifyButton"></div>
                                <div id="googleVerifySuccess" class="verify-success" style="display: none;">
                                    <i class="fa-solid fa-check-circle"></i> Đã xác thực thành công!
                                </div>
                                <div id="googleVerifyError" class="verify-error"></div>
                            </div>
                        </div>

                        <div class="form-divider"></div>

                        <div class="form-group">
                            <label for="newPassword">
                                <i class="fa-solid fa-key"></i>
                                Mật khẩu mới
                                <span class="required">*</span>
                            </label>
                            <div class="password-input-wrapper">
                                <input type="password" id="newPassword" name="newPassword" placeholder="Nhập mật khẩu mới" minlength="8" required>
                                <label class="toggle-password" for="showNewPassword">
                                    <input type="checkbox" id="showNewPassword" hidden>
                                    <i class="fa-solid fa-eye"></i>
                                </label>
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="confirmPassword">
                                <i class="fa-solid fa-check-double"></i>
                                Xác nhận mật khẩu mới
                                <span class="required">*</span>
                            </label>
                            <div class="password-input-wrapper">
                                <input type="password" id="confirmPassword" name="confirmPassword" placeholder="Nhập lại mật khẩu mới" minlength="8" required>
                                <label class="toggle-password" for="showConfirmPassword">
                                    <input type="checkbox" id="showConfirmPassword" hidden>
                                    <i class="fa-solid fa-eye"></i>
                                </label>
                            </div>
                        </div>

                        <div class="form-actions">
                            <button type="reset" class="btn-cancel">
                                <i class="fa-solid fa-rotate-left"></i>
                                Đặt lại
                            </button>
                            <button type="submit" class="btn-submit">
                                <i class="fa-solid fa-shield-halved"></i>
                                Đổi mật khẩu
                            </button>
                        </div>
                    </form>
                </div>

                <div class="password-requirements">
                    <div class="requirements-header">
                        <i class="fa-solid fa-circle-info"></i>
                        <h3>Yêu cầu mật khẩu</h3>
                    </div>
                    <ul class="requirements-list">
                        <li>
                            <i class="fa-solid fa-check"></i>
                            <span>Tối thiểu 8 ký tự</span>
                        </li>
                        <li>
                            <i class="fa-solid fa-check"></i>
                            <span>Gồm chữ hoa, chữ thường, số và ký tự đặc biệt</span>
                        </li>
                    </ul>
                </div>
            </div>
        </div>
    </div>
</main>

<jsp:include page="/compenents/footer.jsp" />

<script>
    function toggleVerifyMethod() {
        const method = document.querySelector('input[name="verifyMethod"]:checked').value;
        const passSection = document.getElementById('passwordAuthSection');
        const googleSection = document.getElementById('googleAuthSection');
        const currentPassInput = document.getElementById('currentPassword');

        if (method === 'password') {
            passSection.style.display = 'block';
            googleSection.style.display = 'none';
            currentPassInput.required = true;
            currentPassInput.disabled = false;
        } else {
            passSection.style.display = 'none';
            googleSection.style.display = 'block';
            currentPassInput.required = false;
            currentPassInput.disabled = true;
        }
    }
</script>

<c:if test="${not empty applicationScope.googleClientId}">
    <script src="https://accounts.google.com/gsi/client" async defer></script>
    <script>
        const googleClientId = "${applicationScope.googleClientId}";
        const verifyUrl = "${pageContext.request.contextPath}/change-password?action=verifyGoogle";

        function handleGoogleVerifyResponse(response) {
            const errorEl = document.getElementById('googleVerifyError');
            errorEl.textContent = '';

            if (!response || !response.credential) {
                errorEl.textContent = 'Xác thực Google thất bại.';
                return;
            }

            const body = new URLSearchParams();
            body.append('idToken', response.credential);

            fetch(verifyUrl, {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: body.toString()
            })
            .then(res => res.json())
            .then(data => {
                if (data && data.success) {
                    document.getElementById('googleVerifySuccess').style.display = 'flex';
                    document.getElementById('googleVerifyButton').style.display = 'none';
                    
                    document.querySelectorAll('input[name="verifyMethod"]').forEach(el => el.disabled = true);
                } else {
                    errorEl.textContent = (data && data.message) ? data.message : 'Xác thực thất bại.';
                }
            })
            .catch(err => {
                console.error(err);
                errorEl.textContent = 'Lỗi kết nối đến máy chủ.';
            });
        }

        window.addEventListener('load', () => {
            if (!window.google || !googleClientId) return;

            google.accounts.id.initialize({
                client_id: googleClientId,
                callback: handleGoogleVerifyResponse
            });

            const container = document.getElementById('googleVerifyButton');
            if (container) {
                google.accounts.id.renderButton(container, {
                    theme: 'outline',
                    size: 'large',
                    text: 'continue_with',
                    shape: 'rectangular',
                    width: 250
                });
            }
        });
    </script>
</c:if>

</body>
</html>
