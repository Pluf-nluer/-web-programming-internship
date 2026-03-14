<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý khách hàng</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/admin/css/admin-dashboard.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/admin/css/customers-list.css">
</head>
<body>
<main class="admin-dashboard-main">
    <div class="admin-dashboard-container">
        <jsp:include page="/admin/components/sidebar.jsp">
            <jsp:param name="active" value="customers" />
        </jsp:include>

        <div class="admin-content">
            <div class="page-header">
                <div class="header-left">
                    <h1>Quản lý khách hàng</h1>
                    <p>Danh sách người dùng trong hệ thống</p>
                </div>
            </div>

            <div class="filter-section">
                <form action="${pageContext.request.contextPath}/admin/customers" method="get" class="filter-form">
                    <div class="search-wrapper">
                        <i class="fa-solid fa-search"></i>
                        <input type="text" name="q" placeholder="Tìm theo tên, email, số điện thoại"
                               class="search-input" value="${keyword}">
                    </div>
                    <div class="filter-actions">
                        <button type="submit" class="btn-apply-filter">
                            <i class="fa-solid fa-filter"></i> Tìm kiếm
                        </button>
                        <a href="${pageContext.request.contextPath}/admin/customers" class="btn-reset-filter">
                            <i class="fa-solid fa-rotate"></i> Đặt lại
                        </a>
                    </div>
                </form>
            </div>

            <c:if test="${not empty adminCustomerMessage}">
                <c:choose>
                    <c:when test="${adminCustomerMessageType == 'success'}">
                        <div style="padding:10px;margin-bottom:15px;background:#d4edda;color:#155724;border-radius:6px;">
                            ${adminCustomerMessage}
                        </div>
                    </c:when>
                    <c:when test="${adminCustomerMessageType == 'error'}">
                        <div style="padding:10px;margin-bottom:15px;background:#f8d7da;color:#721c24;border-radius:6px;">
                            ${adminCustomerMessage}
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div style="padding:10px;margin-bottom:15px;background:#d1ecf1;color:#0c5460;border-radius:6px;">
                            ${adminCustomerMessage}
                        </div>
                    </c:otherwise>
                </c:choose>
            </c:if>

            <div class="customers-table-container">
                <table class="customers-table">
                    <thead>
                    <tr>
                        <th class="col-customer-name">Khách hàng</th>
                        <th class="col-email">Email</th>
                        <th class="col-phone">Số điện thoại</th>
                        <th class="col-customer-type">Vai trò</th>
                        <th class="col-status">Trạng thái</th>
                        <th class="col-register-date">Ngày tạo</th>
                        <th class="col-actions">Thao tác</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach items="${customers}" var="c">
                        <tr class="customer-row ${c.active ? '' : 'inactive-row'}">
                            <td class="col-customer-name">
                                <div class="customer-info">
                                    <div class="customer-avatar">
                                        <i class="fa-solid fa-user"></i>
                                    </div>
                                    <div class="customer-details">
                                        <h4>${c.fullName}</h4>
                                        <span class="customer-id">ID: ${c.id}</span>
                                    </div>
                                </div>
                            </td>
                            <td class="col-email">
                                <a class="email-link" href="mailto:${c.email}">
                                    <i class="fa-solid fa-envelope"></i> ${c.email}
                                </a>
                            </td>
                            <td class="col-phone">
                                <a class="phone-link" href="tel:${c.phone}">
                                    <i class="fa-solid fa-phone"></i> ${c.phone}
                                </a>
                            </td>
                            <td class="col-customer-type">
                                <span class="customer-badge regular">
                                    <i class="fa-solid fa-user"></i> Khách hàng
                                </span>
                            </td>
                            <td class="col-status">
                                <c:choose>
                                    <c:when test="${c.active}">
                                        <span class="status-badge active">
                                            <i class="fa-solid fa-circle-check"></i> Hoạt động
                                        </span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="status-badge inactive">
                                            <i class="fa-solid fa-circle-xmark"></i> Bị khóa
                                        </span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td class="col-register-date">
                                <div class="date-info">
                                    <p>
                                        <fmt:formatDate value="${c.createdAt}" pattern="dd/MM/yyyy"/>
                                    </p>
                                </div>
                            </td>
                            <td class="col-actions">
                                <div class="action-buttons">
                                    <a class="btn-action btn-view"
                                       href="${pageContext.request.contextPath}/admin/customers/detail?id=${c.id}"
                                       title="Xem chi tiết">
                                        <i class="fa-solid fa-eye"></i>
                                    </a>
                                    <c:choose>
                                        <c:when test="${c.active}">
                                            <form method="post" action="${pageContext.request.contextPath}/admin/customers"
                                                  onsubmit="return confirm('Khóa tài khoản này?');">
                                                <input type="hidden" name="userId" value="${c.id}">
                                                <input type="hidden" name="action" value="lock">
                                                <input type="hidden" name="page" value="${currentPage}">
                                                <c:if test="${not empty keyword}">
                                                    <input type="hidden" name="q" value="${keyword}">
                                                </c:if>
                                                <button type="submit" class="btn-action btn-toggle" title="Khóa tài khoản">
                                                    <i class="fa-solid fa-lock"></i>
                                                </button>
                                            </form>
                                        </c:when>
                                        <c:otherwise>
                                            <form method="post" action="${pageContext.request.contextPath}/admin/customers"
                                                  onsubmit="return confirm('Mở khóa tài khoản này?');">
                                                <input type="hidden" name="userId" value="${c.id}">
                                                <input type="hidden" name="action" value="unlock">
                                                <input type="hidden" name="page" value="${currentPage}">
                                                <c:if test="${not empty keyword}">
                                                    <input type="hidden" name="q" value="${keyword}">
                                                </c:if>
                                                <button type="submit" class="btn-action btn-toggle btn-activate"
                                                        title="Mở khóa tài khoản">
                                                    <i class="fa-solid fa-unlock"></i>
                                                </button>
                                            </form>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </div>

            <c:choose>
                <c:when test="${totalCustomers == 0}">
                    <c:set var="startIndex" value="0"/>
                    <c:set var="endIndex" value="0"/>
                </c:when>
                <c:otherwise>
                    <c:set var="startIndex" value="${(currentPage - 1) * pageSize + 1}"/>
                    <c:set var="endIndex" value="${currentPage * pageSize}"/>
                    <c:if test="${endIndex > totalCustomers}">
                        <c:set var="endIndex" value="${totalCustomers}"/>
                    </c:if>
                </c:otherwise>
            </c:choose>

            <div class="pagination-section">
                <div class="pagination-info">
                    Hiển thị <strong>${startIndex}-${endIndex}</strong> trên <strong>${totalCustomers}</strong> tài khoản
                </div>
                <div class="pagination">
                    <c:url var="prevUrl" value="/admin/customers">
                        <c:param name="page" value="${currentPage - 1}"/>
                        <c:if test="${not empty keyword}">
                            <c:param name="q" value="${keyword}"/>
                        </c:if>
                    </c:url>
                    <a href="${prevUrl}" class="page-link ${currentPage == 1 ? 'disabled' : ''}">
                        <i class="fa-solid fa-chevron-left"></i>
                    </a>

                    <c:forEach begin="1" end="${totalPages}" var="i">
                        <c:url var="pageUrl" value="/admin/customers">
                            <c:param name="page" value="${i}"/>
                            <c:if test="${not empty keyword}">
                                <c:param name="q" value="${keyword}"/>
                            </c:if>
                        </c:url>
                        <a href="${pageUrl}" class="page-link ${i == currentPage ? 'active' : ''}">
                            ${i}
                        </a>
                    </c:forEach>

                    <c:url var="nextUrl" value="/admin/customers">
                        <c:param name="page" value="${currentPage + 1}"/>
                        <c:if test="${not empty keyword}">
                            <c:param name="q" value="${keyword}"/>
                        </c:if>
                    </c:url>
                    <a href="${nextUrl}" class="page-link ${currentPage == totalPages ? 'disabled' : ''}">
                        <i class="fa-solid fa-chevron-right"></i>
                    </a>
                </div>
            </div>
        </div>
    </div>
</main>
</body>
</html>
