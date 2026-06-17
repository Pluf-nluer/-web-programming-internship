<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý đơn hàng</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/admin/css/admin-dashboard.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/admin/css/orders-list.css">
    <script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
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
                    <p>Tổng cộng <strong id="order-count-label">${orders != null ? orders.size() : 0} đơn hàng</strong></p>
                </div>
            </div>

            <div class="status-tabs">
                <a href="#" class="tab-item active" data-status="all"><span class="tab-label">Tất cả</span></a>
                <a href="#" class="tab-item pending" data-status="pending"><span class="tab-label">Chờ xác nhận</span></a>
                <a href="#" class="tab-item completed" data-status="completed"><span class="tab-label">Hoàn thành</span></a>
                <div class="header-right">
                    <form action="orders" method="GET" class="search-form">
                        <i class="fa-solid fa-magnifying-glass search-icon"></i>
                        <input type="text" name="search" value="${searchQuery}" placeholder="Tìm kiếm" class="search-input">
                    </form>
                </div>
            </div>

            <div class="orders-table-container" style="margin-top: 20px;">
                <c:choose>
                <c:when test="${not empty orders}">
                <table class="orders-table" id="adminOrderTable">
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
                        <tr class="order-row" data-status="${fn:toLowerCase(o.order_status)}">
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
                            <td class="col-payment"><span class="payment-badge cod">COD</span></td>
                            <td class="col-payment-status">
                                    <span class="status-text ${fn:toLowerCase(o.order_status) == 'pending' ? 'text-unpaid' : 'text-paid'}">
                                            ${fn:toLowerCase(o.order_status) == 'pending' ? 'Chưa TT' : 'Đã TT'}
                                    </span>
                            </td>
                            <td class="col-date">
                                <div class="date-info">
                                    <p><fmt:formatDate value="${o.created_at}" pattern="dd/MM/yyyy"/></p>
                                    <small><fmt:formatDate value="${o.created_at}" pattern="HH:mm"/></small>
                                </div>
                            </td>
                            <td class="col-status">
                                    <span class="badge ${fn:toLowerCase(o.order_status) == 'pending' ? 'warning' : 'success'}">
                                            ${o.order_status}
                                    </span>
                            </td>
                            <td class="col-actions">
                                <div class="action-buttons">
                                    <a href="orders?action=detail&id=${o.id}" class="btn-action btn-view" title="Xem"><i class="fa-solid fa-eye"></i></a>
                                </div>
                            </td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
                </c:when>
                    <c:otherwise>
                        <div class="empty-state">
                            <i class="fa-solid fa-file-invoice empty-icon"></i>
                            <h3>Không tìm thấy đơn hàng nào!</h3>
                            <p>Rất tiếc, không có đơn hàng nào khớp với tìm kiếm của bạn.</p>
                            <a href="orders" class="btn-clear-search">
                                <i class="fa-solid fa-rotate-left"></i> Xóa tìm kiếm và Tải lại
                            </a>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
</main>

<script>
    $(document).ready(function() {
        $('.tab-item').on('click', function(e) {
            e.preventDefault();
            $('.tab-item').removeClass('active');
            $(this).addClass('active');

            const targetStatus = $(this).data('status');
            let visibleCount = 0;

            $('.order-row').each(function() {
                const rowStatus = $(this).data('status');
                if (targetStatus === 'all' || rowStatus === targetStatus) {
                    $(this).show();
                    visibleCount++;
                } else {
                    $(this).hide();
                }
            });

            if($('.order-row').length>0){
            $('#order-count-label').text(visibleCount + " đơn hàng");
            }
        });
    });
</script>
</body>
</html>