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
                                <c:otherwise></c:otherwise>
                            </c:choose>">
                        </span>
                        <span class="status-text">${order.status}</span>
                    </div>

                    <div class="order-time">
                        Ngày đặt: <fmt:formatDate value="${order.orderDate}" pattern="dd/MM/yyyy"/>
                    </div>


                    <div class="order-money">
                        <fmt:formatNumber value="${order.totalAmount}" type="currency" currencySymbol="₫"/>
                    </div>
                </div>

                <div class="order-divider"></div>

                <c:forEach var="detail" items="${order.orderDetails}">
                    <div class="order-body">
                        <div class="product-image">
                            <img src="${detail.product.imageUrl}" alt="${detail.product.name}"
                                 onerror="this.src='${pageContext.request.contextPath}/assets/img/no-image.jpg'">
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

                                <a href="Chitietmon?id=${detail.product.id}#review-section">
                                    <button class="btn btn-review">Đánh giá</button>
                                </a>

                            </c:if>

                        </div>
                    </div>
                </c:forEach>

                <div class="order-footer">
                    <form action="AddToCartServlet" method="post">
                        <input type="hidden" name="orderId" value="${order.id}">
                        <input type="hidden" name="action" value="buy_again">
                        <button class="btn btn-primary">Mua lại đơn này</button>
                    </form>
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

</div>

<script src="${pageContext.request.contextPath}/assets/js/Header.js"></script>
</body>
</html>