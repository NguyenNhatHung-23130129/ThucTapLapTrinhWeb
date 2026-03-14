
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%><!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Chính sách bảo hành | Chay Tươi</title>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/normalize/8.0.1/normalize.min.css"
        integrity="sha512-NhSC1YmyruXifcj/KFRWoC561YpHpc5Jtzgvbuzx5VozKpWvQ+4nXhPdFgmx8xqexRcpAglTj9sIBWINXa8x5w=="
        crossorigin="anonymous" referrerpolicy="no-referrer"/>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.1/css/all.min.css"
        integrity="sha512-2SwdPD6INVrV/lHTZbO2nodKhrnDdJK9/kg2XD1r9uGqPo1cUbujc+IYdlYdEErWNu69gVcYgdxlmVmzTWnetw=="
        crossorigin="anonymous" referrerpolicy="no-referrer"/>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@500;600;800&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/CustomerSupport.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/Nav.css">
</head>
<body>
<%@ include file="Header.jsp"%>
<div class="container">
  <div class="breadcrumb">
    <a href="TrangChu.jsp"><i class="fa-home"></i> Trang chủ</a>
    <span>/</span>
    <span>Chính sách bảo hành</span>
  </div>

  <div class="policy-header">
    <i class="shield-alt"></i>
    <h1>CHÍNH SÁCH BẢO HÀNH</h1>
    <p class="subtitle">Cam kết chất lượng và bảo vệ quyền lợi khách hàng</p>
  </div>

  <div class="policy-content">
    <section class="policy-section">
      <h2><i class="check-circle"></i> 1. Điều Kiện Bảo Hành</h2>
      <p>Chay Tươi cam kết bảo hành cho các sản phẩm thực phẩm chay đáp ứng đầy đủ các điều kiện sau:</p>
      <ul>
        <li>Sản phẩm còn trong thời hạn sử dụng được in trên bao bì</li>
        <li>Bao bì còn nguyên vẹn, không bị rách, móp méo hay hư hỏng</li>
        <li>Sản phẩm được bảo quản đúng cách theo hướng dẫn trên nhãn</li>
        <li>Có hóa đơn mua hàng hoặc phiếu giao hàng từ Chay Tươi</li>
        <li>Sản phẩm chưa qua sử dụng hoặc chế biến</li>
      </ul>
    </section>

    <section class="policy-section">
      <h2><i class="fa-clock"></i> 2. Thời Gian Bảo Hành</h2>
      <div class="info-box">
        <div class="info-item">
          <i class="snowflake"></i>
          <h3>Sản phẩm đông lạnh</h3>
          <p>Bảo hành trong vòng 7 ngày kể từ ngày nhận hàng</p>
        </div>
        <div class="info-item">
          <i class="temperature-low"></i>
          <h3>Sản phẩm tươi sống</h3>
          <p>Bảo hành trong vòng 3 ngày kể từ ngày nhận hàng</p>
        </div>
        <div class="info-item">
          <i class="fa-box"></i>
          <h3>Sản phẩm khô</h3>
          <p>Bảo hành trong vòng 15 ngày kể từ ngày nhận hàng</p>
        </div>
      </div>
    </section>

    <section class="policy-section">
      <h2><i class="times-circle"></i> 3. Trường Hợp Không Được Bảo Hành</h2>
      <ul class="warning-list">
        <li>Sản phẩm đã qua chế biến hoặc sử dụng một phần</li>
        <li>Hư hỏng do bảo quản không đúng cách (nhiệt độ, độ ẩm)</li>
        <li>Hết hạn sử dụng do khách hàng để quá lâu</li>
        <li>Bao bì bị rách do tác động từ bên ngoài</li>
        <li>Không có hóa đơn hoặc chứng từ mua hàng</li>
        <li>Sản phẩm không mua từ Chay Tươi</li>
      </ul>
    </section>

    <section class="policy-section">
      <h2><i class="clipboard-list"></i> 4. Quy Trình Bảo Hành</h2>
      <div class="process-steps">
        <div class="step">
          <div class="step-number">1</div>
          <h3>Liên hệ</h3>
          <p>Gọi hotline 0808150866 hoặc gửi email để thông báo</p>
        </div>
        <div class="step">
          <div class="step-number">2</div>
          <h3>Cung cấp thông tin</h3>
          <p>Gửi ảnh sản phẩm, hóa đơn và mô tả vấn đề</p>
        </div>
        <div class="step">
          <div class="step-number">3</div>
          <h3>Xác nhận</h3>
          <p>Chúng tôi xem xét và phản hồi trong 24h</p>
        </div>
        <div class="step">
          <div class="step-number">4</div>
          <h3>Giải quyết</h3>
          <p>Đổi mới sản phẩm hoặc hoàn tiền 100%</p>
        </div>
      </div>
    </section>

    <section class="policy-section highlight">
      <h2><i class="phone-alt"></i> 5. Thông Tin Liên Hệ</h2>
      <div class="contact-info">
        <p><strong>Hotline:</strong> 0808150866 (8:00 - 20:00 hàng ngày)</p>
        <p><strong>Email:</strong> 23130293@hcmuaf.edu.vn</p>
        <p><strong>Địa chỉ:</strong> Đại học Nông Lâm, Linh Trung, Thủ Đức, TP.HCM</p>
      </div>
    </section>
  </div>
</div>
<script src="assets/js/Header.js"></script>
</body>


</html>