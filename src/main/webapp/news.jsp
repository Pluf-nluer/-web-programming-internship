<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link
    rel="stylesheet"
    href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"
    />
    <title>Tin tức</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/news.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/header.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/footer.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/hero-section.css">
</head>
<body>
<c:set var="activeTab" value="news" scope="request"/>
<%@ include file="compenents/header.jsp" %>
<c:set var="pageTitle" value="Tin tức" scope="request"/>
<c:set var="breadcrumbText"
       value="<a href='${pageContext.request.contextPath}/news'>Tin tức</a>"
       scope="request"/>
<jsp:include page="compenents/hero-section.jsp"/>
<section class="container">
    <div class="news-layout">
        <main class="main-content">
            <nav class="filter-tabs">
                <ul>
                    <li><a href="#" class="active">Tất cả</a></li>
                    <li><a href="#">Bộ Trà</a></li>
                    <li><a href="#">Cà phê</a></li>
                    <li><a href="#">Phụ kiện trà - cà phê</a></li>
                </ul>
            </nav>
            <div class="post-gird">
                <c:forEach var="p" items="${posts}">
                    <div class="news-card">
                        <div class="block">
                            <div class="news-image">
                                <a href="news-detail?id=${p.id}">
                                    <img src="${p.featuredImageUrl}" alt="${p.title}">
                                </a>
                            </div>
                            <div class="news-text">
                                <span><fmt:formatDate value="${p.createdAt}" pattern="dd 'tháng' MM 'năm' yyyy"/></span>
                                <h3><a href="news-detail?id=${p.id}" style="text-decoration: none; color: inherit;">${p.title}</a></h3>
                                <p>${p.shortContent}</p>
                                <a href="news-detail?id=${p.id}" class="read-more">Xem thêm</a>
                            </div>
                        </div>
                    </div>
                </c:forEach>

                <c:if test="${empty posts}">
                    <p>Hiện chưa có bài viết nào.</p>
                </c:if>
            </div>
        </main>
        <div class="sidebar">
            <div class="news-category">
                <h2>Danh mục</h2>
                <ul>
                    <li>
                        <a href="#">
                            <span class="items">Phòng ăn</span>
                        </a>
                    </li>
                    <li>
                        <a href="#">
                            <span class="items">Trà - cà phê</span>
                        </a>
                    </li>
                    <li>
                        <a href="#">
                            <span class="items">Nồi sứ dưỡng sinh</span>
                        </a>
                    </li>
                    <li>
                        <a href="#">
                            <span class="items">Sứ dưỡng sinh</span>
                        </a>
                    </li>
                    <li>
                        <a href="#">
                            <span class="items">Phụ kiện bàn ăn</span>
                        </a>
                    </li>
                    <li>
                        <a href="#">
                            <span class="items">Sứ nghệ thuật</span>
                        </a>
                    </li>
                </ul>
            </div>
            <div class="news-hot">
                    <h2>Tin tức nổi bậc</h2>
                    <div class="post-list">
                        <c:forEach var="fp" items="${featuredPosts}">
                            <div class="post-item">
                                <a href="news-detail?id=${fp.id}" class="news-hot-image">
                                    <img src="${fp.featuredImageUrl}" alt="${fp.title}" >
                                </a>
                                <div class="news-hot-title">
                                    <a href="news-detail?id=${fp.id}">${fp.title}</a>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </div>
            </div>
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
                    <h2>Chính sách</h2> <ul> <li><a href="policy/security.html" class="hover color">Chính sách bảo mật</a></li>
                    <li><a href="policy/transport.html" class="hover color">Chính sách vận chuyển</a></li>
                    <li><a href="policy/change.html" class="hover color">Chính sách đổi trả</a></li>
                    <li><a href="policy/regulation-use.html" class="hover color">Quy định sử dụng</a></li>
                </ul> </div>
                <div class="component guide">
                    <h2>Hướng dẫn</h2> <ul> <li><a href="guide/purchase.html" class="hover color">Hướng dẫn mua hàng</a></li>
                    <li><a href="guide/payment.html" class="hover color">Hướng dẫn thanh toán</a></li>
                    <li><a href="guide/delivery.html" class="hover color">Hướng dẫn giao nhận</a></li>
                    <li><a href="guide/clause.html" class="hover color">Điều khoản sử dụng</a></li>
                </ul> </div>
            </div>

            <div class="others">
                <h2>Đăng ký nhận tin</h2>
                <p>Đăng ký ngay! Để nhận nhiều ưu đãi</p>
                <div class="input">
                    <input type="text" name="Email" id="email" placeholder="Nhập địa chỉ email">
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

            <a href="./search.html" class="search-result-item">
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
</body>
</html>