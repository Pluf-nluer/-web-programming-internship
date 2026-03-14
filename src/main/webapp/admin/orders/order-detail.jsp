<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chi tiết đơn hàng #DH2547</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/admin/css/admin-dashboard.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/admin/css/orders-detail.css">
</head>

<body>
<main class="admin-dashboard-main">
    <div class="admin-dashboard-container">
        
        <aside class="admin-sidebar">
            <div class="sidebar-header">
                <div class="admin-logo">
                    <i class="fa-solid fa-user-shield"></i>
                </div>
                <h2>Bảng quản lý Website</h2>
                <p>Quản trị viên</p>
            </div>

            <nav class="admin-menu">
                <a href="${pageContext.request.contextPath}/admin/dashboard" class="admin-menu-item">
                    <i class="fa-solid fa-chart-line"></i>
                    <span>Bảng điều khiển</span>
                </a>
                <a href="${pageContext.request.contextPath}/admin/products" class="admin-menu-item">
                    <i class="fa-solid fa-box"></i>
                    <span>Quản lý sản phẩm</span>
                </a>
                <a href="${pageContext.request.contextPath}/admin/order-list.jsp" class="admin-menu-item active">
                    <i class="fa-solid fa-shopping-cart"></i>
                    <span>Quản lý đơn hàng</span>
                </a>
                <a href="${pageContext.request.contextPath}/admin/customers" class="admin-menu-item">
                    <i class="fa-solid fa-users"></i>
                    <span>Quản lý khách hàng</span>
                </a>
                <a href="${pageContext.request.contextPath}/admin/reviews" class="admin-menu-item">
                    <i class="fa-solid fa-star"></i>
                    <span>Quản lý đánh giá</span>
                </a>
                <a href="${pageContext.request.contextPath}/admin/categories" class="admin-menu-item">
                    <i class="fa-solid fa-folder-tree"></i>
                    <span>Quản lý danh mục</span>
                </a>
                <a href="${pageContext.request.contextPath}/admin/contact" class="admin-menu-item">
                    <i class="fa-solid fa-envelope"></i>
                    <span>Quản lý liên hệ</span>
                </a>
                <a href="${pageContext.request.contextPath}/admin/blog" class="admin-menu-item">
                    <i class="fa-solid fa-blog"></i>
                    <span>Blog</span>
                </a>
                <a href="${pageContext.request.contextPath}/admin/banner" class="admin-menu-item">
                    <i class="fa-solid fa-images"></i>
                    <span>Banner & Slider</span>
                </a>
            </nav>
        </aside>

        
        <div class="admin-content">
            
            <div class="page-header-detail">
                <div class="header-left">
                    <a href="${pageContext.request.contextPath}/admin/orders" class="back-link">
                        <i class="fa-solid fa-arrow-left"></i>
                        Quay lại danh sách
                    </a>
                    <div class="order-header-info">
                        <h1>Đơn hàng #${order.id}</h1>
                        <span class="status-badge status-${order.order_status != null ? order.order_status.toLowerCase() : 'pending'}">
                            ${order.order_status}
                        </span>
                    </div>
                    <p class="order-date">
                        Đặt lúc: <fmt:formatDate value="${order.created_at}" pattern="dd/MM/yyyy HH:mm"/>
                    </p>
                </div>
                <div class="header-actions">
                    <button class="btn-action-header btn-print">
                        <i class="fa-solid fa-print"></i>
                        In hóa đơn
                    </button>
                    <button class="btn-action-header btn-shipping-label">
                        <i class="fa-solid fa-file-invoice"></i>
                        Phiếu giao hàng
                    </button>
                </div>
            </div>

            
            <div class="order-detail-layout">
                
                <div class="order-main-column">

                    
                    <div class="detail-section">
                        <div class="section-header">
                            <h2>
                                <i class="fa-solid fa-box-open"></i>
                                Sản phẩm đã đặt
                            </h2>
                        </div>
                        <div class="section-content">
                            <div class="order-items-table">
                                <table>
                                    <thead>
                                    <tr>
                                        <th>Sản phẩm</th>
                                        <th>Đơn giá</th>
                                        <th>Số lượng</th>
                                        <th>Thành tiền</th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    
                                    <c:forEach var="item" items="${details}">
                                        <tr>
                                            <td>
                                                <div class="product-info">
                                                        
                                                    <img src="${item.product.imageUrl}" alt="${item.product.name}"
                                                         onerror="this.src='https://via.placeholder.com/60'">
                                                    <div class="product-details">
                                                            
                                                        <h4>${item.product.name}</h4>
                                                            
                                                        <p>Mã SP: #${item.product.id}</p>
                                                    </div>
                                                </div>
                                            </td>
                                            <td><fmt:formatNumber value="${item.product.price}" type="currency"
                                                                  currencySymbol="₫"/></td>
                                            <td>${item.quantity}</td>
                                            <td>
                                                <strong><fmt:formatNumber value="${item.product.price * item.quantity}"
                                                                          type="currency" currencySymbol="₫"/></strong>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                            <c:set var="shipAmt" value="${order['shipping_fee']}"/>
                            <c:set var="totalAmt" value="${order['total_amount']}"/>
                            <c:set var="subTotalAmt" value="${totalAmt - shipAmt}"/>

                            <div class="order-summary">
                                <div class="summary-row">
                                    <span>Tạm tính:</span>
                                    <span>
                                        <fmt:formatNumber value="${subTotalAmt}" type="currency" currencySymbol="₫"
                                                          maxFractionDigits="0"/>
                                    </span>
                                </div>
                                <div class="summary-row">
                                    <span>Phí vận chuyển:</span>
                                    <span>
                                        <fmt:formatNumber value="${shipAmt}" type="currency" currencySymbol="₫"
                                                          maxFractionDigits="0"/>
                                    </span>
                                </div>
                                <div class="summary-row total">
                                    <span>Tổng cộng:</span>
                                    <span>
                                        <fmt:formatNumber value="${totalAmt}" type="currency" currencySymbol="₫"
                                                          maxFractionDigits="0"/>
                                    </span>
                                </div>
                            </div>
                        </div>
                    </div>

                    
                    <div class="detail-section">
                        <div class="section-header">
                            <h2>
                                <i class="fa-solid fa-message"></i>
                                Ghi chú của khách hàng
                            </h2>
                        </div>
                        <div class="section-content">
                            <div class="note-box">
                                <p>${not empty order.note ? order.note : "Khách hàng không để lại ghi chú."}</p>
                            </div>
                        </div>
                    </div>
                </div>

                
                <div class="order-sidebar-column">

                    
                    <div class="detail-section">
                        <div class="section-header">
                            <h2>
                                <i class="fa-solid fa-sliders"></i>
                                Thao tác
                            </h2>
                        </div>
                        <div class="section-content">
                            <c:if test="${param.status == 'updated'}">
                                <div class="alert-update success">
                                    <i class="fa-solid fa-circle-check"></i> Cập nhật thành công!
                                </div>
                            </c:if>
                            <c:if test="${param.status == 'error'}">
                                <div class="alert-update error">
                                    <i class="fa-solid fa-circle-xmark"></i> Có lỗi xảy ra!
                                </div>
                            </c:if>

                            <form action="${pageContext.request.contextPath}/admin/orders" method="post">
                                <input type="hidden" name="action" value="updateStatus">
                                <input type="hidden" name="order_id" value="${order.id}">

                                <div class="form-group">
                                    <label for="order-status">Cập nhật trạng thái</label>
                                    <select id="order-status" name="order_status">
                                        <option value="Pending" ${order.order_status == 'Pending' ? 'selected' : ''}>Chờ xác nhận</option>
                                        <option value="Confirmed" ${order.order_status == 'Confirmed' ? 'selected' : ''}>Đã xác nhận</option>
                                        <option value="Shipping" ${order.order_status == 'Shipping' ? 'selected' : ''}>Đang giao</option>
                                        <option value="Completed" ${order.order_status == 'Completed' ? 'selected' : ''}>Hoàn thành</option>
                                        <option value="Cancelled" ${order.order_status == 'Cancelled' ? 'selected' : ''}>Đã hủy</option>
                                    </select>
                                </div>
                                <button type="submit" class="btn-update-status">
                                    <i class="fa-solid fa-check"></i> Cập nhật trạng thái
                                </button>
                            </form>
                            <div class="action-buttons">
                                <button class="btn-action-full btn-email">
                                    <i class="fa-solid fa-envelope"></i>
                                    Gửi Email
                                </button>
                            </div>
                        </div>
                    </div>

                    
                    <div class="detail-section">
                        <div class="section-header">
                            <h2>
                                <i class="fa-solid fa-user"></i>
                                Thông tin khách hàng
                            </h2>
                        </div>
                        <div class="section-content">
                            <div class="info-group">
                                <div class="info-item">
                                    <i class="fa-solid fa-user"></i>
                                    <div class="info-details">
                                        <label>Họ và tên</label>
                                        <p>${order.shipping_name}</p>
                                    </div>
                                </div>
                                <div class="info-item">
                                    <i class="fa-solid fa-phone"></i>
                                    <div class="info-details">
                                        <label>Số điện thoại</label>
                                        <p>${order.shipping_phone}</p>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    
                    <div class="detail-section">
                        <div class="section-header">
                            <h2>
                                <i class="fa-solid fa-location-dot"></i>
                                Địa chỉ giao hàng
                            </h2>
                        </div>
                        <div class="section-content">
                            <div class="shipping-address">
                                <p class="address-name"><strong>${order.shipping_name}</strong></p>
                                <p class="address-phone">${order.shipping_phone}</p>
                                <p class="address-text">${order.shipping_address}</p>
                            </div>
                        </div>
                    </div>

                    
                    <div class="detail-section">
                        <div class="section-header">
                            <h2>
                                <i class="fa-solid fa-credit-card"></i>
                                Thanh toán
                            </h2>
                        </div>
                        <div class="section-content">
                            <div class="info-group">
                                <div class="info-row">
                                    <label>Phương thức:</label>
                                    <span class="payment-badge cod">COD</span>
                                </div>
                                <div class="info-row">
                                    <label>Trạng thái:</label>
                                    <span class="payment-status unpaid">Chưa thanh toán</span>
                                </div>
                                <div class="info-row">
                                    <label>Tổng tiền:</label>
                                    <strong class="total-amount"><fmt:formatNumber value="${order.total_amount}"
                                                                                   type="currency"/></strong>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</main>
</body>

</html>