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
          <div class="addr-info">
            <div class="addr-user">
              <span class="u-name">${user.name}</span>
              <span class="u-phone">${user.phone}</span>
              <span class="u-badge">Mặc định</span>
            </div>
            <div class="addr-text">
              <p>${userAddress.addressLine}, ${userAddress.ward}, ${userAddress.city}</p>
              <p>Thành phố ${userAddress.city}, Việt Nam</p>
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
</script>
</body>
</html>