<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chi tiết sản phẩm | Nhóm 10</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/productdetail.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/header.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/footer.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/hero-section.css">
</head>
<body>
<%@ include file="compenents/header.jsp" %>
<c:set var="pageTitle" value="${product.name}" scope="request"/>
<c:set var="breadcrumbText"
       value="<a href='${pageContext.request.contextPath}/products.jsp'>Sản phẩm</a> / ${product.name}"
       scope="request"/>

<jsp:include page="compenents/hero-section.jsp"/>

<div class="product-page">
    <section class="product-details">
        <div class="container">
            <div class="product-gallery">
                <div class="product-img">
                    <a href="#">
                        <img id="main-display" src="${product.imageUrl}" alt="${product.name}">
                    </a>
                </div>
            </div>

            <div class="product-detail-info">
                <div class="product-name">
                    <h2>${product.name}</h2>
                </div>
                <div class="inventory">
                    <span>Tình trạng: </span>
                    <span style="color: green;">${product.stock > 0 ? 'Còn hàng' : 'Hết hàng'}</span>
                </div>
                <div class="product-price">
                    <div class="prices">
                        <c:choose>
                            <c:when test="${product.discountPercent > 0}">
                                <span class="price" style="color: red; font-weight: bold;">
                                    <fmt:formatNumber value="${product.price * (1 - product.discountPercent)}" type="currency" currencySymbol="đ"  maxFractionDigits="0"/>
                                </span>
                                    <span class="old-price" style="text-decoration: line-through; color: #888; margin-left: 10px; font-size: 0.9em;">
                                    <fmt:formatNumber value="${product.price}" type="currency" currencySymbol="đ"  maxFractionDigits="0"/>
                                </span>
                                    <span class="badge-sale" style="background: #ff4d4d; color: white; padding: 2px 5px; border-radius: 3px; margin-left: 5px;">
                                    -<fmt:formatNumber value="${product.discountPercent * 100}"  />%
                                </span>
                            </c:when>
                            <c:otherwise>
                                <span class="price">
                                    <fmt:formatNumber value="${product.price}" type="currency" currencySymbol="đ" maxFractionDigits="0"/>
                                </span>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <form action="${pageContext.request.contextPath}/cart" method="get" class="product-amount-cart">
                    <input type="hidden" name="action" value="add">
                    <input type="hidden" name="productId" value="${product.id}">
                    <div class="quantity">
                        <label for="quantity">Số lượng: </label>
                        <input type="number" name="quantity" id="quantity" value="1" min="1" max="${product.stock}">
                    </div>
                    <div class="cart">
                        <button type="submit" ${product.stock == 0 ? 'disabled' : ''}>
                            <i class="fa-solid fa-cart-plus"></i> Thêm vào giỏ hàng
                        </button>
                    </div>
                </form>

                <div class="product-attributes-short">
                    <h3>Thông tin chi tiết</h3>
                    <ul>
                        <li><strong>Xuất
                            xứ:</strong> ${not empty product.attribute.origin ? product.attribute.origin : 'Đang cập nhật'}
                        </li>
                        <li><strong>Chất
                            liệu:</strong> ${not empty product.attribute.material ? product.attribute.material : 'Đang cập nhật'}
                        </li>
                        <li><strong>Kích
                            thước:</strong> ${not empty product.attribute.size ? product.attribute.size : 'Đang cập nhật'}
                        </li>
                        <li><strong>Trọng
                            lượng:</strong> ${not empty product.attribute.weight ? product.attribute.weight : 'Đang cập nhật'}
                        </li>
                        <li><strong>Màu
                            sắc:</strong> ${not empty product.attribute.color ? product.attribute.color : 'Đang cập nhật'}
                        </li>
                    </ul>
                </div>
            </div>
        </div>
    </section>

    <section class="product-description">
        <div class="container">
            <div class="product-tab">
                <ul>
                    <li class="tab-link active" onclick="openTab(event, 'tab-description')"><h3>Mô tả sản phẩm</h3></li>
                    <li class="tab-link" onclick="openTab(event, 'tab-review')"><h3>Đánh giá</h3></li>
                </ul>

                <div class="tab">
                    <div id="tab-description" class="tab-content-item" style="display: block;">
                        <div class="product-content">
                            <p>${not empty product.fullDescription ? product.fullDescription : 'Chưa có mô tả chi tiết cho sản phẩm này.'}</p>
                        </div>
                    </div>

                    <div id="tab-review" class="tab-content-item" style="display: none;">
                        <div class="product-content">
                            <c:choose>
                                <c:when test="${not empty reviews}">
                                    <c:forEach items="${reviews}" var="rev">
                                        <div class="review-item" style="border-bottom: 1px solid #eee; margin-bottom: 15px; padding-bottom: 10px;">
                                            <strong style="color: #333;">${rev.userName}</strong>

                                            <span style="color: #ffc107; margin-left: 10px;">
                                                <c:forEach begin="1" end="${rev.rating}">★</c:forEach>
                                            </span>

                                            <p style="margin-top: 10px; color: #555;">${rev.comment}</p>

                                            <small style="color: #999;">
                                                <fmt:formatDate value="${rev.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
                                            </small>
                                        </div>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <p>Hiện chưa có đánh giá nào cho sản phẩm này.</p>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <section class="product-relate">
        <div class="container">
            <div class="product-relate">
                <h2 class="carousel">
                    <span>Sản phẩm liên quan</span>
                </h2>
                <div class="product-grid">
                    <c:forEach items="${relatedProducts}" var="rp" begin="0" end="3">
                        <div class="product-card">
                            <a href="${pageContext.request.contextPath}/productdetail?id=${rp.id}" class="product-link">
                                <div class="product-imgs">
                                    <img src="${rp.imageUrl}" alt="${rp.name}">
                                </div>
                                <div class="product-info">
                                    <h3>${rp.name}</h3>
                                    <div class="price-box">
                                        <c:choose>
                                            <c:when test="${rp.discountPercent > 0}">
                                                <span class="price" style="color: red;">
                                                    <fmt:formatNumber value="${rp.price * (1 - rp.discountPercent/100)}" type="currency" currencySymbol="đ"  maxFractionDigits="0"/>
                                                </span>
                                                <br>
                                                <span class="old-price" style="text-decoration: line-through; color: #999; font-size: 0.8em;">
                                                    <fmt:formatNumber value="${rp.price}" type="currency"  currencySymbol="đ" maxFractionDigits="0"/>
                                                </span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="price">
                                                    <fmt:formatNumber value="${rp.price}" type="currency" currencySymbol="đ" maxFractionDigits="0"/>
                                                </span>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                            </a>
                        </div>
                    </c:forEach>
                    <c:if test="${empty relatedProducts}">
                        <p style="text-align: center; width: 100%;">Không có sản phẩm liên quan.</p>
                    </c:if>
                </div>
            </div>
        </div>
    </section>
</div>
<%@include file="compenents/footer.jsp" %>

<input type="checkbox" id="search-toggle" class="hidden-checkbox">
<label for="search-toggle" class="search-overlay"></label>

<div id="search-panel">
    <div class="search-panel-header">
        <label for="search-toggle" class="close-search-label">
            <i class="fa-solid fa-xmark"></i>
        </label>
    </div>

    <div class="search-panel-content">
        <div class="search-form">
            <input type="text" placeholder="Nhập tên sản phẩm...">
            <i class="fa-solid fa-magnifying-glass search-icon"></i>
        </div>

        <h3>Sản phẩm được tìm nhiều nhất</h3>

        <div class="search-results-list">
            <a href="${pageContext.request.contextPath}/search.jsp" class="search-result-item">
                <div class="search-item-image">
                    <img src="#" alt="Ca tháp">
                </div>
                <div class="search-item-info">
                    <p class="product-name">Ca tháp quai tròn 0.35 L - Jasmine - Trắng</p>
                    <p class="product-price">93.500đ</p>
                </div>
            </a>
        </div>
    </div>
</div>

<div id="cart-modal-overlay">
    <div class="cart-modal-container">
        <div class="cart-modal-header">
            <span><i class="fa-solid fa-cart-shopping"></i> Mua hàng thành công</span>
            <button id="modal-close-x" class="modal-close-btn">&times;</button>
        </div>

        <div class="cart-modal-body">
            <div class="modal-product-info">
                <img src="https://mia.vn/media/uploads/blog-du-lich/Hang-thu-cong-my-nghe-net-dep-truyen-thong-tai-vung-tau-06-1635702336.jpg"
                     alt="product-image" id="modal-product-img">
                <div>
                    <p id="modal-product-name">Ca trà 0.30 L - Mẫu Đơn - Trắng</p>
                    <strong id="modal-product-price">108.000đ</strong>
                </div>
            </div>

            <p class="modal-cart-status">Giỏ hàng của bạn hiện có ${sessionScope.cart.totalQuantity} sản phẩm</p>

            <div class="modal-actions">
                <button id="modal-continue-shopping" class="btn-continue">Tiếp tục mua hàng</button>
                <button id="modal-checkout" class="btn-checkout"><a
                        href="${pageContext.request.contextPath}/shopping-cart.jsp">Đến giỏ hàng</a></button>
            </div>
        </div>
    </div>
</div>

<script src="${pageContext.request.contextPath}/js/hero-section.js"></script>

<script>
    document.addEventListener('DOMContentLoaded', function () {

        const openButton = document.querySelector('.product-detail-info .cart button');
        const modal = document.getElementById('cart-modal-overlay');
        const closeXBtn = document.getElementById('modal-close-x');
        const continueShoppingBtn = document.getElementById('modal-continue-shopping');

        function openModal() {
            if (modal) {
                modal.classList.add('show');
            }
        }

        function closeModal() {
            if (modal) {
                modal.classList.remove('show');
            }
        }

        
        
        
        
        
        

        if (closeXBtn) {
            closeXBtn.addEventListener('click', closeModal);
        }

        if (continueShoppingBtn) {
            continueShoppingBtn.addEventListener('click', closeModal);
        }

        if (modal) {
            modal.addEventListener('click', function (e) {
                if (e.target === modal) {
                    closeModal();
                }
            });
        }
    });
</script>
<script>
    function openTab(evt, tabName) {
        
        var i, tabcontent, tablinks;
        tabcontent = document.getElementsByClassName("tab-content-item");
        for (i = 0; i < tabcontent.length; i++) {
            tabcontent[i].style.display = "none";
        }

        
        tablinks = document.getElementsByClassName("tab-link");
        for (i = 0; i < tablinks.length; i++) {
            tablinks[i].className = tablinks[i].className.replace(" active", "");
        }

        
        document.getElementById(tabName).style.display = "block";
        evt.currentTarget.className += " active";
    }
</script>
</body>
</html>