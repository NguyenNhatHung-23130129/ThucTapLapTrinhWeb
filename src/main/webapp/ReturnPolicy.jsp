<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Chính sách đổi trả | Chay Tươi</title>
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
    <span>Chính sách đổi trả</span>
  </div>

  <div class="policy-header">
    <i class="sync"></i>
    <h1>CHÍNH SÁCH ĐỔI TRẢ</h1>
    <p class="subtitle">Đổi trả linh hoạt, đảm bảo quyền lợi khách hàng</p>
  </div>

  <div class="policy-content">
    <section class="policy-section">
      <h2><i class="check-circle"></i> 1. Điều Kiện Đổi Trả</h2>
      <p>Chay Tươi chấp nhận đổi trả sản phẩm khi đáp ứng các điều kiện sau:</p>

      <div class="condition-grid">
        <div class="condition-card">
          <i class="box-open"></i>
          <h3>Sản phẩm lỗi</h3>
          <ul>
            <li>Bị hư hỏng trong quá trình vận chuyển</li>
            <li>Bao bì rách, móp méo nghiêm trọng</li>
            <li>Sản phẩm không đúng chất lượng mô tả</li>
            <li>Hết hạn sử dụng hoặc gần hết hạn</li>
          </ul>
        </div>

        <div class="condition-card">
          <i class="exchange-alt"></i>
          <h3>Giao nhầm hàng</h3>
          <ul>
            <li>Sản phẩm không đúng như đơn hàng</li>
            <li>Số lượng không khớp</li>
            <li>Giao thiếu sản phẩm</li>
            <li>Nhầm loại/size sản phẩm</li>
          </ul>
        </div>

        <div class="condition-card">
          <i class="clock"></i>
          <h3>Trong thời hạn</h3>
          <ul>
            <li>Sản phẩm tươi sống: 24 giờ</li>
            <li>Sản phẩm đông lạnh: 48 giờ</li>
            <li>Sản phẩm khô: 7 ngày</li>
            <li>Kể từ khi nhận hàng</li>
          </ul>
        </div>
      </div>
    </section>

    <section class="policy-section">
      <h2><i class="times-circle"></i> 2. Trường Hợp Không Được Đổi Trả</h2>
      <div class="warning-box">
        <ul class="warning-list">
          <li><i class="utensils"></i> Sản phẩm đã qua chế biến hoặc sử dụng</li>
          <li><i class="thermometer-half"></i> Bảo quản không đúng cách (nhiệt độ, độ ẩm)</li>
          <li><i class="calendar-times"></i> Quá thời hạn đổi trả quy định</li>
          <li><i class="file-invoice"></i> Không có hóa đơn hoặc phiếu giao hàng</li>
          <li><i class="user-slash"></i> Lỗi do người mua gây ra</li>
          <li><i class="hand-paper"></i> Khách hàng đã ký nhận hàng không có vấn đề</li>
        </ul>
      </div>
    </section>

    <section class="policy-section">
      <h2><i class="clipboard-list"></i> 3. Quy Trình Đổi Trả</h2>
      <div class="process-steps">
        <div class="step">
          <div class="step-number">1</div>
          <h3>Liên hệ</h3>
          <p>Gọi hotline <strong>0808150866</strong> hoặc nhắn tin qua Zalo/Facebook trong vòng 24h kể từ khi nhận hàng</p>
          <span class="note">Thời gian: 8:00 - 20:00 hàng ngày</span>
        </div>

        <div class="step">
          <div class="step-number">2</div>
          <h3>Cung cấp thông tin</h3>
          <p>Chuẩn bị các thông tin sau:</p>
          <ul>
            <li>Mã đơn hàng</li>
            <li>Ảnh sản phẩm lỗi (bao bì, tem nhãn)</li>
            <li>Video unbox (nếu có)</li>
            <li>Hóa đơn mua hàng</li>
          </ul>
        </div>

        <div class="step">
          <div class="step-number">3</div>
          <h3>Xác nhận</h3>
          <p>Bộ phận CSKH kiểm tra và xác nhận yêu cầu trong vòng <strong>2-4 giờ</strong></p>
          <span class="note">Thời gian xử lý nhanh trong giờ hành chính</span>
        </div>

        <div class="step">
          <div class="step-number">4</div>
          <h3>Đổi/Trả hàng</h3>
          <p>Chúng tôi sẽ:</p>
          <ul>
            <li><i class="truck"></i> Đến tận nơi lấy hàng cũ</li>
            <li><i class="box"></i> Giao hàng mới (nếu đổi)</li>
            <li><i class="money-bill-wave"></i> Hoàn tiền 100% (nếu trả)</li>
          </ul>
        </div>

        <div class="step">
          <div class="step-number">5</div>
          <h3>Hoàn tất</h3>
          <p>Nhận hàng mới hoặc nhận tiền hoàn trong vòng:</p>
          <ul>
            <li>24h: Nội thành TP.HCM</li>
            <li>48-72h: Ngoại thành và tỉnh khác</li>
            <li>3-5 ngày: Hoàn tiền qua ngân hàng</li>
          </ul>
        </div>
      </div>
    </section>

    <section class="policy-section">
      <h2><i class="undo"></i> 4. Hình Thức Đổi Trả</h2>
      <div class="return-options">
        <div class="option-card">
          <i class="sync"></i>
          <h3>Đổi sản phẩm mới</h3>
          <ul>
            <li>Đổi sản phẩm cùng loại</li>
            <li>Đổi sang sản phẩm khác (nếu còn hàng)</li>
            <li>Bù trừ chênh lệch (nếu có)</li>
            <li>Miễn phí vận chuyển đổi hàng</li>
          </ul>
        </div>

        <div class="option-card">
          <i class="money-bill-wave"></i>
          <h3>Hoàn tiền 100%</h3>
          <ul>
            <li>Hoàn tiền qua tài khoản ngân hàng</li>
            <li>Hoàn qua ví điện tử (MoMo, ZaloPay)</li>
            <li>Hoàn tiền mặt (nếu thanh toán COD)</li>
            <li>Thời gian: 3-5 ngày làm việc</li>
          </ul>
        </div>

        <div class="option-card">
          <i class="gift"></i>
          <h3>Đổi voucher</h3>
          <ul>
            <li>Nhận voucher 110% giá trị đơn hàng</li>
            <li>Sử dụng cho lần mua tiếp theo</li>
            <li>Thời hạn: 30 ngày</li>
            <li>Áp dụng toàn bộ sản phẩm</li>
          </ul>
        </div>
      </div>
    </section>

    <section class="policy-section">
      <h2><i class="shipping-fast"></i> 5. Chi Phí Đổi Trả</h2>
      <table class="fee-table">
        <thead>
        <tr>
          <th>Trường hợp</th>
          <th>Phí vận chuyển</th>
          <th>Chi phí xử lý</th>
        </tr>
        </thead>
        <tbody>
        <tr>
          <td><i class="check-circle text-success"></i> Lỗi từ shop</td>
          <td><strong>Miễn phí</strong></td>
          <td><strong>Miễn phí</strong></td>
        </tr>
        <tr>
          <td><i class="check-circle text-success"></i> Giao nhầm hàng</td>
          <td><strong>Miễn phí</strong></td>
          <td><strong>Miễn phí</strong></td>
        </tr>
        <tr>
          <td><i class="user"></i> Đổi ý (trong 24h)</td>
          <td>30.000đ - 50.000đ</td>
          <td>Miễn phí</td>
        </tr>
        <tr>
          <td><i class="user"></i> Đổi ý (sau 24h)</td>
          <td>30.000đ - 50.000đ</td>
          <td>10% giá trị đơn</td>
        </tr>
        </tbody>
      </table>
    </section>

    <section class="policy-section">
      <h2><i class="lightbulb"></i> 6. Lưu Ý Quan Trọng</h2>
      <div class="tips-box">
        <div class="tip-item">
          <i class="video"></i>
          <p><strong>Quay video khi mở hàng:</strong> Để làm bằng chứng nếu sản phẩm có vấn đề</p>
        </div>
        <div class="tip-item">
          <i class="search"></i>
          <p><strong>Kiểm tra kỹ khi nhận:</strong> Xem xét bao bì, hạn sử dụng, chất lượng trước khi ký nhận</p>
        </div>
        <div class="tip-item">
          <i class="thermometer-half"></i>
          <p><strong>Bảo quản đúng cách:</strong> Theo hướng dẫn trên nhãn sản phẩm</p>
        </div>
        <div class="tip-item">
          <i class="file-invoice"></i>
          <p><strong>Giữ hóa đơn:</strong> Cần thiết cho việc đổi trả và bảo hành</p>
        </div>
      </div>
    </section>

    <section class="policy-section highlight">
      <h2><i class="question-circle"></i> 7. Câu Hỏi Thường Gặp</h2>
      <div class="faq">
        <div class="faq-item">
          <h4>Q: Tôi đổi ý không muốn mua nữa, có được trả không?</h4>
          <p>A: Được, nhưng cần liên hệ trong vòng 24h và chịu phí vận chuyển. Sản phẩm phải còn nguyên vẹn.</p>
        </div>
        <div class="faq-item">
          <h4>Q: Sản phẩm bị hỏng một phần, tôi có thể đổi không?</h4>
          <p>A: Có, chúng tôi sẽ đổi toàn bộ sản phẩm mới cho bạn. Vui lòng chụp ảnh và liên hệ ngay.</p>
        </div>
        <div class="faq-item">
          <h4>Q: Tôi đã ký nhận hàng rồi, có được đổi trả không?</h4>
          <p>A: Được, miễn là còn trong thời hạn và sản phẩm có vấn đề từ shop. Hãy liên hệ ngay với chúng tôi.</p>
        </div>
        <div class="faq-item">
          <h4>Q: Bao lâu tôi nhận lại tiền khi trả hàng?</h4>
          <p>A: 3-5 ngày làm việc cho chuyển khoản, 1-2 ngày cho ví điện tử, ngay khi xác nhận cho tiền mặt.</p>
        </div>
      </div>
    </section>

    <section class="policy-section highlight">
      <h2><i class="phone-alt"></i> 8. Liên Hệ Hỗ Trợ</h2>
      <div class="contact-info">
        <p><i class="phone"></i> <strong>Hotline:</strong> 0808150866 (8:00 - 20:00 hàng ngày)</p>
        <p><i class="envelope"></i> <strong>Email:</strong> 23130293@hcmuaf.edu.vn</p>
        <p><i class="map-marker-alt"></i> <strong>Địa chỉ:</strong> Đại học Nông Lâm, Linh Trung, Thủ Đức, TP.HCM</p>
        <p><i class="facebook"></i> <strong>Facebook:</strong> fb.com/ChayTuoi</p>
        <p><i class="twitter"></i> <strong>Zalo:</strong> 0808150866</p>
      </div>
    </section>
  </div>
</div>
<script src="assets/js/Header.js"></script>
</body>
</html>
