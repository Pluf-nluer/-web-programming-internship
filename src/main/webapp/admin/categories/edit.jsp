<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <title>Chỉnh sửa danh mục: ${category.name}</title>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/admin/css/admin-dashboard.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/admin/css/categories-list.css">
</head>
<body>
<main class="admin-dashboard-main">
  <div class="admin-dashboard-container">
    
    <jsp:include page="/admin/components/sidebar.jsp">
      <jsp:param name="activePage" value="categories" />
    </jsp:include>

    <div class="admin-content">
      <div class="page-header">
        <h1>Chỉnh sửa danh mục</h1>
        <a href="${pageContext.request.contextPath}/admin/categories" class="btn-cancel">
          <i class="fa-solid fa-arrow-left"></i> Quay lại
        </a>
      </div>

      <div class="form-card">
        <form action="${pageContext.request.contextPath}/admin/categories" method="post" enctype="multipart/form-data" class="category-form">
          
          <input type="hidden" name="action" value="update">
          <input type="hidden" name="id" value="${category.id}">

          <div class="form-grid">
            <div class="form-group full-width">
              <label>Tên danh mục <span class="required">*</span></label>
              <input type="text" name="category_name" value="${category.name}" required>
            </div>

            <div class="form-group">
              <label>Trạng thái</label>
              <select name="status">
                <option value="active" ${category.status == 'active' ? 'selected' : ''}>Hiển thị</option>
                <option value="inactive" ${category.status == 'inactive' ? 'selected' : ''}>Ẩn</option>
              </select>
            </div>

            <div class="form-group">
              <label>Chương trình Sale áp dụng</label>
              <div style="display: flex; flex-direction: column; gap: 15px; margin-top: 10px;">

                <div style="display: flex; align-items: flex-start; gap: 10px;">
                  <input type="radio" name="sale_option" value="existing" id="opt-existing"
                  ${not empty category.sale_id ? 'checked' : ''} style="margin-top: 5px;">
                  <div style="flex: 1;">
                    <label for="opt-existing" style="font-weight: 600; cursor: pointer;">Sử dụng mã giảm giá có sẵn</label>
                    <select name="sale_id" class="form-control" style="margin-top: 5px; width: 100%;">
                      <option value="">-- Chọn mã trong danh sách --</option>
                      <c:forEach var="s" items="${salesList}">
                        <option value="${s.id}" ${category.sale_id == s.id ? 'selected' : ''}>
                          Giảm ${s.discountPercent * 100}% (ID: ${s.id})
                        </option>
                      </c:forEach>
                    </select>
                  </div>
                </div>

                <hr style="border: 0; border-top: 1px solid var(--admin-border-subtle); margin: 5px 0;">

                <div style="display: flex; align-items: flex-start; gap: 10px;">
                  <input type="radio" name="sale_option" value="new" id="opt-new"
                  ${empty category.sale_id ? 'checked' : ''} style="margin-top: 5px;">
                  <div style="flex: 1; border: 1px dashed var(--admin-border-subtle); padding: 15px; border-radius: 8px; background: var(--admin-surface-alt);">
                    <label for="opt-new" style="font-weight: 600; color: var(--admin-accent); cursor: pointer;">
                      <i class="fa-solid fa-plus-circle"></i> Hoặc tạo mã mới nhanh
                    </label>
                    <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 12px; margin-top: 10px;">
                      <div class="form-group">
                        <label style="font-size: 11px;">Mã số (ID)</label>
                        <input type="number" name="new_sale_id" placeholder="VD: 102">
                      </div>
                      <div class="form-group">
                        <label style="font-size: 11px;">% giảm</label>
                        <input type="number" name="new_sale_percent" placeholder="VD: 20">
                      </div>
                      <div class="form-group">
                        <label style="font-size: 11px;">Ngày bắt đầu</label>
                        <input type="datetime-local" name="new_sale_start">
                      </div>
                      <div class="form-group">
                        <label style="font-size: 11px;">Ngày kết thúc</label>
                        <input type="datetime-local" name="new_sale_end">
                      </div>
                    </div>
                  </div>
                </div>
              </div>
              <small style="display: block; margin-top: 10px;">ID sale hiện tại gắn với danh mục: <strong>${category.sale_id}</strong></small>
            </div>

            <div class="form-group full-width">
              <label>Ảnh đại diện hiện tại</label>
              <c:if test="${not empty category.imageUrl}">
                <img src="${category.imageUrl}" alt="Category Image" style="width: 100px; margin-bottom: 10px; border-radius: 5px;">
              </c:if>
              <input type="file" name="category_image" accept="image/*">
            </div>
          </div>

          <div class="form-actions" style="margin-top: 20px;">
            <button type="submit" class="btn-submit"><i class="fa-solid fa-save"></i> Cập nhật thay đổi</button>
          </div>
        </form>
      </div>
    </div>
  </div>
</main>
</body>
</html>