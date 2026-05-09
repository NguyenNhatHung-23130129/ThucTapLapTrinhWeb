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
        </div>
        <div class="box-body" style="display: flex; justify-content: space-between; align-items: center;">
          <div class="addr-info">
            <div class="addr-user">
              <span class="u-name">${not empty userAddress.orderName ? userAddress.orderName : sessionScope.auth.name}</span>
              <span class="u-sep">|</span>
              <span class="u-phone">${not empty userAddress.orderSdt ? userAddress.orderSdt : sessionScope.auth.phone}</span>
              <c:if test="${userAddress.isDefault == 1}">
                <span class="u-badge">Mặc định</span>
              </c:if>
            </div>
            <div class="addr-text">
              <p>${userAddress.addressLine}, ${userAddress.ward}, ${userAddress.city}</p>
            </div>
          </div>
          <div class="addr-change">
          <c:set var="urlParams" value="returnTo=checkout" />
          <c:if test="${not empty param.ids}"><c:set var="urlParams" value="${urlParams}&ids=${param.ids}" /></c:if>
          <c:if test="${not empty param.id}"><c:set var="urlParams" value="${urlParams}&buyNowId=${param.id}" /></c:if>
          <c:if test="${not empty param.buyNowId}"><c:set var="urlParams" value="${urlParams}&buyNowId=${param.buyNowId}" /></c:if>
          <c:if test="${not empty param.quantity}"><c:set var="urlParams" value="${urlParams}&buyNowQty=${param.quantity}" /></c:if>
          <c:if test="${not empty param.buyNowQty}"><c:set var="urlParams" value="${urlParams}&buyNowQty=${param.buyNowQty}" /></c:if>
          <c:if test="${not empty voucherCode}"><c:set var="urlParams" value="${urlParams}&voucherCode=${voucherCode}" /></c:if>
            <c:if test="${not empty param.chosenAddrId}"><c:set var="urlParams" value="${urlParams}&chosenAddrId=${param.chosenAddrId}" /></c:if>

          <a href="address?${urlParams}">
            Thay đổi
          </a>
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

        <div class="pay-list ship-list">
          <label class="opt-card active">
            <input type="radio" name="shipMethod" value="standard" checked>
            <div class="opt-content">
              <div class="opt-name">Giao Tiêu Chuẩn</div>
              <div class="opt-desc">30.000 ₫ ( giao hàng sau 3 -5 ngày )</div>
            </div>
          </label>

          <label class="opt-card">
            <input type="radio" name="shipMethod" value="express">
            <div class="opt-content">
              <div class="opt-name">Giao Hỏa Tốc </div>
              <div class="opt-desc">50.000 ₫ ( giao hàng sau 1 đến 2 ngày )</div>
            </div>
          </label>

          <label class="opt-card">
            <input type="radio" name="shipMethod" value="cold">
            <div class="opt-content">
              <div class="opt-name">Giao Lạnh (Thực phẩm tươi sống & đông lạnh )</div>
              <div class="opt-desc">100.000 ₫ ( giao trong ngày ) </div>
            </div>
          </label>
        </div>
      </section>

      <section class="box">
        <div class="box-head">
          <h2 class="box-title"><span class="payments"></span> Phương thức thanh toán</h2>
        </div>
        <div class="pay-list">
          <label class="opt-card active">
            <input type="radio" name="payType" value="cod" checked>
            <div class="opt-content">
              <span class="opt-name">Thanh Toán Khi Nhận Hàng (COD)</span>
            </div>
          </label>

          <div class="pay-item-wrapper">
            <label class="opt-card">
              <input type="radio" name="payType" value="ewallet">
              <div class="opt-content">
                <span class="opt-name">Chuyển khoản qua VN PAY / QR Code</span>
              </div>
            </label>

            <div id="form-ewallet" class="pay-detail qr-container">
              <p class="qr-title">Quét mã QR để thanh toán</p>
              <img id="vnpay-qr" class="qr-image" src="" alt="Mã QR Thanh Toán">
              <p class="qr-amount-wrap">
                Số tiền cần chuyển: <strong id="qr-amount-text" class="qr-amount-text"></strong>
              </p>
              <p class="qr-note">(Nội dung CK: Thanh toan don hang)</p>
            </div>
          </div>
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
              <span id="displayShippingFee"><fmt:formatNumber value="${shippingFee}" type="currency" currencySymbol="₫"/></span>
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
              <span class="total-num" id="displayTotal"><fmt:formatNumber value="${total}" type="currency" currencySymbol="₫"/></span>
            </div>
          </div>

          <form action="checkout" method="post" id="checkoutForm">
            <input type="hidden" name="ids" value="${param.ids}">
            <input type="hidden" name="chosenAddrId" value="${param.chosenAddrId}">
            <input type="hidden" name="addressId" value="${userAddress.id}">
            <input type="hidden" name="buyNowId" value="${param.id != null ? param.id : param.buyNowId}">
            <input type="hidden" name="buyNowQty" value="${param.quantity != null ? param.quantity : param.buyNowQty}">
            <input type="hidden" name="finalName" value="${not empty userAddress.orderName ? userAddress.orderName : user.name}">
            <input type="hidden" name="finalPhone" value="${not empty userAddress.orderSdt ? userAddress.orderSdt : user.phone}">
            <input type="hidden" name="finalAddress" value="${userAddress.addressLine}">
            <input type="hidden" name="finalWard" value="${userAddress.ward}">
            <input type="hidden" name="finalCity" value="${userAddress.city}">
            <input type="hidden" name="voucherCode" value="${voucherCode}">
            <input type="hidden" name="finalShipMethod" id="finalShipMethod" value="standard">

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
  const rawSubtotal = ${not empty subtotal ? subtotal : 0};
  const rawDiscount = ${not empty discount ? discount : 0};
  const BANK_ID = "MB";
  const ACCOUNT_NO = "0828762663";
  const ACCOUNT_NAME = "VO NHAT TAN";
  function updateQRCode(totalAmount) {
    const qrImg = document.getElementById('vnpay-qr');
    const qrText = document.getElementById('qr-amount-text');
    if (qrImg && qrText) {
      const addInfo = encodeURIComponent("Thanh toan don hang");
      const accName = encodeURIComponent(ACCOUNT_NAME);
      const qrUrl = `https://img.vietqr.io/image/${BANK_ID}-${ACCOUNT_NO}-compact2.png?amount=${totalAmount}&addInfo=${addInfo}&accountName=${accName}`;
      qrImg.src = qrUrl;
      const formatVND = new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' });
      qrText.innerText = formatVND.format(totalAmount);
    }
  }
  function setupSelection(groupName) {
    const radios = document.querySelectorAll('input[name="' + groupName + '"]');
    radios.forEach(radio => {
      radio.addEventListener('change', function() {
        radios.forEach(r => {
          const card = r.closest('.opt-card');
          if(card) card.classList.remove('active');
        });
        this.closest('.opt-card').classList.add('active');
        if (groupName === 'payType') {
          const walletForm = document.getElementById('form-ewallet');
          if(walletForm) walletForm.style.display = (this.value === 'ewallet') ? 'block' : 'none';
        }
        if (groupName === 'shipMethod') {
          document.getElementById('finalShipMethod').value = this.value;
          let fee = 30000;
          if (this.value === 'express') fee = 50000;
          if (this.value === 'cold') fee = 100000;
          const formatVND = new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' });
          document.getElementById('displayShippingFee').innerText = formatVND.format(fee);
          let newTotal = rawSubtotal + fee - rawDiscount;
          if (newTotal < 0) newTotal = 0;
          document.getElementById('displayTotal').innerText = formatVND.format(newTotal);
          updateQRCode(newTotal);
        }
      });
    });
  }

  setupSelection('shipMethod');
  setupSelection('payType');
  let initialFee = 30000;
  const checkedShipMethod = document.querySelector('input[name="shipMethod"]:checked');
  if(checkedShipMethod) {
    if (checkedShipMethod.value === 'express') initialFee = 50000;
    if (checkedShipMethod.value === 'cold') initialFee = 100000;
  }
  let initialTotal = rawSubtotal + initialFee - rawDiscount;
  if(initialTotal < 0) initialTotal = 0;
  updateQRCode(initialTotal);
</script>
</body>
</html>