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

<script>
    document.addEventListener("DOMContentLoaded", function() {
        const passwordInput = document.getElementById("password");
        const confirmPasswordInput = document.getElementById("password_confirm");
        const confirmPasswordError = document.getElementById("confirm-password-error");
        const reqLength = document.getElementById("req-length");
        const reqUpper = document.getElementById("req-upper");
        const reqLower = document.getElementById("req-lower");
        const reqNumber = document.getElementById("req-number");
        const reqSpecial = document.getElementById("req-special");
        const reqSpace = document.getElementById("req-space");

        function checkPasswordMatch() {
            if (confirmPasswordInput.value === "") {
                confirmPasswordInput.setCustomValidity("");
                confirmPasswordError.style.display = "none";
            } else if (passwordInput.value !== confirmPasswordInput.value) {
                confirmPasswordInput.setCustomValidity("Bạn nhập lại chưa chính xác!");
                confirmPasswordError.style.display = "block";
            } else {
                confirmPasswordInput.setCustomValidity("");
                confirmPasswordError.style.display = "none";
            }
        }

        passwordInput.addEventListener("input", function() {
            const val = passwordInput.value;
            checkPasswordMatch();

            if (val.length === 0) {
                reqLength.classList.remove("valid");
                reqUpper.classList.remove("valid");
                reqLower.classList.remove("valid");
                reqNumber.classList.remove("valid");
                reqSpecial.classList.remove("valid");
                reqSpace.classList.remove("valid");
                return;
            }

            reqLength.classList.toggle("valid", val.length >= 8 && val.length <= 16);
            reqUpper.classList.toggle("valid", /[A-Z]/.test(val));
            reqLower.classList.toggle("valid", /[a-z]/.test(val));
            reqNumber.classList.toggle("valid", /[0-9]/.test(val));
            reqSpecial.classList.toggle("valid", /[@#$%^&+=!._-]/.test(val));
            reqSpace.classList.toggle("valid", !/\s/.test(val));
        });

        confirmPasswordInput.addEventListener("input", checkPasswordMatch);

        const togglePasswordIcon = document.getElementById('toggle-password-icon');
        const toggleConfirmPasswordIcon = document.getElementById('toggle-confirm-password-icon');

        togglePasswordIcon.addEventListener('click', function() {
            const isPasswordType = passwordInput.type === 'password';
            passwordInput.type = isPasswordType ? 'text' : 'password';
            togglePasswordIcon.className = isPasswordType ? 'fa-regular fa-eye' : 'fa-regular fa-eye-slash';
        });

        toggleConfirmPasswordIcon.addEventListener('click', function() {
            const isPasswordType = confirmPasswordInput.type === 'password';
            confirmPasswordInput.type = isPasswordType ? 'text' : 'password';
            toggleConfirmPasswordIcon.className = isPasswordType ? 'fa-regular fa-eye' : 'fa-regular fa-eye-slash';
        });
    });
</script>
</body>
</html>