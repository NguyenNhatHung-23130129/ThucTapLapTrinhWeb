
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/normalize/8.0.1/normalize.min.css"
          integrity="sha512-NhSC1YmyruXifcj/KFRWoC561YpHpc5Jtzgvbuzx5VozKpWvQ+4nXhPdFgmx8xqexRcpAglTj9sIBWINXa8x5w=="
          crossorigin="anonymous" referrerpolicy="no-referrer"/>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.1/css/all.min.css"
          integrity="sha512-2SwdPD6INVrV/lHTZbO2nodKhrnDdJK9/kg2XD1r9uGqPo1cUbujc+IYdlYdEErWNu69gVcYgdxlmVmzTWnetw=="
          crossorigin="anonymous" referrerpolicy="no-referrer"/>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@500;600;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/Footer.css">
    <title>Footer</title>
</head>
<body>
<footer>

    <div class="support-section">
        <h2 class="support-title">Hỗ Trợ Khách Hàng</h2>

        <div class="support-grid">

            <div class="support-item">
                <a href="WarrantyPolicy.jsp" class="support-link">
                    <div class="support-icon">
                        <i class="fas fa-shield-alt"></i>
                    </div>
                    <h3>CHÍNH SÁCH BẢO HÀNH</h3>
                    <p>Thông tin quy định về các trường hợp sản phẩm được hoặc không được bảo hành.</p>
                </a>

            </div>


            <div class="support-item">
                <a href="PaymentInstructions.jsp" class="support-link">
                    <div class="support-icon">
                        <i class="credit-card"></i>
                    </div>
                    <h3>HƯỚNG DẪN THANH TOÁN</h3>
                    <p>Chi tiết về các phương thức thanh toán, quy trình thanh toán và điều kiện áp dụng</p>
                </a>
            </div>


            <div class="support-item">
                <a href="ReturnPolicy.jsp" class="support-link">
                    <div class="support-icon">
                        <i class="sync-alt"></i>
                    </div>
                    <h3>CHÍNH SÁCH ĐỔI TRẢ</h3>
                    <p>Chính sách đổi trả linh hoạt nếu sản phẩm không đạt yêu cầu</p>
                </a>
            </div>
        </div>
    </div>


    <div class="footer-container">
        <div class="footer-grid">

            <div class="footer-column">
                <h3>Chay Tươi</h3>
                <p class="info-text">Trách nhiệm hữu hạn 3 thành viên :) )</p>

            </div>


            <div class="footer-column">
                <h3>Thông tin liên hệ</h3>
                <p class="info-text">
                    <span class="info-icon">📍</span>
                    <strong>Địa chỉ:</strong> Đại học Nông Lâm, Linh Trung, Thủ Đức, Tp. Hồ Chí Minh.
                </p>
                <p class="info-text">
                    <span class="info-icon">📞</span>
                    0808150866
                </p>
                <p class="info-text">
                    <span class="info-icon">✉️</span>
                    Email: 23130293@hcmuaf.edu.vn
                </p>

            </div>


            <div class="footer-column">
                <h3>Hỗ trợ khách hàng</h3>
                <ul>
                    <li><a href="PaymentInstructions.jsp">Hướng dẫn thanh toán</a></li>
                    <li><a href="WarrantyPolicy.jsp">Chính sách bảo hành</a></li>
                    <li><a href="ReturnPolicy.jsp">Chính sách đổi trả</a></li>
                </ul>
            </div>


            <div class="footer-column">
                <h3>Về chúng tôi</h3>
                <ul>
                    <li><a href="#">Giới thiệu</a></li>
                    <li><a href="#">Tin tức</a></li>
                    <li><a href="#">Liên hệ</a></li>
                </ul>
            </div>
        </div>
    </div>
</footer>
</body>
</html>