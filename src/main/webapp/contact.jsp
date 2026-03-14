<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Liên Hệ</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/contact.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/header.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/footer.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/hero-section.css">
</head>
<body data-context-path="${pageContext.request.contextPath}">

<c:set var="activeTab" value="contact" scope="request"/>
<jsp:include page="/compenents/header.jsp" />

<main>
    
    <c:set var="pageTitle" value="Liên hệ" scope="request" />
    <c:set var="breadcrumbText" value="Liên hệ" scope="request" />
    <jsp:include page="/compenents/hero-section.jsp" />

    
    <div class="main-content">
        
        <div class="contact-info">
            <h2>Cửa hàng đồ thủ công mỹ nghệ</h2>

            <div class="info-item">
                <div class="info-icon">
                    <i class="fas fa-map-marker-alt"></i>
                </div>
                <div class="info-content">
                    <h3>Địa chỉ</h3>
                    <p>Trường Đại học Nông Lâm Tp.HCM</p>
                </div>
            </div>

            <div class="info-item">
                <div class="info-icon">
                    <i class="fas fa-phone"></i>
                </div>
                <div class="info-content">
                    <h3>Thời gian làm việc</h3>
                    <p>Thứ 2 - Thứ 7: 8:00 - 17:00<br>Chủ nhật: 9:00 - 16:00</p>
                </div>
            </div>


            <div class="info-item">
                <div class="info-icon">
                    <i class="fas fa-mobile-alt"></i>
                </div>
                <div class="info-content">
                    <h3>Hotline</h3>
                    <p>+84 909 876 543</p>
                </div>
            </div>

            <div class="info-item">
                <div class="info-icon">
                    <i class="fas fa-envelope"></i>
                </div>
                <div class="info-content">
                    <h3>Email</h3>
                    <p>23130240@st.hcmuaf.edu.vn</p>
                </div>
            </div>
        </div>

        
        <div class="contact-form">
            <h2>Liên hệ với chúng tôi</h2>
            <p style="color: #666; margin-bottom: 20px; font-size: 14px;">
                Xin lưu ý rằng nhận xét cần được phê duyệt trước khi được xuất bản và hệ thống sẽ ghi lại địa chỉ IP của bạn
            </p>

            
            <c:if test="${not empty successMessage}">
                <div class="alert alert-success" style="background-color: #d4edda; color: #155724; padding: 10px; border-radius: 5px; margin-bottom: 15px;">
                        ${successMessage}
                </div>
            </c:if>
            <c:if test="${not empty errorMessage}">
                <div class="alert alert-error" style="background-color: #f8d7da; color: #721c24; padding: 10px; border-radius: 5px; margin-bottom: 15px;">
                        ${errorMessage}
                </div>
            </c:if>

            <form action="${pageContext.request.contextPath}/contact" method="post">
                <div class="form-group">
                    <label>Tên</label>
                    <input type="text" name="name" required
                           value="${clearForm ? '' : (not empty formName ? formName : (sessionScope.user != null ? sessionScope.user.fullName : ''))}">
                </div>

                <div class="form-group">
                    <label>Email</label>
                    <input type="email" name="email" required
                           value="${clearForm ? '' : (not empty formEmail ? formEmail : (sessionScope.user != null ? sessionScope.user.email : ''))}">
                </div>

                <div class="form-group">
                    <label>Nội dung</label>
                    <textarea name="message" required>${clearForm ? '' : (not empty formMessage ? formMessage : '')}</textarea>
                </div>

                <button type="submit" class="submit-btn">Gửi</button>
            </form>
        </div>

        
        <div class="map-section">
            <div class="map-container">
                <iframe
                        src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d3919.6456!2d106.6677!3d10.7626!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x0%3A0x0!2zMTDCsDQ1JzQ1LjQiTiAxMDbCsDQwJzAzLjciRQ!5e0!3m2!1svi!2s!4v1234567890"
                        allowfullscreen="" loading="lazy"></iframe>
            </div>
        </div>
    </div>
</main>


<jsp:include page="/compenents/footer.jsp" />


<div class="floating-buttons">
    <div class="float-btn phone">
        <i class="fas fa-phone"></i>
    </div>
    <div class="float-btn messenger">
        <i class="fab fa-facebook-messenger"></i>
    </div>
</div>
</body>
</html>
