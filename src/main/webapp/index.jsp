<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
    if (request.getAttribute("categories") == null) {
        try {
            com.example.backend.service.CategoryService service = new com.example.backend.service.CategoryService();
            request.setAttribute("categories", service.getAllCategories());
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
%>
<!DOCTYPE html>
<html lang="vi"> <head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/index.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/header.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/footer.css">
    <title>Nhóm 10 | Trang chủ</title>
</head>
<body>
<c:set var="activeTab" value="home" scope="request"/>
<%@ include file="compenents/header.jsp" %>
<main class="component">
    <section class="section_intro">
        <img id="intro-bg"
             src="${not empty banners ? banners[0].image_url.trim() : ''}"
             class="intro-bg-img"
             alt="Background Banner">

        <div class="section_intro-content">
            <h1>Đồ thủ công mỹ nghệ</h1>
            <p>Tinh tế – Mộc mạc – Đậm bản sắc Việt</p>
            <a href="${pageContext.request.contextPath}/products" class="btn">Khám phá ngay</a>
        </div>
    </section>
    <section class="section_danhmuc">
        <div class="container">
            <div class="category-list">
                <c:choose>
                    <c:when test="${not empty categories}">
                        <c:forEach items="${categories}" var="cat">
                            <div class="category-item">
                                <a href="${pageContext.request.contextPath}/products?category_id=${cat.id}">
                                    <div class="category-image-wrapper">
                                        <img src="${cat.imageUrl}" alt="${cat.name}">
                                    </div>
                                    <h3>${cat.name}</h3>

                                </a>
                            </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <p style="text-align: center; width: 100%;">Đang tải danh mục...</p>
                    </c:otherwise>
                </c:choose>
            </div>


        </div>
    </section>

    <section class="news-section">
        <div class="container">
            <div class="section-header">
                <h2>Tin tức mới nhất</h2>
                <p>Cập nhật những tin tức xu hướng mới nhất hiện nay.</p>
            </div>
            <div class="news-grid">
                <c:choose>
                    <c:when test="${not empty posts}">
                        <c:forEach items="${posts}" var="p">
                            <article class="news-card">
                                <div class="card-image-container">
                                    <a href="${pageContext.request.contextPath}/news-detail?id=${p.id}">
                                        <img src="${p.featuredImageUrl}" alt="${p.title}">
                                        <span class="date-badge">
                                        <i class="fa-regular fa-clock"></i>
                                        <fmt:formatDate value="${p.createdAt}" pattern="dd/MM/yyyy" />
                                    </span>
                                    </a>
                                </div>
                                <div class="card-content">
                                    <h3>
                                        <a href="${pageContext.request.contextPath}/news-detail?id=${p.id}">${p.title}</a>
                                    </h3>
                                    <a href="${pageContext.request.contextPath}/news-detail?id=${p.id}" class="read-more">Xem thêm</a>
                                </div>
                            </article>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <p style="text-align: center; width: 100%;">Hiện chưa có bài viết nào.</p>
                    </c:otherwise>
                </c:choose>
            </div>
            <a href="${pageContext.request.contextPath}/news" class="btn-view-all">Xem Tất Cả</a>
        </div>
    </section>
    <script>
        document.addEventListener("DOMContentLoaded", function () {
            const bgImg = document.getElementById('intro-bg');
            if (!bgImg) return;

            const rawImages = [
                <c:forEach var="url" items="${banners}" varStatus="status">
                '${url.image_url}'${!status.last ? ',' : ''}
                </c:forEach>
            ];

            const cleanImages = rawImages
                .map(img => img.replace(/\s/g, ''))
                .filter(img => img !== "");

            if (cleanImages.length === 0) return;

            let currentIndex = 0;

            function updateBanner(index) {
                const url = cleanImages[index];
                bgImg.src = url;
            }

            updateBanner(0);
            if (cleanImages.length > 1) {
                setInterval(() => {
                    currentIndex = (currentIndex + 1) % cleanImages.length;
                    updateBanner(currentIndex);
                }, 5000);
            }
        });
    </script>
</main>
</body>

<%@ include file="compenents/footer.jsp" %>