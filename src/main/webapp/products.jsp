<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sản phẩm | Nhóm 10</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/products.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/header.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/footer.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/hero-section.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>
</head>
<body>
<c:set var="activeTab" value="products" scope="request"/>
<%@ include file="compenents/header.jsp" %>
<c:set var="pageTitle" value="Sản phẩm" scope="request"/>
<c:set var="breadcrumbText"
       value="<a href='${pageContext.request.contextPath}/products'>Sản phẩm</a>"
       scope="request"/>
<jsp:include page="compenents/hero-section.jsp" />

<div class="products-wrapper">
    <section class="filter-bar">
        <div class="filter-controls">
            <form action="products" method="GET" id="filterForm">
                <select name="category_id" id="category" onchange="this.form.submit()">
                    <option value="">Tất cả danh mục</option>
                    <c:forEach items="${categoryList}" var="cat">
                        
                        <option value="${cat.id}" ${param.category_id == cat.id ? 'selected' : ''}>
                                ${cat.name}
                        </option>
                    </c:forEach>
                </select>
            </form>
        </div>

        <div class="sort-control">
            <span id="sor">Sắp xếp: </span>
            <button type="button" class="sort-btn">
                <i class="fa-solid fa-arrow-up-right-dots"></i>
                <span>Giá tăng dần</span>
            </button>
            <button type="button" class="sort-btn">
                <i class="fa-solid fa-chart-line"></i>
                <span>Giá giảm dần</span>
            </button>
        </div>
    </section>

    <main class="product-list">
        <div class="container">
            <div class="product-grid">
                <c:if test="${empty productList}">
                    <p style="text-align: center; width: 100%;">Không tìm thấy sản phẩm nào.</p>
                </c:if>
                <c:forEach items="${productList}" var="p">
                    <div class="product-card">
                        <a href="${pageContext.request.contextPath}/productdetail?id=${p.id}" class="product-link">
                            <div class="product-img">
                                <c:if test="${p.price > 0}">
                                </c:if>
                                <img src="${p.imageUrl}" alt="${p.name}">
                            </div>
                            <div class="product-info">
                                <h3><c:out value="${p.name}" /></h3>
                                <div class="price-container">
                                    <fmt:setLocale value="vi_VN"/>
                                    <c:choose>
                                        <c:when test="${p.discountPercent > 0}">
                                            
                                            <span class="price-sale" style="color:red;">
                                                <fmt:formatNumber value="${p.price * (1 - p.discountPercent)}" type="currency" currencySymbol="đ" />
                                            </span>
                                            <del><fmt:formatNumber value="${p.price}" type="currency" currencySymbol="đ"/></del>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="price">
                                                <fmt:formatNumber value="${p.price}" type="currency" currencySymbol="đ"/>
                                            </span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </a>
                    </div>
                </c:forEach>

            </div>
        </div>
        <div class="pagination-area">
            <nav aria-label="Page navigation">
                <ul class="pagination">
                    
                    <c:if test="${currentPage > 1}">
                        <li class="page-item">
                            <a class="page-link" href="products?page=${currentPage - 1}${not empty paramCid ? '&category_id='.concat(paramCid) : ''}">&laquo;</a>
                        </li>
                    </c:if>

                    <c:forEach begin="1" end="${totalPages}" var="i">
                        <c:choose>
                            
                            <c:when test="${i == 1 || i == totalPages || (i >= currentPage - 2 && i <= currentPage + 2)}">
                                <li class="page-item ${currentPage == i ? 'active' : ''}">
                                    <a class="page-link" href="products?page=${i}${not empty paramCid ? '&category_id='.concat(paramCid) : ''}">${i}</a>
                                </li>
                            </c:when>

                            
                            <c:when test="${i == currentPage - 3 || i == currentPage + 3}">
                                <li class="page-item disabled"><span class="page-link">...</span></li>
                            </c:when>
                        </c:choose>
                    </c:forEach>

                    
                    <c:if test="${currentPage < totalPages}">
                        <li class="page-item">
                            <a class="page-link" href="products?page=${currentPage + 1}${not empty paramCid ? '&category_id='.concat(paramCid) : ''}">&raquo;</a>
                        </li>
                    </c:if>
                </ul>
            </nav>
        </div>
    </main>
</div>

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
        <form action="${pageContext.request.contextPath}/products" method="GET" class="search-form">
            <input type="text" name="search" id="ajaxSearchInput"
                   placeholder="Nhập tên sản phẩm..." autocomplete="off">
            <button type="submit" style="background: none; border: none; cursor: pointer;">
                <i class="fa-solid fa-magnifying-glass search-icon"></i>
            </button>
        </form>

        <h3 id="searchTitle">Sản phẩm gợi ý</h3>

        <div class="search-results-list" id="searchResultArea">
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