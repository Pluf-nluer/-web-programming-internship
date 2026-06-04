<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<fmt:setLocale value="vi_VN" />
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
<div id="toast-container"></div>
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

                        <div class="cart-row" id="cart-row-${item.product.id}">
                            <input type = "checkbox" value = "${item.product.id}" class = "item-checkbox single-check" data-price = "${item.product.price}" data-qty = "${item.quantity}">
                            <div class="cart-items">
                                <a href="productdetail?id=${item.product.id}" class="cart-item">
                                    <img src="${item.product.imageUrl}" alt="image">
                                </a>
                                <div class="cart-info">
                                    <strong class="cart-item-name">${item.product.name}</strong>

                                    <br>
                                    <button type="button" class="cart-item-delete btn-remove-ajax" data-id = "${item.product.id}" >
                                        <i class="fa-solid fa-trash"></i> Xóa
                                    </button>
                                </div>
                            </div>

                            <div class="price">
                                <span>
                                    <fmt:formatNumber value="${item.product.price}" pattern="#,##0"/> đ
                                </span>
                            </div>

                            <div class="cart-items-quantity">
                                <div class="quantity">

                                    <button type="button" class="btn-qty-ajax" data-action = "decrease" name="quantity" data-id="${item.product.id}">-</button>
                                    <input type="text" id="qty-input-${item.product.id}" value="${item.quantity}" readonly>
                                    <button type="button" class="btn-qty-ajax" data-action="increase" name="quantity" data-id="${item.product.id}">+</button>
                                </div>
                            </div>

                            <div class="price-total" id="row-total-${item.product.id}">
                                <fmt:formatNumber value="${item.product.price * item.quantity}" pattern="#,##0"/> đ
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
                            <span>Tổng tiền (<span id="totalSelectedCount">0</span>sản phẩm):</span>
                            <span id = "dynamicTotalMoney">0₫</span>
                        </div>
                        <a href="#" class="btn-checkout disabled" id = "btnCheckout">Thanh toán</a>
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
    // window.addEventListener("beforeunload", function() {
    //     sessionStorage.setItem("position", window.scrollY);
    // });
    document.addEventListener("DOMContentLoaded", function() {
        // let scrollPos = sessionStorage.getItem("position");
        const searchInput = document.getElementById("ajaxSearchInput");
        const resultArea = document.getElementById("searchResultArea");
        const searchTitle = document.getElementById("searchTitle");
        const checkAll = document.getElementById("selectedAll");
        let itemChecks = document.querySelectorAll(".single-check")
        const totalMoneyDisplay = document.getElementById('dynamicTotalMoney');
        const totalCountDisplay = document.getElementById('totalSelectedCount');
        const btnCheckout = document.getElementById('btnCheckout');
        const cartBody = document.getElementById('cart-body');
        // if (scrollPos) {
        //     window.scrollTo(0, scrollPos);
        //     sessionStorage.removeItem("position");
        // }
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
        function calculateTotal(){
            let totalMoney = 0;
            let totalItems = 0;

            itemChecks.forEach(check =>{
                if(check.checked){
                    let price = parseFloat(check.getAttribute("data-price"));
                    let qty = parseInt(check.getAttribute("data-qty"));
                    totalMoney += (price*qty);
                    totalItems += qty;
                }
            });
            if(totalMoneyDisplay){
                totalMoneyDisplay.innerText = new Intl.NumberFormat('vi-VN').format(totalMoney) + "đ";
            }
            if(totalCountDisplay){
                totalCountDisplay.innerText = totalItems;
            }
            if(btnCheckout){
                if(totalItems>0){
                    btnCheckout.classList.remove('disabled');
                }else{
                    btnCheckout.classList.add('disabled');
                }

            }
        }

        // thanh toan
        if(btnCheckout){
            btnCheckout.addEventListener('click', function(e){
                e.preventDefault();
                if(this.classList.contains('disabled')){
                    return;
                }
                let selectedId = [];
                itemChecks.forEach(check => {
                    if(check.checked){
                        selectedId.push("selectedId="+check.value);
                    }
                });
                if(selectedId.length > 0){
                    let query = selectedId.join("&");
                    window.location.href = "${pageContext.request.contextPath}/checkout?"+query;
                }
            });
        }
        // Thông báo
        function showInfo(message,type= 'success'){
            const container = document.getElementById('toast-container');
            const toast = document.createElement('div');
            toast.className = ' toast' + type + ' show';
            toast.innerText = message;
            container.append(toast);
            setTimeout(() =>{
                toast.classList.remove('show');
                setTimeout(()=>toast.remove(),300);
            },3000);
        }
        // Danh sách sau khi xóa
        function refreshChecks(){
            itemChecks = document.querySelectorAll(".single-check");
            itemChecks.forEach(check =>{
                check.removeEventListener('change',handleCheck);
                check.addEventListener('change',handleCheck)
            });
        }
        function handleCheck(){
            if(!this.checked && checkAll){
                checkAll.checked = false;
            }
            let allChecked = Array.from(itemChecks).every(c => c.checked);
            if(itemChecks.length >0&&checkAll ){
                checkAll.checked = allChecked;
            }
            calculateTotal();
        }
        refreshChecks(); // Tạo lại checkbox
        if(checkAll){
            checkAll.addEventListener('change', function (){
                itemChecks.forEach(c=>c.checked = this.checked);
                calculateTotal();
            });
        }
        // Tăng giảm
        document.querySelectorAll('.btn-qty-ajax').forEach(button=>{
           button.addEventListener('click',function (){
              const action = this.getAttribute('data-action');
              const productId = this.getAttribute('data-id');
              const input = document.getElementById('qty-input-' + productId);
              let current = parseInt(input.value);
              if(action==='decrease' && current<=1){
                  return;
              }
              let newQty = action ==='increase'?current+1:current-1;
              fetch('${pageContext.request.contextPath}/cart?action=updateAjax&productId='+productId+'&quantity=' +newQty)
                  .then(response=>response.json()).then(data=>{
                  if(data.success){
                      input.value = data.newQuantity;
                      const checkbox = document.querySelector('input.single-check[value="'+productId+'"]');
                      if (checkbox){
                          checkbox.setAttribute('data-qty',data.newQuantity);
                      }
                      const rowTotal = document.getElementById('row-total-'+productId);
                      if(rowTotal){
                          rowTotal.innerText = new Intl.NumberFormat('vi-VN').format(data.rowTotal)+" đ";
                      }
                      calculateTotal();
                      const headerCount = document.getElementById('header-cart-count');
                      if(headerCount){
                          headerCount.innerText = data.totalCartQuantity;
                      }
                  }else{
                      showInfo(data.message);
                  }
              }).catch(err => console.error("Lỗi ajax:",err));
           });
        });


        // Xóa
        document.querySelectorAll('.btn-remove-ajax').forEach(button=>{
            button.addEventListener('click', function (e){
                e.preventDefault();
                if(!confirm('Bạn có chắc muốn xoa sản phẩm này ra khỏi giỏ hàng')){
                    return;
                }
                const productId = this.getAttribute('data-id');
                fetch('${pageContext.request.contextPath}/cart?action=removeAjax&productId='+productId)
                    .then(response=>response.json())
                    .then(data=>{
                        if(data.success){
                            const row = document.getElementById('cart-row-'+productId);
                            if(row){
                                row.remove();
                            }
                            refreshChecks();
                            calculateTotal();
                            showInfo("Đã xóa thành công sản phẩm");
                            const headerCount = document.getElementById('header-cart-count');
                            if(headerCount) {
                                headerCount.innerText = data.totalCartQuantity;
                            }
                            if(data.totalCartQuantity === 0){
                                window.location.reload();
                            }
                        }else{
                            showInfo(data.message || "Lỗi xóa sản phẩm", 'error');
                        }
                    }).catch(err=>console.error("Lỗi khi xóa",err));
            });
        });
    });
</script>
</body>
</html>