<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<fmt:setLocale value="vi_VN" />
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
                <img src="https://thesuncraft.com/wp-content/webp-express/webp-images/uploads/2024/10/logo-thesuncraft.png.webp" alt="Logo Suncraft">
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
                            <small id="phoneError" class="error-text">
                                <i class="fa-solid fa-circle-exclamation"></i>Gồm 10 số bắt đầu 03, 05, 07, 08, 09
                            </small>
                        </div>

                        <div class="form-group">
                            <label for="address">Địa chỉ</label>
                            <input type="text"  id="address" placeholder="Địa chỉ (Số nhà, đường...)" required
                                   value="${not empty sessionScope.checkoutForm.address ? sessionScope.checkoutForm.address : ''}">
                        </div>

                        <input type="hidden" id="fullAddressInput" name="address">
                        <div class="form-group">
                            <label for="province">Tỉnh / Thành phố</label>
                            <select id="province" name="province" required>
                                <option value="" disabled  selected }>Chọn Tỉnh / Thành phố</option>

                            </select>
                        </div>

                        <div class="form-group">
                            <label for="district">Quận / Huyện</label>
                            <select id="district" name="district"required>
                                <option value="" disabled   selected }>Chọn Quận / Huyện</option>

                            </select>
                        </div>

                        <div class="form-group">
                            <label for="ward">Phường / Xã</label>
                            <select id="ward" name="ward" required>
                                <option value="" disabled  selected }>Chọn Phường / Xã</option>

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
                            <span>30.000 đ</span>
                        </div>
                    </div>
                </div>

                <div class="payment">
                    <h3>Thanh toán</h3>
                    <div class="payment-options">
                        <label for="payment-cod" class="payment-option">
                            <input type="radio" id="payment-cod" name="paymentMethod" value="1">
                            <span>Thanh toán khi giao hàng (COD)</span>
                            <i class="fa fa-money-bill-alt"></i>
                        </label>
                        <div class="payment-info" id="info-cod">
                            <span>Bạn chỉ thanh toán khi nhận hàng</span>
                        </div>
                    </div>

                    <div class="payment-options">
                        <label for="payment-momo" class="payment-option">
                            <input type="radio" id="payment-momo" name="paymentMethod" value="2">
                            <span>Thanh toán qua ví Momo</span>
                            <i class="fa-solid fa-wallet"></i>
                        </label>
                        <div class="payment-info" id="info-momo">
                            <span>Chuyển hướng đến ứng dụng Momo</span>
                        </div>
                    </div>

                    <div class="payment-options">
                        <label for="payment-vnpay" class="payment-option">
                            <input type="radio" id="payment-vnpay" name="paymentMethod" value="3">
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

                    <c:forEach var="item" items="${checkoutItems}">
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
                                <fmt:formatNumber value = "${item.product.price * item.quantity}" pattern="#,### đ"/>
                            </div>

                        </div>
                    </c:forEach>
                </div>

                <div class="order-total">
                    <div class="order-total-top">
                        <span>Tạm tính</span>
                        <span class="price">
                            <fmt:formatNumber value="${totalCheckout}" pattern="#,### đ"/>
                        </span>
                    </div>
                    <div class="order-total-bottom">
                        <span>Phí vận chuyển</span>
                        <span class="price">30.000 đ</span>
                    </div>
                </div>

                <div class="order-price">
                    <div class="order-price-top">
                        <span>Tổng cộng</span>
                        <span class="price">
                            <fmt:formatNumber value="${totalCheckout + 30000}" pattern="#,### đ"/>
                        </span>
                    </div>
                    <div class="order-price-bottom">
                        <a href="${pageContext.request.contextPath}/cart" class="back-to-cart">
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

<script>
    document.addEventListener("DOMContentLoaded", function (){
        const provinceSelect = document.getElementById("province");
        const districtSelect = document.getElementById("district");
        const wardSelect = document.getElementById("ward");
        const address = document.getElementById("address");
        const fullAddress = document.getElementById("fullAddressInput");
        const phoneInput = document.getElementById("phone");
        const checkoutForm = document.getElementById("checkoutForm");
        const phoneErr = document.getElementById("phoneError");
        fetch('https://provinces.open-api.vn/api/p/') //danh sách tỉnh tp từ việc gọi api
            .then(response=>response.json()).then(data=>{
                data.forEach(province=>{
                    let option = document.createElement("option");
                    option.value = province.code;
                    option.text = province.name;
                    option.setAttribute("data-name",province.name);
                    provinceSelect.add(option);
                });
        });
        provinceSelect.addEventListener("change",function (){
            // khi bấm chọn tỉnh thì load huyện
            const provinceCode = this.value;
            districtSelect.innerHTML = '<option value="" disabled selected> Chọn Quận / Huyện</option>';
            wardSelect.innerHTML = '<option value="" disabled selected> Chọn Phường / Xã</option>';
            wardSelect.disabled = true;
            if(provinceCode){
                fetch('https://provinces.open-api.vn/api/p/'+provinceCode+'?depth=2')
                    .then(response=>response.json())
                    .then(data =>{
                        data.districts.forEach(district =>{
                            let option = document.createElement("option");
                            option.value = district.code;
                            option.text = district.name;
                            option.setAttribute("data-name",district.name);
                            districtSelect.add(option);
                        });
                        districtSelect.disabled = false;
                    }).catch(err=> console.error("Lỗi danh sách huyện:", err));
            }
            updateFullAddress();
        });

        districtSelect.addEventListener("change",function (){
            const districtCode = this.value;
            wardSelect.innerHTML = '<option value="" disabled selected>Chọn Phường / Xã</option>';
            wardSelect.disabled = true;
            if(districtCode){
                fetch('https://provinces.open-api.vn/api/d/'+districtCode+'?depth=2')
                    .then(response=>response.json()).then(data=>{
                        data.wards.forEach(ward=>{
                            let option = document.createElement("option");
                            option.value = ward.code;
                            option.text = ward.name;
                            option.setAttribute("data-name",ward.name);
                            wardSelect.add(option)
                        });
                        wardSelect.disabled = false;
                }).catch(err=> console.error("Lỗi danh sách xã:",err));
            }
            updateFullAddress();

        });
        wardSelect.addEventListener("change",updateFullAddress);
        address.addEventListener("input",updateFullAddress);// ở xã và input nhận vào có thay đổi gì không

        function updateFullAddress() {
            let pName = provinceSelect.options[provinceSelect.selectedIndex]?.getAttribute("data-name")||"";
            let dName = districtSelect.options[districtSelect.selectedIndex]?.getAttribute("data-name")||"";
            let wName = wardSelect.options[wardSelect.selectedIndex]?.getAttribute("data-name")||"";
            let detail= address.value.trim();
            let finaladd = [];
            if(detail) finaladd.push(detail);
            if(wName) finaladd.push(wName);
            if(dName) finaladd.push(dName);
            if(pName) finaladd.push(pName);
            fullAddress.value = finaladd.join(", "); // gộp chuỗi về servlet qua name=address
        }
        const phoneRegex = /^(03|05|07|08|09)\d{8}$/;
        phoneInput.addEventListener("keypress",function (event){
            const str = event.key;
            if(!/^[0-9]$/.test(str)){
                event.preventDefault();
                return;
            }
            if(phoneInput.value.length >=10){
                event.preventDefault();
            }
        });
        function validateP(){
            const phoneValue = phoneInput.value.trim();
            if(!phoneRegex.test(phoneValue)){
                phoneErr.classList.add("active");
                phoneInput.classList.add("input-error");
                return false;
            }else{
                phoneErr.classList.remove("active");
                phoneInput.classList.remove("input-error");
                return true;
            }
        }
        phoneInput.addEventListener("input", validateP);
        checkoutForm.addEventListener("submit",function (e){
            if(!validateP()){
                e.preventDefault();
                phoneInput.focus();
            }
        });
    });
</script>
</body>
</html>