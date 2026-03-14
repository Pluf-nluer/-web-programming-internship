<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ page import="com.example.backend.service.CategoryService" %>
<%@ page import="com.example.backend.model.Category" %>
<%@ page import="java.util.List" %>

<%
    
    if (request.getAttribute("categories") == null) {
        try {
            com.example.backend.service.CategoryService service = new com.example.backend.service.CategoryService();
            List<com.example.backend.model.Category> list = service.getAllCategories();

            
            System.out.println("DEBUG Category List Size: " + (list != null ? list.size() : "null"));

            request.setAttribute("categories", list);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
%>
<div class="hero-section-container">
    <section class="hero">
        <div class="hero-content">
            <h1>${not empty pageTitle ? pageTitle : 'Trang chủ'}</h1>
            <div class="breadcrumb">
                <a href="${pageContext.request.contextPath}/">Trang chủ</a>
                <c:if test="${not empty breadcrumbText}">
                    / ${breadcrumbText}
                </c:if>
            </div>
        </div>
    </section>

    <div class="categories-wrapper">
        <button id="prevButton" class="nav-button prev-button">&#8249;</button>
        <div class="categories" id="categoriesContainer">
            <c:if test="${empty categories}"><p style="text-align: center; width: 100%;">Không tìm thấy sản phẩm
                nào.</p>
            </c:if>
            <c:forEach items="${categories}" var="c">
                <div class="category-item" data-category="${c.id}">
                    <div class="category-circle">
                        <img src="${c.imageUrl}" alt="Đồ mây tre đan">
                    </div>
                    <div class="category-name">${c.name}</div>
                </div>
            </c:forEach>
        </div>
        <button id="nextButton" class="nav-button next-button">&#8250;</button>
    </div>
</div>

<script src="${pageContext.request.contextPath}/js/hero-section.js"></script>
