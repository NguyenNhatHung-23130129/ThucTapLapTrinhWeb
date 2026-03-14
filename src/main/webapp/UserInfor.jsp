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

            <c:if test="${not empty sessionScope.message}">
                <div style="color: green; margin-bottom: 15px; font-weight: bold; padding: 10px; background: #e8f5e9; border-radius: 4px;">
                        ${sessionScope.message}
                </div>
                <% session.removeAttribute("message"); %>
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

            <div class="form-group">
                <label style="margin-top: 20px; display: block; font-size: 18px; margin-bottom: 15px;">Địa chỉ nhận
                    hàng</label>
                <c:choose>
                    <c:when test="${not empty addresses}">
                        <c:forEach var="addr" items="${addresses}">

                            <form action="UserAddressServlet" method="POST" class="address-row">
                                <input type="hidden" name="action" value="update">
                                <input type="hidden" name="id" value="${addr.id}">

                                <div class="address-inputs">
                                    <input type="text" name="address" value="${addr.addressLine}" class="addr-field"
                                           readonly placeholder="Số nhà, đường">
                                    <input type="text" name="ward" value="${addr.ward}" class="addr-field" readonly
                                           placeholder="Phường/Xã">
                                    <input type="text" name="city" value="${addr.city}" class="addr-field" readonly
                                           placeholder="Tỉnh/Thành">
                                </div>

                                <button type="submit" class="btn-action btn-save-addr">Lưu</button>
                                <a href="#" class="btn-action btn-delete-addr" data-id="${addr.id}">Xóa</a>
                            </form>

                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <p style="color: #666; font-style: italic;">Chưa có địa chỉ nào.</p>
                    </c:otherwise>
                </c:choose>
            </div>

            <a href="#" id="open-address-modal" class="add-address"><i class="fa-solid fa-plus"></i> Thêm địa chỉ
                mới</a>
        </section>
    </main>
</div>

<form id="delete-addr-form" action="UserAddressServlet" method="POST" style="display:none;">
    <input type="hidden" name="action" value="delete">
    <input type="hidden" name="id" id="delete-addr-id">
</form>

<div id="addressModal" class="modal" style="display: none;">
    <div class="modal-content">
        <span class="close">&times;</span>
        <h3>Thêm địa chỉ mới</h3>
        <form action="UserAddressServlet" method="POST">
            <input type="hidden" name="action" value="add">

            <div class="form-group">
                <label>Địa chỉ cụ thể</label>
                <input type="text" name="address" required placeholder="Số nhà, đường...">
            </div>
            <div class="form-group">
                <label>Phường / Xã</label>
                <input type="text" name="ward" required placeholder="Nhập Phường / Xã">
            </div>
            <div class="form-group">
                <label>Tỉnh / Thành phố</label>
                <input type="text" name="city" required placeholder="Nhập Tỉnh / Thành phố">
            </div>
            <button type="submit" class="modal-btn">Xác nhận</button>
        </form>
    </div>
</div>

<%@ include file="Footer.jsp" %>

<script>
    document.addEventListener('DOMContentLoaded', function () {
        const editBtn = document.getElementById('edit-btn');
        const profileForm = document.getElementById('profile-form');
        const profileInputs = document.querySelectorAll('.editable');

        const addrInputs = document.querySelectorAll('.addr-field');
        const saveAddrBtns = document.querySelectorAll('.btn-save-addr');
        const deleteAddrBtns = document.querySelectorAll('.btn-delete-addr');
        const addressRows = document.querySelectorAll('.address-row');

        editBtn.addEventListener('click', function () {
            if (editBtn.innerText === 'Sửa') {
                profileInputs.forEach(input => input.removeAttribute('readonly'));

                addrInputs.forEach(input => {
                    input.removeAttribute('readonly');
                    input.classList.add('editing');
                });

                addressRows.forEach(row => row.style.borderColor = '#00332c');

                saveAddrBtns.forEach(btn => btn.style.display = 'block');
                deleteAddrBtns.forEach(btn => btn.style.display = 'inline-block');

                if (profileInputs.length > 0) profileInputs[0].focus();
                editBtn.innerText = 'Lưu thông tin';

            } else if (editBtn.innerText === 'Lưu thông tin') {
                profileForm.submit();
            }
        });

        const deleteForm = document.getElementById('delete-addr-form');
        const deleteInput = document.getElementById('delete-addr-id');

        deleteAddrBtns.forEach(btn => {
            btn.addEventListener('click', function (e) {
                e.preventDefault();
                if (confirm('Bạn có chắc chắn muốn xóa địa chỉ này?')) {
                    deleteInput.value = this.getAttribute('data-id');
                    deleteForm.submit();
                }
            });
        });

        const modal = document.getElementById("addressModal");
        const btnOpen = document.getElementById("open-address-modal");
        const spanClose = document.getElementsByClassName("close")[0];

        btnOpen.onclick = function (e) {
            e.preventDefault();
            modal.style.display = "block";
        }
        spanClose.onclick = function () {
            modal.style.display = "none";
        }
        window.onclick = function (event) {
            if (event.target == modal) modal.style.display = "none";
        }
    });
</script>
</body>
</html>