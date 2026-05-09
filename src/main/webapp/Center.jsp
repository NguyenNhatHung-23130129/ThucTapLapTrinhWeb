<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sản Phẩm Nổi Bật | Chay Tươi</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/normalize/8.0.1/normalize.min.css"/>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.1/css/all.min.css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/Center.css">
</head>
<body>
<div class="category_container_center">
    <div class="category-section">
        <h2 class="category-section__header">Sản phẩm nổi bật</h2>

        <div class="category-section__grid page active">
            <c:forEach var="p" items="${productList}">
                <div class="product-card" onclick="goToProduct(${p.id})">

                    <div class="product-card__image-wrapper">
                        <img class="product-card__image" src="${p.imageUrl}" alt="${p.name}">
                    </div>

                    <div class="product-card__info">
                        <h3 class="product-card__name">${p.name}</h3>

                        <div class="product-card__meta">
                            <div class="price-container">
                    <span class="price">
                        <fmt:setLocale value="vi_VN"/>
                        <fmt:formatNumber value="${p.price}" type="currency" currencySymbol="₫"/>
                    </span>
                                <c:if test="${p.discount > 0}">
                                    <span class="discount">-${p.discount}%</span>
                                </c:if>
                            </div>
                            <div class="rating">
                                <i class="fa-solid fa-star"></i>
                                <span><fmt:formatNumber value="${p.averageRating}" pattern="0.0"/></span> (${p.ratingCount}) &nbsp;&nbsp;&nbsp;&nbsp;
                            </div>
                        </div>

                        <div class="button-group">
                            <form action="add-cart" method="get" target="hiddenFrame" class="form-add-to-cart">
                                <input type="hidden" name="id" value="${p.id}">
                                <input type="hidden" name="quantity" value="1">
                                <button type="submit" class="btn btn-add-cart" onclick="event.stopPropagation();">
                                    <i class="fa-solid fa-cart-plus"></i> Giỏ hàng
                                </button>
                            </form>

                            <a href="checkout?id=${p.id}&quantity=1&action=buynow" class="btn btn-buy-now" onclick="event.stopPropagation();">
                                Mua ngay
                            </a>
                        </div>
                    </div>
                </div>
            </c:forEach>

            <c:if test="${empty productList}">
                <p style="text-align: center; width: 100%; font-size: 1.6rem; grid-column: 1 / -1;">
                    Không tìm thấy sản phẩm nào.
                </p>
            </c:if>
        </div>
    </div>

    <div class="pagination">
        <c:if test="${currentPage > 1}">
            <a href="home?page=${currentPage - 1}">
                <button>&laquo;</button>
            </a>
        </c:if>

        <c:forEach begin="1" end="${totalPages}" var="i">
            <a href="home?page=${i}">
                <button class="${currentPage == i ? 'active' : ''}">${i}</button>
            </a>
        </c:forEach>

        <c:if test="${currentPage < totalPages}">
            <a href="home?page=${currentPage + 1}">
                <button>&raquo;</button>
            </a>
        </c:if>
    </div>
</div>

<iframe name="hiddenFrame" style="display:none;"></iframe>

<script>
    function goToProduct(productId) {
        window.location.href = "${pageContext.request.contextPath}/productdetails?id=" + productId;
    }
</script>
</body>
</html>