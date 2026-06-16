<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/wishlist.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/header.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/footer.css">
    <title>Sản phẩm yêu thích của tôi</title>
</head>
<body>
<jsp:include page="/compenents/header.jsp" />

<main class="dashboard-main">
    <div class="dashboard-container">
        <jsp:include page="/compenents/sidebar.jsp" />

        <section class="dashboard-content">
            <div class="welcome-section">
                <div class="welcome-text">
                    <h1><i class="fa-solid fa-heart" style="color: #c0392b; margin-right: 10px;"></i> Sản phẩm yêu thích</h1>
                    <p>Nơi lưu giữ những món đồ thủ công tinh xảo bạn đã chọn.</p>
                </div>
                <div class="welcome-image">
                    <i class="fa-solid fa-heart"></i>
                </div>
            </div>

            <div class="section-container">
                <div class="section-header">
                    <h2><i class="fa-solid fa-list-ul"></i> Danh sách của tôi</h2>
                    <span class="orders-count">Đang có <strong>${wishlistCount != null ? wishlistCount : 0}</strong> sản phẩm</span>
                </div>

                <div class="wishlist-grid" id="wishlist-grid-area">
                    <c:choose>
                        <c:when test="${not empty wishlistProducts}">
                            <c:forEach var="p" items="${wishlistProducts}">
                                <div class="wishlist-item" id="wishlist-item-${p.id}">
                                    <div class="wishlist-image">
                                        <img src="${p.imageUrl}" alt="${p.name}">
                                        <button class="btn-remove-wishlist" title="Xóa khỏi danh sách" onclick="removeWishlistItem(${p.id})">
                                            <i class="fa-solid fa-trash-can"></i>
                                        </button>
                                    </div>
                                    <div class="wishlist-info">
                                        <h4><c:out value="${p.name}"/></h4>
                                        <div class="wishlist-price">
                                            <fmt:setLocale value="vi_VN"/>
                                            <fmt:formatNumber value="${p.price}" type="currency" currencySymbol="đ"/>
                                        </div>
                                        <a href="${pageContext.request.contextPath}/cart?action=add&productId=${p.id}&quantity=1" class="btn-add-cart">
                                            <i class="fa-solid fa-cart-plus"></i> Thêm vào giỏ
                                        </a>
                                    </div>
                                </div>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <div class="empty-state" style="text-align: center; width: 100%; padding: 40px 0; color: #888;">
                                <i class="fa-solid fa-heart-crack" style="font-size: 3rem; margin-bottom: 15px; color: #ccc;"></i>
                                <h3>Danh sách yêu thích trống</h3>
                                <p>Hãy quay lại cửa hàng để chọn những sản phẩm ưng ý nhé.</p>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>

            </div>
        </section>
    </div>
</main>

<jsp:include page="/compenents/footer.jsp" />

<script>
    function removeWishlistItem(productId) {
        if(confirm("Bạn có chắc muốn bỏ sản phẩm này khỏi danh sách yêu thích?")) {
            const params = new URLSearchParams();
            params.append("action", "remove");
            params.append("productId", productId);

            fetch("${pageContext.request.contextPath}/account/wishlist", {
                method: "POST",
                headers: { "Content-Type": "application/x-www-form-urlencoded" },
                body: params
            })
                .then(res => res.text())
                .then(data => {
                    if (data === "success") {
                        const itemContainer = document.getElementById("wishlist-item-" + productId);
                        if(itemContainer) {
                            itemContainer.remove();
                        }
                       window.location.reload();
                    } else {
                        alert("Xóa thất bại, vui lòng thử lại.");
                    }
                })
                .catch(err => console.error("Lỗi:", err));
        }
    }
</script>
</body>
</html>