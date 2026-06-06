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
                <li><a href="#" class="nav-link active" data-target="profile-content"><i
                        class="fa-solid fa-user"></i> Thông tin của tôi</a></li>
                <li>
                    <a href="#" class="nav-link" data-target="change-password-content" data-provider="${sessionScope.auth.authProvider}">
                        <i class="fa-solid fa-lock"></i> Đổi mật khẩu
                    </a>
                </li>
                <li><a href="${pageContext.request.contextPath}/logout"
                       class="nav-link logout-link"><i class="fa-solid fa-arrow-right-from-bracket"></i> Đăng xuất</a></li>
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
            <c:if test="${not empty sessionScope.message}">
                <input type="hidden" id="server-message" value="${sessionScope.message}">
                <c:remove var="message" scope="session"/>
            </c:if>

            <form id="profile-form" action="${pageContext.request.contextPath}/userinfor" method="POST" enctype="multipart/form-data">
                <div class="avatar-section">
                    <div class="avatar-wrapper" id="avatar-wrapper" style="position: relative; display: inline-block; cursor: default;">
                        <img src="${sessionScope.auth.imageUrl}"
                             id="avatar-preview"
                             alt="anh dai dien"
                             class="avatar-placeholder"
                             referrerpolicy="no-referrer"
                             onerror="this.onerror=null; this.src='${pageContext.request.contextPath}/assets/images/userProfile.webp';">

                        <div id="camera-icon" style="position: absolute; bottom: 5px; right: 5px; background-color: rgba(0, 0, 0, 0.6); color: white; border-radius: 50%; width: 32px; height: 32px; display: none; align-items: center; justify-content: center; box-shadow: 0 2px 4px rgba(0,0,0,0.3); transition: background-color 0.3s;">
                            <i class="fa-solid fa-camera"></i>
                        </div>

                        <input type="file" name="avatar" id="avatar-input" accept="image/*" style="display: none;" onchange="previewImage(event)">
                        <input type="hidden" name="old_avatar" value="${sessionScope.auth.imageUrl}">
                    </div>
                    <div class="user-meta">
                        <span class="user-name">${sessionScope.auth.name}</span>
                        <span class="user-role">
                            <c:choose>
                                <c:when test="${sessionScope.auth.roleId == 1}">Admin</c:when>
                                <c:when test="${sessionScope.auth.roleId == 2}">Nhân viên</c:when>
                                <c:when test="${sessionScope.auth.roleId == 3}">Người dùng</c:when>
                                <c:otherwise>Khách hàng</c:otherwise>
                            </c:choose>
                        </span>
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

            <form id="change-password-form" action="${pageContext.request.contextPath}/changepassword" method="POST">
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

<div id="confirm-delete-modal" class="modal-overlay">
    <div class="modal-content">
        <div class="modal-icon warning"><i class="fa-solid fa-circle-exclamation"></i></div>
        <div class="modal-title">Xác nhận xóa tài khoản</div>
        <div class="modal-msg">Bạn có chắc chắn muốn vô hiệu hóa tài khoản này không? Hệ thống sẽ bảo lưu lịch sử giao dịch nhưng bạn sẽ không thể đăng nhập lại. Hành động này sẽ khiến bạn bị đăng xuất ngay lập tức.</div>
        <div class="modal-btn-group">
            <button type="button" id="confirm-delete-btn" class="modal-btn-close btn-danger">Xóa tài khoản</button>
            <button type="button" id="cancel-delete-btn" class="modal-btn-close btn-secondary">Hủy bỏ</button>
        </div>
    </div>
</div>

<form id="delete-account-form" action="${pageContext.request.contextPath}/deleteaccount" method="POST" class="hidden-form"></form>

<%@ include file="Footer.jsp" %>

<script src="${pageContext.request.contextPath}/assets/js/passwordValidation.js"></script>
<script>
    function previewImage(event) {
        const file = event.target.files[0];
        if (file) {
            const reader = new FileReader();
            reader.onload = function(e) {
                document.getElementById('avatar-preview').src = e.target.result;
            }
            reader.readAsDataURL(file);
        }
    }

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

        const avatarWrapper = document.getElementById('avatar-wrapper');
        const cameraIcon = document.getElementById('camera-icon');
        const avatarInput = document.getElementById('avatar-input');

        let countdownTimer = null;

        avatarWrapper.addEventListener('click', function() {
            if (editBtn.innerText === 'Lưu thông tin') {
                avatarInput.click();
            }
        });

        function showModal(type, title, message) {
            modalTitle.innerText = title;
            modalMsg.innerText = message;
            modalBtn.innerText = "Đóng";

            if (type === 'success') {
                modalIcon.innerHTML = '<i class="fa-solid fa-circle-check"></i>';
                modalIcon.className = 'modal-icon success';
                modalBtn.className = 'modal-btn-close success';
            } else if (type === 'warning') {
                modalIcon.innerHTML = '<i class="fa-solid fa-circle-exclamation"></i>';
                modalIcon.className = 'modal-icon warning';
                modalBtn.className = 'modal-btn-close warning';
            } else {
                modalIcon.innerHTML = '<i class="fa-solid fa-circle-xmark"></i>';
                modalIcon.className = 'modal-icon error';
                modalBtn.className = 'modal-btn-close error';
            }

            modal.classList.add('show');
        }

        modalBtn.addEventListener('click', function() {
            if (modalBtn.innerText.includes("Đăng xuất")) {
                if (countdownTimer) clearInterval(countdownTimer); // Xóa đếm ngược nếu click sớm
                window.location.href = "${pageContext.request.contextPath}/logout";
            } else {
                modal.classList.remove('show');
            }
        });

        const serverMsgElement = document.getElementById('server-message');
        if (serverMsgElement) {
            const serverMsg = serverMsgElement.value.trim();

            if (serverMsg.includes("Vui lòng đăng nhập lại bằng mật khẩu mới")) {
                showModal('success', 'Thành công', serverMsg);

                let timeLeft = 5;
                modalBtn.innerText = "Đăng xuất (" + timeLeft + "s)";

                countdownTimer = setInterval(() => {
                    timeLeft -= 1;
                    if (timeLeft <= 0) {
                        clearInterval(countdownTimer);
                        window.location.href = "${pageContext.request.contextPath}/logout";
                    } else {
                        modalBtn.innerText = "Đăng xuất (" + timeLeft + "s)";
                    }
                }, 1000);

            } else if (serverMsg.includes("thành công")) {
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

                avatarWrapper.style.cursor = 'pointer';
                cameraIcon.style.display = 'flex';

            } else if (editBtn.innerText === 'Lưu thông tin') {
                const phoneValue = phoneInput.value.trim();

                if (phoneValue === '') {
                    showModal('warning', 'Thiếu thông tin', 'Vui lòng nhập số điện thoại của bạn.');
                    phoneInput.focus();
                    return;
                }

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

                const targetId = this.getAttribute('data-target');
                const authProvider = this.getAttribute('data-provider');

                if (targetId === 'change-password-content' && authProvider === 'google') {
                    showModal('warning', 'Không khả dụng', 'Tài khoản liên kết với Google không hỗ trợ tính năng đổi mật khẩu!');
                    return;
                }

                navLinks.forEach(l => l.classList.remove('active'));
                this.classList.add('active');
                contentSections.forEach(section => section.classList.remove('active'));

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

        const deleteAccountBtn = document.getElementById('delete-account-btn');
        const confirmDeleteModal = document.getElementById('confirm-delete-modal');
        const confirmDeleteBtn = document.getElementById('confirm-delete-btn');
        const cancelDeleteBtn = document.getElementById('cancel-delete-btn');
        const deleteAccountForm = document.getElementById('delete-account-form');

        if (deleteAccountBtn) {
            deleteAccountBtn.addEventListener('click', function () {
                confirmDeleteModal.classList.add('show');
            });
        }

        if (cancelDeleteBtn) {
            cancelDeleteBtn.addEventListener('click', function () {
                confirmDeleteModal.classList.remove('show');
            });
        }

        if (confirmDeleteBtn) {
            confirmDeleteBtn.addEventListener('click', function () {
                deleteAccountForm.submit();
            });
        }
    });
</script>
</body>
</html>