<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);

    Long expiryTime = (Long) session.getAttribute("otpExpiryTime");
    long timeLeft = 0;
    if (expiryTime != null) {
        timeLeft = (expiryTime - System.currentTimeMillis()) / 1000;
        if (timeLeft < 0) timeLeft = 0;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Xác thực OTP | Chay tươi</title>
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
            <h2>Kiểm tra Email</h2>
            <p>Chúng tôi đã gửi mã xác thực gồm 6 số đến email của bạn.</p>
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
        <h1>Nhập mã OTP</h1>

        <form action="${pageContext.request.contextPath}/validateotp" method="post">
            <% String error = (String) request.getAttribute("error"); %>
            <% if (error != null) { %>
            <div class="error-message"><%= error %></div>
            <% } %>

            <div class="countdown-wrapper">
                <p class="countdown-text">Mã OTP sẽ hết hạn sau: <span id="timer">00:00</span></p>
            </div>

            <div class="form-group">
                <label for="otp">Mã xác thực <span class="required-star">*</span></label>
                <div class="otp-input-wrapper">
                    <input type="text" id="otp" name="otp" placeholder="000000" maxlength="6" required class="otp-field"
                           pattern="\d*">
                    <span class="focus-border"></span>
                </div>
                <small class="hint">Nhập 6 số chúng tôi vừa gửi vào email của bạn</small>
            </div>

            <button type="submit" class="login-button" id="submit-btn">Xác nhận</button>
        </form>
    </div>
</div>
<script>
    let timeLeft = parseInt("<%= timeLeft %>");
    if (isNaN(timeLeft)) timeLeft = 0;

    const timerElement = document.getElementById('timer');
    const submitBtn = document.getElementById('submit-btn');

    function updateDisplay() {
        let minutes = Math.floor(timeLeft / 60);
        let seconds = timeLeft % 60;

        minutes = minutes < 10 ? '0' + minutes : minutes;
        seconds = seconds < 10 ? '0' + seconds : seconds;

        timerElement.textContent = minutes + ':' + seconds;
    }

    if (timeLeft <= 0) {
        timerElement.textContent = "Đã hết hạn";
        submitBtn.disabled = true;
        submitBtn.classList.add('disabled');
    } else {
        updateDisplay();
        const countdown = setInterval(() => {
            timeLeft--;

            updateDisplay();

            if (timeLeft <= 0) {
                clearInterval(countdown);
                timerElement.textContent = "Đã hết hạn";

                submitBtn.disabled = true;
                submitBtn.classList.add('disabled');
            }
        }, 1000);
    }
</script>
</body>
</html>