<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>


<fmt:setLocale value="vi_VN"/>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lịch sử đơn hàng | Chay Tươi</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/OrderHistory.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/Nav.css">
</head>
<body>

<%@ include file="Header.jsp"%>

<h1 class="page-title">Lịch Sử Đơn Hàng</h1>
<div class="container">

    <c:if test="${not empty orderList}">
        <c:forEach var="order" items="${orderList}">
            <div class="order-item">
                <div class="order-header">
                    <div class="order-code">Mã đơn hàng: #${order.id}</div>
                    <div class="order-status">
                    <span class="status-dot
                        <c:choose>
                            <c:when test="${order.status eq 'Đang giao hàng' or order.status eq 'Đang giao'}">status-shipping</c:when>
                            <c:when test="${order.status eq 'Đã giao hàng' or order.status eq 'Đã giao'}">status-completed</c:when>
                        </c:choose>">
                    </span>
                        <span class="status-text">${order.status}</span>
                    </div>
                    <div class="order-time">
                        Ngày đặt: <fmt:formatDate value="${order.orderDate}" pattern="dd/MM/yyyy"/>
                    </div>
                    <div class="order-money"> Tổng tiền:
                        <fmt:formatNumber value="${order.totalAmount}" type="currency" currencySymbol="₫"/>
                    </div>
                </div>

                <div class="order-divider"></div>

                <c:forEach var="detail" items="${order.orderDetails}">
                    <div class="order-body">
                        <div class="product-image">
                            <c:choose>
                                <c:when test="${not empty detail.product.imageUrl}">
                                    <img src="${detail.product.imageUrl}" alt="${detail.product.name}">
                                </c:when>
                                <c:otherwise>
                                    <img src="${pageContext.request.contextPath}/assets/img/no-image.jpg" alt="${detail.product.name}">
                                </c:otherwise>
                            </c:choose>
                        </div>
                        <div class="product-info">
                            <div class="product-name">${detail.product.name}</div>
                        </div>
                        <div class="product-quantity">x${detail.quantity}</div>
                        <div class="product-price">
                            <fmt:formatNumber value="${detail.unitPrice}" type="currency" currencySymbol="₫"/>
                        </div>
                        <div style="text-align: right;">
                            <c:if test="${order.status eq 'Đã giao hàng' or order.status eq 'Đã giao'}">
                                <a href="${pageContext.request.contextPath}/productdetails?id=${detail.product.id}#review-section">
                                    <button class="btn btn-review">Đánh giá</button>
                                </a>
                            </c:if>
                        </div>
                    </div>
                </c:forEach>


                <div class="order-footer">
                    <c:if test="${order.status eq 'Đang xử lý'}">
                        <button type="button" class="btn btn-cancel-order" onclick="showCancelPopup(${order.id})">
                            Hủy đơn hàng
                        </button>
                    </c:if>

                    <button type="button" class="btn btn-primary" onclick="openOrderModal(${order.id})">Xem chi tiết đơn hàng</button>
                </div>

                <div id="orderModal-${order.id}" class="custom-modal-overlay">
                    <div class="custom-modal-content">
                        <span class="custom-close-btn" onclick="closeOrderModal(${order.id})">&times;</span>
                        <h2 class="modal-title">Chi tiết đơn hàng</h2>

                        <div class="modal-header-info">
                            <span class="modal-order-id">Mã đơn hàng: #${order.id}</span>
                            <div class="order-payment-status">
                                <strong>Trạng thái thanh toán: </strong>
                                <c:choose>
                                    <c:when test="${order.paymentStatus == 'Đã thanh toán'}">
                                        <span class="badge-paid">Đã thanh toán</span>
                                    </c:when>
                                    <c:when test="${order.paymentStatus == 'Thanh toán khi nhận hàng'}">
                                        <span class="badge-cod">Thanh toán khi nhận hàng (COD)</span>
                                    </c:when>
                                    <c:otherwise>
                                    <span class="badge-unpaid">
                                            ${not empty order.paymentStatus ? order.paymentStatus : 'Chưa thanh toán'}
                                    </span>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>

                        <div class="modal-product-list">
                            <c:forEach var="detail" items="${order.orderDetails}">
                                <div class="modal-product-item">
                                    <div class="modal-prod-img">
                                        <c:choose>
                                            <c:when test="${not empty detail.product.imageUrl}">
                                                <img src="${detail.product.imageUrl}" alt="${detail.product.name}">
                                            </c:when>
                                            <c:otherwise>
                                                <img src="${pageContext.request.contextPath}/assets/img/no-image.jpg" alt="${detail.product.name}">
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                    <div class="modal-prod-name">${detail.product.name}</div>
                                    <div class="modal-prod-qty">x${detail.quantity}</div>
                                    <div class="modal-prod-price"><fmt:formatNumber value="${detail.unitPrice}" type="currency" currencySymbol="₫"/></div>
                                    <div class="modal-prod-action">
                                        <button class="btn-buy-again" onclick="buyAgain(${detail.product.id})">Mua lại</button>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>

                        <div class="modal-shipping-tracking-wrapper">
                            <div class="modal-shipping-info">
                                <h3>Thông tin giao nhận</h3>
                                <p><strong>Tên:</strong> ${order.userName}</p>
                                <p><strong>Số điện thoại:</strong> ${not empty order.recipientPhone ? order.recipientPhone : 'Chưa cập nhật'}</p>
                                <p><strong>Địa chỉ:</strong> ${order.address}</p>
                                <h3 class="modal-total-money">Tổng tiền đơn hàng: <fmt:formatNumber value="${order.totalAmount}" type="currency" currencySymbol="₫"/></h3>
                            </div>

                            <div class="modal-tracking-timeline">
                                <jsp:useBean id="expectedDate" class="java.util.Date" />
                                <jsp:setProperty name="expectedDate" property="time" value="${order.orderDate.time + 345600000}" />

                                <h3>Thời gian dự kiến nhận hàng: <fmt:formatDate value="${expectedDate}" pattern="dd/MM/yyyy"/></h3>

                                <c:set var="statusLvl" value="0" />
                                <c:if test="${order.status eq 'Đang xử lý'}"><c:set var="statusLvl" value="1" /></c:if>
                                <c:if test="${order.status eq 'Đang giao hàng'}"><c:set var="statusLvl" value="2" /></c:if>
                                <c:if test="${order.status eq 'Đã giao hàng'}"><c:set var="statusLvl" value="3" /></c:if>

                                <div class="timeline-container">
                                    <div class="time-step ${statusLvl >= 1 ? 'active' : ''}">
                                        <div class="time-icon"><i class="fa-solid fa-clipboard-check"></i></div>
                                        <p>Đang xử lý</p>
                                        <span class="time-date"><fmt:formatDate value="${order.orderDate}" pattern="dd/MM/yyyy"/></span>
                                    </div>

                                    <div class="time-connector ${statusLvl >= 2 ? 'active' : ''}">
                                        <div class="line"></div>
                                        <i class="fa-solid fa-caret-right"></i>
                                    </div>

                                    <div class="time-step ${statusLvl >= 2 ? 'active' : ''}">
                                        <div class="time-icon"><i class="fa-solid fa-truck-fast"></i></div>
                                        <p>Đang giao hàng</p>
                                    </div>

                                    <div class="time-connector ${statusLvl >= 3 ? 'active' : ''}">
                                        <div class="line"></div>
                                        <i class="fa-solid fa-caret-right"></i>
                                    </div>

                                    <div class="time-step ${statusLvl >= 3 ? 'active' : ''}">
                                        <div class="time-icon"><i class="fa-solid fa-box-open"></i></div>
                                        <p>Đã giao hàng</p>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </c:forEach>
    </c:if>

    <c:if test="${empty orderList}">
        <div style="text-align: center; padding: 50px 0;">
            <img src="${pageContext.request.contextPath}/assets/img/empty-order.png" alt="Empty" style="width: 150px; opacity: 0.5;">
            <p style="font-size: 1.8rem; color: #666; margin-top: 20px;">Bạn chưa có đơn hàng nào.</p>
            <a href="home" class="btn btn-primary" style="text-decoration: none; display: inline-block; margin-top: 15px;">Tiếp tục mua sắm</a>
        </div>
    </c:if>
    <div id="cancelConfirmationModal" class="confirm-modal-overlay">
        <div class="confirm-modal-content">
            <div class="confirm-modal-header">
                <h3>Xác nhận hủy đơn hàng</h3>
            </div>
            <div class="confirm-modal-body">
                <p id="cancelModalMessage">Bạn có chắc chắn muốn hủy đơn hàng này không?</p>
            </div>
            <div class="confirm-modal-footer">
                <button class="confirm-btn confirm-btn-close" onclick="closeCancelPopup()">Đóng</button>
                <button class="confirm-btn confirm-btn-submit" id="confirmCancelSubmitBtn">Xác nhận hủy</button>
            </div>
        </div>
    </div>

</div>


<script src="${pageContext.request.contextPath}/assets/js/Header.js"></script>
<script>
    function openOrderModal(orderId) {
        document.getElementById('orderModal-' + orderId).style.display = 'flex';
    }

    function closeOrderModal(orderId) {
        document.getElementById('orderModal-' + orderId).style.display = 'none';
    }

    function buyAgain(productId) {
        window.location.href = "${pageContext.request.contextPath}/productdetails?id=" + productId;
    }

    window.onclick = function(event) {
        if (event.target.classList.contains('custom-modal-overlay')) {
            event.target.style.display = 'none';
        } if (event.target.classList.contains('confirm-modal-overlay')) {
    closeCancelPopup();
    }

    }
    let currentCancelOrderId = null;

    function showCancelPopup(orderId) {
        currentCancelOrderId = orderId;
        document.getElementById('cancelModalMessage').innerText = "Bạn có chắc chắn muốn hủy đơn hàng #" + orderId + " không?";
        document.getElementById('confirmCancelSubmitBtn').onclick = executeCancelOrder;
        document.getElementById('cancelConfirmationModal').style.display = 'flex';
    }

    function closeCancelPopup() {
        document.getElementById('cancelConfirmationModal').style.display = 'none';
        currentCancelOrderId = null;
    }

    function executeCancelOrder() {
        if (!currentCancelOrderId) return;
        const params = new URLSearchParams();
        params.append('action', 'cancel');
        params.append('orderId', currentCancelOrderId);
        document.getElementById('cancelModalMessage').innerText = "Đang xử lý yêu cầu...";
        document.getElementById('confirmCancelSubmitBtn').style.display = 'none';

        fetch('${pageContext.request.contextPath}/orderhistory', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded'
            },
            body: params.toString()
        })
            .then(response => {
                if (response.ok) {
                    document.getElementById('cancelModalMessage').innerText = "Hủy đơn hàng thành công!";
                    setTimeout(() => {
                        window.location.reload();
                    }, 1000);
                } else {
                    document.getElementById('cancelModalMessage').innerText = "Có lỗi xảy ra khi xử lý yêu cầu.";
                    document.getElementById('confirmCancelSubmitBtn').style.display = 'inline-block';
                    setTimeout(closeCancelPopup, 2000);
                }
            })
            .catch(error => {
                console.error('Error:', error);
                document.getElementById('cancelModalMessage').innerText = "Không thể kết nối đến hệ thống máy chủ.";
                document.getElementById('confirmCancelSubmitBtn').style.display = 'inline-block';
                setTimeout(closeCancelPopup, 2000);
            });
    }
</script>
</body>
</html>