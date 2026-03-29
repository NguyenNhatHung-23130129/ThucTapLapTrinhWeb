<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>


<fmt:setLocale value="vi_VN"/>

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/Checkout.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/Nav.css">
  <title>Thanh toán | Chay Tươi</title>
</head>
<body>

<%@ include file = "Header.jsp" %>
<div class="checkout-page">
  <main class="main-container">
    <div class="left-col">

      <section class="box">
        <div class="box-head">
          <h2 class="box-title"><span class="location-on"></span> Địa chỉ nhận hàng</h2>
          <a href="Address.jsp" class="link-action">Thay đổi</a>
        </div>
        <div class="box-body">
          <div class="address-form">
            <div class="form-group full-width">
              <input type="text" id="shipName" placeholder="Tên" value="${not empty user.name ? user.name : ''}">
            </div>

            <div class="form-group full-width">
              <input type="tel" id="shipPhone" placeholder="Số điện thoại" value="${not empty user.phone ? user.phone : ''}" oninput="validatePhone()">
              <div id="phoneError" class="error-text" style="display: none; color: red; font-size: 1.3rem; margin-top: 5px;">
                Số điện thoại không hợp lệ (Phải có 10 số, bắt đầu bằng 0 và thuộc nhà mạng VN).
              </div>
            </div>

            <div class="form-row">
              <div class="form-group">
                <select id="shipProvince" onchange="loadDistricts()">
                  <option value="" disabled selected>Tỉnh</option>
                </select>
              </div>
              <div class="form-group">
                <select id="shipDistrict">
                  <option value="" disabled selected>Huyện</option>
                </select>
              </div>
            </div>

            <div class="form-group full-width">
              <input type="text" id="shipAddress" placeholder="Địa chỉ cụ thể" value="${not empty userAddress.addressLine ? userAddress.addressLine : ''}">
            </div>
          </div>
        </div>
      </section>

      <section class="box">
        <div class="box-head">
          <h2 class="box-title"><span class="shopping-basket"></span> Sản phẩm đã chọn</h2>
        </div>
        <div class="box-body">
          <c:forEach var="item" items="${selectedProducts}">
            <div class="prod-item">
              <img src="${item.product.imageUrl}" class="prod-img">
              <div class="prod-info">
                <h3 class="prod-title">${item.product.name}</h3>
                <p class="prod-sub">Phân loại: Hữu cơ</p>
                <span class="prod-tag">Thuần chay</span>
              </div>
              <div class="prod-price-qty">
                <div class="p-unit"><fmt:formatNumber value="${item.price}" type="currency" currencySymbol="₫"/></div>
                <div class="p-qty">SL: ${item.quantity}</div>
                <div class="p-total"><fmt:formatNumber value="${item.price * item.quantity}" type="currency" currencySymbol="₫"/></div>
              </div>
            </div>
          </c:forEach>
        </div>
      </section>

      <section class="box">
        <div class="box-head">
          <h2 class="box-title"><span class="local-shipping"></span> Đơn vị vận chuyển</h2>
        </div>
        <div class="box-body ship-grid">
          <label class="opt-card active">
            <input type="radio" name="shipMethod" value="standard" checked>
            <div class="opt-content">
              <div class="opt-name">Giao Tiêu Chuẩn</div>
              <div class="opt-desc">30.000 ₫ - 45-60 phút</div>
            </div>
          </label>

          <label class="opt-card">
            <input type="radio" name="shipMethod" value="express">
            <div class="opt-content">
              <div class="opt-name">Giao Hỏa Tốc ⚡</div>
              <div class="opt-desc">50.000 ₫ - 20-30 phút</div>
            </div>
          </label>
        </div>
      </section>

      <section class="box">
        <div class="box-head">
          <h2 class="box-title"><span class="payments"></span> Phương thức thanh toán</h2>
        </div>
        <div class="pay-list">
          <div class="pay-item-wrapper">
            <label class="opt-card">
              <input type="radio" name="payType" value="card">
              <div class="opt-content">
                <span class="opt-name">Thẻ Tín Dụng / Ghi Nợ</span>
              </div>
            </label>
            <div id="form-card" class="pay-detail">
              <div class="form-group">
                <label>Số Thẻ</label>
                <input type="text" placeholder="0000 0000 0000 0000">
              </div>
              <div class="form-row">
                <input type="text" placeholder="MM/YY">
                <input type="text" placeholder="CVV">
              </div>
            </div>
          </div>

          <div class="pay-item-wrapper">
            <label class="opt-card">
              <input type="radio" name="payType" value="ewallet">
              <div class="opt-content">
                <span class="opt-name">Ví Momo / ZaloPay</span>
              </div>
            </label>
            <div id="form-ewallet" class="pay-detail">
              <div class="form-group">
                <label>Số điện thoại ví</label>
                <input type="text" placeholder="Nhập số điện thoại đăng ký ví">
              </div>
            </div>
          </div>

          <label class="opt-card">
            <input type="radio" name="payType" value="cod">
            <div class="opt-content ">
              <span class="opt-name">Thanh Toán Khi Nhận Hàng (COD)</span>
            </div>
          </label>
        </div>
    </section>
</div>

    <aside class="right-col">
      <div class="box sticky">
        <div class="box-head">
          <h2 class="box-title"><span class="symbols-outlined "></span> Tóm tắt đơn hàng</h2>
        </div>
        <div class="box-body">
          <div class="promo-box">
            <label>Nhập mã giảm giá</label>
            <div class="input-group">
              <input type="text" id="vCode" placeholder="Nhập mã" value="${voucherCode}">
              <button type="button" class="btn-black">Áp dụng</button>
            </div>
          </div>

          <div class="sum-table">
            <div class="sum-row">
              <span>Tạm tính (${selectedProducts.size()} sản phẩm)</span>
              <span><fmt:formatNumber value="${subtotal}" type="currency" currencySymbol="₫"/></span>
            </div>
            <div class="sum-row">
              <span>Phí vận chuyển</span>
              <span><fmt:formatNumber value="${shippingFee}" type="currency" currencySymbol="₫"/></span>
            </div>
            <div class="sum-row">
              <span>Thuế (8%)</span>
              <span><fmt:formatNumber value="${subtotal * 0.08}" type="currency" currencySymbol="₫"/></span>
            </div>
            <c:if test="${discount > 0}">
              <div class="sum-row discount">
                <span>Giảm giá (${voucherCode})</span>
                <span>-<fmt:formatNumber value="${discount}" type="currency" currencySymbol="₫"/></span>
              </div>
            </c:if>
          </div>

          <div class="sum-total">
            <span>Tổng cộng</span>
            <div class="total-val">
              <small>VND</small>
              <span class="total-num"><fmt:formatNumber value="${total}" type="currency" currencySymbol="₫"/></span>
            </div>
          </div>

          <form action="checkout" method="post" id="checkoutForm">
            <input type="hidden" name="ids" value="${param.ids}">

            <input type="hidden" name="buyNowId" value="${param.id != null ? param.id : param.buyNowId}">
            <input type="hidden" name="buyNowQty" value="${param.quantity != null ? param.quantity : param.buyNowQty}">

            <input type="hidden" name="finalName" value="${user.name}">
            <input type="hidden" name="finalPhone" value="${user.phone}">
            <input type="hidden" name="finalAddress" value="${userAddress.addressLine}">
            <input type="hidden" name="finalWard" value="${userAddress.ward}">
            <input type="hidden" name="finalCity" value="${userAddress.city}">
            <input type="hidden" name="voucherCode" value="${voucherCode}">

            <button type="submit" class="btn-checkout">
              <span class="symbols-outlined"></span> Đặt hàng
            </button>
          </form>
          <p class="secure-tip"><span class="symbols-outlined"></span> Thanh toán an toàn và bảo mật.</p>
        </div>
      </div>
    </aside>
  </main>
</div>

<script>
  function setupSelection(groupName) {
    const radios = document.querySelectorAll(`input[name="${groupName}"]`);

    radios.forEach(radio => {
      radio.addEventListener('change', function() {
        radios.forEach(r => {
          const card = r.closest('.opt-card');
          if(card) card.classList.remove('active');
        });

        this.closest('.opt-card').classList.add('active');
        if (groupName === 'payType') {
          const cardForm = document.getElementById('form-card');
          const walletForm = document.getElementById('form-ewallet');

          if(cardForm) cardForm.style.display = (this.value === 'card') ? 'block' : 'none';
          if(walletForm) walletForm.style.display = (this.value === 'ewallet') ? 'block' : 'none';
        }
      });
    });
  }
  setupSelection('shipMethod');
  setupSelection('payType');

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


    districtSelect.innerHTML = '<option value="" disabled selected>Huyện</option>';

    if (!provinceCode) return;


    const selectedProvince = provincesData.find(p => p.code == provinceCode);

    if (selectedProvince && selectedProvince.districts) {
    selectedProvince.districts.forEach(district => {
    let option = document.createElement('option');
    option.value = district.name;
    option.text = district.name;
    districtSelect.add(option);
  });
  }
  }

    function validatePhone() {
    const phoneInput = document.getElementById('shipPhone').value;
    const errorText = document.getElementById('phoneError');


    const phoneRegex = /^(0)(86|96|97|98|32|33|34|35|36|37|38|39|88|91|94|83|84|85|81|82|89|90|93|70|79|77|76|78|92|56|58|99|59|87|55)\d{7}$/;

    if (phoneInput.length === 0) {
    errorText.style.display = 'none';
    return false;
  }

    if (!phoneRegex.test(phoneInput)) {
    errorText.style.display = 'block';
    return false;
  } else {
    errorText.style.display = 'none';
    return true;
  }
  }


    document.getElementById('checkoutForm').addEventListener('submit', function(e) {
    if (!validatePhone()) {
    e.preventDefault();
    alert("Vui lòng kiểm tra lại số điện thoại giao hàng!");
    document.getElementById('shipPhone').focus();
    return;
  }


    const provSelect = document.getElementById('shipProvince');
    const provName = provSelect.options[provSelect.selectedIndex].text;

    document.querySelector('input[name="finalName"]').value = document.getElementById('shipName').value;
    document.querySelector('input[name="finalPhone"]').value = document.getElementById('shipPhone').value;
    document.querySelector('input[name="finalAddress"]').value = document.getElementById('shipAddress').value;
    document.querySelector('input[name="finalWard"]').value = document.getElementById('shipDistrict').value;
    document.querySelector('input[name="finalCity"]').value = (provName === 'Tỉnh' ? '' : provName);
  });

</script>
</body>
</html>