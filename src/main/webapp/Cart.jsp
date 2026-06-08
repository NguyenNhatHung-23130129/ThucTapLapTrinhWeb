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
                <p class="cart-title p">Đã chọn <span id="checked-count">0</span> sản phẩm</p>
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
                        <div class="cart-item cart-items__item cart-grid-row" id="cart-item-row-${p.product.id}" data-stock="${p.product.stockQuantity}">

                            <div class="col-product cart-item__product-col">
                                <input type="checkbox" class="cart-checkbox cart-item__checkbox" value="${p.product.id}"
                                       data-total="${p.price * p.quantity}" onchange="updateCartTotal()">
                                <img src="${p.product.imageUrl}" alt="${p.product.name}" class="cart-item__image">
                                <div class="item-info cart-item__info">
                                    <a href="productdetails?id=${p.product.id}" class="cart-item__name">${p.product.name}</a>
                                </div>
                            </div>

                            <div class="col-price text-center item-unit-price">
                                <fmt:formatNumber value="${p.price}" type="currency" currencySymbol="₫"/>
                            </div>

                            <div class="col-qty text-center cart-item__qty-col">
                                <div class="stock-info">Kho: ${p.product.stockQuantity}</div>

                                <div class="qty-ctrl quantity">
                                    <button type="button" class="qty-btn quantity__btn"
                                            style="border: none; background: none; cursor: pointer;"
                                            onclick="updateQuantityAjax(${p.product.id}, -1)">
                                        <i class="fa-solid fa-minus"></i>
                                    </button>

                                    <span class="qty-input-display quantity__value"
                                          id="qty-val-${p.product.id}">${p.quantity}</span>

                                    <button type="button" class="qty-btn quantity__btn btn-plus"
                                            style="border: none; background: none; cursor: pointer;"
                                            onclick="updateQuantityAjax(${p.product.id}, 1)">
                                        <i class="fa-solid fa-plus"></i>
                                    </button>

                                </div>
                            </div>

                            <div class="col-total text-right item-total cart-item__total"
                                 id="item-total-${p.product.id}">
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
                    <span class="summary-line__label">Tổng tiền hàng</span>
                    <span id="subtotal-price" class="summary-line__value">
                        <fmt:formatNumber value="${sessionScope.cart.total}" type="currency" currencySymbol="₫"/>
                    </span>
                </div>
            </div>

            <div class="summary-total">
                <span class="summary-total__label">Tạm tính:</span>
                <div class="summary-total__amount-wrapper">
                    <span class="total-price" id="total-price">
                        <fmt:formatNumber value="${sessionScope.cart.total}" type="currency" currencySymbol="₫"/>
                    </span>
                    <p class="summary-total__vat-note">Chưa bao gồm phí vận chuyển</p>
                </div>
            </div>

            <button class="checkout-btn summary__checkout-btn" type="button" onclick="goToCheckout()">
                Tiến hành thanh toán
            </button>

            <div class="summary-benefits">
                <div class="summary-benefits__item">
                    <span class="material-symbols-outlined summary-benefits__icon">verified_user</span>
                    <span class="summary-benefits__text">Thanh toán an toàn bảo mật 100%</span>
                </div>
            </div>
        </div>

    </div>
</main>

<script>
    function checkStockButtons() {
        const items = document.querySelectorAll('.cart-item');
        items.forEach(item => {
            const stock = parseInt(item.getAttribute('data-stock') || 0);
            const productId = item.id.replace('cart-item-row-', '');
            const qtyDisplay = document.getElementById('qty-val-' + productId);

            if (qtyDisplay) {
                const currentQty = parseInt(qtyDisplay.innerText || 0);
                const plusBtn = item.querySelector('.btn-plus');

                if (plusBtn) {
                    if (currentQty >= stock) {
                        plusBtn.classList.add('disabled-btn');
                        plusBtn.setAttribute('disabled', 'true');
                    } else {
                        plusBtn.classList.remove('disabled-btn');
                        plusBtn.removeAttribute('disabled');
                    }
                }
            }
        });
    }

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
        checkStockButtons();

        itemCheckboxes.forEach(cb => {
            cb.addEventListener('change', function () {
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
        let checkedCount = 0;
        const itemCheckboxes = document.querySelectorAll('.cart-checkbox:not(#selectAll)');
        const selectAllCheckbox = document.getElementById('selectAll');

        let allChecked = true;
        let hasItems = itemCheckboxes.length > 0;

        itemCheckboxes.forEach(box => {
            if (box.checked) {
                total += parseFloat(box.getAttribute('data-total') || 0);
                checkedCount++;
            } else {
                allChecked = false;
            }
        });

        if (selectAllCheckbox && hasItems) {
            selectAllCheckbox.checked = allChecked;
        }
        const checkedCountElement = document.getElementById('checked-count');
        if (checkedCountElement) {
            checkedCountElement.innerText = checkedCount;
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

    function updateQuantityAjax(productId, changeQty) {
        fetch('add-cart', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8'
            },
            body: 'id=' + productId + '&quantity=' + changeQty + '&fromCart=true'
        })
            .then(response => response.json())
            .then(data => {
                if (data.redirect) {
                    window.location.href = data.redirect;
                    return;
                }

                if (data.status === 'success') {
                    if (data.itemQuantity <= 0) {
                        const itemRow = document.getElementById('cart-item-row-' + productId);
                        if (itemRow) itemRow.remove();
                    } else {
                        const qtyDisplay = document.getElementById('qty-val-' + productId);
                        if (qtyDisplay) qtyDisplay.innerText = data.itemQuantity;

                        const itemTotal = document.getElementById('item-total-' + productId);
                        if (itemTotal) {
                            itemTotal.innerText = new Intl.NumberFormat('vi-VN', {
                                style: 'currency',
                                currency: 'VND'
                            }).format(data.itemTotal);
                        }

                        const cb = document.querySelector(`#cart-item-row-${productId} .cart-item__checkbox`);
                        if (cb) cb.setAttribute('data-total', data.itemTotal);
                    }

                    const badge = document.getElementById('cartCount');
                    if (badge) badge.innerText = data.cartTotalQuantity;

                    updateCartTotal();
                    saveCheckboxState();
                    checkStockButtons();

                    if (data.cartTotalQuantity === 0) {
                        const container = document.querySelector('.cart-items');
                        if (container) container.innerHTML = '<div class="cart-empty__message">Giỏ hàng của bạn đang trống.</div>';
                    }
                }
            })
            .catch(err => console.error('Lỗi AJAX:', err));
    }
</script>
</body>
</html>
