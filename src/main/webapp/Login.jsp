<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng nhập | Chay tươi</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/Login.css">
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@600;700&family=Inter:wght@400;500&display=swap" rel="stylesheet">
</head>
<body>

<div class="login-container">
    <div class="illustration-panel">
        <div class="background-img">
            <img src="${pageContext.request.contextPath}/images/hinh_nen_login.jpg" alt="Hình nền đăng nhập">
        </div>
        <div class="welcome-text">
            <h2>Chào mừng bạn đến với Chay Tươi!</h2>
            <p>Không chỉ là thực phẩm – đó là một lối sống xanh.</p>
        </div>
    </div>

    <div class="form-panel">
        <%
            String error = (String) request.getAttribute("error");
            if(error == null) error = "";

            String status = request.getParameter("status");
            String successMsg = "";
            if("verified".equals(status)) {
                successMsg = "Kích hoạt tài khoản thành công! Vui lòng đăng nhập.";
            } else if("verify_failed".equals(status)) {
                error = "Link xác thực không hợp lệ hoặc đã hết hạn.";
            }

            String email = request.getParameter("email");
            if(email == null) email = "";
        %>
        <div class="header__logo">
            <div class="header__logo-icon">
                <img class="logo-image" src="${pageContext.request.contextPath}/assets/images/logoChiecla.png" alt="logo">
            </div>
            <div class="logo">
                Chay tươi
            </div>
        </div>

        <h1>Đăng nhập ngay!</h1>
        <form action="${pageContext.request.contextPath}/login" method="post">
            <% if(!error.isEmpty()) { %>
            <div style="color: #FF4B2B; margin-bottom: 15px; font-weight: 500;"><%=error%></div>
            <% } %>
            <% if(!successMsg.isEmpty()) { %>
            <div style="color: #28a745; margin-bottom: 15px; font-weight: 500;"><%=successMsg%></div>
            <% } %>

            <div class="form-group">
                <label for="email">Email <span class="required-star">*</span></label>
                <input
                        name="email"
                        value="<%=email%>"
                        type="email"
                        id="email"
                        placeholder="Vui lòng nhập email của bạn">
            </div>

            <div class="form-group">
                <label for="password">Mật khẩu <span class="required-star">*</span></label>
                <input
                        name="pass"
                        type="password"
                        id="password"
                        placeholder="••••••••">
            </div>

            <div class="form-options">
                <a href="${pageContext.request.contextPath}/forgotpassword">Quên mật khẩu?</a>
            </div>

            <button type="submit" class="login-button">
                Đăng nhập
            </button>

            <div class="separator">
                <span>Hoặc</span>
            </div>

            <a href="#" class="google-btn" id="btn-google-login">
                <div class="google-icon-wrapper">
                    <svg class="google-icon" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 48 48">
                        <path fill="#EA4335" d="M24 9.5c3.54 0 6.71 1.22 9.21 3.6l6.85-6.85C35.9 2.38 30.47 0 24 0 14.62 0 6.51 5.38 2.56 13.22l7.98 6.19C12.43 13.72 17.74 9.5 24 9.5z"></path>
                        <path fill="#4285F4" d="M46.98 24.55c0-1.57-.15-3.09-.38-4.55H24v9.02h12.94c-.58 2.96-2.26 5.48-4.78 7.18l7.73 6c4.51-4.18 7.09-10.36 7.09-17.65z"></path>
                        <path fill="#FBBC05" d="M10.53 28.59c-.48-1.45-.76-2.99-.76-4.59s.27-3.14.76-4.59l-7.98-6.19C.92 16.46 0 20.12 0 24c0 3.88.92 7.54 2.56 10.78l7.97-6.19z"></path>
                        <path fill="#34A853" d="M24 48c6.48 0 11.93-2.13 15.89-5.81l-7.73-6c-2.15 1.45-4.92 2.3-8.16 2.3-6.26 0-11.57-4.22-13.47-9.91l-7.98 6.19C6.51 42.62 14.62 48 24 48z"></path>
                    </svg>
                </div>
                <span class="btn-text">Đăng nhập bằng Google</span>
            </a>

        </form>

        <p class="register-link">
            Chưa là thành viên?
            <a href="${pageContext.request.contextPath}/signup">Đăng kí ngay</a>
        </p>
    </div>
</div>
<script type="module">
    import { initializeApp } from "https://www.gstatic.com/firebasejs/10.7.1/firebase-app.js";
    import { getAuth, signInWithPopup, GoogleAuthProvider, signOut } from "https://www.gstatic.com/firebasejs/10.7.1/firebase-auth.js";

    import { firebaseConfig } from "${pageContext.request.contextPath}/assets/js/FirebaseConfig.js";

    const app = initializeApp(firebaseConfig);
    const auth = getAuth(app);

    const urlParams = new URLSearchParams(window.location.search);
    if (urlParams.get('action') === 'logout') {
        signOut(auth).then(() => {
            console.log("Đã đăng xuất khỏi Firebase thành công");
            // Xoa tham so action=logout khoi URL sau khi dang xuat de tranh bi lap vong dang xuat
            window.history.replaceState({}, document.title, window.location.pathname);
        }).catch((error) => {
            console.error("Lỗi đăng xuất:", error);
        });
    }
    // Cau hinh Google Sign-In de luon hien thi popup chon tai khoan khi dang nhap
    const provider = new GoogleAuthProvider();
    provider.setCustomParameters({
        prompt: 'select_account'
    });

    function handleBackendLogin(user) {
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
            console.error("Lỗi lấy token:", error);
        });
    }

    document.getElementById('btn-google-login').addEventListener('click', (e) => {
        e.preventDefault();
        signInWithPopup(auth, provider)
            .then((result) => {
                handleBackendLogin(result.user);
            })
            .catch((error) => {
                alert("Lỗi đăng nhập Google: " + error.message);
            });
    });
</script>
</body>
</html>