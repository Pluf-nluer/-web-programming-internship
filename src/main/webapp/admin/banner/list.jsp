<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Quản lý Banner & Slider - Admin</title>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/admin/css/admin-dashboard.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/admin/css/banner-list.css">
</head>
<body>
<main class="admin-dashboard-main">
  <div class="admin-dashboard-container">

    
    <jsp:include page="/admin/components/sidebar.jsp">
      <jsp:param name="activePage" value="banner" />
    </jsp:include>

    <div class="admin-content">
      <div class="page-header">
        <div class="header-left">
          <h1>Quản lý Banner & Slider</h1>
          <p>Tổng cộng <strong>${bannersCount != null ? bannersCount : 12} banner</strong></p>
        </div>
        <div class="header-right">
          <a href="#add-banner-form" class="btn-add-banner">
            <i class="fa-solid fa-plus"></i> Thêm banner mới
          </a>
        </div>
      </div>

      <div class="banner-form-section" id="add-banner-form">
        <div class="form-card">
          <div class="form-header">
            <h3><i class="fa-solid fa-plus-circle"></i> Thêm banner mới</h3>
            <a href="#" class="btn-close-form"><i class="fa-solid fa-times"></i></a>
          </div>
          <form action="${pageContext.request.contextPath}/admin/banners" method="post" enctype="multipart/form-data" class="banner-form">
            <div class="form-section">
              <h4 class="section-title"><i class="fa-solid fa-image"></i> Hình ảnh & Thông tin</h4>
              <div class="form-grid">
                <div class="form-group full-width">
                  <label for="banner-image">Upload ảnh <span class="required">*</span></label>
                  <input type="file" id="banner-image" name="banner_image" accept="image/*" required>
                </div>
                <div class="form-group full-width">
                  <label for="banner-title">Tiêu đề <span class="required">*</span></label>
                  <input type="text" id="banner-title" name="title" required>
                </div>
                <div class="form-group">
                  <label for="banner-position">Vị trí hiển thị <span class="required">*</span></label>
                  <select id="banner-position" name="position" required>
                    <option value="home_slider">Slider trang chủ</option>
                    <option value="home_banner">Banner trang chủ</option>
                    <option value="sidebar">Sidebar</option>
                  </select>
                </div>
                <div class="form-group">
                  <label for="banner-status">Trạng thái</label>
                  <select id="banner-status" name="status">
                    <option value="active">Kích hoạt</option>
                    <option value="inactive">Vô hiệu hóa</option>
                  </select>
                </div>
              </div>
            </div>

            <div class="form-actions">
              <button type="submit" class="btn-submit"><i class="fa-solid fa-check"></i> Lưu banner</button>
              <button type="reset" class="btn-reset">Đặt lại</button>
            </div>
          </form>
        </div>
      </div>

      <div class="banners-list-section">
        
        <div class="banner-category-section">
          <div class="category-header">
            <h2><i class="fa-solid fa-sliders"></i> Slider trang chủ</h2>
          </div>

          
          <c:forEach var="banner" items="${bannerList}">
            <div class="banner-item">
              <div class="banner-image">
                <img src="${banner.imageUrl}" alt="${banner.title}">
              </div>
              <div class="banner-details">
                <div class="banner-info">
                  <h3>${banner.title}</h3>
                  <div class="banner-meta">
                    <span class="meta-item"><i class="fa-solid fa-link"></i> ${banner.link}</span>
                    <span class="meta-item">
                                                <i class="fa-solid fa-calendar"></i>
                                                <fmt:formatDate value="${banner.startDate}" pattern="dd/MM/yyyy"/>
                                            </span>
                  </div>
                  <div class="banner-status-info">
                      
                    <span class="status-badge status-${banner.status}">
                        ${banner.status == 'active' ? 'Đang kích hoạt' : 'Vô hiệu hóa'}
                    </span>
                  </div>
                </div>
                <div class="banner-actions">
                  <a href="edit?id=${banner.id}" class="btn-action btn-edit"><i class="fa-solid fa-edit"></i></a>
                  <button class="btn-action btn-delete" onclick="handleDelete(${banner.id})">
                    <i class="fa-solid fa-trash"></i>
                  </button>
                </div>
              </div>
            </div>
          </c:forEach>
        </div>
      </div>
    </div>
  </div>
</main>

<script>
  function handleDelete(id) {
    if(confirm('Bạn có chắc chắn muốn xóa banner này?')) {
      window.location.href = 'delete?id=' + id;
    }
  }
</script>
</body>
</html>