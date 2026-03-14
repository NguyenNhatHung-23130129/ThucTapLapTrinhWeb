<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Hướng dẫn thanh toán | Chay Tươi</title>
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
    <a href="TrangChu.jsp"><i class="fas fa-home"></i> Trang chủ</a>
    <span>/</span>
    <span>Hướng dẫn thanh toán</span>
  </div>

  <div class="policy-header">
    <i class="credit-card"></i>
    <h1>HƯỚNG DẪN THANH TOÁN</h1>
    <p class="subtitle">Các phương thức thanh toán linh hoạt và an toàn</p>
  </div>

  <div class="policy-content">
    <section class="policy-section">
      <h2><i class="wallet"></i> 1. Các Phương Thức Thanh Toán</h2>

      <div class="payment-methods">
        <div class="payment-method">
          <i class="money-bill-wave"></i>
          <h3>Thanh toán khi nhận hàng (COD)</h3>
          <ul>
            <li>Thanh toán bằng tiền mặt cho nhân viên giao hàng</li>
            <li>Kiểm tra hàng trước khi thanh toán</li>
            <li>Áp dụng cho đơn hàng dưới 5.000.000đ</li>
            <li>Phí COD: 15.000đ - 30.000đ tùy khu vực</li>
          </ul>
        </div>

        <div class="payment-method">
          <i class="university"></i>
          <h3>Chuyển khoản ngân hàng</h3>
          <ul>
            <li>Chuyển khoản trước, giao hàng sau</li>
            <li>Miễn phí giao hàng cho đơn trên 500.000đ</li>
            <li>Thời gian xử lý: 1-2 giờ sau khi nhận được tiền</li>
          </ul>
          <div class="bank-info">
            <p><strong>Ngân hàng:</strong> Vietcombank - Chi nhánh TP.HCM</p>
            <p><strong>Số tài khoản:</strong> 1234567890</p>
            <p><strong>Chủ tài khoản:</strong> CÔNG TY CHAY TƯƠI</p>
            <p><strong>Nội dung:</strong> [Mã đơn hàng] [Số điện thoại]</p>
          </div>
        </div>

        <div class="payment-method">
          <i class="qrcode"></i>
          <h3>Ví điện tử & QR Code</h3>
          <ul>
            <li>MoMo, ZaloPay, VNPay</li>
            <li>Quét mã QR để thanh toán nhanh</li>
            <li>Xác nhận tức thì, giao hàng ngay</li>
            <li>Được giảm 2% cho đơn từ 300.000đ</li>
          </ul>
        </div>

        <div class="payment-method">
          <i class="credit-card"></i>
          <h3>Thẻ tín dụng/Ghi nợ</h3>
          <ul>
            <li>Visa, Mastercard, JCB</li>
            <li>Thanh toán an toàn qua cổng VNPay</li>
            <li>Hỗ trợ trả góp 0% cho đơn trên 3.000.000đ</li>
          </ul>
        </div>
      </div>
    </section>

    <section class="policy-section">
      <h2><i class="clipboard-list"></i> 2. Quy Trình Thanh Toán</h2>

      <div class="process-tabs">
        <div class="tab-content">
          <h3>A. Thanh toán COD</h3>
          <div class="process-steps">
            <div class="step">
              <div class="step-number">1</div>
              <h4>Đặt hàng</h4>
              <p>Chọn sản phẩm và điền thông tin nhận hàng</p>
            </div>
            <div class="step">
              <div class="step-number">2</div>
              <h4>Xác nhận</h4>
              <p>Nhận cuộc gọi xác nhận từ Chay Tươi</p>
            </div>
            <div class="step">
              <div class="step-number">3</div>
              <h4>Nhận hàng</h4>
              <p>Kiểm tra hàng khi nhân viên giao đến</p>
            </div>
            <div class="step">
              <div class="step-number">4</div>
              <h4>Thanh toán</h4>
              <p>Trả tiền mặt và nhận hóa đơn</p>
            </div>
          </div>
        </div>

        <div class="tab-content">
          <h3>B. Thanh toán chuyển khoản</h3>
          <div class="process-steps">
            <div class="step">
              <div class="step-number">1</div>
              <h4>Đặt hàng</h4>
              <p>Hoàn tất đơn hàng trên website</p>
            </div>
            <div class="step">
              <div class="step-number">2</div>
              <h4>Chuyển khoản</h4>
              <p>Chuyển tiền theo thông tin tài khoản</p>
            </div>
            <div class="step">
              <div class="step-number">3</div>
              <h4>Gửi biên lai</h4>
              <p>Gửi ảnh biên lai qua Zalo/Email</p>
            </div>
            <div class="step">
              <div class="step-number">4</div>
              <h4>Giao hàng</h4>
              <p>Nhận hàng trong 24-48h</p>
            </div>
          </div>
        </div>
      </div>
    </section>

    <section class="policy-section">
      <h2><i class="gift"></i> 3. Ưu Đãi Thanh Toán</h2>
      <div class="promo-grid">
        <div class="promo-card">
          <i class="percentage"></i>
          <h3>Giảm 2%</h3>
          <p>Thanh toán qua ví điện tử</p>
          <span class="condition">Đơn từ 300.000đ</span>
        </div>
        <div class="promo-card">
          <i class="shipping-fast"></i>
          <h3>Miễn phí ship</h3>
          <p>Chuyển khoản trước</p>
          <span class="condition">Đơn từ 500.000đ</span>
        </div>
        <div class="promo-card">
          <i class="coins"></i>
          <h3>Tích điểm</h3>
          <p>Mọi hình thức thanh toán</p>
          <span class="condition">1 điểm/10.000đ</span>
        </div>
      </div>
    </section>

    <section class="policy-section">
      <h2><i class="shield-alt"></i> 4. Bảo Mật Thanh Toán</h2>
      <ul>
        <li>Thông tin thanh toán được mã hóa SSL 256-bit</li>
        <li>Không lưu trữ thông tin thẻ của khách hàng</li>
        <li>Đối tác thanh toán uy tín: VNPay, MoMo, ZaloPay</li>
        <li>Cam kết bảo mật thông tin cá nhân theo chuẩn quốc tế</li>
        <li>Hỗ trợ xác thực 2 lớp (OTP) cho mọi giao dịch</li>
      </ul>
    </section>

    <section class="policy-section highlight">
      <h2><i class="question-circle"></i> 5. Câu Hỏi Thường Gặp</h2>
      <div class="faq">
        <div class="faq-item">
          <h4>Q: Tôi có thể thanh toán một phần không?</h4>
          <p>A: Hiện tại chúng tôi chưa hỗ trợ thanh toán một phần. Quý khách cần thanh toán toàn bộ đơn hàng.</p>
        </div>
        <div class="faq-item">
          <h4>Q: Tôi chuyển khoản nhầm số tiền thì sao?</h4>
          <p>A: Vui lòng liên hệ hotline ngay để được hỗ trợ. Chúng tôi sẽ hoàn trả hoặc điều chỉnh đơn hàng.</p>
        </div>
        <div class="faq-item">
          <h4>Q: Có được đổi hình thức thanh toán không?</h4>
          <p>A: Có thể đổi trước khi đơn hàng được xác nhận. Sau khi xác nhận sẽ không thể thay đổi.</p>
        </div>
      </div>
    </section>

    <section class="policy-section highlight">
      <h2><i class="phone-alt"></i> 6. Hỗ Trợ Thanh Toán</h2>
      <div class="contact-info">
        <p><strong>Hotline:</strong> 0808150866 (24/7)</p>
        <p><strong>Email:</strong> 23130293@hcmuaf.edu.vn</p>
        <p><strong>Zalo:</strong> 0808150866</p>
      </div>
    </section>
  </div>
</div>

<script src="${pageContext.request.contextPath}/assets/js/Header.js"></script>
</body>
</html>
