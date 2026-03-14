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
            <div style="text-align: center; padding: 50px; background: #fff; border-radius: 8px;">
                <i class="fa-solid fa-cart-arrow-down" style="font-size: 50px; color: #ccc; margin-bottom: 20px;"></i>
                <h3>Giỏ hàng của bạn đang trống!</h3>
                <p>Hãy thêm sản phẩm để tiến hành thanh toán.</p>
                <a href="${pageContext.request.contextPath}/products" style="display: inline-block; margin-top: 15px; padding: 10px 20px; background: #e67e22; color: white; text-decoration: none; border-radius: 5px;">Quay lại mua sắm</a>
            </div>
        </c:if>

        <c:if test="${sessionScope.cart != null && sessionScope.cart.totalQuantity > 0}">
            <div class="cart-layout">
                <div class="cart-left">
                    <div class="cart-header">
                        <span>Thông tin sản phẩm</span>
                        <span>Đơn giá</span>
                        <span>Số lượng</span>
                        <span>Thành tiền</span>
                    </div>
                    <div class="cart-body">

                    <c:forEach var="item" items="${sessionScope.cart.items}">

                        <div class="cart-row" style="display: flex; align-items: center; border-bottom: 1px solid #eee; padding: 15px 0;">

                            <div class="cart-items" style="flex: 2; display: flex; align-items: center; gap: 15px;">
                                <a href="productdetail?id=${item.product.id}" class="cart-item">
                                    <img src="${item.product.imageUrl}" alt="image" style="width: 80px; height: 80px; object-fit: cover; border-radius: 5px;">
                                </a>
                                <div class="cart-info">
                                    <strong class="cart-item-name" style="font-size: 1.1em;">${item.product.name}</strong>

                                    <br>
                                    <a href="cart?action=remove&productId=${item.product.id}" class="cart-item-delete" style="color: #ff4d4f; font-size: 0.9em; text-decoration: none; margin-top: 5px; display: inline-block;" onclick="return confirm('Bạn muốn xóa sản phẩm này?');">
                                        <i class="fa-solid fa-trash"></i> Xóa
                                    </a>
                                </div>
                            </div>

                            <div class="price" style="flex: 1; text-align: center;">
                                <span style="font-weight: 500;">
                                    <fmt:formatNumber value="${item.product.price}" type="currency" currencySymbol="₫" maxFractionDigits="0"/>
                                </span>
                            </div>

                            <div class="cart-items-quantity" style="flex: 1; text-align: center;">
                                <form action="cart" method="GET" class="quantity" style="display: flex; justify-content: center; align-items: center; width: fit-content; border: 1px solid #333333;">
                                    <input type="hidden" name="action" value="update">
                                    <input type="hidden" name="productId" value="${item.product.id}">

                                    <button type="submit" name="quantity" value="${item.quantity - 1}" ${item.quantity <= 1 ? 'disabled' : ''} style="cursor: pointer; width: 30px; height: 30px; border: 1px solid #ddd; background: white;">-</button>
                                    <input type="text" value="${item.quantity}" readonly style="width: 40px; height: 30px; text-align: center; border: 1px solid #ddd; border-left: none; border-right: none; outline: none;">
                                    <button type="submit" name="quantity" value="${item.quantity + 1}" style="cursor: pointer; width: 30px; height: 30px; border: 1px solid #ddd; background: white;">+</button>
                                </form>
                            </div>

                            <div class="price-total" style="flex: 1; text-align: right; font-weight: bold; color: #d0021b; font-size: 1.1em;">
                                <fmt:formatNumber value="${item.product.price * item.quantity}" type="currency" currencySymbol="₫" maxFractionDigits="0"/>
                            </div>

                        </div>

                    </c:forEach>
                    </div>
                </div>

                <div class="cart-footer">
                    <div class="total-summary">
                        <div class="total-price">
                            <span>Tổng tiền: </span>
                            <span style="font-weight: bold; color: #d0021b; font-size: 20px;">
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
<footer id="footer">
    <div class="container">
        <div class="content">
            <div class="info">
                <div class="info_details">
                    <h2>Thông tin</h2>
                    <div>
                        <i class="fa-solid fa-location-dot"></i>
                        <p>Trường Đại học Nông Lâm Tp.Hcm</p>
                    </div>
                    <div>
                        <i class="fa-solid fa-phone"></i>
                        <p>0337429995</p> </div>
                    <div>
                        <i class="fa-solid fa-envelope"></i>
                        <p>23130240@st.hcmuaf.edu.vn</p> </div>
                </div>

                <div class="info_media">
                    <h2>Mạng xã hội</h2>
                    <div class="social-icons">
                        <a href="#" class="social-icon zalo" aria-label="Zalo">
                            <strong>Za</strong>
                        </a>
                        <a href="#" class="social-icon fb" aria-label="Facebook">
                            <i class="fa-brands fa-facebook-f"></i>
                        </a>
                        <a href="#" class="social-icon yt" aria-label="YouTube">
                            <i class="fa-brands fa-youtube"></i>
                        </a>
                        <a href="#" class="social-icon gg" aria-label="Google">
                            <i class="fa-brands fa-google"></i>
                        </a>
                    </div>
                </div>
            </div>

            <div class="policy-guide-wrapper">
                <div class="component policy">
                    <h2>Chính sách</h2> <ul> <li><a href="policy/security.jsp" class="hover color">Chính sách bảo mật</a></li>
                    <li><a href="policy/transport.jsp" class="hover color">Chính sách vận chuyển</a></li>
                    <li><a href="policy/change.jsp" class="hover color">Chính sách đổi trả</a></li>
                    <li><a href="policy/regulation-use.jsp" class="hover color">Quy định sử dụng</a></li>
                </ul> </div>
                <div class="component guide">
                    <h2>Hướng dẫn</h2> <ul> <li><a href="guide/purchase.jsp" class="hover color">Hướng dẫn mua hàng</a></li>
                    <li><a href="guide/payment.jsp" class="hover color">Hướng dẫn thanh toán</a></li>
                    <li><a href="guide/delivery.jsp" class="hover color">Hướng dẫn giao nhận</a></li>
                    <li><a href="guide/clause.jsp" class="hover color">Điều khoản sử dụng</a></li>
                </ul> </div>
            </div>

            <div class="others">
                <h2>Đăng ký nhận tin</h2>
                <p>Đăng ký ngay! Để nhận nhiều ưu đãi</p>
                <div class="input">
                    <input type="text" name="Email" id="address" placeholder="Nhập địa chỉ email">
                    <button>Đăng ký</button>
                </div>
            </div>
        </div>
    </div>
</footer>
<script src="js/hero-section.js"></script>
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
                    <img src="#" alt="Ca bia">
                </div>
                <div class="search-item-info">
                    <p class="product-name">Ca bia 0.36 L - Jasmine - Trắng</p>
                    <p class="product-price">75.900đ</p>
                </div>
            </a>

        </div>
    </div>
</div>
</body>
</html>