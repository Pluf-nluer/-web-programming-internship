<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<%
  String currentUri = request.getRequestURI();
%>

<aside class="dashboard-sidebar">
  <div class="sidebar-header">
    <div class="user-avatar">
      <i class="fa-solid fa-user"></i>
    </div>
    <h3>${sessionScope.user.fullName}</h3>
    <p>${sessionScope.user.email}</p>
  </div>

  <nav class="sidebar-menu">
    <a href="${pageContext.request.contextPath}/account/dashboard.jsp"
       class="menu-item <%= currentUri.contains("dashboard.jsp") ? "active" : "" %>">
      <i class="fa-solid fa-gauge"></i>
      <span>Bảng điều khiển</span>
    </a>

    <a href="${pageContext.request.contextPath}/account/order.jsp"
       class="menu-item <%= currentUri.contains("order.jsp") ? "active" : "" %>">
      <i class="fa-solid fa-box"></i>
      <span>Đơn hàng</span>
    </a>

    <a href="${pageContext.request.contextPath}/account/wishlist.jsp"
       class="menu-item <%= currentUri.contains("wishlist.jsp") ? "active" : "" %>">
      <i class="fa-solid fa-heart"></i>
      <span>Sản phẩm yêu thích</span>
    </a>

    <a href="${pageContext.request.contextPath}/account/account-profile.jsp"
       class="menu-item <%= currentUri.contains("account-profile.jsp") ? "active" : "" %>">
      <i class="fa-solid fa-user-circle"></i>
      <span>Thông tin</span>
    </a>

    <a href="${pageContext.request.contextPath}/change-password"
       class="menu-item <%= currentUri.contains("change-password") ? "active" : "" %>">
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