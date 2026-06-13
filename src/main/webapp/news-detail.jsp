<%@ page contentType="text/html; charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<fmt:setLocale value="vi_VN" />

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chi tiết tin tức</title>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/news-detail.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/header.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/footer.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/hero-section.css">
</head>
<body>
<c:set var="activeTab" value="news" scope="request"/>
<%@ include file="compenents/header.jsp" %>
<c:set var="pageTitle" value="Chi tiết tin tức" scope="request"/>
<c:set var="breadcrumbText" value="<a href='${pageContext.request.contextPath}/news'>Tin tức</a> / Chi tiết" scope="request"/>
<jsp:include page="compenents/hero-section.jsp"/>
<section class="news-detail">
    <div class="news-layout">
        <main class="main-content">
            <c:choose>
                <c:when test="${not empty errorMessage}">
                    <div class="error-message-container">
                        <i class="fa-regular fa-face-frown-open error-icon"></i>
                        <h2>Lỗi tin tức ${errorMessage}</h2>
                        <a href="${pageContext.request.contextPath}/news" class="read-more">Quay lại xem tin tức</a>
                    </div>
                </c:when>
                <c:otherwise>
                    <article>
                        <h2>${post.title}</h2>
                        <span class="post-meta">
                            <i class="fa-regular fa-calendar-days"></i>
                            <fmt:formatDate value="${post.createdAt}" pattern="dd 'tháng' MM 'năm' yyyy"/>
                        </span>
                        <div class="post-image-wrapper">
                            <img src="${post.featuredImageUrl}" alt="${post.title}" class="post-featured-image">
                        </div>
                        <div class="post-content">${post.content}</div>
                    </article>
                </c:otherwise>
            </c:choose>
        </main>
        <div class="sidebar">
            <div class="news-hot">
                <h2>Tin tức nổi bậc</h2>
                <div class="post-list">
                    <c:forEach var="fp" items="${featuredPosts}">
                        <div class="post-item">
                            <a href="news-detail?id=${fp.id}" class="news-hot-image">
                                <img src="${fp.featuredImageUrl}" alt="${fp.title}">
                            </a>
                            <div class="news-hot-title">
                                <a href="news-detail?id=${fp.id}">${fp.title}</a>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </div>
        </div>
    </div>
</section>
<c:if test="${empty errorMessage}">
    <section class="news-down">
        <div class="news-relate">
            <h2>Tin tức liên quan</h2>
        </div>
        <div class="news-relate-grid">
            <c:forEach var="relate" items="${featuredPosts}" begin="0" end="2">
                <div class="news-card">
                    <div class="news-image">
                        <a href="news-detail?id=${relate.id}">
                            <img src="${relate.featuredImageUrl}" alt="${relate.title}">
                        </a>
                    </div>
                    <div class="news-text">
                        <span><fmt:formatDate value="${relate.createdAt}" pattern="dd/MM/yyyy"/></span>
                        <h3><a href="news-detail?id=${relate.id}">${relate.title}</a></h3>
                        <p>${relate.content}</p>
                        <a href="news-detail?id=${relate.id}" class="read-more">Xem thêm</a>
                    </div>
                </div>
            </c:forEach>
        </div>
    </section>
</c:if>
<%@ include file="compenents/footer.jsp" %>
<script src="${pageContext.request.contextPath}/js/hero-section.js"></script>
</body>
</html>
