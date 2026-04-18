<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/register.css">
    <title>Đăng Ký Tài Khoản</title>
</head>
<body>
<main class="register-main">
    <div class="register-container">
        
        <div class="register-decoration">
            <div class="star-container">
                <div class="star-shape">
                    <img src="https://i.pinimg.com/1200x/df/8d/24/df8d24cf36eb3e03aa91e94c71bbccaf.jpg" class="star-image" alt="Vietnamese Craft">
                </div>
                <div class="circular-text">
                    <p>
                        <span style="--i:1">M</span><span style="--i:2">ỗ</span><span style="--i:3">i</span><span style="--i:4"> </span>
                        <span style="--i:5">s</span><span style="--i:6">ả</span><span style="--i:7">n</span><span style="--i:8"> </span>
                        <span style="--i:9">p</span><span style="--i:10">h</span><span style="--i:11">ẩ</span><span style="--i:12">m</span><span style="--i:13"> </span>
                        <span style="--i:14">l</span><span style="--i:15">à</span><span style="--i:16"> </span>
                        <span style="--i:17">m</span><span style="--i:18">ộ</span><span style="--i:19">t</span><span style="--i:20"> </span>
                        <span style="--i:21">c</span><span style="--i:22">â</span><span style="--i:23">u</span><span style="--i:24"> </span>
                        <span style="--i:25">c</span><span style="--i:26">h</span><span style="--i:27">u</span><span style="--i:28">y</span><span style="--i:29">ệ</span><span style="--i:30">n</span><span style="--i:31"> </span>
                        <span style="--i:32">•</span><span style="--i:33"> </span>
                        <span style="--i:34">M</span><span style="--i:35">ỗ</span><span style="--i:36">i</span><span style="--i:37"> </span>
                        <span style="--i:38">h</span><span style="--i:39">ọ</span><span style="--i:40">a</span><span style="--i:41"> </span>
                        <span style="--i:42">t</span><span style="--i:43">i</span><span style="--i:44">ế</span><span style="--i:45">t</span><span style="--i:46"> </span>
                        <span style="--i:47">l</span><span style="--i:48">à</span><span style="--i:49"> </span>
                        <span style="--i:50">m</span><span style="--i:51">ộ</span><span style="--i:52">t</span><span style="--i:53"> </span>
                        <span style="--i:54">t</span><span style="--i:55">â</span><span style="--i:56">m</span><span style="--i:57"> </span>
                        <span style="--i:58">h</span><span style="--i:59">ồ</span><span style="--i:60">n</span><span style="--i:61"> </span>
                        <span style="--i:62">•</span><span style="--i:63"> </span>
                    </p>
                </div>
            </div>
        </div>

        
        <div class="register-form-wrapper">
            <div class="register-form-container">
                <div class="register-header">
                    <a href="${pageContext.request.contextPath}/" class="auth-logo-link" aria-label="Về trang chủ">
                        <img src="https://suncraft.com.vn/wp-content/uploads/2025/09/suncraft-new-logo.svg"
                             alt="Logo Suncraft" class="auth-logo">
                    </a>
                    <h1>Đăng Ký Tài Khoản</h1>
                    <p>Tạo tài khoản để trải nghiệm mua sắm tuyệt vời</p>
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


                <form class="register-form" id="registerForm" action="${pageContext.request.contextPath}/register" method="post" novalidate>
                    <div class="form-group">
                        <label for="fullName">
                            <i class="fa-solid fa-user"></i>
                            Họ và tên
                        </label>
                        <input type="text" id="fullName" name="fullName" value="${fullName}"
                               placeholder="Nhập họ và tên đầy đủ" required>
                        <div class="field-feedback" id="fullNameError" aria-live="polite"></div>
                    </div>

                    <div class="form-group">
                        <label for="email">
                            <i class="fa-solid fa-envelope"></i>
                            Email
                        </label>
                        <input type="email" id="email" name="email" value="${email}"
                               placeholder="example@email.com" required>
                        <div class="field-feedback" id="emailError" aria-live="polite"></div>
                    </div>

                    <div class="form-group">
                        <label for="phone">
                            <i class="fa-solid fa-phone"></i>
                            Số điện thoại
                        </label>
                        <input type="tel" id="phone" name="phone" value="${phone}"
                               placeholder="Nhập số điện thoại" inputmode="numeric" maxlength="10" pattern="0[0-9]{9}" required>
                        <div class="field-feedback" id="phoneError" aria-live="polite"></div>
                    </div>

                    <div class="form-group">
                        <label for="password">
                            <i class="fa-solid fa-lock"></i>
                            Mật khẩu
                        </label>
                        <div class="password-input-wrapper">
                            <input type="password" id="password" name="password"
                                   placeholder="Tối thiểu 8 ký tự, có chữ hoa, chữ thường, số và ký tự đặc biệt" minlength="8" required>
                            <button type="button" class="toggle-password" data-target="password">
                                <i class="fa-solid fa-eye"></i>
                            </button>
                        </div>
                        <div class="password-strength" id="passwordStrength" data-strength="">
                            <div class="password-strength-bar">
                                <span id="passwordStrengthFill"></span>
                            </div>
                            <p id="passwordStrengthText">Mật khẩu phải có ít nhất 8 ký tự, gồm chữ hoa, chữ thường, số và ký tự đặc biệt.</p>
                        </div>
                        <div class="field-feedback" id="passwordError" aria-live="polite"></div>
                    </div>

                    <div class="form-group">
                        <label for="confirmPassword">
                            <i class="fa-solid fa-lock"></i>
                            Xác nhận mật khẩu
                        </label>
                        <div class="password-input-wrapper">
                            <input type="password" id="confirmPassword" name="confirmPassword"
                                   placeholder="Nhập lại mật khẩu" minlength="8" required>
                            <button type="button" class="toggle-password" data-target="confirmPassword">
                                <i class="fa-solid fa-eye"></i>
                            </button>
                        </div>
                        <div class="field-feedback" id="confirmPasswordError" aria-live="polite"></div>
                    </div>

                    <div class="form-options">
                        <label class="terms-checkbox">
                            <input type="checkbox" id="agreeTerms" name="agreeTerms" required>
                            <span>Tôi đồng ý với <a href="#" class="terms-link">điều khoản sử dụng</a> và <a href="#" class="terms-link">Chính sách bảo mật</a></span>
                        </label>
                        <div class="field-feedback" id="agreeTermsError" aria-live="polite"></div>
                    </div>

                    <button type="submit" class="btn-register">
                        <i class="fa-solid fa-user-plus"></i> Đăng ký
                    </button>
                </form>

                <div class="divider">
                    <span>Hoặc đăng ký bằng</span>
                </div>

                <div class="social-login">
                    <c:if test="${not empty applicationScope.googleClientId}">
                        <div id="googleButton" class="google-signin"></div>
                    </c:if>
                    <c:if test="${empty applicationScope.googleClientId}">
                        <button type="button" class="btn-social btn-google" disabled title="Google chưa được cấu hình">
                            <i class="fa-brands fa-google"></i> Đăng ký với Google
                        </button>
                    </c:if>
                </div>

                <div class="login-link">
                    <p>Bạn đã có tài khoản? <a href="${pageContext.request.contextPath}/login">Đăng nhập ngay</a></p>
                </div>
            </div>
        </div>
    </div>
</main>

<script>
    const blockedEmailDomains = [
        'example.com', 'example.org', 'example.net',
        'test.com', 'test.org', 'test.net'
    ];
    const validPhonePrefixes = [
        '032', '033', '034', '035', '036', '037', '038', '039',
        '052', '055', '056', '058', '059',
        '070', '076', '077', '078', '079',
        '081', '082', '083', '084', '085', '086', '087', '088', '089',
        '090', '091', '092', '093', '094',
        '096', '097', '098', '099'
    ];
    const registerForm = document.getElementById('registerForm');
    const fullNameInput = document.getElementById('fullName');
    const emailInput = document.getElementById('email');
    const phoneInput = document.getElementById('phone');
    const passwordInput = document.getElementById('password');
    const confirmPasswordInput = document.getElementById('confirmPassword');
    const agreeTermsInput = document.getElementById('agreeTerms');
    const passwordStrength = document.getElementById('passwordStrength');
    const passwordStrengthFill = document.getElementById('passwordStrengthFill');
    const passwordStrengthText = document.getElementById('passwordStrengthText');
    const passwordRuleMessage = 'Mật khẩu phải có ít nhất 8 ký tự, gồm chữ hoa, chữ thường, số và ký tự đặc biệt.';
    const fieldErrors = {
        fullName: document.getElementById('fullNameError'),
        email: document.getElementById('emailError'),
        phone: document.getElementById('phoneError'),
        password: document.getElementById('passwordError'),
        confirmPassword: document.getElementById('confirmPasswordError'),
        agreeTerms: document.getElementById('agreeTermsError')
    };

    function getFieldWrapper(input) {
        return input.closest('.form-group') || input.closest('.form-options');
    }

    function markTouched(input) {
        input.dataset.touched = 'true';
    }

    function shouldShowFieldError(input, forceShow) {
        return forceShow || input.dataset.touched === 'true';
    }

    function clearFieldError(input) {
        const wrapper = getFieldWrapper(input);
        const errorElement = fieldErrors[input.id];

        if (wrapper) {
            wrapper.classList.remove('has-error');
        }

        if (errorElement) {
            errorElement.textContent = '';
            errorElement.classList.remove('show');
        }
    }

    function showFieldError(input, message, forceShow) {
        if (!shouldShowFieldError(input, forceShow)) {
            clearFieldError(input);
            return;
        }

        const wrapper = getFieldWrapper(input);
        const errorElement = fieldErrors[input.id];

        if (wrapper) {
            wrapper.classList.add('has-error');
        }

        if (errorElement) {
            errorElement.textContent = message;
            errorElement.classList.add('show');
        }
    }

    function validateFullNameField(forceShow = false) {
        const fullName = fullNameInput.value.trim();

        if (!fullName) {
            fullNameInput.setCustomValidity('Vui lòng nhập họ và tên.');
            showFieldError(fullNameInput, 'Vui lòng nhập họ và tên.', forceShow);
            return false;
        }

        fullNameInput.setCustomValidity('');
        clearFieldError(fullNameInput);
        return true;
    }

    function validateEmailField(forceShow = false) {
        const email = emailInput.value.trim().toLowerCase();

        if (!email) {
            emailInput.setCustomValidity('Vui lòng nhập email.');
            showFieldError(emailInput, 'Vui lòng nhập email.', forceShow);
            return false;
        }

        if (!/^[a-zA-Z0-9][a-zA-Z0-9._-]*@[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)+$/.test(email)) {
            emailInput.setCustomValidity('Vui lòng nhập email đúng định dạng.');
            showFieldError(emailInput, 'Vui lòng nhập email đúng định dạng.', forceShow);
            return false;
        }

        const parts = email.split('@');
        const localPart = parts[0];
        const domain = parts[1];

        if (localPart.startsWith('.') || localPart.endsWith('.') || localPart.includes('..') || /^[0-9]+$/.test(localPart) || blockedEmailDomains.includes(domain) || domain.includes('..')) {
            emailInput.setCustomValidity('Vui lòng nhập email thật và không dùng email mẫu.');
            showFieldError(emailInput, 'Vui lòng nhập email thật và không dùng email mẫu.', forceShow);
            return false;
        }

        emailInput.setCustomValidity('');
        clearFieldError(emailInput);
        return true;
    }

    function validatePhoneField(forceShow = false) {
        const phone = phoneInput.value.trim();

        if (!phone) {
            phoneInput.setCustomValidity('Vui lòng nhập số điện thoại.');
            showFieldError(phoneInput, 'Vui lòng nhập số điện thoại.', forceShow);
            return false;
        }

        if (phone.length !== 10 || !phone.startsWith('0') || !validPhonePrefixes.includes(phone.substring(0, 3))) {
            phoneInput.setCustomValidity('Vui lòng nhập số di động Việt Nam hợp lệ.');
            showFieldError(phoneInput, 'Vui lòng nhập số di động Việt Nam hợp lệ.', forceShow);
            return false;
        }

        phoneInput.setCustomValidity('');
        clearFieldError(phoneInput);
        return true;
    }

    function getPasswordStrength(password) {
        if (!password) {
            return '';
        }

        let types = 0;

        if (/[a-z]/.test(password)) {
            types++;
        }
        if (/[A-Z]/.test(password)) {
            types++;
        }
        if (/[0-9]/.test(password)) {
            types++;
        }
        if (/[^A-Za-z0-9\s]/.test(password)) {
            types++;
        }

        if (password.length < 8 || types <= 2) {
            return 'Yếu';
        }
        if (types === 3) {
            return 'Trung bình';
        }
        return 'Mạnh';
    }

    function setPasswordStrengthState(strength) {
        passwordStrength.dataset.strength = strength;

        if (!strength) {
            passwordStrengthFill.style.width = '0%';
            passwordStrengthText.textContent = passwordRuleMessage;
            return;
        }

        if (strength === 'Yếu') {
            passwordStrengthFill.style.width = '33%';
            passwordStrengthText.textContent = 'Mức độ: Yếu. ' + passwordRuleMessage;
            return;
        }

        if (strength === 'Trung bình') {
            passwordStrengthFill.style.width = '66%';
            passwordStrengthText.textContent = 'Mức độ: Trung bình. Thêm 1 nhóm ký tự còn thiếu để đạt mức mạnh.';
            return;
        }

        passwordStrengthFill.style.width = '100%';
        passwordStrengthText.textContent = 'Mức độ: Mạnh. Bạn có thể dùng mật khẩu này để đăng ký.';
    }

    function validateConfirmPassword(forceShow = false) {
        const confirmPassword = confirmPasswordInput.value;

        if (!confirmPassword) {
            confirmPasswordInput.setCustomValidity('Vui lòng nhập lại mật khẩu.');
            showFieldError(confirmPasswordInput, 'Vui lòng nhập lại mật khẩu.', forceShow);
            return false;
        }

        if (passwordInput.value !== confirmPassword) {
            confirmPasswordInput.setCustomValidity('Mật khẩu xác nhận không khớp!');
            showFieldError(confirmPasswordInput, 'Mật khẩu xác nhận không khớp!', forceShow);
            return false;
        }

        confirmPasswordInput.setCustomValidity('');
        clearFieldError(confirmPasswordInput);
        return true;
    }

    function validateAgreeTermsField(forceShow = false) {
        if (!agreeTermsInput.checked) {
            agreeTermsInput.setCustomValidity('Bạn cần đồng ý với điều khoản sử dụng.');
            showFieldError(agreeTermsInput, 'Bạn cần đồng ý với điều khoản sử dụng.', forceShow);
            return false;
        }

        agreeTermsInput.setCustomValidity('');
        clearFieldError(agreeTermsInput);
        return true;
    }

    function updatePasswordStrength(forceShow = false) {
        const strength = getPasswordStrength(passwordInput.value);
        setPasswordStrengthState(strength);

        if (!passwordInput.value) {
            passwordInput.setCustomValidity('Vui lòng nhập mật khẩu.');
            showFieldError(passwordInput, 'Vui lòng nhập mật khẩu.', forceShow);
            validateConfirmPassword();
            return strength;
        }

        if (strength !== 'Mạnh') {
            passwordInput.setCustomValidity(passwordRuleMessage);
            showFieldError(passwordInput, passwordRuleMessage, forceShow);
        } else {
            passwordInput.setCustomValidity('');
            clearFieldError(passwordInput);
        }

        validateConfirmPassword();
        return strength;
    }

    function validateRegisterForm(forceShow = false) {
        const isFullNameValid = validateFullNameField(forceShow);
        const isEmailValid = validateEmailField(forceShow);
        const isPhoneValid = validatePhoneField(forceShow);
        const passwordStrengthValue = updatePasswordStrength(forceShow);
        const isPasswordValid = passwordInput.checkValidity() && passwordStrengthValue === 'Mạnh';
        const isConfirmPasswordValid = validateConfirmPassword(forceShow);
        const isAgreeTermsValid = validateAgreeTermsField(forceShow);

        return isFullNameValid && isEmailValid && isPhoneValid && isPasswordValid && isConfirmPasswordValid && isAgreeTermsValid;
    }

    fullNameInput.addEventListener('input', function() {
        validateFullNameField();
    });

    fullNameInput.addEventListener('blur', function() {
        markTouched(this);
        validateFullNameField(true);
    });

    emailInput.addEventListener('input', function() {
        validateEmailField();
    });

    emailInput.addEventListener('blur', function() {
        markTouched(this);
        validateEmailField(true);
    });

    phoneInput.addEventListener('input', function() {
        this.value = this.value.replace(/[^0-9]/g, '').slice(0, 10);
        validatePhoneField();
    });

    phoneInput.addEventListener('blur', function() {
        markTouched(this);
        validatePhoneField(true);
    });

    passwordInput.addEventListener('input', function() {
        updatePasswordStrength();
    });

    passwordInput.addEventListener('blur', function() {
        markTouched(this);
        updatePasswordStrength(true);
    });

    confirmPasswordInput.addEventListener('input', function() {
        validateConfirmPassword();
    });

    confirmPasswordInput.addEventListener('blur', function() {
        markTouched(this);
        validateConfirmPassword(true);
    });

    agreeTermsInput.addEventListener('change', function() {
        markTouched(this);
        validateAgreeTermsField(true);
    });

    agreeTermsInput.addEventListener('blur', function() {
        markTouched(this);
        validateAgreeTermsField(true);
    });

    document.querySelectorAll('.toggle-password').forEach(button => {
        button.addEventListener('click', function() {
            const targetId = this.getAttribute('data-target');
            const passwordInput = document.getElementById(targetId);
            const icon = this.querySelector('i');

            if (passwordInput.type === 'password') {
                passwordInput.type = 'text';
                icon.classList.remove('fa-eye');
                icon.classList.add('fa-eye-slash');
            } else {
                passwordInput.type = 'password';
                icon.classList.remove('fa-eye-slash');
                icon.classList.add('fa-eye');
            }
        });
    });

    
    registerForm.addEventListener('submit', function(e) {
        [fullNameInput, emailInput, phoneInput, passwordInput, confirmPasswordInput, agreeTermsInput].forEach(markTouched);

        if (!validateRegisterForm(true)) {
            e.preventDefault();
            const firstInvalidField = [fullNameInput, emailInput, phoneInput, passwordInput, confirmPasswordInput, agreeTermsInput]
                .find(input => !input.checkValidity());

            if (firstInvalidField) {
                firstInvalidField.focus();
            }
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
                    text: 'signup_with',
                    shape: 'rectangular',
                    logo_alignment: 'center'
                });
            }
        });
    </script>
</c:if>
</body>
</html>
