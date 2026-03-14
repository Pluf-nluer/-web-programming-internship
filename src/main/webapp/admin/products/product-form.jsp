<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>${product != null ? 'Cập nhật sản phẩm' : 'Thêm sản phẩm mới'}</title>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/admin/css/admin-dashboard.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/admin/css/products-edit.css">
</head>

<body>
<main class="admin-dashboard-main">
  <div class="admin-dashboard-container">
    <jsp:include page="/admin/components/sidebar.jsp">
      <jsp:param name="active" value="products" />
    </jsp:include>

    <div class="admin-content">
      <div class="page-header-edit">
        <div class="header-left">
          <a href="${pageContext.request.contextPath}/admin/products" class="back-link">
            <i class="fa-solid fa-arrow-left"></i> Quay lại danh sách
          </a>
          <h1>${product != null ? 'Cập nhật sản phẩm' : 'Thêm sản phẩm mới'}</h1>
        </div>
        <div class="header-actions">
          <button type="submit" form="product-form" class="btn-save">
            <i class="fa-solid fa-check"></i> Lưu sản phẩm
          </button>
        </div>
      </div>

      <form id="product-form" action="${pageContext.request.contextPath}/admin/products" method="post" enctype="multipart/form-data">
        <input type="hidden" name="action" value="${product != null ? 'update' : 'insert'}">
        <c:if test="${product != null}">
          <input type="hidden" name="id" value="${product.id}">
        </c:if>

        <div class="form-layout">
          <div class="form-main-column">

            
            <div class="form-section">
              <div class="section-header"><h2>Thông tin cơ bản</h2></div>
              <div class="section-content">
                <div class="form-group full-width">
                  <label class="required">Tên sản phẩm</label>
                  <input type="text" name="name" value="${product.name}" required placeholder="VD: Bình gốm...">
                </div>
                <div class="form-row three-cols">
                  <div class="form-group">
                    <label class="required">Giá bán (VNĐ)</label>
                    <input type="number" name="price" value="${product.price}" required min="0">
                  </div>
                  <div class="form-group">
                    <label class="required">Tồn kho</label>
                    <input type="number" name="stock" value="${product.stock}" required min="0">
                  </div>
                  <div class="form-group">
                    <label>Danh mục (ID)</label>
                    <input type="number" name="category_id" value="${product != null ? product.categoryId : 1}" required>
                  </div>
                </div>
              </div>
            </div>

            
            <div class="form-section">
              <div class="section-header">
                <h2><i class="fa-solid fa-list-check"></i> Thuộc tính sản phẩm</h2>
              </div>
              <div class="section-content">
                <div class="form-row two-cols">
                  <div class="form-group">
                    <label for="material">Chất liệu</label>
                    <input type="text" id="material" name="material" value="${product.attribute.material}" placeholder="VD: Gốm sứ Bát Tràng">
                  </div>
                  <div class="form-group">
                    <label for="origin">Xuất xứ</label>
                    <input type="text" id="origin" name="origin" value="${product.attribute.origin}" placeholder="VD: Việt Nam">
                  </div>
                </div>
                <div class="form-row three-cols">
                  <div class="form-group">
                    <label for="dimensions">Kích thước (DxRxC)</label>
                    <input type="text" id="dimensions" name="dimensions" value="${product.attribute.size}" placeholder="VD: 20x20x30 cm">
                  </div>
                  <div class="form-group">
                    <label for="weight">Trọng lượng</label>
                    <input type="text" id="weight" name="weight" value="${product.attribute.weight}" placeholder="VD: 1.5 kg">
                  </div>
                  <div class="form-group">
                    <label for="manufacturer">Nhà sản xuất</label>
                    <input type="text" id="manufacturer" name="manufacturer" value="${product.attribute.color}" placeholder="VD: Làng gốm Bát Tràng">
                  </div>
                </div>
              </div>
            </div>

            
            <div class="form-section">
              <div class="section-header"><h2>Mô tả chi tiết</h2></div>
              <div class="section-content">
                <div class="form-group">
                  <textarea name="full_description" rows="6" placeholder="Mô tả chi tiết...">${product.fullDescription}</textarea>
                </div>
              </div>
            </div>

            
            <div class="form-section">
              <div class="section-header"><h2>Hình ảnh sản phẩm</h2></div>
              <div class="section-content">
                <div class="form-group" style="margin-bottom: 15px;">
                  <label>Chọn ảnh từ thiết bị</label>
                  <input type="file" name="image_file" id="image-file" class="form-control" accept="image/*" onchange="previewLocalFile(this)">
                </div>
                <div style="text-align: center; margin: 10px 0; color: #888; font-style: italic;">-- Hoặc nhập liên kết ảnh --</div>
                <div class="form-group">
                  <label>Link ảnh sản phẩm (URL)</label>
                  <input type="text" id="image-url" name="image_url" class="form-control" value="${product.imageUrl}" placeholder="https://..." oninput="document.getElementById('preview-img').src = this.value">
                </div>
                <div style="margin-top: 10px; border: 1px dashed #ccc; padding: 5px; width: 150px; text-align: center; margin-inline: auto;">
                  <img id="preview-img" src="${not empty product.imageUrl ? product.imageUrl : '#'}" alt="Preview" style="max-width: 100%; max-height: 150px;">
                </div>
              </div>
            </div>
          </div>

          <div class="form-sidebar-column">
            <div class="form-section">
              <div class="section-header"><h2>Trạng thái</h2></div>
              <div class="section-content">
                <div class="form-group">
                  <label>Trạng thái bán</label>
                  <select name="status">
                    <option value="active" ${product.status == 'active' ? 'selected' : ''}>Đang bán</option>
                    <option value="inactive" ${product.status == 'inactive' ? 'selected' : ''}>Tạm ngưng</option>
                  </select>
                </div>
                <div class="checkbox-group" style="margin-top: 15px;">
                  <label class="custom-checkbox-container">
                    <input type="checkbox" name="featured" value="1" ${product.featured ? 'checked' : ''}>
                    <span class="checkmark"></span>
                    <span class="label-text">Sản phẩm nổi bật</span>
                  </label>
                </div>
              </div>
            </div>
          </div>
        </div>
      </form>
    </div>
  </div>
</main>

<script>
  function previewLocalFile(input) {
    const file = input.files[0];
    if (file) {
      const reader = new FileReader();
      reader.onload = function(e) {
        document.getElementById('preview-img').src = e.target.result;
        document.getElementById('image-url').value = "";
      }
      reader.readAsDataURL(file);
    }
  }
</script>
</body>
</html>