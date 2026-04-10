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
</head>
<body>
<%@ include file="Header.jsp" %>

<div class="profile-container">
    <aside class="profile-sidebar">
        <h3>Tài khoản</h3>
        <nav>
            <ul>
                <li><a href="#" class="nav-link active"><i class="fa-solid fa-user"></i> Thông tin của tôi</a></li>
                <li><a href="${pageContext.request.contextPath}/logout" class="nav-link"><i
                        class="fa-solid fa-arrow-right-from-bracket"></i> Đăng xuất</a></li>
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
                    <img src="${sessionScope.auth.imageUrl}"
                         alt="anh dai dien"
                         class="avatar-placeholder"
                         onerror="this.onerror=null; this.src='assets/images/userProfile.webp';">
                    <span>${sessionScope.auth.name}</span>
                </div>

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
                    <input type="email" value="${sessionScope.auth.email}" readonly style="background-color: #e9ecef;">
                </div>
            </form>
            <div class="danger-zone">
                <div class="danger-text">
                    <h3>Xóa tài khoản</h3>
                    <p>Hành động này không thể hoàn tác. Mọi dữ liệu của bạn sẽ bị xóa vĩnh viễn.</p>
                    <p>Trước khi xóa, bạn hãy chắc chắn rằng bạn đã hoàn thành hết các đơn hàng.</p>
                </div>
                <button type="button" id="delete-account-btn" class="danger-btn">Xóa tài khoản</button>
            </div>
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
            } else if (editBtn.innerText === 'Lưu thông tin') {
                const phoneValue = phoneInput.value.trim();
                const phoneRegex = /^(0|\+84)(3|5|7|8|9)[0-9]{8}$/;

                if (!phoneRegex.test(phoneValue)) {
                    showModal('error', 'Lỗi xác thực', 'Số điện thoại không hợp lệ! Vui lòng nhập đúng định dạng số điện thoại Việt Nam.');
                    phoneInput.focus();
                    return;
                }

                profileForm.submit();
            }
        });
    });
</script>
</body>
</html>