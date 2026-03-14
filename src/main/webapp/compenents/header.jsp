<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<header id="header">
  <div class="container">
    <a href="${pageContext.request.contextPath}/" class="logo">
      <img src="https://suncraft.com.vn/suncraft/Suncraft_website_Inf/suncraft_logo/e6e59529-b1df-4676-a5b2-f3757e67957e.png"
           alt="Logo Suncraft">
    </a>
    <div class="menu">
      <li class="nav-item">
        <a href="${pageContext.request.contextPath}/"
           class="${activeTab == 'home' ? 'active' : ''}">Trang chủ</a>
      </li>
      <li class="nav-item">
        <a href="${pageContext.request.contextPath}/about.jsp"
           class="${activeTab == 'about' ? 'active' : ''}">Giới thiệu</a>
      </li>

      <li class="nav-item list-product">
        <a href="${pageContext.request.contextPath}/products"
           class="caret-down a ${activeTab == 'products' ? 'active' : ''}">
          Sản phẩm <i class="fa-solid fa-caret-down"></i>
        </a>
        <div class="dropdown">
          <div class="product-items">
            <div class="menu-product-item">
              <h4><a href="#">Đồ mây tre đan</a></h4>
              <ul>
                <li><a href="#">Giỏ</a></li>
                <li><a href="#">Đèn tre</a></li>
                <li><a href="#">Túi cói</a></li>
              </ul>
            </div>
            <div class="menu-product-item">
              <h4><a href="#">Gốm sứ</a></h4>
              <ul>
                <li><a href="#">Bình</a></li>
                <li><a href="#">Ấm chén</a></li>
                <li><a href="#">Tượng gốm</a></li>
              </ul>
            </div>
            <div class="menu-product-item">
              <h4><a href="#">Đồ gỗ mỹ nghệ</a></h4>
              <ul>
                <li><a href="#">Tượng</a></li>
                <li><a href="#">Hộp</a></li>
                <li><a href="#">Khung ảnh</a></li>
              </ul>
            </div>
            <div class="menu-product-item">
              <h4><a href="#">Dệt thêu & may mặc</a></h4>
              <ul>
                <li><a href="#">Khăn</a></li>
                <li><a href="#">Túi</a></li>
                <li><a href="#">Áo thổ cẩm</a></li>
              </ul>
            </div>
            <div class="menu-product-item">
              <h4><a href="#">Trang sức & phụ kiện</a></h4>
              <ul>
                <li><a href="#">Vòng</a></li>
                <li><a href="#">Dây chuyền</a></li>
                <li><a href="#">Nhẫn</a></li>
              </ul>
            </div>
            <div class="menu-product-item">
              <h4><a href="#">Quà tặng nghệ thuật</a></h4>
              <ul>
                <li><a href="#">Nến</a></li>
                <li><a href="#">Thiệp 3D</a></li>
                <li><a href="#">Tranh giấy</a></li>
              </ul>
            </div>
          </div>
          <div class="dropdown-image">
            <img width="300"
                 src="https://bizweb.dktcdn.net/100/485/241/themes/911577/assets/megamenu_banner.png?1758008990171"
                 alt="Gốm sứ Bát Tràng">
          </div>
        </div>
      </li>
      <li class="nav-item">
        <a href="${pageContext.request.contextPath}/news"
           class="${activeTab == 'news' ? 'active' : ''}">Tin tức</a>
      </li>
      <li class="nav-item">
        <a href="${pageContext.request.contextPath}/contact"
           class="${activeTab == 'contact' ? 'active' : ''}">Liên hệ</a>
      </li>
    </div>
    <div class="others">
      <div class="icon">
        <label for="search-toggle" class="search-toggle-label">
          <i class="fa-solid fa-magnifying-glass"></i>
        </label>
      </div>
      <div class="icon user-menu-container">
        <a href="${pageContext.request.contextPath}/login" class="icon">
          <i class="fa-regular fa-user"></i>
        </a>
        <% if (session.getAttribute("user") != null) { %>
        <div class="user-dropdown">
          <div class="user-info-header">
            <span>Xin chào, <strong>${sessionScope.user.fullName}</strong></span>
          </div>
          <hr>
          <ul>
            <li><a href="${pageContext.request.contextPath}/account/dashboard.jsp"><i
                    class="fa-regular fa-address-card"></i> Thông tin cá nhân</a></li>
            <li><a href="${pageContext.request.contextPath}/logout" class="logout-link"><i
                    class="fa-solid fa-right-from-bracket"></i> Đăng xuất</a></li>
          </ul>
        </div>
        <% } %>
      </div>

      <a href="${pageContext.request.contextPath}/shopping-cart.jsp" class="icon badge">
        <i class="fa-solid fa-cart-shopping"></i>
        <span>${sessionScope.cart != null ? sessionScope.cart.totalQuantity : 0}</span>
      </a>
    </div>
  </div>
</header>
<jsp:include page="/compenents/overlay-disable.jsp"/>