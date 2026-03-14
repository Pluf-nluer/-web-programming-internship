<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đặt Hàng Thành Công</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/order-success.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/header.css">
</head>
<body>
    <main>
        <div class="order">
            
            <div class="order-header">
                <a href="${pageContext.request.contextPath}/index.jsp" class="logo">
                    <img src="https://suncraft.com.vn/suncraft/Suncraft_website_Inf/suncraft_logo/e6e59529-b1df-4676-a5b2-f3757e67957e.png"
                        alt="Logo">
                </a>
            </div>

            <div class="container">
                <div class="order-left">
                    <div class="order-image">
                        
                        <div class="order-info-thanks">
                            <div class="success-icon">
                                <svg viewBox="0 0 52 52" xmlns="http://www.w3.org/2000/svg">
                                    <circle cx="26" cy="26" r="25" fill="#7ed321" />
                                    <path fill="none" stroke="#fff" stroke-width="3" stroke-linecap="round"
                                        stroke-linejoin="round" d="M14 27l7.5 7.5L38 18" />
                                </svg>
                            </div>
                            <div class="thanks-content">
                                <h3>Cảm ơn bạn đã đặt hàng</h3>
                                <p>Mã đơn hàng: <strong style="color: #2a9dcc;">#${orderId}</strong></p>
                                <span>Một email xác nhận đã được gửi tới <strong>${customerEmail}</strong></span>
                                <span>Xin vui lòng kiểm tra email của bạn.</span>
                            </div>
                        </div>

                        <div class="order-info">
                            <div class="order-info-left">
                                <h3>Thông tin mua hàng</h3>
                                <span>${order.shipping_name}</span>
                                <span>${customerEmail}</span>
                                <span>${order.shipping_phone}</span>

                                <h3 style="margin-top: 15px;">Phương thức thanh toán</h3>
                                <span>Thanh toán khi giao hàng (COD)</span>
                            </div>

                            <div class="order-info-right">
                                <h3>Địa chỉ nhận hàng</h3>
                                <span>${order.shipping_name}</span>
                                <span style="display: block; width: 100%; word-break: break-word;">${order.shipping_address}</span>
                                <span>${order.shipping_phone}</span>

                                <h3 style="margin-top: 15px;">Phương thức vận chuyển</h3>
                                <span>Giao hàng tận nơi</span>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="checkout-sidebar">
                    <div class="order-infos">
                        <div class="order-amount">
                            <h3>Đơn hàng</h3>
                        </div>
                        <div class="order-product">
                            <div class="order-summary">

                                <c:forEach var="item" items="${orderedItems}">
                                    <div class="cart-row">
                                        <div class="cart-items">
                                            <div class="cart-image">
                                                <a href="#" class="cart-item">
                                                    <img src="${item.product.imageUrl}" alt="${item.product.name}">
                                                </a>
                                                <span class="quantity">${item.quantity}</span>
                                            </div>
                                            <div class="cart-info">
                                                <a href="#" class="cart-item-name" style="text-decoration: none; color: #333; font-weight: 500;">${item.product.name}</a>
                                            </div>
                                        </div>
                                        <div class="price-total">
                                            <span><fmt:formatNumber value="${item.product.price*item.quantity}" type="currency" currencySymbol="₫" maxFractionDigits="0"/></span>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                            <div class="order-total">
                                <div class="order-total-top">
                                    <span>Tạm tính</span>
                                <span class="price">
                                    <fmt:formatNumber value="${order.total_amount - 30000}" type="currency" currencySymbol="₫" maxFractionDigits="0"/>
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
                                    <fmt:formatNumber value="${order.total_amount}" type="currency" currencySymbol="₫" maxFractionDigits="0"/>
                                </span>
                                </div>
                                <div class="order-price-bottom">
                                    <a href="${pageContext.request.contextPath}/order-review" class="btn-review">Đánh giá ngay</a>

                                    <a href="${pageContext.request.contextPath}/" class="btn-continue">Tiếp tục mua hàng</a>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </main>
</body>
</html>