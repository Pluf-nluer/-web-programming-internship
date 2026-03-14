<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý đơn hàng</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/admin/css/admin-dashboard.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/admin/css/orders-list.css">
</head>
<body>
    <fmt:setLocale value="vi_VN"/>
    <main class="admin-dashboard-main">
        <div class="admin-dashboard-container">
            <jsp:include page="/admin/components/sidebar.jsp">
                <jsp:param name="active" value="orders" />
            </jsp:include>

            
            <div class="admin-content">
                
                <div class="page-header">
                    <div class="header-left">
                        <h1>Quản lý đơn hàng</h1>
                        <p>Tổng cộng <strong>${orders != null ? orders.size() : 0} đơn hàng</strong></p>
                    </div>
                    <div class="header-right">
                        <button class="btn-export-excel">
                            <i class="fa-solid fa-file-excel"></i>
                            Xuất Excel
                        </button>
                        <button class="btn-export-pdf">
                            <i class="fa-solid fa-file-pdf"></i>
                            Xuất PDF
                        </button>
                    </div>
                </div>

                
                <div class="status-tabs">
                    <a href="#" class="tab-item active">
                        <span class="tab-label">Tất cả</span>
                    </a>
                    <a href="#" class="tab-item pending">
                        <span class="tab-label">Chờ xác nhận</span>
                    </a>
                    <a href="#" class="tab-item confirmed">
                        <span class="tab-label">Đã xác nhận</span>
                    </a>
                    <a href="#" class="tab-item shipping">
                        <span class="tab-label">Đang giao</span>
                    </a>
                    <a href="#" class="tab-item completed">
                        <span class="tab-label">Hoàn thành</span>
                    </a>
                    <a href="#" class="tab-item cancelled">
                        <span class="tab-label">Đã hủy</span>
                    </a>
                    <a href="#" class="tab-item returned">
                        <span class="tab-label">Hoàn trả</span>
                    </a>
                </div>

                
                <div class="filter-section">
                    <form action="${pageContext.request.contextPath}/admin/orders" method="get" class="filter-form">
                        
                        <div class="search-wrapper">
                            <i class="fa-solid fa-search"></i>
                            <input type="text" name="search" value="${param.search}" placeholder="Tìm kiếm theo mã đơn hàng, tên khách hàng, SĐT, email..." class="search-input">
                        </div>

                        
                        <div class="filter-options">
                            
                            <div class="filter-group">
                                <label for="date-from">
                                    <i class="fa-solid fa-calendar"></i>
                                    Từ ngày
                                </label>
                                <input type="date" id="date-from" name="date_from">
                            </div>

                            <div class="filter-group">
                                <label for="date-to">
                                    <i class="fa-solid fa-calendar"></i>
                                    Đến ngày
                                </label>
                                <input type="date" id="date-to" name="date_to">
                            </div>

                            
                            <div class="filter-group">
                                <label for="order-value">
                                    <i class="fa-solid fa-dollar-sign"></i>
                                    Giá trị đơn hàng
                                </label>
                                <select name="order_value" id="order-value">
                                    <option value="">Tất cả</option>
                                    <option value="0-500000">Dưới 500K</option>
                                    <option value="500000-1000000">500K - 1M</option>
                                    <option value="1000000-2000000">1M - 2M</option>
                                    <option value="2000000-5000000">2M - 5M</option>
                                    <option value="5000000+">Trên 5M</option>
                                </select>
                            </div>

                            
                            <div class="filter-group">
                                <label for="payment-method">
                                    <i class="fa-solid fa-credit-card"></i>
                                    Phương thức thanh toán
                                </label>
                                <select name="payment_method" id="payment-method">
                                    <option value="">Tất cả</option>
                                    <option value="cod">Tiền mặt</option>
                                    <option value="momo">Ví MoMo</option>
                                    <option value="vnpay">VNPay</option>
                                </select>
                            </div>

                            
                            <div class="filter-group">
                                <label for="payment-status">
                                    <i class="fa-solid fa-money-check"></i>
                                    Trạng thái thanh toán
                                </label>
                                <select name="payment_status" id="payment-status">
                                    <option value="">Tất cả</option>
                                    <option value="paid">Đã thanh toán</option>
                                    <option value="unpaid">Chưa thanh toán</option>
                                    <option value="refunded">Đã hoàn tiền</option>
                                </select>
                            </div>
                        </div>

                        
                        <div class="filter-actions">
                            <button type="submit" class="btn-apply-filter">
                                <i class="fa-solid fa-filter"></i>
                                Áp dụng
                            </button>
                            <button type="reset" class="btn-reset-filter">
                                <i class="fa-solid fa-rotate-right"></i>
                                Đặt lại
                            </button>
                        </div>
                    </form>
                </div>

                <div class="orders-table-container">
                    <table class="orders-table">
                        <thead>
                        <tr>
                            <th class="col-order-id">MÃ ĐƠN HÀNG</th>
                            <th class="col-customer">KHÁCH HÀNG / LIÊN HỆ</th>
                            <th class="col-total">TỔNG TIỀN</th>
                            <th class="col-payment">THANH TOÁN</th>
                            <th class="col-payment-status">TT THANH TOÁN</th>
                            <th class="col-date">NGÀY ĐẶT</th>
                            <th class="col-status">TRẠNG THÁI</th>
                            <th class="col-actions">THAO TÁC</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="o" items="${orders}">
                            <tr class="order-row">
                                <td class="col-order-id">
                                    <a href="orders?action=detail&id=${o.id}" class="order-id-link">#DH${o.id}</a>
                                </td>

                                <td class="col-customer">
                                    <div class="customer-info-box">
                                        <div class="customer-main">
                                            <i class="fa-solid fa-circle-user"></i>
                                            <strong>${o.shipping_name}</strong>
                                        </div>
                                        <div class="customer-sub">
                                            <span><i class="fa-solid fa-phone"></i> ${o.shipping_phone}</span>
                                        </div>
                                    </div>
                                </td>

                                <td class="col-total">
                        <span class="total-amount">
                            <fmt:formatNumber value="${o.total_amount}" pattern="#,###"/>₫
                        </span>
                                </td>

                                <td class="col-payment">
                                    <span class="payment-badge cod">COD</span>
                                </td>

                                <td class="col-payment-status">
                        <span class="status-text ${o.order_status == 'Pending' ? 'text-unpaid' : 'text-paid'}">
                                ${o.order_status == 'Pending' ? 'Chưa TT' : 'Đã TT'}
                        </span>
                                </td>

                                <td class="col-date">
                                    <div class="date-info">
                                        <p><fmt:formatDate value="${o.created_at}" pattern="dd/MM/yyyy"/></p>
                                        <small><fmt:formatDate value="${o.created_at}" pattern="HH:mm"/></small>
                                    </div>
                                </td>

                                <td class="col-status">
                        <span class="status-badge status-${o.order_status.toLowerCase()}">
                                ${o.order_status}
                        </span>
                                </td>

                                <td class="col-actions">
                                    <div class="action-buttons">
                                        <a href="orders?action=detail&id=${o.id}" class="btn-action btn-view" title="Xem">
                                            <i class="fa-solid fa-eye"></i>
                                        </a>
                                        <button class="btn-action btn-print" title="In" onclick="window.print()">
                                            <i class="fa-solid fa-print"></i>
                                        </button>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </div>

                <div class="pagination-section">
                    <div class="pagination-info">
                        
                        Hiển thị <strong>1 - ${orders.size()}</strong> trong tổng số <strong>${totalOrders != null ? totalOrders : orders.size()}</strong> đơn hàng
                    </div>

                    <div class="pagination">
                        
                        <a href="orders?action=list&page=${currentPage - 1}" class="page-link ${currentPage <= 1 ? 'disabled' : ''}">
                            <i class="fa-solid fa-chevron-left"></i>
                        </a>

                        
                        <c:forEach begin="1" end="${totalPages}" var="i">
                            <a href="orders?action=list&page=${i}" class="page-link ${i == currentPage ? 'active' : ''}">${i}</a>
                        </c:forEach>

                        
                        <a href="orders?action=list&page=${currentPage + 1}" class="page-link ${currentPage >= totalPages ? 'disabled' : ''}">
                            <i class="fa-solid fa-chevron-right"></i>
                        </a>
                    </div>

                    <div class="per-page">
                        <label for="per-page">Hiển thị:</label>
                        <select name="per_page" id="per-page" onchange="window.location.href='orders?action=list&pageSize=' + this.value">
                            <option value="8" ${pageSize == 8 ? 'selected' : ''}>8</option>
                            <option value="20" ${pageSize == 20 ? 'selected' : ''}>20</option>
                            <option value="50" ${pageSize == 50 ? 'selected' : ''}>50</option>
                        </select>
                    </div>
                </div>
            </div>
        </div>
    </main>
</body>
</html>
