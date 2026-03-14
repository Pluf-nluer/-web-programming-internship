<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/header.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/footer.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/hero-section.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/search.css">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>
  <title>Trang tìm kiếm | Suncraft</title>
</head>
<body>

<%@ include file="compenents/header.jsp" %>
<c:set var="pageTitle" value="Trang tìm kiếm" scope="request"/>
<c:set var="breadcrumbText"
       value="<a href='${pageContext.request.contextPath}/search.jsp'>Tìm kiếm</a>"
       scope="request"/>
<jsp:include page="compenents/hero-section.jsp"/>

<main class="search-page-container">
  <div class="search-results-header">
    <h3>Có ${totalResults != null ? totalResults : '45'} kết quả tìm kiếm phù hợp</h3>
  </div>

  <div class="product-grid-container">
    
    <c:forEach var="product" items="${productList}">
      <div class="product-card">
        <a href="${pageContext.request.contextPath}/productDetail?id=${product.id}" class="product-link">
          <div class="product-image-wrapper">
            <img src="${product.image}" alt="${product.name}">
            <c:if test="${product.discount > 0}">
              <span class="discount-badge">Giảm ${product.discount}%</span>
            </c:if>
          </div>
          <div class="product-info">
            <p class="product-name">${product.name}</p>
            <p class="product-price">
              <fmt:formatNumber value="${product.price}" type="currency" currencySymbol="đ" maxFractionDigits="0"/>
              <c:if test="${product.oldPrice > 0}">
                <span class="original-price"><fmt:formatNumber value="${product.oldPrice}" type="currency" currencySymbol="đ" maxFractionDigits="0"/></span>
              </c:if>
            </p>
          </div>
        </a>
      </div>
    </c:forEach>

    
    <c:if test="${empty productList}">
      <div class="product-card">
        <a href="${pageContext.request.contextPath}/productdetail" class="product-link">
          <div class="product-image-wrapper">
            <img src="https://bizweb.dktcdn.net/thumb/large/100/485/241/products/3-64a2c56a-11a5-4424-8178-0e98031e42c5.jpg" alt="Khay mứt">
          </div>
          <div class="product-info">
            <p class="product-name">Khay mứt 5 ngăn - Viền chỉ vàng</p>
            <p class="product-price">847.000đ</p>
          </div>
        </a>
      </div>
      
    </c:if>
  </div>

  
  <nav class="pagination-container" aria-label="Pagination">
    <ul class="pagination">
      <li class="page-item active"><a class="page-link" href="?page=1">1</a></li>
      <li class="page-item"><a class="page-link" href="?page=2">2</a></li>
      <li class="page-item"><a class="page-link" href="#">&rsaquo;</a></li>
    </ul>
  </nav>
</main>

<%@ include file="compenents/footer.jsp" %>

<script src="${pageContext.request.contextPath}/js/main.js"></script>
</body>
</html>