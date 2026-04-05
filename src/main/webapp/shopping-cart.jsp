<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Giỏ Hàng</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/shopping-cart.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/header.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/footer.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/hero-section.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>
</head>
<body>
<%@ include file="compenents/header.jsp" %>
<c:set var="pageTitle" value="Giỏ hàng" scope="request"/>
<c:set var="breadcrumbText"
       value="Giỏ hàng"
       scope="request"/>
<jsp:include page="compenents/hero-section.jsp"/>
<section class="cart-page">
    <div class="container">

        <c:if test="${sessionScope.cart == null || sessionScope.cart.totalQuantity == 0}">
            <div class="empty-cart">
                <i class="fa-solid fa-cart-arrow-down" ></i>
                <h3>Giỏ hàng của bạn đang trống!</h3>
                <p>Hãy thêm sản phẩm để tiến hành thanh toán.</p>
                <a href="${pageContext.request.contextPath}/products" class="btn-return">Quay lại mua sắm</a>
            </div>
        </c:if>

        <c:if test="${sessionScope.cart != null && sessionScope.cart.totalQuantity > 0}">
            <div class="cart-layout">
                <div class="cart-left">
                    <div class="cart-header">
                        <input type = "checkbox" id = "selectedAll" class = "item-checkbox">
                        <span>Thông tin sản phẩm</span>
                        <span>Đơn giá</span>
                        <span>Số lượng</span>
                        <span>Thành tiền</span>
                    </div>
                    <div class="cart-body">

                    <c:forEach var="item" items="${sessionScope.cart.items}">

                        <div class="cart-row">

                            <div class="cart-items">
                                <a href="productdetail?id=${item.product.id}" class="cart-item">
                                    <img src="${item.product.imageUrl}" alt="image">
                                </a>
                                <div class="cart-info">
                                    <strong class="cart-item-name">${item.product.name}</strong>

                                    <br>
                                    <a href="cart?action=remove&productId=${item.product.id}" class="cart-item-delete" onclick="return confirm('Bạn muốn xóa sản phẩm này?');">
                                        <i class="fa-solid fa-trash"></i> Xóa
                                    </a>
                                </div>
                            </div>

                            <div class="price">
                                <span>
                                    <fmt:formatNumber value="${item.product.price}" type="currency" currencySymbol="₫" maxFractionDigits="0"/>
                                </span>
                            </div>

                            <div class="cart-items-quantity">
                                <form action="cart" method="GET" class="quantity">
                                    <input type="hidden" name="action" value="update">
                                    <input type="hidden" name="productId" value="${item.product.id}">

                                    <button type="submit" name="quantity" value="${item.quantity - 1}" ${item.quantity <= 1 ? 'disabled' : ''}>-</button>
                                    <input type="text" value="${item.quantity}" readonly>
                                    <button type="submit" name="quantity" value="${item.quantity + 1}">+</button>
                                </form>
                            </div>

                            <div class="price-total">
                                <fmt:formatNumber value="${item.product.price * item.quantity}" type="currency" currencySymbol="₫" maxFractionDigits="0"/>
                            </div>

                        </div>

                    </c:forEach>
                    </div>
                </div>

                <div class="cart-footer">
                    <a href = "${pageContext.request.contextPath}/products" class = "btn-continue">
                        <i class = "fa-solid fa-arrow-left"></i>Quay lại
                    </a>
                    <div class="total-summary">
                        <div class="total-price">
                            <span>Tổng tiền: </span>
                            <span>
                                <fmt:formatNumber value="${sessionScope.cart.totalMoney}" type="currency" currencySymbol="₫" maxFractionDigits="0"/>
                            </span>
                        </div>
                        <a href="${pageContext.request.contextPath}/checkout" class="btn-checkout">Thanh toán</a>
                    </div>
                </div>
            </div>
        </c:if>

    </div>
</section>
<%@include file = "compenents/footer.jsp"%>
<script src="${pageContext.request.contextPath}/js/hero-section.js"></script>
<input type="checkbox" id="search-toggle" class="hidden-checkbox">

<label for="search-toggle" class="search-overlay"></label>

<div id="search-panel">
    <div class="search-panel-header">
        <label for="search-toggle" class="close-search-label">
            <i class="fa-solid fa-xmark"></i>
        </label>
    </div>

    <div class="search-panel-content">
        <form action="${pageContext.request.contextPath}/products" method = "GET" class="search-form">
            <input type="text" name = "search" id = "ajaxSearchInput" placeholder="Nhập tên sản phẩm..." autocomplete = "off">
            <button type = submit>
            <i class="fa-solid fa-magnifying-glass search-icon"></i>
            </button>
        </form>

        <h3 id = "searchTitle">Sản phẩm gợi ý</h3>

        <div class="search-results-list" id = "searchResultArea">
        </div>
    </div>
</div>
<script>
    window.addEventListener("beforeunload", function() {
        sessionStorage.setItem("position", window.scrollY);
    });
    document.addEventListener("DOMContentLoaded", function() {
        let scrollPos = sessionStorage.getItem("position");
        const searchInput = document.getElementById("ajaxSearchInput");
        const resultArea = document.getElementById("searchResultArea");
        const searchTitle = document.getElementById("searchTitle");
        if (scrollPos) {
            window.scrollTo(0, scrollPos);
            sessionStorage.removeItem("position");
        }
        searchInput.addEventListener("input", function() {
            const keyword = this.value.trim();

            if (keyword.length >= 1) {
                searchTitle.innerText = "Kết quả gợi ý cho: '" + keyword + "'";
                fetch("${pageContext.request.contextPath}/search-ajax?keyword=" + encodeURIComponent(keyword))
                    .then(response => response.text())
                    .then(data => {
                        resultArea.innerHTML = data;
                    })
                    .catch(err => console.error("Lỗi tìm kiếm AJAX:", err));
            } else {
                searchTitle.innerText = "Sản phẩm gợi ý";
                resultArea.innerHTML = "";
            }
        });
    });
</script>
</body>
</html>