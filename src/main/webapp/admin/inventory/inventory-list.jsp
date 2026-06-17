<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản lý tồn kho</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.7/css/jquery.dataTables.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/admin/css/admin-dashboard.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/admin/css/admin-inventory.css">

    <script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.7/js/jquery.dataTables.min.js"></script>
</head>
<body>
<div class="admin-dashboard-container">
    <jsp:include page="/admin/components/sidebar.jsp">
        <jsp:param name="active" value="inventory" />
    </jsp:include>

    <div class="admin-content">
        <div class="page-header">
            <div class="header-left">
                <h1>Quản lý kho hàng tập trung</h1>
                <p>Hệ thống hỗ trợ phân trang và tìm kiếm thông minh. Dữ liệu nhập thêm sẽ được giữ nguyên khi chuyển trang.</p>
            </div>
        </div>

        <div class="inv-card">
            <c:if test="${param.status == 'success'}">
                <div class="alert-toast toast-success">Đã import cộng dồn số lượng tồn kho mới vào hệ thống thành công!</div>
            </c:if>
            <c:if test="${param.status == 'error'}">
                <div class="alert-toast toast-error">Quá trình kết nối hoặc import thất bại. Vui lòng kiểm tra lại cấu trúc DB!</div>
            </c:if>

            <form id="inventoryForm" action="${pageContext.request.contextPath}/admin/inventory" method="post">
                <table class="inv-table" id="inventoryTable">
                    <thead>
                    <tr>
                        <th style="width: 50px;">ID</th>
                        <th>TÊN SẢN PHẨM</th>
                        <th style="text-align: center;">ĐƠN GIÁ</th>
                        <th style="text-align: center;">TỒN KHO</th>
                        <th style="text-align: center;">ĐÃ BÁN</th>
                        <th style="text-align: center; width: 150px;">NHẬP THÊM</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="p" items="${inventoryList}">
                        <tr>
                            <td><strong>#${p.id}</strong></td>
                            <td>
                                <div class="p-info">
                                    <span style="font-weight: 600; color: var(--admin-text-main);">${p.name}</span>
                                </div>
                            </td>
                            <td style="text-align: center; font-weight: 500; color: var(--admin-text-muted);">
                                <fmt:setLocale value="vi_VN"/>
                                <fmt:formatNumber value="${p.price}" type="currency" currencySymbol="đ"/>
                            </td>

                            <td style="text-align: center;">
                                <c:choose>
                                    <c:when test="${p.stock == 0}">
                                        <span class="badge-stock badge-danger">Hết hàng (0)</span>
                                    </c:when>
                                    <c:when test="${p.stock <= 10}">
                                        <span class="badge-stock badge-warning">Sắp hết (${p.stock})</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge-stock badge-success">Còn hàng (${p.stock})</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>

                            <td style="text-align: center; font-weight: 700; color: var(--admin-text-main); font-size: 15px;">
                                    ${p.totalSold} cái
                            </td>

                            <td class="import-td-bg">
                                <input type="hidden" name="productIds" value="${p.id}">
                                <input type="number" name="stockAdds" min="0" placeholder="+" class="input-import">
                            </td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>

                <button type="submit" class="btn-submit-inv">Xác nhận Import kho hàng loạt</button>
                <div style="clear: both;"></div>
            </form>
        </div>
    </div>
</div>

<script>
    $(document).ready(function() {
        const vietnameseLanguage = {
            "sProcessing": "Đang xử lý...", "sLengthMenu": "Xem _MENU_ mục", "sZeroRecords": "Không tìm thấy dòng nào phù hợp",
            "sInfo": "Đang xem _START_ đến _END_ trong tổng số _TOTAL_ mục", "sInfoEmpty": "Đang xem 0 đến 0 trong tổng số 0 mục",
            "sSearch": "Tìm kiếm nhanh sản phẩm:",
            "oPaginate": { "sFirst": "Đầu", "sPrevious": "Trước", "sNext": "Tiếp", "sLast": "Cuối" }
        };

        const table = $('#inventoryTable').DataTable({
            "language": vietnameseLanguage,
            "pageLength": 10,
            "order": [[0, 'desc']],
            "columnDefs": [
                { "orderable": false, "targets": [1, 5] }
            ]
        });

        $('#inventoryForm').on('submit', function(e) {
            const form = this;
            table.$('input').each(function() {
                if (!$.contains(document, this)) {
                    $(form).append(
                        $('<input>')
                            .attr('type', 'hidden')
                            .attr('name', this.name)
                            .val($(this).val())
                    );
                }
            });
        });
    });
</script>
</body>
</html>