<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đặt lại mật khẩu | Chay tươi</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/Login.css">
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@600;700&family=Inter:wght@400;500&display=swap"
          rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
</head>
<body>
<div class="login-container">
    <div class="illustration-panel">
        <div class="background-img">
            <img src="${pageContext.request.contextPath}/images/hinh_nen_login.jpg" alt="Background">
        </div>
        <div class="welcome-text">
            <h2>Mật khẩu mới</h2>
            <p>Vui lòng đặt mật khẩu mạnh để bảo vệ tài khoản.</p>
        </div>
    </div>

    <div class="form-panel">
        <div class="header__logo">
            <div class="header__logo-icon">
                <img class="logo-image" src="${pageContext.request.contextPath}/assets/images/logoChiecla.png"
                     alt="logo">
            </div>
            <div class="logo">Chay tươi</div>
        </div>
        <h1>Đặt lại mật khẩu</h1>

        <form action="${pageContext.request.contextPath}/resetpassword" method="post">
            <% String error = (String) request.getAttribute("error"); %>
            <% if (error != null) { %>
            <div style="color: #FF4B2B; margin-bottom: 15px;"><%= error %></div>
            <% } %>

            <div class="form-group">
                <label for="password">Mật khẩu mới <span class="required-star">*</span></label>
                <div class="password-container">
                    <input type="password" name="password" id="password" placeholder="••••••••" required minlength="8" maxlength="16"
                           pattern="(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[^a-zA-Z0-9]).{8,16}">
                    <i id="toggle-password-icon" class="fa-regular fa-eye-slash"></i>
                </div>
                <div class="password-criteria">
                    <ul>
                        <li id="req-length">Từ 8 đến 16 ký tự</li>
                        <li id="req-upper">Ít nhất 1 chữ cái viết hoa</li>
                        <li id="req-lower">Ít nhất 1 chữ cái viết thường</li>
                        <li id="req-number">Ít nhất 1 chữ số</li>
                        <li id="req-special">Ít nhất 1 ký tự đặc biệt (@, #, $,...)</li>
                        <li id="req-space">Không chứa khoảng trắng</li>
                    </ul>
                </div>
            </div>

            <div class="form-group">
                <label for="password_confirm">Xác nhận mật khẩu <span class="required-star">*</span></label>
                <div class="password-container">
                    <input type="password" id="password_confirm" name="confirm_password" placeholder="Nhập lại mật khẩu"
                           required minlength="8" maxlength="16">
                    <i id="toggle-confirm-password-icon" class="fa-regular fa-eye-slash"></i>
                </div>
                <div id="confirm-password-error">Bạn nhập lại chưa chính xác!</div>
            </div>

            <button type="submit" class="login-button">Đổi mật khẩu</button>
        </form>
    </div>
</div>
<script src="${pageContext.request.contextPath}/assets/js/passwordValidation.js"></script>
</body>
</html>