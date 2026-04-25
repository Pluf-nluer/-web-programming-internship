<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">git
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/wishlist.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/header.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/footer.css">
    <title>Sản phẩm yêu thích của tôi</title>
</head>
<body>
<jsp:include page="/compenents/header.jsp" />

<main class="dashboard-main">
    <div class="dashboard-container">
        <aside class="dashboard-sidebar">
            <div class="sidebar-header">
                <div class="user-avatar"><i class="fa-solid fa-user"></i></div>
                <h3>${sessionScope.user.fullName}</h3>
                <p>${sessionScope.user.email}</p>
            </div>

            <nav class="sidebar-menu">
                <a href="${pageContext.request.contextPath}/account/dashboard.jsp" class="menu-item">
                    <i class="fa-solid fa-gauge"></i><span>Bảng điều khiển</span>
                </a>
                <a href="${pageContext.request.contextPath}/account/order.jsp" class="menu-item">
                    <i class="fa-solid fa-box"></i><span>Đơn hàng</span>
                </a>
                <a href="${pageContext.request.contextPath}/account/wishlist.jsp" class="menu-item active">
                    <i class="fa-solid fa-heart"></i><span>Sản phẩm yêu thích</span>
                </a>
                <a href="${pageContext.request.contextPath}/account/account-profile.jsp" class="menu-item">
                    <i class="fa-solid fa-user-circle"></i><span>Thông tin</span>
                </a>
                <a href="${pageContext.request.contextPath}/change-password" class="menu-item">
                    <i class="fa-solid fa-key"></i><span>Đổi mật khẩu</span>
                </a>
                <a href="${pageContext.request.contextPath}/logout" class="menu-item logout">
                    <i class="fa-solid fa-right-from-bracket"></i><span>Đăng xuất</span>
                </a>
            </nav>

            <div class="sidebar-decoration">
                <div class="pattern-circle"></div><div class="pattern-circle"></div><div class="pattern-circle"></div>
            </div>
        </aside>

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
                    <h2><i class="fa-solid fa- list-ul"></i> Danh sách của tôi</h2>
                    <span class="orders-count">Đang có <strong>3</strong> sản phẩm</span>
                </div>

                <div class="wishlist-grid">
                    <div class="wishlist-item">
                        <div class="wishlist-image">
                            <img src="https://thesuncraft.com/wp-content/uploads/2024/10/product-sample-1.jpg" alt="Product">
                            <button class="btn-remove-wishlist" title="Xóa khỏi danh sách">
                                <i class="fa-solid fa-trash-can"></i>
                            </button>
                        </div>
                        <div class="wishlist-info">
                            <h4>Đèn tre thủ công mỹ nghệ</h4>
                            <div class="wishlist-price">450.000 đ</div>
                            <a href="#" class="btn-add-cart">
                                <i class="fa-solid fa-cart-plus"></i> Thêm vào giỏ
                            </a>
                        </div>
                    </div>

                    <div class="wishlist-item">
                        <div class="wishlist-image">
                            <img src="https://thesuncraft.com/wp-content/uploads/2024/10/product-sample-2.jpg" alt="Product">
                            <button class="btn-remove-wishlist" title="Xóa khỏi danh sách">
                                <i class="fa-solid fa-trash-can"></i>
                            </button>
                        </div>
                        <div class="wishlist-info">
                            <h4>Bình gốm Bát Tràng cao cấp</h4>
                            <div class="wishlist-price">1.200.000 đ</div>
                            <a href="#" class="btn-add-cart">
                                <i class="fa-solid fa-cart-plus"></i> Thêm vào giỏ
                            </a>
                        </div>
                    </div>
                </div>

            </div>
        </section>
    </div>
</main>

<jsp:include page="/compenents/footer.jsp" />
</body>
</html>