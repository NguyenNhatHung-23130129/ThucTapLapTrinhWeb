<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng ký | Chay tươi</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/SignUp.css">
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@600;700&family=Inter:wght@400;500&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
</head>
<body>
<div class="signup-container">
    <div class="illustration-panel">
        <div class="background-img">
            <img src="${pageContext.request.contextPath}/images/hinh_nen_signup.jpg" alt="Hình nền đăng ký">
        </div>
        <div class="welcome-text">
            <h2>Chào mừng bạn đến với Chay Tươi!</h2>
            <p>Không chỉ là thực phẩm – đó là một lối sống xanh.</p>
        </div>
    </div>

    <div class="form-panel">
        <div class="header__logo">
            <div class="header__logo-icon">
                <img class="logo-image" src="${pageContext.request.contextPath}/assets/images/logoChiecla.png" alt="logo">
            </div>
            <div class="logo">
                Chay tươi
            </div>
        </div>

        <h1>Đăng ký ngay</h1>

        <form action="${pageContext.request.contextPath}/signup" method="post">
            <% String error = (String) request.getAttribute("error"); %>
            <% if (error != null) { %>
            <div style="color: #FF4B2B; margin-bottom: 5px; font-weight: 500;" class="error-msg"><%= error %></div>
            <% } %>

            <div class="form-group">
                <label for="email">Email <span class="required-star">*</span></label>
                <input type="email" id="email" name="email" value="${email}" placeholder="Vui lòng nhập email của bạn" required>
            </div>

            <div class="form-group">
                <label for="password">Mật khẩu <span class="required-star">*</span></label>
                <div class="password-container">
                    <input type="password" name="password" id="password" placeholder="••••••••" required minlength="8" maxlength="16" pattern="(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[^a-zA-Z0-9]).{8,16}">
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
                    <input type="password" id="password_confirm" name="confirm_password" placeholder="Vui lòng nhập lại mật khẩu của bạn" required minlength="8" maxlength="16">
                    <i id="toggle-confirm-password-icon" class="fa-regular fa-eye-slash"></i>
                </div>
                <div id="confirm-password-error">Bạn nhập lại chưa chính xác!</div>
            </div>

            <div class="form-options">
                <a href="${pageContext.request.contextPath}/forgotpassword">Quên mật khẩu?</a>
            </div>
            <button type="submit" class="signup-button">
                Đăng ký
            </button>

            <div class="separator">
                <span>Hoặc</span>
            </div>

            <a href="#" class="google-btn" id="btn-google-signup">
                <div class="google-icon-wrapper">
                    <svg class="google-icon" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 48 48">
                        <path fill="#EA4335" d="M24 9.5c3.54 0 6.71 1.22 9.21 3.6l6.85-6.85C35.9 2.38 30.47 0 24 0 14.62 0 6.51 5.38 2.56 13.22l7.98 6.19C12.43 13.72 17.74 9.5 24 9.5z"></path>
                        <path fill="#4285F4" d="M46.98 24.55c0-1.57-.15-3.09-.38-4.55H24v9.02h12.94c-.58 2.96-2.26 5.48-4.78 7.18l7.73 6c4.51-4.18 7.09-10.36 7.09-17.65z"></path>
                        <path fill="#FBBC05" d="M10.53 28.59c-.48-1.45-.76-2.99-.76-4.59s.27-3.14.76-4.59l-7.98-6.19C.92 16.46 0 20.12 0 24c0 3.88.92 7.54 2.56 10.78l7.97-6.19z"></path>
                        <path fill="#34A853" d="M24 48c6.48 0 11.93-2.13 15.89-5.81l-7.73-6c-2.15 1.45-4.92 2.3-8.16 2.3-6.26 0-11.57-4.22-13.47-9.91l-7.98 6.19C6.51 42.62 14.62 48 24 48z"></path>
                    </svg>
                </div>
                <span class="btn-text">Đăng ký bằng Google</span>
            </a>
        </form>

        <p class="login-link">
            Bạn đã có tài khoản? <a href="${pageContext.request.contextPath}/login">Đăng nhập ngay</a>
        </p>
    </div>
</div>
<script type="module">
    import { initializeApp } from "https://www.gstatic.com/firebasejs/10.7.1/firebase-app.js";
    import { getAuth, signInWithPopup, GoogleAuthProvider } from "https://www.gstatic.com/firebasejs/10.7.1/firebase-auth.js";
    import { firebaseConfig } from "${pageContext.request.contextPath}/assets/js/FirebaseConfig.js";

    const app = initializeApp(firebaseConfig);
    const auth = getAuth(app);
    const provider = new GoogleAuthProvider();

    provider.setCustomParameters({
        prompt: 'select_account'
    });

    function handleBackendSignup(user) {
        user.getIdToken().then((idToken) => {
            const formData = new URLSearchParams();
            formData.append('idToken', idToken);

            fetch('${pageContext.request.contextPath}/login-google', {
                method: 'POST',
                body: formData,
                headers: { 'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8' }
            }).then((response) => {
                if (response.ok) {
                    window.location.href = "${pageContext.request.contextPath}/home";
                } else {
                    alert("Lỗi xác thực từ Server!");
                }
            });
        }).catch((error) => {
            console.error(error);
        });
    }

    document.getElementById('btn-google-signup').addEventListener('click', (e) => {
        e.preventDefault();
        signInWithPopup(auth, provider)
            .then((result) => {
                handleBackendSignup(result.user);
            })
            .catch((error) => {
                alert("Lỗi: " + error.message);
            });
    });

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

        // kiem tra mat khau nhap lai co khop hay khong
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

        // kiem tra mat khau theo tieu chi
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