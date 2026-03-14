<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<fmt:setLocale value="vi_VN"/>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Giỏ hàng | Chay Tươi</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/normalize/8.0.1/normalize.min.css"
          integrity="sha512-NhSC1YmyruXifcj/KFRWoC561YpHpc5Jtzgvbuzx5VozKpWvQ+4nXhPdFgmx8xqexRcpAglTj9sIBWINXa8x5w=="
          crossorigin="anonymous" referrerpolicy="no-referrer"/>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.1/css/all.min.css"
          integrity="sha512-2SwdPD6INVrV/lHTZbO2nodKhrnDdJK9/kg2XD1r9uGqPo1cUbujc+IYdlYdEErWNu69gVcYgdxlmVmzTWnetw=="
          crossorigin="anonymous" referrerpolicy="no-referrer"/>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@500;600;800&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;700&display=swap" rel="stylesheet"/>
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@400,0&display=swap" rel="stylesheet"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/Cart.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/Nav.css">

</head>
<body>
<%@ include file="Header.jsp" %>
<main class="cart">
    <div class="layout">

        <div class="cart-section">
            <div class="cart-title">
                <h1 class="cart-section__title">Giỏ hàng của bạn</h1>
                <p>${sessionScope.cart.list.size()} sản phẩm</p>
            </div>

            <div class="cart-box">
                <div class="select-all-bar">
                    <input type="checkbox" id="selectAll" class="cart-checkbox" name="selectAll" checked onclick="toggleAll(this)"/>
                    <label for="selectAll">Chọn tất cả</label>
                </div>

                <div class="cart-items">
                    <c:forEach var="p" items="${sessionScope.cart.list}">
                        <div class="cart-item cart-items__item">
                            <input type="checkbox"
                                   class="cart-checkbox"
                                   value="${p.product.id}"
                                   data-total="${p.price * p.quantity}"
                                   onchange="updateCartTotal()"
                                   checked>

                            <div class="item-img" style='background-image:url("${p.product.imageUrl}")'></div>

                            <div class="item-info">
                                <h3 class="cart-item__name">${p.product.name}</h3>
                                <p class="item-unit-price">
                                    <fmt:formatNumber value="${p.price}" type="currency" currencySymbol="₫"/>
                                </p>
                            </div>

                            <div class="item-right">
                                <div class="qty-ctrl quantity">
                                    <a href="add-cart?id=${p.product.id}&quantity=-1&fromCart=true" class="qty-btn quantity__btn">
                                        <span class="material-symbols-outlined">remove</span>
                                    </a>

                                    <span class="qty-input-display quantity__value">${p.quantity}</span>

                                    <a href="add-cart?id=${p.product.id}&quantity=1&fromCart=true" class="qty-btn quantity__btn">
                                        <span class="material-symbols-outlined">add</span>
                                    </a>
                                </div>
                                <p class="item-total cart-item__total">
                                    <fmt:formatNumber value="${p.total}" type="currency" currencySymbol="₫"/>
                                </p>
                            </div>

                            <a href="del-cart?id=${p.product.id}" class="delete-btn btn--remove" >
                                <i class="fa-solid fa-trash"></i>
                            </a>
                        </div>
                    </c:forEach>

                    <c:if test="${empty sessionScope.cart.list}">
                        <div style="padding: 40px; text-align: center; color: var(--text-muted);">
                            Giỏ hàng của bạn đang trống.
                        </div>
                    </c:if>
                </div>
            </div>
        </div>

        <div class="summary-box summary">
            <h2 class="summary__title">Tóm tắt đơn hàng</h2>

            <div class="summary-lines">
                <div class="summary-line">
                    <span>Tạm tính</span>
                    <span id="subtotal-price">
                        <fmt:formatNumber value="${sessionScope.cart.total}" type="currency" currencySymbol="₫"/>
                    </span>
                </div>
                <div class="summary-line">
                    <span>Phí vận chuyển</span>
                    <span style="font-size: 0.8rem; font-style: italic;">Tạm tính lúc thanh toán</span>
                </div>
            </div>

            <div class="summary-total">
                <span style="font-weight: 700;">Tổng cộng</span>
                <span class="total-price" id="total-price">
                    <fmt:formatNumber value="${sessionScope.cart.total}" type="currency" currencySymbol="₫"/>
                </span>
            </div>

            <button class="checkout-btn summary__checkout-btn" type="button" onclick="goToCheckout()">
                Thanh toán ngay
            </button>

            <div style="margin-top: 10px; display: flex; flex-direction: column; gap: 8px;">
                <div style="display: flex; align-items: center; gap: 8px; font-size: .8rem; color: var(--text-muted);">
                    <span class="material-symbols-outlined" style="color: var(--accent-green); font-size: 18px;">local_shipping</span>
                    <span>Miễn phí vận chuyển cho đơn từ 500.000 ₫</span>
                </div>
                <div style="display: flex; align-items: center; gap: 8px; font-size: .8rem; color: var(--text-muted);">
                    <span class="material-symbols-outlined" style="color: var(--accent-green); font-size: 18px;">verified_user</span>
                    <span>Thanh toán an toàn 100%</span>
                </div>
            </div>
        </div>

    </div>
</main>


</body>
</html>
<script>
    function updateCartTotal() {
        let total = 0;


        const checkboxes = document.querySelectorAll('.cart-checkbox:checked');

        checkboxes.forEach(box => {
            if (!isNaN(val)) total += val;
            total += parseFloat(box.getAttribute('data-total'));
        });


        const formattedMoney = new Intl.NumberFormat('vi-VN', {
            style: 'currency',
            currency: 'VND'
        }).format(total);


        const totalElement = document.getElementById('total-price');
        const subTotalElement = document.getElementById('subtotal-price');

        if (totalElement) {
            totalElement.innerText = formattedMoney;
        }
        if (subTotalElement) {
            subTotalElement.innerText = formattedMoney;
        }
    }


    document.addEventListener("DOMContentLoaded", function() {
        updateCartTotal();
    });

    function goToCheckout() {

        const checkboxes = document.querySelectorAll('.cart-checkbox:checked');


        if (checkboxes.length === 0) {
            alert("Vui lòng chọn ít nhất một sản phẩm để thanh toán!");
            return;
        }


        let selectedIds = [];
        checkboxes.forEach(box => {
            selectedIds.push(box.value);
        });



        window.location.href = "checkout?ids=" + selectedIds.join(",");
    }
</script>