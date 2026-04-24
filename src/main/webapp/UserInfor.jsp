<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Hồ sơ người dùng | Chay Tươi</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/Nav.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/UserInfor.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
</head>
<body>
<%@ include file="Header.jsp" %>

<div class="profile-container">
    <aside class="profile-sidebar">
        <div class="sidebar-header">
            <h3>Tài khoản</h3>
        </div>
        <nav>
            <ul>
                <li><a href="#" class="nav-link active" data-target="profile-content"><i class="fa-solid fa-user"></i> Thông tin của tôi</a></li>
                <li><a href="#" class="nav-link" data-target="change-password-content"><i class="fa-solid fa-lock"></i> Đổi mật khẩu</a></li>
                <li><a href="${pageContext.request.contextPath}/logout" class="nav-link logout-link"><i class="fa-solid fa-arrow-right-from-bracket"></i> Đăng xuất</a></li>
            </ul>
        </nav>
    </aside>

    <main class="profile-content">
        <section id="profile-content" class="content-section active">
            <div class="content-header">
                <h2>Thông tin của tôi</h2>
                <button type="button" id="edit-btn" class="submit-btn">Sửa</button>
            </div>

            <c:if test="${not empty requestScope.message}">
                <input type="hidden" id="server-message" value="${requestScope.message}">
            </c:if>

            <form id="profile-form" action="${pageContext.request.contextPath}/userinfor" method="POST">
                <div class="avatar-section">
                    <div class="avatar-wrapper">
                        <img src="${sessionScope.auth.imageUrl}"
                             alt="anh dai dien"
                             class="avatar-placeholder"
                             referrerpolicy="no-referrer"
                             onerror="this.onerror=null; this.src='${pageContext.request.contextPath}/assets/images/userProfile.webp';">
                    </div>
                    <div class="user-meta">
                        <span class="user-name">${sessionScope.auth.name}</span>
                        <span class="user-role">Khách hàng thành viên</span>
                    </div>
                </div>

                <div class="form-grid">
                    <div class="form-group">
                        <label>Họ và tên</label>
                        <input type="text" name="name" value="${sessionScope.auth.name}" class="editable" readonly>
                    </div>

                    <div class="form-group">
                        <label>Số điện thoại</label>
                        <input type="text" name="phone" value="${sessionScope.auth.phone}" class="editable" readonly>
                    </div>

                    <div class="form-group">
                        <label>Email</label>
                        <input type="email" value="${sessionScope.auth.email}" readonly class="readonly-field">
                    </div>
                </div>
            </form>

            <div class="danger-zone">
                <div class="danger-text">
                    <h3>Xóa tài khoản</h3>
                    <p>Hành động này không thể hoàn tác. Mọi dữ liệu sẽ bị xóa vĩnh viễn.</p>
                </div>
                <button type="button" id="delete-account-btn" class="danger-btn">Xóa tài khoản</button>
            </div>
        </section>

        <section id="change-password-content" class="content-section">
            <div class="content-header">
                <h2>Đổi mật khẩu</h2>
                <button type="submit" form="change-password-form" id="submit-change-pwd-btn" class="submit-btn">Cập nhật</button>
            </div>

            <form id="change-password-form" action="${pageContext.request.contextPath}/auth/change-password" method="POST">
                <div class="form-group">
                    <label for="current_password">Mật khẩu hiện tại <span class="required-star">*</span></label>
                    <div class="password-container">
                        <input type="password" id="current_password" name="current_password" placeholder="••••••••" required>
                        <i id="toggle-current-password-icon" class="fa-regular fa-eye-slash"></i>
                    </div>
                </div>

                <div class="form-group">
                    <label for="password">Mật khẩu mới <span class="required-star">*</span></label>
                    <div class="password-container">
                        <input type="password" name="new_password" id="password" placeholder="••••••••" required minlength="8" maxlength="16" pattern="(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[^a-zA-Z0-9]).{8,16}">
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
                    <label for="password_confirm">Xác nhận mật khẩu mới <span class="required-star">*</span></label>
                    <div class="password-container">
                        <input type="password" id="password_confirm" name="confirm_new_password" placeholder="Vui lòng nhập lại mật khẩu mới" required minlength="8" maxlength="16">
                        <i id="toggle-confirm-password-icon" class="fa-regular fa-eye-slash"></i>
                    </div>
                    <div id="confirm-password-error" class="error-text">Bạn nhập lại chưa chính xác!</div>
                </div>
            </form>
        </section>
    </main>
</div>

<div id="custom-modal" class="modal-overlay">
    <div class="modal-content">
        <div id="modal-icon"></div>
        <div id="modal-title" class="modal-title"></div>
        <div id="modal-message" class="modal-msg"></div>
        <button type="button" id="modal-btn-close" class="modal-btn-close">Đóng</button>
    </div>
</div>

<%@ include file="Footer.jsp" %>

<script src="${pageContext.request.contextPath}/assets/js/passwordValidation.js"></script>
<script>
    document.addEventListener('DOMContentLoaded', function () {
        const editBtn = document.getElementById('edit-btn');
        const profileForm = document.getElementById('profile-form');
        const profileInputs = document.querySelectorAll('.editable');
        const phoneInput = document.querySelector('input[name="phone"]');
        const modal = document.getElementById('custom-modal');
        const modalIcon = document.getElementById('modal-icon');
        const modalTitle = document.getElementById('modal-title');
        const modalMsg = document.getElementById('modal-message');
        const modalBtn = document.getElementById('modal-btn-close');

        function showModal(type, title, message) {
            modalTitle.innerText = title;
            modalMsg.innerText = message;
            if (type === 'success') {
                modalIcon.innerHTML = '<i class="fa-solid fa-circle-check"></i>';
                modalIcon.className = 'modal-icon success';
                modalBtn.className = 'modal-btn-close success';
            } else {
                modalIcon.innerHTML = '<i class="fa-solid fa-circle-xmark"></i>';
                modalIcon.className = 'modal-icon error';
                modalBtn.className = 'modal-btn-close error';
            }
            modal.classList.add('show');
        }

        modalBtn.addEventListener('click', function() {
            modal.classList.remove('show');
        });

        const serverMsgElement = document.getElementById('server-message');
        if (serverMsgElement) {
            const serverMsg = serverMsgElement.value;
            if (serverMsg.includes("thành công")) {
                showModal('success', 'Thành công', serverMsg);
            } else {
                showModal('error', 'Thất bại', serverMsg);
            }
        }

        editBtn.addEventListener('click', function () {
            if (editBtn.innerText === 'Sửa') {
                profileInputs.forEach(input => input.removeAttribute('readonly'));
                if (profileInputs.length > 0) profileInputs[0].focus();
                editBtn.innerText = 'Lưu thông tin';
                editBtn.style.backgroundColor = '#28a745';
            } else if (editBtn.innerText === 'Lưu thông tin') {
                const phoneValue = phoneInput.value.trim();
                const phoneRegex = /^(0|\+84)(3|5|7|8|9)[0-9]{8}$/;
                if (!phoneRegex.test(phoneValue)) {
                    showModal('error', 'Lỗi xác thực', 'Số điện thoại không hợp lệ! Vui lòng nhập đúng định dạng Việt Nam.');
                    phoneInput.focus();
                    return;
                }
                profileForm.submit();
            }
        });

        const navLinks = document.querySelectorAll('.nav-link[data-target]');
        const contentSections = document.querySelectorAll('.content-section');

        navLinks.forEach(link => {
            link.addEventListener('click', function(e) {
                e.preventDefault();
                navLinks.forEach(l => l.classList.remove('active'));
                this.classList.add('active');
                contentSections.forEach(section => section.classList.remove('active'));
                const targetId = this.getAttribute('data-target');
                document.getElementById(targetId).classList.add('active');
            });
        });

        const toggleCurrentPasswordIcon = document.getElementById('toggle-current-password-icon');
        const currentPasswordInput = document.getElementById('current_password');

        if (toggleCurrentPasswordIcon && currentPasswordInput) {
            toggleCurrentPasswordIcon.addEventListener('click', function() {
                const isPasswordType = currentPasswordInput.type === 'password';
                currentPasswordInput.type = isPasswordType ? 'text' : 'password';
                toggleCurrentPasswordIcon.className = isPasswordType ? 'fa-regular fa-eye' : 'fa-regular fa-eye-slash';
            });
        }
    });
</script>
</body>
</html>