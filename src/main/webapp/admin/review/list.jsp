<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Quản lý đánh giá - Admin Dashboard</title>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/admin/css/admin-dashboard.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/admin/css/reviews-list.css">
</head>
<body>
<main class="admin-dashboard-main">
  <div class="admin-dashboard-container">

    
    <jsp:include page="/admin/components/sidebar.jsp">
      <jsp:param name="activePage" value="review" />
    </jsp:include>

    <div class="admin-content">
      <div class="page-header">
        <div class="header-left">
          <h1>Quản lý đánh giá</h1>
          <p>Tổng cộng <strong>${totalReviews != null ? totalReviews : 487} đánh giá</strong></p>
        </div>
      </div>

      <div class="statistics-section">
        <div class="stats-grid">
          <div class="stat-card total">
            <div class="stat-icon"><i class="fa-solid fa-star"></i></div>
            <div class="stat-info">
              <h3>${totalReviews != null ? totalReviews : "487"}</h3>
              <p>Tổng đánh giá</p>
            </div>
          </div>

          <div class="stat-card average">
            <div class="stat-icon"><i class="fa-solid fa-chart-line"></i></div>
            <div class="stat-info">
              <h3>${avgRating != null ? avgRating : "4.3"}</h3>
              <p>Điểm trung bình</p>
              <div class="stars">
                <c:forEach begin="1" end="4"><i class="fa-solid fa-star"></i></c:forEach>
                <i class="fa-regular fa-star"></i>
              </div>
            </div>
          </div>

          <div class="stat-card pending">
            <div class="stat-icon"><i class="fa-solid fa-clock"></i></div>
            <div class="stat-info">
              <h3>${pendingCount != null ? pendingCount : "28"}</h3>
              <p>Chờ duyệt</p>
            </div>
          </div>

          <div class="stat-card distribution">
            <h4>Phân bố đánh giá</h4>
            <div class="rating-bars">
              
              <div class="rating-bar-item">
                <span class="rating-label"><i class="fa-solid fa-star"></i> 5 sao</span>
                <div class="rating-bar"><div class="rating-fill" style="width: 65%"></div></div>
                <span class="rating-count">317 (65%)</span>
              </div>
              
            </div>
          </div>
        </div>
      </div>

      <div class="status-tabs">
        <c:set var="currentStatus" value="${param.status != null ? param.status : 'all'}" />
        <a href="?status=all" class="tab-item ${currentStatus == 'all' ? 'active' : ''}">
          <span class="tab-label">Tất cả</span>
        </a>
        <a href="?status=pending" class="tab-item pending ${currentStatus == 'pending' ? 'active' : ''}">
          <span class="tab-label">Chờ duyệt</span>
        </a>
        
      </div>

      <div class="filter-section">
        <form action="${pageContext.request.contextPath}/admin/reviews" method="get" class="filter-form">
          <div class="search-wrapper">
            <i class="fa-solid fa-search"></i>
            <input type="text" name="search" value="${param.search}" placeholder="Tìm kiếm khách hàng, sản phẩm..." class="search-input">
          </div>
          <div class="filter-actions">
            <button type="submit" class="btn-apply-filter"><i class="fa-solid fa-filter"></i> Áp dụng</button>
          </div>
        </form>
      </div>

      <div class="reviews-list-section">
        
        <c:forEach var="review" items="${reviewList}">
          <div class="review-item ${review.status}">
            <div class="review-header">
              <div class="review-customer">
                <div class="customer-avatar"><i class="fa-solid fa-user"></i></div>
                <div class="customer-info">
                  <h4>${review.customerName}</h4>
                  <p>${review.customerEmail}</p>
                </div>
              </div>
              <div class="review-meta">
                <div class="review-rating">
                  <c:forEach begin="1" end="${review.rating}"><i class="fa-solid fa-star"></i></c:forEach>
                  <span class="rating-number">${review.rating}.0</span>
                </div>
                <span class="review-date">${review.createdAt}</span>
                <span class="status-badge status-${review.status}">
                    ${review.status == 'pending' ? 'Chờ duyệt' : (review.status == 'approved' ? 'Đã duyệt' : 'Từ chối')}
                </span>
              </div>
            </div>

            <div class="review-product">
              <div class="product-image"><img src="${review.productImage}" alt="${review.productName}"></div>
              <div class="product-info">
                <h5>${review.productName}</h5>
                <p>Mã: ${review.productCode}</p>
              </div>
            </div>

            <div class="review-content">
              <p>${review.content}</p>
            </div>

            <div class="review-actions">
              <c:if test="${review.status == 'pending'}">
                <button class="btn-action btn-approve" onclick="updateStatus(${review.id}, 'approved')">
                  <i class="fa-solid fa-check"></i> Duyệt
                </button>
              </c:if>
              <button class="btn-action btn-delete" onclick="confirmDelete(${review.id})">
                <i class="fa-solid fa-trash"></i> Xóa
              </button>
            </div>
          </div>
        </c:forEach>

        
        <c:if test="${empty reviewList}">
          <p style="text-align: center; padding: 20px;">Không có đánh giá nào phù hợp.</p>
        </c:if>
      </div>

      <div class="pagination-section">
        <div class="pagination">
          
        </div>
      </div>
    </div>
  </div>
</main>

<script>
  function updateStatus(id, status) {
    if(confirm('Bạn có chắc muốn cập nhật trạng thái này?')) {
      window.location.href = '${pageContext.request.contextPath}/admin/reviews/update?id=' + id + '&status=' + status;
    }
  }

  function confirmDelete(id) {
    if(confirm('Hành động này không thể hoàn tác. Xóa đánh giá này?')) {
      window.location.href = '${pageContext.request.contextPath}/admin/reviews/delete?id=' + id;
    }
  }
</script>
</body>
</html>