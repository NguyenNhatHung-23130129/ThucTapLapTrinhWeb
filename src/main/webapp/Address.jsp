<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>


<fmt:setLocale value="vi_VN"/>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>ADDRESS | Chay Tươi</title>
    <link rel="stylesheet" href="assets/css/Address.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@24,400,0,0" />
</head>
<body>

<div class="container">
    <div class="box">
        <div class="h">
            <h2 class="ttl">Địa Chỉ Của Tôi</h2>
            <button class="btn-g" onclick="togglePop(true)">
                <span class="material-symbols-outlined"></span> Thêm địa chỉ mới
            </button>
        </div>

        <div class="b">
            <div class="addr-item">
                <div class="addr-l">
                    <div class="u-meta">
                        <span class="u-name">Nguyễn Văn A</span>
                        <span class="u-sep">|</span>
                        <span class="u-phone">0901 234 567</span>
                    </div>
                    <p class="u-text">123 Đường ABC, Phường 15, Quận Tân Bình</p>
                    <p class="u-text">Thành Phố Hồ Chí Minh</p>
                    <span class="badge">Mặc định</span>
                </div>
                <div class="addr-r">
                    <a href="#" class="link">Cập nhật</a>
                </div>
            </div>

            <div class="add-quick" onclick="togglePop(true)">
                <span class="material-symbols-outlined"></span> Thêm địa chỉ mới
            </div>
        </div>
    </div>
</div>

<div id="pop" class="overlay">
    <div class="pop-box">
        <div class="pop-h">Địa chỉ mới</div>
        <div class="pop-b">
            <div class="grid">
                <input type="text" placeholder="Họ và tên" class="in">
                <input type="text" placeholder="Số điện thoại" class="in">
            </div>

            <div class="select-box">
                <select class="in">
                    <option disabled selected>Tỉnh/ Thành phố, Quận/Huyện, Phường/Xã</option>
                    <option>Hồ Chí Minh, Quận 1, Phường Bến Nghé</option>
                </select>
            </div>

            <input type="text" placeholder="Địa chỉ cụ thể" class="in">

            <button class="btn-loc">
                <span class="material-symbols-outlined">map</span> Thêm vị trí
            </button>

            <p class="lab">Loại địa chỉ:</p>
            <div class="grid">
                <button class="btn-tab active" onclick="selTab(this)">Nhà Riêng</button>
                <button class="btn-tab" onclick="selTab(this)">Văn Phòng</button>
            </div>

            <label class="check">
                <input type="checkbox"> Đặt làm địa chỉ mặc định
            </label>

            <div class="pop-f">
                <button class="btn-back" onclick="togglePop(false)">Trở Lại</button>
                <button class="btn-save">Hoàn thành</button>
            </div>
        </div>
    </div>
</div>

<script>

    function togglePop(show) {
        document.getElementById('pop').style.display = show ? 'flex' : 'none';
    }


    function selTab(btn) {
        btn.parentElement.querySelectorAll('.btn-tab').forEach(b => b.classList.remove('active'));
        btn.classList.add('active');
    }


    window.onclick = (e) => {
        if (e.target == document.getElementById('pop')) togglePop(false);
    }
</script>

</body>
</html>