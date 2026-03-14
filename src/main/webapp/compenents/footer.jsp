<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
            <p>0337429995</p>
          </div>
          <div>
            <i class="fa-solid fa-envelope"></i>
            <p>23130240@st.hcmuaf.edu.vn</p>
          </div>
        </div>

        <div class="info_media">
          <h2>Mạng xã hội</h2>
          <div class="social-icons">
            <a href="#" class="social-icon zalo" aria-label="Zalo"><strong>Za</strong></a>
            <a href="#" class="social-icon fb" aria-label="Facebook"><i class="fa-brands fa-facebook-f"></i></a>
            <a href="#" class="social-icon yt" aria-label="YouTube"><i class="fa-brands fa-youtube"></i></a>
            <a href="#" class="social-icon gg" aria-label="Google"><i class="fa-brands fa-google"></i></a>
          </div>
        </div>
      </div>

      <div class="policy-guide-wrapper">
        <div class="component policy">
          <h2>Chính sách</h2>
          <ul>
            <li><a href="#" class="hover color">Chính sách bảo mật</a></li>
            <li><a href="#" class="hover color">Chính sách vận chuyển</a></li>
            <li><a href="#" class="hover color">Chính sách đổi trả</a></li>
            <li><a href="#" class="hover color">Quy định sử dụng</a></li>
          </ul>
        </div>
        <div class="component guide">
          <h2>Hướng dẫn</h2>
          <ul>
            <li><a href="#" class="hover color">Hướng dẫn mua hàng</a></li>
            <li><a href="#" class="hover color">Hướng dẫn thanh toán</a></li>
            <li><a href="#" class="hover color">Hướng dẫn giao nhận</a></li>
            <li><a href="#" class="hover color">Điều khoản sử dụng</a></li>
          </ul>
        </div>
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

<script>
  
  document.addEventListener("DOMContentLoaded", function() {
    const sliderSection = document.querySelector('.section_intro');
    if(sliderSection){
      const images = [
        'https://denmaytre.net/wp-content/uploads/2019/12/may-tre-dan-ninh-so-vuon-minh-ra-bien-lon.jpg',
        'https://madebymaries.com/wp-content/uploads/2021/09/ancient-2179091_1920.jpg',
        'https://madebymaries.com/wp-content/uploads/2021/09/clay-1139098_1920.jpg'
      ];
      let currentIndex = 0;
      function changeBackground() {
        currentIndex++;
        if (currentIndex >= images.length) currentIndex = 0;
        sliderSection.style.backgroundImage = `url('${images[currentIndex]}')`;
      }
      sliderSection.style.backgroundImage = `url('${images[0]}')`;
      setInterval(changeBackground, 5000);
    }
  });
</script>
