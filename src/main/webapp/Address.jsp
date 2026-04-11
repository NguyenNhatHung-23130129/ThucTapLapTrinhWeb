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
            <c:forEach var="addr" items="${addresses}">
                <div class="addr-item">
                    <div class="addr-l">
                        <div class="u-meta">
                            <span class="u-name">${sessionScope.auth.name}</span>
                            <span class="u-sep">|</span>
                            <span class="u-phone">${sessionScope.auth.phone}</span>
                        </div>
                        <p class="u-text">${addr.addressLine}, ${addr.ward}</p>
                        <p class="u-text">${addr.city}</p>
                        <c:if test="${addr.isDefault == 1}">
                            <span class="badge">Mặc định</span>
                        </c:if>
                    </div>
                    <div class="addr-r">
                        <c:if test="${addr.isDefault != 1}">
                            <form action="address" method="post">
                                <input type="hidden" name="action" value="setIsDefault">
                                <input type="hidden" name="addressId" value="${addr.id}">
                                <input type="hidden" name="returnTo" value="${returnTo}">
                                <button type="submit" class="link">
                                    Đặt làm mặc định
                                </button>
                            </form>
                        </c:if>
                    </div>
                </div>
            </c:forEach>

            <div class="add-quick" onclick="togglePop(true)">
                <span class="material-symbols-outlined"></span> Thêm địa chỉ mới
            </div>
        </div>
    </div>
</div>

<div id="pop" class="overlay">
    <form action="address" method="post" class="pop-box">
        <input type="hidden" name="action" value="add">
        <input type="hidden" name="returnTo" value="${returnTo}">
        <div class="pop-h">Địa chỉ mới</div>
        <div class="pop-b">
            <input type="text" id="newName" name="receiverName" placeholder="Họ và tên người nhận" class="in input-spacing">
            <div id="nameErr" class="error-text">Vui lòng nhập họ tên!</div>

            <input type="text" id="newPhone" name="receiverPhone" placeholder="Số điện thoại" class="in input-spacing">
            <div id="phoneErr" class="error-text">Số điện thoại không hợp lệ (Bắt đầu bằng 0, đủ 10 số)!</div>
            <div class="grid">
                <select id="shipProvince" name="city" class="in" onchange="loadDistricts()" required>
                    <option value="" disabled selected>Tỉnh/ Thành phố</option>
                </select>
                <select id="shipDistrict" name="ward" class="in" required>
                    <option value="" disabled selected>Quận/ Huyện</option>
                </select>
            </div>
            <input type="text" name="address" placeholder="Địa chỉ cụ thể (Số nhà, tên đường...)" class="in" required style="margin-bottom: 15px;">

            <div class="pop-f">
                <button type="button" class="btn-back" onclick="togglePop(false)">Trở Lại</button>
                <button type="submit" class="btn-save">Hoàn thành</button>
            </div>
        </div>
    </form>
</div>
<script>
    let provincesData = [];
    fetch('https://provinces.open-api.vn/api/?depth=2')
        .then(response => response.json())
        .then(data => {
            provincesData = data;
            const provinceSelect = document.getElementById('shipProvince');
            data.forEach(province => {
                let option = document.createElement('option');
                option.value = province.code;
                option.text = province.name;
                provinceSelect.add(option);
            });
        })
        .catch(err => console.error('Lỗi tải dữ liệu tỉnh thành:', err));
    function loadDistricts() {
        const provinceCode = document.getElementById('shipProvince').value;
        const districtSelect = document.getElementById('shipDistrict');
        districtSelect.innerHTML = '<option value="" disabled selected>Quận/Huyện</option>';

        if (!provinceCode) return;

        const selectedProvince = provincesData.find(p => p.code == provinceCode);
        if (selectedProvince && selectedProvince.districts) {
            selectedProvince.districts.forEach(district => {
                let option = document.createElement('option');
                option.value = district.name;
                option.text = district.name;
                districtSelect.add(option);
            });
            document.getElementById('shipProvince').options[document.getElementById('shipProvince').selectedIndex].value = selectedProvince.name;
        }
    }
    function togglePop(show) {
        document.getElementById('pop').style.display = show ? 'flex' : 'none';
    }
    window.onclick = (e) => {
        if (e.target == document.getElementById('pop')) togglePop(false);
    }
    document.getElementById('addForm').addEventListener('submit', function(e) {
        let isValid = true;

        const nameInput = document.getElementById('newName').value.trim();
        const phoneInput = document.getElementById('newPhone').value.trim();
        const phoneRegex = /^(0)(86|96|97|98|32|33|34|35|36|37|38|39|88|91|94|83|84|85|81|82|89|90|93|70|79|77|76|78|92|56|58|99|59|87|55)\d{7}$/;

        document.getElementById('nameErr').style.display = 'none';
        document.getElementById('phoneErr').style.display = 'none';
        if (nameInput === '') {
            document.getElementById('nameErr').style.display = 'block';
            isValid = false;
        }
        if (phoneInput === '') {
            document.getElementById('phoneErr').innerText = 'Vui lòng nhập số điện thoại!';
            document.getElementById('phoneErr').style.display = 'block';
            isValid = false;
        } else if (!phoneRegex.test(phoneInput)) {
            document.getElementById('phoneErr').innerText = 'Số điện thoại không hợp lệ (Bắt đầu bằng 0, đủ 10 số)!';
            document.getElementById('phoneErr').style.display = 'block';
            isValid = false;
        }
        if (!isValid) {
            e.preventDefault();
        }
    });
</script>

</body>
</html>