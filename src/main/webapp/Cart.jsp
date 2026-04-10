<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<fmt:setLocale value="vi_VN"/>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Giỏ hàng | Chay Tươi</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/normalize/8.0.1/normalize.min.css"/>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"/>
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500;700&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@400,0&display=swap"
          rel="stylesheet"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/Nav.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/Cart.css">
</head>
<body class="cart-page__body">
<%@ include file="Header.jsp" %>

<main class="cart cart-main">
    <div class="layout cart-layout">

        <div class="cart-section">
            <div class="cart-title">
                <h1 class="cart-section__title">Giỏ hàng của bạn</h1>
                <p class="cart-section__count">${sessionScope.cart.list.size()} sản phẩm</p>
            </div>

            <div class="cart-box">
                <div class="select-all-bar cart-grid-row">
                    <div class="col-product">
                        <input type="checkbox" id="selectAll" class="cart-checkbox select-all__checkbox"
                               name="selectAll" onclick="toggleAll(this)"/>
                        <label for="selectAll" class="select-all__label">Sản phẩm</label>
                    </div>
                    <div class="col-price text-center cart-header__price">Đơn giá</div>
                    <div class="col-qty text-center cart-header__qty">Số lượng</div>
                    <div class="col-total text-right cart-header__total">Thành tiền</div>
                    <div class="col-action text-center cart-header__action">Thao tác</div>
                </div>

                <div class="cart-items">
                    <c:forEach var="p" items="${sessionScope.cart.list}">
                        <div class="cart-item cart-items__item cart-grid-row">

                            <div class="col-product cart-item__product-col">
                                <input type="checkbox" class="cart-checkbox cart-item__checkbox" value="${p.product.id}"
                                       data-total="${p.price * p.quantity}" onchange="updateCartTotal()">
                                <img src="${p.product.imageUrl}" alt="${p.product.name}" class="cart-item__image">
                                <div class="item-info cart-item__info">
                                    <a href="product?id=${p.product.id}" class="cart-item__name">${p.product.name}</a>
                                </div>
                            </div>

                            <div class="col-price text-center item-unit-price">
                                <fmt:formatNumber value="${p.price}" type="currency" currencySymbol="₫"/>
                            </div>

                            <div class="col-qty text-center cart-item__qty-col">
                                <div class="stock-info">Kho: ${p.product.stockQuantity}</div>

                                <div class="qty-ctrl quantity">
                                    <a href="add-cart?id=${p.product.id}&quantity=-1&fromCart=true"
                                       class="qty-btn quantity__btn">
                                        <span class="material-symbols-outlined">remove</span>
                                    </a>

                                    <span class="qty-input-display quantity__value">${p.quantity}</span>

                                    <c:choose>
                                        <c:when test="${p.quantity >= p.product.stockQuantity}">
                                                <span class="qty-btn quantity__btn disabled-btn" title="Đã đạt tối đa tồn kho">
                                                 <span class="material-symbols-outlined" style="color: #ccc;">add</span>
                                                </span>
                                        </c:when>
                                        <c:otherwise>
                                            <a href="add-cart?id=${p.product.id}&quantity=1&fromCart=true"
                                               class="qty-btn quantity__btn">
                                                <span class="material-symbols-outlined">add</span>
                                            </a>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>

                            <div class="col-total text-right item-total cart-item__total">
                                <fmt:formatNumber value="${p.total}" type="currency" currencySymbol="₫"/>
                            </div>

                            <div class="col-action text-center cart-item__action-col">
                                <a href="del-cart?id=${p.product.id}" class="delete-btn btn--remove"
                                   title="Xóa sản phẩm">
                                    <i class="fa-solid fa-trash"></i>
                                </a>
                            </div>

                        </div>
                    </c:forEach>

                    <c:if test="${empty sessionScope.cart.list}">
                        <div class="cart-empty__message">
                            Giỏ hàng của bạn đang trống.
                        </div>
                    </c:if>
                </div>
            </div>
        </div>

        <div class="summary-box summary">
            <h2 class="summary__title">Tổng quan đơn hàng</h2>

            <div class="summary-lines">
                <div class="summary-line">
                    <span class="summary-line__label">Tạm tính</span>
                    <span id="subtotal-price" class="summary-line__value">
                        <fmt:formatNumber value="${sessionScope.cart.total}" type="currency" currencySymbol="₫"/>
                    </span>
                </div>
                <div class="summary-line">
                    <span class="summary-line__label">Phí vận chuyển</span>
                    <span class="summary-line__shipping-note">Tạm tính lúc thanh toán</span>
                </div>
            </div>

            <div class="coupon-box">
                <label for="couponCode" class="coupon-box__label">Mã giảm giá</label>
                <div class="coupon-input-group">
                    <input type="text" id="couponCode" class="coupon-box__input" placeholder="Nhập mã...">
                    <button type="button" class="coupon-box__btn" onclick="applyCoupon()">Áp dụng</button>
                </div>
            </div>

            <div class="summary-total">
                <span class="summary-total__label">Tổng cộng</span>
                <div class="summary-total__amount-wrapper">
                    <span class="total-price" id="total-price">
                        <fmt:formatNumber value="${sessionScope.cart.total}" type="currency" currencySymbol="₫"/>
                    </span>
                    <p class="summary-total__vat-note">Đã bao gồm VAT</p>
                </div>
            </div>

            <button class="checkout-btn summary__checkout-btn" type="button" onclick="goToCheckout()">
                Tiến hành thanh toán
            </button>

            <div class="summary-benefits">
                <div class="summary-benefits__item">
                    <span class="material-symbols-outlined summary-benefits__icon">local_shipping</span>
                    <span class="summary-benefits__text">Miễn phí vận chuyển cho đơn từ 500.000 ₫</span>
                </div>
                <div class="summary-benefits__item">
                    <span class="material-symbols-outlined summary-benefits__icon">verified_user</span>
                    <span class="summary-benefits__text">Thanh toán an toàn bảo mật 100%</span>
                </div>
            </div>
        </div>

    </div>
    <c:if test="${not empty sessionScope.cartError}">
        <script>
            alert('${sessionScope.cartError}');
        </script>
        <c:remove var="cartError" scope="session"/>
    </c:if>
</main>

<script>
    document.addEventListener("DOMContentLoaded", function () {
        const selectAllBtn = document.getElementById('selectAll');
        const itemCheckboxes = document.querySelectorAll('.cart-item__checkbox');

        const savedState = sessionStorage.getItem('cartCheckboxState');

        if (savedState) {
            const state = JSON.parse(savedState);
            if (selectAllBtn) selectAllBtn.checked = state.selectAll;

            itemCheckboxes.forEach(cb => {
                if (state.items.includes(cb.value)) {
                    cb.checked = true;
                } else {
                    cb.checked = false;
                }
            });
        } else {
            if (selectAllBtn) selectAllBtn.checked = true;
            itemCheckboxes.forEach(cb => cb.checked = true);
            saveCheckboxState();
        }

        updateCartTotal();

        itemCheckboxes.forEach(cb => {
            cb.addEventListener('change', function() {
                // Kiểm tra SelectAll
                if (!this.checked && selectAllBtn) selectAllBtn.checked = false;
                const allChecked = Array.from(itemCheckboxes).every(c => c.checked);
                if (selectAllBtn) selectAllBtn.checked = allChecked;

                saveCheckboxState();
                updateCartTotal();
            });
        });
    });

    function saveCheckboxState() {
        const selectAllBtn = document.getElementById('selectAll');
        const checkedItems = Array.from(document.querySelectorAll('.cart-item__checkbox:checked')).map(cb => cb.value);

        const state = {
            selectAll: selectAllBtn ? selectAllBtn.checked : false,
            items: checkedItems
        };
        sessionStorage.setItem('cartCheckboxState', JSON.stringify(state));
    }

    function updateCartTotal() {
        let total = 0;
        const itemCheckboxes = document.querySelectorAll('.cart-checkbox:not(#selectAll)');
        const selectAllCheckbox = document.getElementById('selectAll');

        let allChecked = true;
        let hasItems = itemCheckboxes.length > 0;

        itemCheckboxes.forEach(box => {
            if (box.checked) {
                total += parseFloat(box.getAttribute('data-total') || 0);
            } else {
                allChecked = false;
            }
        });

        if (selectAllCheckbox && hasItems) {
            selectAllCheckbox.checked = allChecked;
        }

        const formattedMoney = new Intl.NumberFormat('vi-VN', {
            style: 'currency',
            currency: 'VND'
        }).format(total);

        const totalElement = document.getElementById('total-price');
        const subTotalElement = document.getElementById('subtotal-price');

        if (totalElement) totalElement.innerText = formattedMoney;
        if (subTotalElement) subTotalElement.innerText = formattedMoney;
    }

    function toggleAll(source) {
        const itemCheckboxes = document.querySelectorAll('.cart-checkbox:not(#selectAll)');
        itemCheckboxes.forEach(box => {
            box.checked = source.checked;
        });
        saveCheckboxState();
        updateCartTotal();
    }

    function goToCheckout() {
        const checkboxes = document.querySelectorAll('.cart-checkbox:checked:not(#selectAll)');
        let selectedIds = [];

        checkboxes.forEach(box => {
            selectedIds.push(box.value);
        });

        if (selectedIds.length === 0) {
            alert("Vui lòng chọn ít nhất một sản phẩm để thanh toán!");
            return;
        }

        window.location.href = "checkout?ids=" + selectedIds.join(",");
    }

    function applyCoupon() {
        const code = document.getElementById('couponCode').value;
        if (!code.trim()) {
            alert("Vui lòng nhập mã giảm giá.");
            return;
        }
        alert("Tính năng áp dụng mã giảm giá cần được map với API backend.");
    }
</script>
</body>
</html>