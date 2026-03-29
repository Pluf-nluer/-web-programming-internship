<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thanh toán</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/checkout.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>
</head>
<body>

<main class="checkout-layout">
    <div class="checkout-main">
        <header class="header">
            <a href="${pageContext.request.contextPath}/" class="logo">
                <img src="https://suncraft.com.vn/suncraft/Suncraft_website_Inf/suncraft_logo/e6e59529-b1df-4676-a5b2-f3757e67957e.png" alt="Suncraft Logo">
            </a>
        </header>

        <form id="checkoutForm" action="checkout" method="POST" class="container">

            <div class="checkout-info-left">
                <div class="checkout-info">
                    <div class="section-header">
                        <h3>Thông tin nhận hàng</h3>
                    </div>

                    <div class="info-form">
                        <div class="form-group">
                            <label for="email">Email</label>
                            <input type="email" name="email" id="email" placeholder="Email"
                                   value="${not empty sessionScope.checkoutForm.email ? sessionScope.checkoutForm.email : (sessionScope.user != null ? sessionScope.user.email : '')}" required>
                        </div>

                        <div class="form-group">
                            <label for="full-name">Họ và tên</label>
                            <input type="text" name="fullname" id="full-name" placeholder="Họ và tên"
                                   value="${not empty sessionScope.checkoutForm.fullname ? sessionScope.checkoutForm.fullname : (sessionScope.user != null ? sessionScope.user.fullName : '')}" required>
                        </div>

                        <div class="form-group">
                            <label for="phone">Số điện thoại</label>
                            <div class="phone-input-group">
                                <input type="tel" name="phone" id="phone" placeholder="Số điện thoại"
                                       value="${not empty sessionScope.checkoutForm.phone ? sessionScope.checkoutForm.phone : (sessionScope.user != null ? sessionScope.user.phone : '')}" required>
                                <select class="country-code">
                                    <option>🇻🇳</option>
                                </select>
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="address">Địa chỉ</label>
                            <input type="text" name="address" id="address" placeholder="Địa chỉ (Số nhà, đường...)" required
                                   value="${not empty sessionScope.checkoutForm.address ? sessionScope.checkoutForm.address : ''}">
                        </div>

                        <div class="form-group">
                            <label for="province">Tỉnh / Thành phố</label>
                            <select id="province" name="province">
                                <option value="" disabled ${empty sessionScope.checkoutForm.province ? 'selected' : ''}>Chọn Tỉnh / Thành phố</option>
                                <option value="Hồ Chí Minh" ${sessionScope.checkoutForm.province == 'Hồ Chí Minh' ? 'selected' : ''}>Hồ Chí Minh</option>
                                <option value="Hà Nội" ${sessionScope.checkoutForm.province == 'Hà Nội' ? 'selected' : ''}>Hà Nội</option>
                                <option value="Đà Nẵng" ${sessionScope.checkoutForm.province == 'Đà Nẵng' ? 'selected' : ''}>Đà Nẵng</option>
                            </select>
                        </div>

                        <div class="form-group">
                            <label for="district">Quận / Huyện</label>
                            <select id="district" name="district">
                                <option value="" disabled ${empty sessionScope.checkoutForm.district ? 'selected' : ''}>Chọn Quận / Huyện</option>
                                <option value="Quận 1" ${sessionScope.checkoutForm.district == 'Quận 1' ? 'selected' : ''}>Quận 1</option>
                                <option value="Thủ Đức" ${sessionScope.checkoutForm.district == 'Thủ Đức' ? 'selected' : ''}>Thủ Đức</option>
                            </select>
                        </div>

                        <div class="form-group">
                            <label for="ward">Phường / Xã</label>
                            <select id="ward" name="ward">
                                <option value="" disabled ${empty sessionScope.checkoutForm.ward ? 'selected' : ''}>Chọn Phường / Xã</option>
                                <option value="Linh Trung" ${sessionScope.checkoutForm.ward == 'Linh Trung' ? 'selected' : ''}>Linh Trung</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label for="note">Ghi chú</label>
                            <textarea id="note" name="note" rows="3" placeholder="Ghi chú (tùy chọn)">${sessionScope.checkoutForm.note}</textarea>
                        </div>
                    </div>
                </div>
            </div>

            <div class="checkout-info-right">
                <h3>Vận chuyển</h3>
                <div class="checkout-sidebars">
                    <div class="shipping-note">
                        <label for="shipping-note" class="payment-option">
                            <input type="radio" id="shipping-note" checked>
                            <span>Giao hàng tận nơi</span>
                        </label>
                        <div class="shipping-price">
                            <span>30.000₫</span>
                        </div>
                    </div>
                </div>

                <div class="payment">
                    <h3>Thanh toán</h3>
                    <div class="payment-options">
                        <label for="payment-cod" class="payment-option">
                            <input type="radio" id="payment-cod" name="paymentMethod" value="COD">
                            <span>Thanh toán khi giao hàng (COD)</span>
                            <i class="fa fa-money-bill-alt"></i>
                        </label>
                        <div class="payment-info" id = "info-cod">
                            <span>Bạn chỉ thanh toán khi nhận hàng</span>
                        </div>
                    </div>

                    <div class="payment-options">
                        <label for="payment-momo" class="payment-option">
                            <input type="radio" id="payment-momo" name="paymentMethod" value="Momo">
                            <span>Thanh toán qua ví Momo</span>
                            <i class="fa-solid fa-wallet"></i>
                        </label>
                        <div class="payment-info" id="info-momo">
                            <span>Chuyển hướng đến ứng dụng Momo</span>
                        </div>
                    </div>

                    <div class="payment-options">
                        <label for="payment-bank" class="payment-option">
                            <input type="radio" id="payment-bank" name="paymentMethod" value="Bank" checked>
                            <span>Thanh toán qua ngân hàng</span>
                            <i class="fa-solid fa-building-columns"></i>
                        </label>
                        <div class="payment-info" id="info-bank">
                            <span>Chuyển tiền trước khi nhận hàng</span>
                        </div>
                    </div>

                    <div class="payment-options">
                        <label for="payment-vnpay" class="payment-option">
                            <input type="radio" id="payment-vnpay" name="paymentMethod" value="VnPay">
                            <span>Thanh toán qua VNPay</span>
                            <i class="fa-solid fa-qrcode"></i>
                        </label>
                        <div class="payment-info" id="info-vnpay">
                            <span>Chuyển tiền trước khi nhận hàng</span>
                        </div>
                    </div>
                </div>
            </div>

        </form> </div>

    <div class="checkout-sidebar">
        <div class="order-info">
            <div class="order-amount">
                <h3>Đơn hàng (${sessionScope.cart.totalQuantity} sản phẩm)</h3>
            </div>

            <div class="order-product">
                <div class="order-summary">

                    <c:forEach var="item" items="${sessionScope.cart.items}">
                        <div class="cart-row">
                            <div class="cart-items">
                                <div class="cart-image" style="position: relative;">
                                    <a href="#" class="cart-item">
                                        <img src="${item.product.imageUrl}" alt="${item.product.name}">
                                    </a>
                                    <span class="quantity">${item.quantity}</span>
                                </div>
                                <div class="cart-info">
                                    <a href="#" class="cart-item-name">${item.product.name}</a>
                                </div>
                            </div>

                            <div class = "cart-item-price">
                                <fmt:formatNumber value = "${item.product.price * item.quantity}" type = "currency" currencySymbol = "₫" maxFractionDigits = "0"/>
                            </div>

                        </div>
                    </c:forEach>
                </div>

                <div class="order-total">
                    <div class="order-total-top">
                        <span>Tạm tính</span>
                        <span class="price">
                            <fmt:formatNumber value="${sessionScope.cart.totalMoney}" type="currency" currencySymbol="₫" maxFractionDigits="0"/>
                        </span>
                    </div>
                    <div class="order-total-bottom">
                        <span>Phí vận chuyển</span>
                        <span class="price">30.000₫</span>
                    </div>
                </div>

                <div class="order-price">
                    <div class="order-price-top">
                        <span>Tổng cộng</span>
                        <span class="price">
                            <fmt:formatNumber value="${sessionScope.cart.totalMoney + 30000}" type="currency" currencySymbol="₫" maxFractionDigits="0"/>
                        </span>
                    </div>
                    <div class="order-price-bottom">
                        <a href="${pageContext.request.contextPath}/shopping-cart.jsp" class="back-to-cart">
                            <span><i class="fa-solid fa-chevron-left"></i> Quay về giỏ hàng</span>
                        </a>

                        <button type="submit" form="checkoutForm" class="btn-order">
                            Đặt hàng</button>
                    </div>
                </div>
            </div>
        </div>
    </div>
</main>

</body>
</html>