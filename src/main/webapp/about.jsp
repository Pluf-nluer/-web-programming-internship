<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link
    rel="stylesheet"
    href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"
    />
    <title>Giới thiệu - Về chúng tôi</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/header.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/footer.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/about.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/hero-section.css">
</head>
<body>
<c:set var="activeTab" value="about" scope="request"/>
<%@ include file="compenents/header.jsp" %>
<c:set var="pageTitle" value="Giới thiệu" scope="request"/>
<c:set var="breadcrumbText"
       value="<a href='${pageContext.request.contextPath}/about.jsp'>Giới thiệu</a>"
       scope="request"/>

<jsp:include page="compenents/hero-section.jsp"/>
    <div id="about-us-page">
        <div class="about-container">

            <div class="section-title-center">
                <h2>Về chúng tôi</h2>
                <p>Khám phá câu chuyện và sứ mệnh của Nhóm 10</p>
            </div>

            <section class="story-section">
                <div class="story-content">
                    <h3>Câu chuyện của chúng tôi</h3>
                    <p>Là một doanh nghiệp xã hội tiên phong trong việc phát triển và quảng bá các sản phẩm thủ công mỹ nghệ độc đáo của dân tộc Việt Nam.</p>
                    <p>Với tâm huyết bảo tồn và phát triển các làng nghề thủ công truyền thống, nhóm chúng tôi không chỉ mang đến những sản phẩm tinh xảo mà còn góp phần nâng cao đời sống của các nghệ nhân và người lao động ở các làng nghề, bảo vệ môi trường và gìn giữ bản sắc văn hóa dân tộc.</p>
                </div>
                <div class="story-image">
                    <img src="https://toplist.vn/images/800px/lang-nghe-may-tre-dan-ninh-so-281406.jpg" alt="Nghệ nhân thủ công">
                </div>
            </section>

        </div><section class="products-section">
            <div class="about-container">
                <div class="section-title-center">
                    <h2>Sản Phẩm và Dịch Vụ</h2>
                    <p>Tập trung phát triển các sản phẩm làng nghề thủ công Việt Nam, mang đến sự đa dạng và phong phú trong từng sản phẩm.</p>
                </div>

                <div class="products-grid">
                    <div class="product-card">
                        <div class="product-image">
                            <img src="https://denmaytre.net/wp-content/uploads/2019/12/san-pham-may-tre-dan-xuat-khau-lang-nghe-tang-tien.jpg.webp" alt="Mây tre đan">
                        </div>
                        <div class="product-info">
                            <h4>Mây tre đan</h4>
                        </div>
                    </div>

                    <div class="product-card">
                        <div class="product-image">
                            <img src="https://cdn.pixabay.com/photo/2023/05/29/18/10/pottery-8026823_1280.jpg" alt="Gốm sứ">
                        </div>
                        <div class="product-info">
                            <h4>Gốm sứ</h4>
                        </div>
                    </div>

                    <div class="product-card">
                        <div class="product-image">
                            <img src="https://dntt.mediacdn.vn/197608888129458176/2023/7/14/27-1-1689328749793900374452.jpg" alt="Đồ gỗ mỹ nghệ">
                        </div>
                        <div class="product-info">
                            <h4>Đồ gỗ mỹ nghệ</h4>
                        </div>
                    </div>

                    <div class="product-card">
                        <div class="product-image">
                            <img src="https://images.pexels.com/photos/236748/pexels-photo-236748.jpeg" alt="Dệt thêu & may mặc thủ công">
                        </div>
                        <div class="product-info">
                            <h4>Dệt thêu & may mặc thủ công</h4>
                        </div>
                    </div>

                    <div class="product-card">
                        <div class="product-image">
                            <img src="https://nvhphunu.vn/wp-content/uploads/2023/12/2023-07-29_0000478.png" alt="Trang sức & phụ kiện thủ công">
                        </div>
                        <div class="product-info">
                            <h4>Trang sức & phụ kiện thủ công</h4>
                        </div>
                    </div>

                    <div class="product-card">
                        <div class="product-image">
                            <img src="https://chus.vn/images/detailed/239/10237_21_F1.jpg" alt="Đồ trang trí & quà tặng nghệ thuật">
                        </div>
                        <div class="product-info">
                            <h4>Đồ trang trí & quà tặng nghệ thuật</h4>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <div class="about-container">
            <section class="vision-mission-section">
                <div class="vision-mission-grid">
                    <div class="vision-mission-item">
                        <svg class="icon" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor"><path d="M12 4.5C7 4.5 2.73 7.61 1 12c1.73 4.39 6 7.5 11 7.5s9.27-3.11 11-7.5C21.27 7.61 17 4.5 12 4.5zM12 17c-2.76 0-5-2.24-5-5s2.24-5 5-5 5 2.24 5 5-2.24 5-5 5zm0-8c-1.66 0-3 1.34-3 3s1.34 3 3 3 3-1.34 3-3-1.34-3-3-3z"/></svg>
                        <h4>Tầm nhìn</h4>
                        <p>Trở thành doanh nghiệp tiên phong trong việc bảo tồn và phát triển các làng nghề thủ công truyền thống Việt Nam, tạo ra giá trị bền vững cho cộng đồng và môi trường.</p>
                    </div>

                    <div class="vision-mission-image">
                        <img src="https://bcp.cdnchinhphu.vn/334894974524682240/2023/6/16/nghe-nhan-16868857004851326065658.jpg" alt="Nghệ nhân thủ công">
                    </div>

                    <div class="vision-mission-item">
                        <svg class="icon" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor"><path d="M14.4 6L14 4H5v17h2v-7h5.6l.4 2h7V6h-5.6z"/></svg>
                        <h4>Sứ mệnh</h4>
                        <p>Tôn vinh, quảng bá và phát triển các làng nghề; mang đến cho khách hàng những sản phẩm chất lượng cao; hỗ trợ các nhóm dân tộc thiểu số, các nhóm khuyết tật; góp phần vào việc cải thiện đời sống của nghệ nhân và gìn giữ bản sắc văn hóa dân tộc.</p>
                    </div>
                </div>
            </section>
        </div><section class="core-values-section">
            <div class="about-container">
                <div class="section-title-center">
                    <h2>Giá trị cốt lõi</h2>
                    <p>Những giá trị định hướng mọi hoạt động của chúng tôi</p>
                </div>

                <div class="values-grid">
                    <div class="value-item">
                        <svg class="icon" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor"><path d="M12 2L2 7l10 15 10-15L12 2zm0 2.34L18.63 9H5.37L12 4.34z"/></svg>
                        <h4>Tinh hoa thủ công</h4>
                        <p>Mỗi sản phẩm đều được chế tác tỉ mỉ, kết hợp giữa kỹ thuật truyền thống và sự sáng tạo hiện đại, mang đến những tác phẩm nghệ thuật độc đáo.</p>
                    </div>

                    <div class="value-item">
                        <svg class="icon" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor"><path d="M12 2C9.24 2 7 4.24 7 7c0 2.24 1.24 4.15 3 5.18V17h-2v2h2v2h2v-2h2v-2h-2v-4.82c1.76-.97 3-2.94 3-5.18 0-2.76-2.24-5-5-5z"/></svg>
                        <h4>Bền vững</h4>
                        <p>Sử dụng nguyên liệu thân thiện với môi trường và áp dụng quy trình sản xuất bền vững, góp phần bảo vệ môi trường và duy trì tài nguyên thiên nhiên.</p>
                    </div>

                    <div class="value-item">
                        <svg class="icon" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor"><path d="M16 11c1.66 0 2.99-1.34 2.99-3S17.66 5 16 5c-1.66 0-3 1.34-3 3s1.34 3 3 3zm-8 0c1.66 0 2.99-1.34 2.99-3S9.66 5 8 5C6.34 5 5 6.34 5 8s1.34 3 3 3zm0 2c-2.33 0-7 1.17-7 3.5V18h14v-1.5c0-2.33-4.67-3.5-7-3.5zm8 0c-.29 0-.62.02-.97.05 1.16.84 1.97 1.97 1.97 3.45V18h6v-1.5c0-2.33-4.67-3.5-7-3.5z"/></svg>
                        <h4>Trách nhiệm xã hội</h4>
                        <p>Tích cực hỗ trợ cộng đồng nghệ nhân, đảm bảo đời sống ổn định và phát triển bền vững, đặc biệt là các nhóm yếu thế trong xã hội.</p>
                    </div>

                    <div class="value-item">
                        <svg class="icon" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor"><path d="M12 1L2 6v2h20V6L12 1zm0 2.34L18.63 7H5.37L12 3.34zM4 9v11h16V9H4zm2 2h2v7H6v-7zm4 0h2v7h-2v-7zm4 0h2v7h-2v-7z"/></svg>
                        <h4>Bảo tồn văn hóa</h4>
                        <p>Duy trì và phát triển các kỹ thuật thủ công truyền thống, góp phần bảo tồn bản sắc văn hóa dân tộc Việt Nam qua từng sản phẩm.</p>
                    </div>
                </div>
            </div>
        </section>

        <section class="development-orientation-section">
            <div class="about-container">
                <div class="section-title-center">
                    <h2>Định Hướng Phát Triển</h2>
                </div>

                <div class="orientation-grid">
                    <div class="orientation-item">
                        <h4>Mở rộng thị trường</h4>
                        <p>Trong tương lai, sẽ tiếp tục mở rộng thị trường cả trong nước và quốc tế, để giới thiệu, quảng bá vẻ đẹp của nghệ thuật thủ công Việt Nam đến bạn bè thế giới.</p>
                    </div>
                    <div class="orientation-item">
                        <h4>Nghiên cứu và phát triển</h4>
                        <p>Doanh nghiệp cũng sẽ đầu tư mạnh mẽ vào nghiên cứu và phát triển, nhằm không ngừng cải tiến chất lượng sản phẩm và mang đến những giá trị tốt đẹp hơn nữa cho cộng đồng.</p>
                    </div>
                    <div class="orientation-item">
                        <h4>Phát triển bền vững</h4>
                        <p>Tin rằng, thông qua những nỗ lực và cam kết của mình, doanh nghiệp sẽ góp phần bảo tồn và phát triển nền văn hóa thủ công mỹ nghệ Việt Nam, đồng thời xây dựng một cộng đồng nghệ nhân, làng nghề bền vững.</p>
                    </div>
                </div>
            </div>
        </section>
        <section class="testimonials-section">
            <div class="about-container">
                <div class="section-title-center testimonial-header">
                    <h2 class="serif-title">Khách hàng nói gì về chúng tôi</h2>
                    <p>Những đánh giá chân thực từ khách hàng đã trải nghiệm sản phẩm</p>
                </div>

                <div class="testimonials-grid">
                    <div class="testimonial-card">
                        <div class="stars">
                            <i class="fa-solid fa-star"></i>
                            <i class="fa-solid fa-star"></i>
                            <i class="fa-solid fa-star"></i>
                            <i class="fa-solid fa-star"></i>
                            <i class="fa-solid fa-star"></i>
                        </div>
                        <p class="review-text">"Tôi vô cùng hài lòng với chiếc khăn lụa tơ tằm mua từ cửa hàng. Chất lượng tuyệt vời, màu sắc rực rỡ và họa tiết tinh tế. Đây là món quà hoàn hảo cho bạn bè quốc tế."</p>
                        <div class="user-info">
                            <img src="https://i.pravatar.cc/150?img=11" alt="Nguyễn Thị Minh" class="user-avatar">
                            <div class="user-details">
                                <h4>Nguyễn Thị Minh</h4>
                                <span>Hà Nội</span>
                            </div>
                        </div>
                    </div>

                    <div class="testimonial-card">
                        <div class="stars">
                            <i class="fa-solid fa-star"></i>
                            <i class="fa-solid fa-star"></i>
                            <i class="fa-solid fa-star"></i>
                            <i class="fa-solid fa-star"></i>
                            <i class="fa-solid fa-star"></i>
                        </div>
                        <p class="review-text">"Tranh sơn mài mà tôi mua từ cửa hàng đã trở thành điểm nhấn trong phòng khách của tôi. Màu sắc và họa tiết truyền thống kết hợp với thiết kế hiện đại tạo nên một tác phẩm nghệ thuật đẹp mắt."</p>
                        <div class="user-info">
                            <img src="https://i.pravatar.cc/150?img=5" alt="Trần Văn Nam" class="user-avatar">
                            <div class="user-details">
                                <h4>Trần Văn Nam</h4>
                                <span>TP. Hồ Chí Minh</span>
                            </div>
                        </div>
                    </div>

                    <div class="testimonial-card">
                        <div class="stars">
                            <i class="fa-solid fa-star"></i>
                            <i class="fa-solid fa-star"></i>
                            <i class="fa-solid fa-star"></i>
                            <i class="fa-solid fa-star"></i>
                            <i class="fa-solid fa-star"></i>
                        </div>
                        <p class="review-text">"Tôi rất ấn tượng với chất lượng sản phẩm thổ cẩm từ cửa hàng. Mỗi sản phẩm đều mang đậm bản sắc văn hóa dân tộc và được làm thủ công tỉ mỉ. Dịch vụ khách hàng cũng rất chu đáo."</p>
                        <div class="user-info">
                            <img src="https://i.pravatar.cc/150?img=12" alt="Lê Thị Hương" class="user-avatar">
                            <div class="user-details">
                                <h4>Lê Thị Hương</h4>
                                <span>Đà Nẵng</span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </section>

    </div>
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
                    <h2>Chính sách</h2> <ul> <li><a href="#" class="hover color">Chính sách bảo mật</a></li>
                        <li><a href="#" class="hover color">Chính sách vận chuyển</a></li>
                        <li><a href="#" class="hover color">Chính sách đổi trả</a></li>
                        <li><a href="#" class="hover color">Quy định sử dụng</a></li>
                    </ul> </div>
                <div class="component guide">
                    <h2>Hướng dẫn</h2> <ul> <li><a href="#" class="hover color">Hướng dẫn mua hàng</a></li>
                        <li><a href="#" class="hover color">Hướng dẫn thanh toán</a></li>
                        <li><a href="#" class="hover color">Hướng dẫn giao nhận</a></li>
                        <li><a href="#" class="hover color">Điều khoản sử dụng</a></li>
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
                    <img src="" alt="Ca tháp">
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
