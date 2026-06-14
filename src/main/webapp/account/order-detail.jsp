<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<c:if test="${empty sessionScope.user}">
    <c:redirect url="${pageContext.request.contextPath}/login" />
</c:if>

<jsp:useBean id="orderDao" class="com.example.backend.dao.OrderDao" scope="request" />
<c:catch var="orderLoadError">
    <c:set var="order" value="${orderDao.getOrderById(param.id)}" />
</c:catch>
<c:if test="${not empty orderLoadError or empty order or order.user_id != sessionScope.user.id}">
    <c:redirect url="${pageContext.request.contextPath}/account/order.jsp" />
</c:if>
<c:set var="orderItems" value="${orderDao.getOrderItems(order.id)}" />
<fmt:setLocale value="vi_VN" />

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/order-detail.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/header.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/footer.css">
    <title>Chi tiết đơn hàng</title>
</head>
<body>
<jsp:include page="/compenents/header.jsp" />

<main class="dashboard-main">
    <div class="dashboard-container">
        <jsp:include page="/compenents/sidebar.jsp" />

        <div class="dashboard-content">
            <div class="page-header">
                <div class="header-top">
                    <a href="${pageContext.request.contextPath}/account/order.jsp" class="btn-back">
                        <i class="fa-solid fa-arrow-left"></i>
                        <span>Quay lại danh sách</span>
                    </a>
                    <button class="btn-print" onclick="window.print()">
                        <i class="fa-solid fa-print"></i>
                        <span>In đơn hàng</span>
                    </button>
                </div>
                <div class="header-content">
                    <div class="header-info">
                        <h1>
                            <i class="fa-solid fa-file-invoice"></i>
                            Chi tiết hóa đơn
                        </h1>
                        <p class="order-code">
                            <i class="fa-solid fa-hashtag"></i>
                            <strong>${order.id}</strong>
                        </p>
                    </div>
                    <span class="status-badge status-${order.statusClass}"><c:out value="${order.statusText}" /></span>
                </div>
            </div>

            <div class="invoice-document">
                <div class="invoice-data-grid">
                    <section class="invoice-data-card">
                        <h3><i class="fa-solid fa-calendar-check"></i> Thông tin hóa đơn</h3>
                        <div class="invoice-data-row">
                            <span>Mã hóa đơn</span>
                            <strong>#${order.id}</strong>
                        </div>
                        <div class="invoice-data-row">
                            <span>Ngày đặt</span>
                            <strong><fmt:formatDate value="${order.created_at}" pattern="dd/MM/yyyy HH:mm" /></strong>
                        </div>
                        <div class="invoice-data-row">
                            <span>Phương thức</span>
                            <strong>Thanh toán khi nhận hàng</strong>
                        </div>
                    </section>

                    <section class="invoice-data-card">
                        <h3><i class="fa-solid fa-truck"></i> Người nhận</h3>
                        <div class="invoice-data-row">
                            <span>Họ tên</span>
                            <strong><c:out value="${order.shipping_name}" /></strong>
                        </div>
                        <div class="invoice-data-row">
                            <span>Số điện thoại</span>
                            <strong><c:out value="${order.shipping_phone}" /></strong>
                        </div>
                        <div class="invoice-data-row invoice-address-row">
                            <span>Địa chỉ</span>
                            <strong><c:out value="${order.shipping_address}" /></strong>
                        </div>
                    </section>
                </div>

                <div class="invoice-table-section">
                    <div class="section-header">
                        <h2>
                            <i class="fa-solid fa-table-list"></i>
                            Dữ liệu sản phẩm
                        </h2>
                    </div>
                    <div class="invoice-table-wrapper">
                        <table class="invoice-table">
                            <thead>
                            <tr>
                                <th>STT</th>
                                <th>Sản phẩm</th>
                                <th>Đơn giá</th>
                                <th>SL</th>
                                <th>Thành tiền</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:forEach var="item" items="${orderItems}" varStatus="row">
                                <tr>
                                    <td class="invoice-index">${row.count}</td>
                                    <td>
                                        <div class="invoice-product">
                                            <img src="${fn:escapeXml(item.product.imageUrl)}" alt="${fn:escapeXml(item.product.name)}">
                                            <div>
                                                <strong><c:out value="${item.product.name}" /></strong>
                                                <span>SP-${item.product.id}</span>
                                            </div>
                                        </div>
                                    </td>
                                    <td><fmt:formatNumber value="${item.product.price}" type="currency" /></td>
                                    <td>${item.quantity}</td>
                                    <td class="invoice-line-total"><fmt:formatNumber value="${item.totalPrice}" type="currency" /></td>
                                </tr>
                            </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>

                <div class="invoice-footer-grid">
                    <div class="invoice-note-box">
                        <h3><i class="fa-solid fa-note-sticky"></i> Ghi chú hóa đơn</h3>
                        <c:choose>
                            <c:when test="${not empty order.note}">
                                <p><c:out value="${order.note}" /></p>
                            </c:when>
                            <c:otherwise>
                                <p>Không có ghi chú thêm cho đơn hàng này.</p>
                            </c:otherwise>
                        </c:choose>
                        <span>Khách hàng thanh toán khi nhận hàng. Vui lòng kiểm tra sản phẩm trước khi hoàn tất thanh toán.</span>
                    </div>

                    <div class="summary-content invoice-summary">
                        <div class="summary-row">
                            <span class="summary-label">Tạm tính:</span>
                            <span class="summary-value"><fmt:formatNumber value="${order.subtotal}" type="currency" /></span>
                        </div>
                        <div class="summary-row">
                            <span class="summary-label">Phí vận chuyển:</span>
                            <span class="summary-value"><fmt:formatNumber value="${order.shipping_fee}" type="currency" /></span>
                        </div>
                        <div class="summary-divider"></div>
                        <div class="summary-row total">
                            <span class="summary-label">Tổng thanh toán:</span>
                            <span class="summary-value"><fmt:formatNumber value="${order.total_amount}" type="currency" /></span>
                        </div>
                        <div class="payment-note">
                            <i class="fa-solid fa-circle-info"></i>
                            <span>Thanh toán khi nhận hàng</span>
                        </div>
                    </div>
                </div>
            </div>

            <div class="action-section">
                <a href="${pageContext.request.contextPath}/account/order.jsp" class="btn-secondary">
                    <i class="fa-solid fa-arrow-left"></i>
                    Quay lại
                </a>
                <a href="${pageContext.request.contextPath}/contact.jsp" class="btn-support">
                    <i class="fa-solid fa-headset"></i>
                    Liên hệ hỗ trợ
                </a>
            </div>
        </div>
    </div>
</main>

<jsp:include page="/compenents/footer.jsp" />
</body>
</html>