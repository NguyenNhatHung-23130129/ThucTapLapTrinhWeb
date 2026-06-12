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
                <div class="p-qty">SL: ${item.quantity}</div>
              </div>
              <div class="prod-price-qty">
                <div class="p-unit"><fmt:formatNumber value="${item.price}" type="currency" currencySymbol="₫"/></div>
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
              <div class="opt-desc">15.000 ₫ ( giao hàng sau 3 -5 ngày )</div>
            </div>
          </label>

          <label class="opt-card">
            <input type="radio" name="shipMethod" value="express">
            <div class="opt-content">
              <div class="opt-name">Giao Hỏa Tốc </div>
              <div class="opt-desc">30.000 ₫ ( giao hàng sau 1 đến 2 ngày )</div>
            </div>
          </label>

          <label class="opt-card">
            <input type="radio" name="shipMethod" value="cold">
            <div class="opt-content">
              <div class="opt-name">Giao Lạnh (Thực phẩm tươi sống & đông lạnh )</div>
              <div class="opt-desc">50.000 ₫ ( giao trong ngày ) </div>
            </div>
          </label>
        </div>
          <p id="shipping-notice"></p>
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
                <span class="opt-name">Thanh toán qua VN PAY </span>
              </div>
            </label>
<%--            <div id="vnpay-card-fields" class="pay-detail" style="display: none;">--%>
<%--              <p class="vnpay-notice">--%>
<%--                * Sử dụng thông tin thẻ test do VNPAY cung cấp để thử nghiệm.--%>
<%--              </p>--%>

<%--              <div class="form-group">--%>
<%--                <label for="vnpayBank">Chọn Ngân hàng Demo</label>--%>
<%--                <select id="vnpayBank" name="vnpayBank">--%>
<%--                  <option value="NCB">Ngân hàng NCB</option>--%>
<%--                  <option value="AGRIBANK">Agribank</option>--%>
<%--                  <option value="SACOMBANK">Sacombank</option>--%>
<%--                  <option value="EXIMBANK">Eximbank</option>--%>
<%--                </select>--%>
<%--              </div>--%>

<%--              <div class="form-group">--%>
<%--                <label for="vnpayCardNo">Số thẻ</label>--%>
<%--                <input type="text" id="vnpayCardNo" name="vnpayCardNo" placeholder="9704 19xx xxxx xxxx" value="9704198526191432119">--%>
<%--              </div>--%>

<%--              <div class="form-group">--%>
<%--                <label for="vnpayCardName">Tên chủ thẻ:</label>--%>
<%--                <input type="text" id="vnpayCardName" name="vnpayCardName" placeholder="NGUYEN VAN A" value="NGUYEN VAN A">--%>
<%--              </div>--%>
<%--            </div>--%>
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
                <button type="button" class="btn-black" onclick="applyVoucherCode()">Áp dụng</button>
            </div>
          </div>

            <div class="sum-table">
                <div class="sum-row">
                    <span>Tiền hàng (${selectedProducts.size()} sản phẩm)</span>
                    <span><fmt:formatNumber value="${subtotal}" type="currency" currencySymbol="₫"/></span>
                </div>

                <div class="sum-row">
                    <span>Phí vận chuyển</span>
                    <span id="displayShippingFee"><fmt:formatNumber value="${shippingFee}" type="currency" currencySymbol="₫"/></span>
                </div>

                <div class="sum-row discount" style="color: #27ae60; font-weight: 500;">
                    <span>Giảm giá ${not empty voucherCode ? '('.concat(voucherCode).concat(')') : ''}</span>
                    <span id="displayDiscount">
      <c:choose>
          <c:when test="${discount > 0}">
              -<fmt:formatNumber value="${discount}" type="currency" currencySymbol="₫"/>
          </c:when>
          <c:otherwise>0 ₫</c:otherwise>
      </c:choose>
    </span>
                </div>
            </div>

          <div class="sum-total">
            <span>Tổng thanh toán</span>
            <div class="total-val">
              <span class="total-num" id="displayTotal"><fmt:formatNumber value="${total}" type="currency" currencySymbol="₫"/></span>
            </div>
          </div>
          <input type="hidden" id="hiddenCityCode" value="${userAddress.city}">
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
<%--    <div id="qrModal" class="modal-overlay">--%>
<%--      <div class="modal-content">--%>
<%--        <h3 class="qr-modal-title">Quét mã QR để thanh toán</h3>--%>
<%--        <p>Đơn hàng <strong id="popup-order-id"></strong> đã được tạo. Vui lòng quét mã:</p>--%>

<%--        <img id="popup-qr-img" class="qr-modal-img" src="" alt="Mã QR">--%>

<%--        <p class="qr-modal-amount-wrap">Số tiền: <strong id="popup-qr-amount" class="qr-modal-amount"></strong></p>--%>
<%--        <p class="qr-modal-content-wrap">Nội dung CK: <strong id="popup-qr-content"></strong></p>--%>

<%--        <p class="loading-text">⏳ Hệ thống đang chờ thanh toán...</p>--%>
<%--        <button type="button" class="btn-close-modal" onclick="closeQrModal()">Đóng / Thanh toán sau</button>--%>
<%--      </div>--%>
<%--    </div>--%>
  </main>
</div>
<script>
  const rawSubtotal = ${not empty subtotal ? subtotal : 0};
  const rawDiscount = ${not empty discount ? discount : 0};
  const BANK_ID = "MB";
  const ACCOUNT_NO = "0828762663";
  const ACCOUNT_NAME = "VO NHAT TAN";
  // function updateQRCode(totalAmount) {
  //   const qrImg = document.getElementById('vnpay-qr');
  //   const qrText = document.getElementById('qr-amount-text');
  //   if (qrImg && qrText) {
  //     const addInfo = encodeURIComponent("Thanh toan don hang");
  //     const accName = encodeURIComponent(ACCOUNT_NAME);
  //     const qrUrl = "https://img.vietqr.io/image/" + BANK_ID + "-" + ACCOUNT_NO + "-compact2.png?amount=" + totalAmount + "&addInfo=" + addInfo + "&accountName=" + accName;
  //     qrImg.src = qrUrl;
  //     const formatVND = new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' });
  //     qrText.innerText = formatVND.format(totalAmount);
  //   }
  // }

  function checkFrozenItems() {
      const hasFrozen = ${hasFrozen != null ? hasFrozen : false};

      if (hasFrozen) {
          const normalShip = document.querySelector('input[value="standard"]');
          const economyShip = document.querySelector('input[value="economy"]');

          if (normalShip) normalShip.disabled = true;
          if (economyShip) economyShip.disabled = true;

          document.querySelector('input[value="cold"]').checked = true;
          const noticeEl = document.getElementById("shipping-notice");
          if (noticeEl) {
              noticeEl.innerText = "(*) Đơn hàng có thực phẩm đông lạnh hoặc trái cây, hệ thống đã bắt buộc chọn Giao Lạnh hoặc Hỏa Tốc để bảo đảm chất lượng.";
              noticeEl.style.color = "#e74c3c";
              noticeEl.style.display = "block";
          }
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
                  const cardFields = document.getElementById('vnpay-card-fields');
                  if(cardFields) cardFields.style.display = (this.value === 'ewallet') ? 'block' : 'none';
              }

              if (groupName === 'shipMethod') {
                  document.getElementById('finalShipMethod').value = this.value;

                  const rawCityCode = document.getElementById('hiddenCityCode').value || "700000";
                  const cityCode = encodeURIComponent(rawCityCode);
                  const method = encodeURIComponent(this.value);

                  document.getElementById('displayShippingFee').innerText = "Đang tính...";

                  fetch('${pageContext.request.contextPath}/api/calculate-shipping?cityCode=' + cityCode + '&method=' + method)
                      .then(res => res.json())
                      .then(data => {
                          const fee = data.fee;
                          const formatVND = new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' });

                          document.getElementById('displayShippingFee').innerText = formatVND.format(fee);

                          let newTotal = rawSubtotal + fee - rawDiscount;
                          if (newTotal < 0) newTotal = 0;
                          document.getElementById('displayTotal').innerText = formatVND.format(newTotal);
                      })
                      .catch(err => {
                          console.error("Lỗi tính phí vận chuyển:", err);
                          document.getElementById('displayShippingFee').innerText = "Lỗi kết nối";
                      });
              }
          });
      });
  }
  window.onload = function() {
      checkFrozenItems();
      setupSelection('shipMethod');
      setupSelection('payType');
  };

  setupSelection('shipMethod');
  setupSelection('payType');
  let initialFee = 15000;
  const checkedShipMethod = document.querySelector('input[name="shipMethod"]:checked');
  if(checkedShipMethod) {
    if (checkedShipMethod.value === 'express') initialFee = 30000;
    if (checkedShipMethod.value === 'cold') initialFee = 50000;
  }
  let initialTotal = rawSubtotal + initialFee - rawDiscount;
  if(initialTotal < 0) initialTotal = 0;


  function applyVoucherCode() {
      const vCode = document.getElementById('vCode').value;
      if(vCode.trim() !== '') {
          const currentUrl = new URL(window.location.href);
          currentUrl.searchParams.set('voucherCode', vCode.trim());
        window.location.href = "voucher?tab=saved";

      }

  }
  let checkInterval = null;
  let pollCount = 0;
  const MAX_POLLS = 100;

  document.getElementById('checkoutForm').addEventListener('submit', function(e) {
    const payType = document.querySelector('input[name="payType"]:checked').value;
    if (payType === 'cod') return true;
    e.preventDefault();

    const formData = new FormData(this);
    formData.append('isAjax', 'true');
    formData.append('payType', payType);
    // formData.append('vnpayBank', document.getElementById('vnpayBank').value);
    // formData.append('vnpayCardNo', document.getElementById('vnpayCardNo').value);
    // formData.append('vnpayCardName', document.getElementById('vnpayCardName').value);
    fetch('checkout', {
      method: 'POST',
      body: new URLSearchParams(formData)
    }).then(async res => {
      const text = await res.text();
      try {

        const data = JSON.parse(text);
        if (data.success) {
          if (data.vnpayUrl) {
            window.location.href = data.vnpayUrl;
          } else {
            window.location.href = 'orderhistory';
          }
        } else {
          if (data.message === "SESSION_EXPIRED") {
            alert("Phiên đăng nhập đã hết hạn. Vui lòng đăng nhập lại!");
            window.location.href = "login";
          } else if (data.message.includes("hết hàng") || data.message.includes("không đủ số lượng")) {

            alert("Sản phẩm đã hết hàng, vui lòng chọn sản phẩm khác.");
            window.location.href = "cart";
          } else {
            alert("Lỗi tạo đơn: " + data.message);
          }
        }
      } catch (err) {
        console.error("Server không trả về JSON, mà trả về:", text);
        if (text.includes("<html") || text.includes("<body")) {
          alert("Đã bắt được trang HTML lỗi ngầm từ Server! Bấm OK để hiển thị chi tiết.");
          document.open();
          document.write(text);
          document.close();
        } else {
          alert("Lỗi máy chủ không xác định: " + text.substring(0, 150));
        }
      }
    }).catch(err => {
      alert("Lỗi kết nối mạng: " + err.message);
    });
  });

  function openPaymentModal(orderId, total) {
    const content = 'THANHTOAN DH' + orderId;
    const qrUrl = `https://img.vietqr.io/image/` + BANK_ID + `-` + ACCOUNT_NO + `-compact2.png?amount=` + total + `&addInfo=` + encodeURIComponent(content) + `&accountName=` + encodeURIComponent(ACCOUNT_NAME);

    document.getElementById('popup-qr-img').src = qrUrl;
    document.getElementById('popup-qr-amount').innerText = new Intl.NumberFormat('vi-VN', {style:'currency', currency:'VND'}).format(total);
    document.getElementById('popup-qr-content').innerText = content;
    document.getElementById('popup-order-id').innerText = '#' + orderId;
    document.getElementById('qrModal').style.display = 'flex';
    pollCount = 0;

    checkInterval = setInterval(() => {
      pollCount++;
      if (pollCount > MAX_POLLS) {
        clearInterval(checkInterval);
        alert('Đã hết thời gian chờ thanh toán (5 phút). Đơn hàng đã được lưu trữ, bạn có thể thanh toán sau.');
        window.location.href = 'orderhistory';
        return;
      }

      fetch('api/check-payment?orderId=' + orderId)
              .then(res => res.json())
              .then(data => {
                if (data.status === 'PAID') {
                  clearInterval(checkInterval);
                  alert('Thanh toán thành công! Hệ thống đang chuyển trang.');
                  window.location.href = 'orderhistory';
                } else if (data.status === 'ERROR') {
                  console.warn('Hệ thống đang kiểm tra lại giao dịch...');
                }
              })
              .catch(err => {

                console.error("Lỗi kết nối khi kiểm tra thanh toán: ", err);
              });
    }, 3000);
  }

  function closeQrModal() {
    clearInterval(checkInterval);
    window.location.href = 'orderhistory';
  }
</script>
</body>
</html>