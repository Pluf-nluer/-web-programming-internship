<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<c:set var="currentUri" value="${pageContext.request.requestURI}" />

<aside class="dashboard-sidebar">
  <div class="sidebar-header">
    <div class="user-avatar">
      <i class="fa-solid fa-user"></i>
    </div>
    <h3><c:out value="${sessionScope.user.fullName}" /></h3>
    <p><c:out value="${sessionScope.user.email}" /></p>
  </div>

  <nav class="sidebar-menu">
    <a href="${pageContext.request.contextPath}/account/dashboard.jsp"
       class="menu-item ${fn:contains(currentUri, 'dashboard.jsp') ? 'active' : ''}">
      <i class="fa-solid fa-gauge"></i>
      <span>Bảng điều khiển</span>
    </a>

    <a href="${pageContext.request.contextPath}/account/order.jsp"
       class="menu-item ${fn:contains(currentUri, '/account/order') ? 'active' : ''}">
      <i class="fa-solid fa-box"></i>
      <span>Đơn hàng</span>
    </a>

    <a href="${pageContext.request.contextPath}/account/wishlist.jsp"
       class="menu-item ${fn:contains(currentUri, 'wishlist.jsp') ? 'active' : ''}">
      <i class="fa-solid fa-heart"></i>
      <span>Sản phẩm yêu thích</span>
    </a>

    <a href="${pageContext.request.contextPath}/profile"
       class="menu-item ${fn:contains(currentUri, 'profile') ? 'active' : ''}">
      <i class="fa-solid fa-user-circle"></i>
      <span>Thông tin</span>
    </a>

    <a href="${pageContext.request.contextPath}/change-password"
       class="menu-item ${fn:contains(currentUri, 'change-password') ? 'active' : ''}">
      <i class="fa-solid fa-key"></i>
      <span>Đổi mật khẩu</span>
    </a>

    <a href="${pageContext.request.contextPath}/logout" class="menu-item logout" onclick="return confirm('Bạn có chắc muốn đăng xuất?')">
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