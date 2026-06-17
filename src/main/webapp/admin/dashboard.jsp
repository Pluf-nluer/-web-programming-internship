<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Bảng điều khiển Tổng quan</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/admin/css/admin-dashboard.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/admin/css/admin-home.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>
<body>
<main class="admin-dashboard-main">
    <div class="admin-dashboard-container">
        <jsp:include page="/admin/components/sidebar.jsp">
            <jsp:param name="active" value="dashboard" />
        </jsp:include>

        <div class="admin-content">
            <div class="page-header">
                <div class="header-left">
                    <h1>Tổng quan hệ thống</h1>
                    <p>Theo dõi nhanh tình trạng cửa hàng</p>
                </div>
                <div class="header-right">
                    <a href="${pageContext.request.contextPath}/" class="btn btn-secondary" target="_blank"><i class="fa-solid fa-globe"></i> Website</a>
                </div>
            </div>

            <section class="stats-grid">
                <div class="stat-card">
                    <div class="stat-header">
                        <div class="stat-icon info"><i class="fa-solid fa-boxes-stacked"></i></div>
                        <span class="badge info">Sản phẩm</span>
                    </div>
                    <div class="stat-value">${totalProducts}</div>
                    <div class="stat-label">Tổng số sản phẩm</div>
                </div>
                <div class="stat-card">
                    <div class="stat-header">
                        <div class="stat-icon"><i class="fa-solid fa-cart-shopping"></i></div>
                        <span class="badge info">Đơn hàng</span>
                    </div>
                    <div class="stat-value">${ordersToday}</div>
                    <div class="stat-label">Tổng số đơn hàng</div>
                </div>
                <div class="stat-card">
                    <div class="stat-header">
                        <div class="stat-icon warning"><i class="fa-solid fa-clock"></i></div>
                        <span class="badge warning">Chờ xử lý</span>
                    </div>
                    <div class="stat-value">${pendingOrders}</div>
                    <div class="stat-label">Đơn chờ xác nhận</div>
                </div>
                <div class="stat-card">
                    <div class="stat-header">
                        <div class="stat-icon success"><i class="fa-solid fa-sack-dollar"></i></div>
                        <span class="badge success">Doanh thu</span>
                    </div>
                    <div class="stat-value" style="color: #2ecc71;"><fmt:formatNumber value="${monthlyRevenue}" type="currency" currencySymbol="đ" /></div>
                    <div class="stat-label">Doanh thu tháng này</div>
                </div>
            </section>

            <section class="dashboard-panels" style="margin-top: 20px;">

                <div class="panel">
                    <div>
                        <div class="panel-header panel-header-line">
                            <h2>Bộ phân tích đối chiếu doanh thu</h2>
                        </div>
                        <form action="${pageContext.request.contextPath}/admin/dashboard" method="get" class="analytics-form">
                            <div class="compare-nodes-wrapper">
                                <div class="compare-node node-a">
                                    <label>Mốc đối chiếu A:</label>
                                    Tháng <input type="number" name="monthA" value="${mA}" min="1" max="12">
                                    Năm <input type="number" name="yearA" value="${yA}">
                                </div>
                                <div style="font-size: 1.2rem; color: #95a5a6;"><i class="fa-solid fa-arrow-right-arrow-left"></i></div>
                                <div class="compare-node node-b">
                                    <label>Mốc đối chiếu B:</label>
                                    Tháng <input type="number" name="monthB" value="${mB}" min="1" max="12">
                                    Năm <input type="number" name="yearB" value="${yB}">
                                </div>
                            </div>
                            <button type="submit" class="btn-analyze">Tính toán & Vẽ lại biểu đồ</button>
                        </form>
                    </div>

                    <div class="results-grid">
                        <div class="result-box">
                            <span>Doanh thu trước</span>
                            <h3><fmt:formatNumber value="${revenueMocA}" type="currency" currencySymbol="đ"/></h3>
                        </div>
                        <div class="result-box" style="background: #e3f2fd;">
                            <span style="color: #1e88e5;">Doanh thu sau</span>
                            <h3 style="color: #1565c0;"><fmt:formatNumber value="${revenueMocB}" type="currency" currencySymbol="đ"/></h3>
                        </div>
                        <div class="result-box ${comparisonGrowth >= 0 ? 'growth-positive' : 'growth-negative'}">
                            <span>Biến động</span>
                            <strong style="font-size: 1.2rem; color: ${comparisonGrowth >= 0 ? '#2e7d32' : '#c62828'};">
                                ${comparisonGrowth >= 0 ? '+' : '-'}${comparisonGrowth}%
                            </strong>
                        </div>
                    </div>
                </div>

                <div class="panel">
                    <div class="panel-header" style="border-bottom: 1px solid #eee; padding-bottom: 10px; margin-bottom: 15px;">
                        <h2>Trực quan hóa dữ liệu</h2>
                    </div>
                    <div class="chart-wrapper-square">
                        <canvas id="comparisonChart"></canvas>
                    </div>
                </div>

            </section>

            <section class="dashboard-panels" style="margin-top: 20px; grid-template-columns: 1fr;">
                <div class="panel">
                    <div class="panel-header panel-header-line">
                        <h2><i class="fa-solid fa-chart-pie" style="color: #e67e22;"></i> Thống kê nhập/xuất & Hiệu suất bán hàng</h2>
                    </div>
                    <div class="inventory-flow-container">
                        <div class="flow-chart-box">
                            <canvas id="flowChart"></canvas>
                        </div>

                        <div class="flow-details" style="flex: 1; min-width: 220px;">
                            <ul class="flow-details-list">
                                <li>
                                    <span><i class="fa-solid fa-box-open" style="color: #2ecc71; margin-right: 5px;"></i> Tổng đã nhập kho (Lịch sử):</span>
                                    <strong style="color: #2ecc71;">${totalAllImport} cái</strong>
                                </li>
                                <li>
                                    <span><i class="fa-solid fa-truck-loading" style="color: #3498db; margin-right: 5px;"></i> Tổng đã xuất bán (Lịch sử):</span>
                                    <strong style="color: #3498db;">${totalAllExport} cái</strong>
                                </li>
                                <li>
                                    <span><i class="fa-solid fa-square-minus" style="color: #e74c3c; margin-right: 5px;"></i> Tổng hao hụt / lỗi hỏng (Theo lịch lọc):</span>
                                    <strong style="color: #e74c3c;">${not empty invFlow['ADJUSTMENT'] ? invFlow['ADJUSTMENT'] : 0} cái</strong>
                                </li>
                            </ul>
                        </div>

                        <div class="kpi-box" style="flex: 1; min-width: 200px; background: #f8f9fa; border-radius: 8px; padding: 20px; text-align: center; border: 1px solid #e2e8f0; display: flex; flex-direction: column; justify-content: center; align-items: center;">
                            <span style="font-size: 13px; color: #4a5568; font-weight: 600; margin-bottom: 8px;">Tỷ lệ Bán ra / Nhập vào</span>
                            <div style="font-size: 2rem; font-weight: 800; color: #2b6cb0;">${salesToImportRatio}%</div>
                            <p style="font-size: 12px; color: #718096; margin-top: 6px; line-height: 1.4;">
                                <c:choose>
                                    <c:when test="${salesToImportRatio >= 70}">Hiệu suất bán hàng xuất sắc! Tốc độ đẩy hàng nhanh.</c:when>
                                    <c:when test="${salesToImportRatio >= 40}">Tốc độ bán hàng ổn định, dòng vốn lưu thông tốt.</c:when>
                                    <c:otherwise>Cảnh báo: Tỷ lệ lưu kho cao, cân nhắc giảm giá để giải phóng hàng.</c:otherwise>
                                </c:choose>
                            </p>
                        </div>
                    </div>
                </div>
            </section>
            <section class="dashboard-panels-secondary">
                <div class="panel">
                    <div class="panel-header">
                        <h2>Hoạt động gần đây</h2>
                    </div>
                    <div class="activity-list">
                        <c:forEach var="order" items="${recentOrders}">
                            <div class="activity-item">
                                <div>
                                    <p class="activity-title">Đơn hàng #${order.id} - ${order.shipping_name}</p>
                                    <span class="activity-time"><fmt:formatDate value="${order.created_at}" pattern="dd/MM/yyyy HH:mm"/></span>
                                </div>
                                <span class="badge ${order.order_status == 'pending' ? 'warning' : 'success'}">
                                    <c:choose>
                                        <c:when test="${order.order_status == 'pending'}">Chờ xử lý</c:when>
                                        <c:when test="${order.order_status == 'completed'}">Hoàn tất</c:when>
                                        <c:otherwise>${order.order_status}</c:otherwise>
                                    </c:choose>
                                </span>
                            </div>
                        </c:forEach>
                        <c:if test="${empty recentOrders}">
                            <div class="activity-item">
                                <p class="activity-title">Chưa có đơn hàng nào mới</p>
                            </div>
                        </c:if>
                    </div>
                </div>

                <div class="panel">
                    <div class="panel-header"><h2>Lối tắt quản lý</h2></div>
                    <div class="action-grid">
                        <a class="action-card" href="${pageContext.request.contextPath}/admin/products?action=new"><i class="fa-solid fa-plus"></i><strong>Thêm sản phẩm</strong><span>Tạo sản phẩm mới</span></a>
                        <a class="action-card" href="${pageContext.request.contextPath}/admin/orders/order-list.jsp"><i class="fa-solid fa-shopping-cart"></i><strong>Danh sách đơn hàng</strong><span>Theo dõi giao dịch</span></a>
                        <a class="action-card" href="${pageContext.request.contextPath}/admin/products"><i class="fa-solid fa-box"></i><strong>Danh sách sản phẩm</strong><span>Quản lý hàng hóa</span></a>
                        <a class="action-card" href="${pageContext.request.contextPath}/admin/customers"><i class="fa-solid fa-users"></i><strong>Danh sách khách hàng</strong><span>Quản lý người dùng</span></a>
                    </div>
                </div>
            </section>
        </div>
    </div>
</main>

<script>
    const compCtx = document.getElementById('comparisonChart').getContext('2d');
    new Chart(compCtx, {
        type: 'bar',
        data: {
            labels: ['Tháng ${mA}/${yA}', 'Tháng ${mB}/${yB}'],
            datasets: [{
                label: 'Doanh thu thu được',
                data: [${revenueMocA}, ${revenueMocB}],
                backgroundColor: ['#bdc3c7', '#3498db'],
                borderWidth: 1,
                borderRadius: 4,
                barPercentage: 0.5
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
                legend: { display: false }
            },
            scales: {
                y: {
                    beginAtZero: true,
                    ticks: { callback: value => value.toLocaleString('vi-VN') + 'đ' }
                }
            }
        }
    });

    const flowCtx = document.getElementById('flowChart').getContext('2d');
    new Chart(flowCtx, {
        type: 'doughnut',
        data: {
            labels: ['Nhập kho', 'Hao hụt lỗi', 'Xuất bán'],
            datasets: [{
                data: [
                    ${not empty invFlow['IMPORT'] ? invFlow['IMPORT'] : 0},
                    ${not empty invFlow['ADJUSTMENT'] ? invFlow['ADJUSTMENT'] : 0},
                    ${not empty invFlow['EXPORT'] ? invFlow['EXPORT'] : 0}
                ],
                backgroundColor: ['#2ecc71', '#e74c3c', '#3498db'],
                borderWidth: 2
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
                legend: { display: false }
            }
        }
    });
</script>
</body>
</html>