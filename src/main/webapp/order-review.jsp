<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <title>Đánh Giá Đơn Hàng - ${order.id}</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/order-review.css">
</head>

<body>
<div class="container">
    <button class="close-btn" onclick="window.location.href='${pageContext.request.contextPath}/account/orders'" title="Đóng">
        <i class="bi bi-x"></i>
    </button>

    <div class="header">
        <div class="container-header">
            <a href="${pageContext.request.contextPath}/index.jsp" class="logo">
                <img src="https://suncraft.com.vn/suncraft/Suncraft_website_Inf/suncraft_logo/e6e59529-b1df-4676-a5b2-f3757e67957e.png" alt="Suncraft Logo">
            </a>
            <h1>Đánh giá đơn hàng</h1>
        </div>
        <p class="subtitle">Chia sẻ trải nghiệm của bạn giúp chúng tôi phục vụ tốt hơn</p>
    </div>

    <div class="order-info">
        <h3>📦 Thông tin đơn hàng</h3>
        <p><strong>Mã đơn hàng:</strong> #${order.id}</p>
        <p><strong>Ngày đặt:</strong> <fmt:formatDate value="${order.created_at}" pattern="dd/MM/yyyy" /></p>
        <p><strong>Tổng tiền:</strong>
            <fmt:formatNumber value="${order.total_amount}" type="number" /> VND
        </p>
    </div>

    <div class="main-content">
        <div class="product-section">
            <h3 class="section-title">🛍️ Sản phẩm trong đơn hàng</h3>

            <c:forEach var="item" items="${orderItems}">
                <div class="product-item" id="product-item-${item.productId}">
                    <div class="product-image">
                        <img src="${item.product.image.imageUrl}" alt="${item.product.name}">
                    </div>
                    <div class="product-info">
                        <div class="product-name">${item.product.name}</div>
                        <div class="product-price">
                            <fmt:formatNumber value="${item.product.price}" type="number" />₫
                            <span class="product-quantity">× ${item.quantity}</span>
                        </div>
                    </div>
                    <button type="button" class="product-action-btn review-btn"
                            onclick="selectProduct('${item.productId}', '${item.product.name}')">
                        Đánh giá
                    </button>
                </div>
            </c:forEach>
        </div>

        <form id="review-form" action="${pageContext.request.contextPath}/order-review" method="POST">
            <input type="hidden" name="productId" id="selectedProductId" required>
            <input type="hidden" name="orderId" value="${order.id}">

            <div class="review-section-wrapper">
                <h3 class="section-title">⭐ Đánh giá: <span id="displayProductName" style="color: #e67e22;">(Chọn sản phẩm để đánh giá)</span></h3>

                <div class="rating-section">
                    <div class="rating-label">Bạn đánh giá sản phẩm này như thế nào?</div>
                    <input type="hidden" name="rating" id="ratingInput" value="0" required>
                    <div class="stars" id="stars">
                        <c:forEach var="i" begin="1" end="5">
                            <div class="star-rating" data-rating="${i}">
                                <span style="width:0%"></span>
                            </div>
                        </c:forEach>
                    </div>
                    <div class="rating-text" id="ratingText"></div>
                </div>

                <div class="review-section">
                    <div class="review-label">Nhận xét của bạn</div>
                    <textarea name="comment" class="review-textarea" id="reviewText"
                              placeholder="Hãy chia sẻ cảm nhận của bạn về sản phẩm..."
                              maxlength="500" required></textarea>
                </div>

                <button type="submit" class="submit-btn" id="submitBtn">Gửi đánh giá sản phẩm</button>
            </div>
        </form>
    </div>
</div>

<script>
    
    function selectProduct(pid, pname) {
        document.getElementById('selectedProductId').value = pid;
        document.getElementById('displayProductName').innerText = pname;

        document.querySelectorAll('.product-item').forEach(el => el.classList.remove('active'));
        const selectedItem = document.getElementById('product-item-' + pid);
        if(selectedItem) selectedItem.classList.add('active');

        document.getElementById('review-form').scrollIntoView({ behavior: 'smooth' });
    }

    
    const stars = document.querySelectorAll('.star-rating');
    const ratingInput = document.getElementById('ratingInput');
    const ratingText = document.getElementById('ratingText');
    const ratingTexts = { 1: "Tệ", 2: "Không tốt", 3: "Bình thường", 4: "Tốt", 5: "Tuyệt vời" };

    stars.forEach(star => {
        star.addEventListener('click', () => {
            const val = star.dataset.rating;
            ratingInput.value = val;
            ratingText.innerText = ratingTexts[val];
            stars.forEach(s => {
                const fill = s.querySelector('span');
                fill.style.width = (s.dataset.rating <= val) ? '100%' : '0%';
            });
        });

        star.addEventListener('mouseenter', () => {
            const val = star.dataset.rating;
            stars.forEach(s => {
                const fill = s.querySelector('span');
                fill.style.width = (s.dataset.rating <= val) ? '100%' : '0%';
            });
            ratingText.innerText = ratingTexts[val];
        });
    });

    document.getElementById('stars').addEventListener('mouseleave', () => {
        const currentVal = ratingInput.value;
        stars.forEach(s => {
            const fill = s.querySelector('span');
            fill.style.width = (currentVal && s.dataset.rating <= currentVal) ? '100%' : '0%';
        });
        ratingText.innerText = currentVal ? ratingTexts[currentVal] : "";
    });
</script>
</body>
</html>