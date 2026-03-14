<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quên mật khẩu | Chay tươi</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/Login.css">
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@600;700&family=Inter:wght@400;500&display=swap"
          rel="stylesheet">
</head>
<body>
<div class="login-container">
    <div class="illustration-panel">
        <div class="background-img">
            <img src="${pageContext.request.contextPath}/images/hinh_nen_login.jpg" alt="Background">
        </div>
        <div class="welcome-text">
            <h2>Khôi phục tài khoản</h2>
            <p>Nhập email để lấy lại quyền truy cập.</p>
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
        <h1>Quên mật khẩu?</h1>

        <form action="${pageContext.request.contextPath}/forgotpassword" method="post">
            <% String error = (String) request.getAttribute("error"); %>
            <% if (error != null) { %>
            <div style="color: #FF4B2B; margin-bottom: 15px;"><%= error %>
            </div>
            <% } %>

            <div class="form-group">
                <label for="email">Email đăng ký <span class="required-star">*</span></label>
                <input type="email" id="email" name="email" placeholder="Nhập email của bạn" required>
            </div>

            <button type="submit" class="login-button">Gửi mã xác nhận</button>
            <div class="separator"></div>
            <p class="register-link"><a href="${pageContext.request.contextPath}/login">Quay lại đăng nhập</a></p>
        </form>
    </div>
</div>
</body>
</html>