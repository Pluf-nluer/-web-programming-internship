<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link
    rel="stylesheet"
    href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"
    />
    <title>Tin tức</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/news.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/header.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/footer.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/hero-section.css">
</head>
<body>
<c:set var="activeTab" value="news" scope="request"/>
<%@ include file="compenents/header.jsp" %>
<c:set var="pageTitle" value="Tin tức" scope="request"/>
<c:set var="breadcrumbText"
       value="<a href='${pageContext.request.contextPath}/news'>Tin tức</a>"
       scope="request"/>
<jsp:include page="compenents/hero-section.jsp"/>
<section class="container">
    <div class="news-layout">
        <main class="main-content">
            <nav class="filter-tabs">
                <ul>
                    <li><a href="#" class="active">Tất cả</a></li>
                    <li><a href="#">Bộ Trà</a></li>
                    <li><a href="#">Cà phê</a></li>
                    <li><a href="#">Phụ kiện trà - cà phê</a></li>
                </ul>
            </nav>
            <div class="post-gird">
                <c:forEach var="p" items="${posts}">
                    <div class="news-card">
                        <div class="block">
                            <div class="news-image">
                                <a href="news-detail?id=${p.id}">
                                    <img src="${p.featuredImageUrl}" alt="${p.title}">
                                </a>
                            </div>
                            <div class="news-text">
                                <span><fmt:formatDate value="${p.createdAt}" pattern="dd 'tháng' MM 'năm' yyyy"/></span>
                                <h3><a href="news-detail?id=${p.id}" style="text-decoration: none; color: inherit;">${p.title}</a></h3>
                                <p>${p.shortContent}</p>
                                <a href="news-detail?id=${p.id}" class="read-more">Xem thêm</a>
                            </div>
                        </div>
                    </div>
                </c:forEach>

                <c:if test="${empty posts}">
                    <p>Hiện chưa có bài viết nào.</p>
                </c:if>
            </div>
        </main>
        <div class="sidebar">
            <div class="news-category">
                <h2>Danh mục</h2>
                <ul>
                    <li>
                        <a href="#">
                            <span class="items">Phòng ăn</span>
                        </a>
                    </li>
                    <li>
                        <a href="#">
                            <span class="items">Trà - cà phê</span>
                        </a>
                    </li>
                    <li>
                        <a href="#">
                            <span class="items">Nồi sứ dưỡng sinh</span>
                        </a>
                    </li>
                    <li>
                        <a href="#">
                            <span class="items">Sứ dưỡng sinh</span>
                        </a>
                    </li>
                    <li>
                        <a href="#">
                            <span class="items">Phụ kiện bàn ăn</span>
                        </a>
                    </li>
                    <li>
                        <a href="#">
                            <span class="items">Sứ nghệ thuật</span>
                        </a>
                    </li>
                </ul>
            </div>
            <div class="news-hot">
                    <h2>Tin tức nổi bậc</h2>
                    <div class="post-list">
                        <c:forEach var="fp" items="${featuredPosts}">
                            <div class="post-item">
                                <a href="news-detail?id=${fp.id}" class="news-hot-image">
                                    <img src="${fp.featuredImageUrl}" alt="${fp.title}" >
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
<%@include file="compenents/footer.jsp"%>
<script src="${pageContext.request.contextPath}/js/hero-section.js"></script>
<input type="checkbox" id="search-toggle" class="hidden-checkbox">

<label for="search-toggle" class="search-overlay"></label>

<div id="search-panel">
    <div class="search-panel-header">
        <label for="search-toggle" class="close-search-label">
            <i class="fa-solid fa-xmark"></i>
        </label>
    </div>

    <div class="search-panel-content">
        <form action = "${pageContext.request.contextPath}/products" method="GET" class="search-form">
            <input type="text" name = "search" id = "ajaxSearchInput" autocomplete="off" placeholder="Nhập tên sản phẩm...">
            <button type="submit" style="background: none; border: none; cursor: pointer;">
            <i class="fa-solid fa-magnifying-glass search-icon"></i>
            </button>
        </form>

        <h3 id="searchTitle">Sản phẩm gợi ý</h3>

        <div class="search-results-list">
        </div>
    </div>
</div>
<script>
    document.addEventListener("DOMContentLoaded", function() {
        const searchInput = document.getElementById("ajaxSearchInput");
        const resultArea = document.getElementById("searchResultArea");
        const searchTitle = document.getElementById("searchTitle");
        searchInput.addEventListener("input", function() {
            const keyword = this.value.trim();
            if (keyword.length >= 1) {
                searchTitle.innerText = "Kết quả gợi ý cho: '" + keyword + "'";
                fetch("${pageContext.request.contextPath}/search-ajax?keyword=" + encodeURIComponent(keyword))
                    .then(response => response.text())
                    .then(data => {
                        resultArea.innerHTML = data;
                    })
                    .catch(err => console.error("Lỗi tìm kiếm AJAX:", err));
            } else {
                searchTitle.innerText = "Sản phẩm gợi ý";
                resultArea.innerHTML = "";
            }
        });
    });
</script>
</body>
</html>