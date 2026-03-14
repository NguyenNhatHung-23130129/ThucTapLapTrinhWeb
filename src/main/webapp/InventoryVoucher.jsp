<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Voucher | Chay Tươi</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/normalize/8.0.1/normalize.min.css"
          integrity="sha512-NhSC1YmyruXifcj/KFRWoC561YpHpc5Jtzgvbuzx5VozKpWvQ+4nXhPdFgmx8xqexRcpAglTj9sIBWINXa8x5w=="
          crossorigin="anonymous" referrerpolicy="no-referrer"/>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.1/css/all.min.css"
          integrity="sha512-2SwdPD6INVrV/lHTZbO2nodKhrnDdJK9/kg2XD1r9uGqPo1cUbujc+IYdlYdEErWNu69gVcYgdxlmVmzTWnetw=="
          crossorigin="anonymous" referrerpolicy="no-referrer"/>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/assest/css/Voucher.css" />
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@500;600;800&display=swap" rel="stylesheet">


</head>
<%@ include file="Header.jsp"%>
<body>
<div class="section">
    <h2>Voucher Nổi Bật</h2>

    <div class="voucher-grid">
        <div class="voucher-card">
            <div>
                <div class="icon-row">
                    <div class="icon-box">
                        <span class="material-icons-outlined">local_offer</span>
                    </div>
                    <div>
                        <h3>Giảm 50K</h3>
                        <p>Cho đơn hàng từ 250K</p>
                    </div>
                </div>
                <p class="expire">HSD: 31/12/2024</p>
            </div>
            <button class="btn-primary">Lưu voucher</button>
        </div>

        <div class="voucher-card">
            <div>
                <div class="icon-row">
                    <div class="icon-box">
                        <span class="material-icons-outlined">local_shipping</span>
                    </div>
                    <div>
                        <h3>Freeship 0Đ</h3>
                        <p>Cho mọi đơn hàng</p>
                    </div>
                </div>
                <p class="expire">HSD: 30/11/2024</p>
            </div>
            <button class="btn-primary">Lưu voucher</button>
        </div>

        <div class="voucher-card">
            <div>
                <div class="icon-row">
                    <div class="icon-box">
                        <span class="material-icons-outlined">confirmation_number</span>
                    </div>
                    <div>
                        <h3>Giảm 15%</h3>
                        <p>Tối đa 30K, cho đơn từ 100K</p>
                    </div>
                </div>
                <p class="expire">HSD: 31/12/2024</p>
            </div>
            <button class="btn-disabled">Đã lưu</button>
        </div>
    </div>
</div>

<div class="section">
    <h2>Voucher Của Bạn</h2>

    <div class="voucher-grid">
        <div class="voucher-card">
            <div class="content">
                <div class="icon-row">
                    <div class="icon-box">
                        <span class="material-icons-outlined">restaurant_menu</span>
                    </div>
                    <div>
                        <h3>Giảm 20% toàn menu</h3>
                        <p>Áp dụng cho đơn hàng từ 150K. Giảm tối đa 40K.</p>
                    </div>
                </div>
                <div class="code-row">
                    <div class="code-box">FASHION20</div>
                    <button class="link">Sao chép</button>
                </div>
            </div>
            <div class="footer">
                <p class="expire">HSD: 15/12/2024</p>
                <button class="btn-primary">Áp dụng</button>
            </div>
        </div>

        <div class="voucher-card">
            <div class="content">
                <div class="icon-row">
                    <div class="icon-box">
                        <span class="material-icons-outlined">card_giftcard</span>
                    </div>
                    <div>
                        <h3>Tặng 1 Gói Cuốn Chay</h3>
                        <p>Áp dụng cho đơn hàng có Mì Xào Chay và Cơm Thập Cẩm.</p>
                    </div>
                </div>
                <div class="code-row">
                    <div class="code-box">CUONCHAY</div>
                    <button class="link">Sao chép</button>
                </div>
            </div>
            <div class="footer">
                <p class="expire">HSD: 25/11/2024</p>
                <button class="btn-primary">Áp dụng</button>
            </div>
        </div>

        <div class="voucher-card disabled">
            <div class="content">
                <div class="icon-row">
                    <div class="icon-box gray">
                        <span class="material-icons-outlined">local_offer</span>
                    </div>
                    <div>
                        <h3>Giảm 10K</h3>
                        <p>Cho đơn hàng từ 50K.</p>
                    </div>
                </div>
                <div class="code-row">
                    <div class="code-box gray-text">GIAM10K</div>
                    <button class="link-disabled">Sao chép</button>
                </div>
            </div>
            <div class="footer">
                <p class="expired-text">Đã hết hạn</p>
                <button class="btn-disabled">Đã hết hạn</button>
            </div>
        </div>
    </div>
</div>
</body>
</html>