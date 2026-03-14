<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<fmt:setLocale value="vi_VN"/>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Danh sách sản phẩm | Chay Tươi</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/normalize/8.0.1/normalize.min.css"
          integrity="sha512-NhSC1YmyruXifcj/KFRWoC561YpHpc5Jtzgvbuzx5VozKpWvQ+4nXhPdFgmx8xqexRcpAglTj9sIBWINXa8x5w=="
          crossorigin="anonymous" referrerpolicy="no-referrer"/>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.1/css/all.min.css"
          integrity="sha512-2SwdPD6INVrV/lHTZbO2nodKhrnDdJK9/kg2XD1r9uGqPo1cUbujc+IYdlYdEErWNu69gVcYgdxlmVmzTWnetw=="
          crossorigin="anonymous" referrerpolicy="no-referrer"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/Nav.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/ProductList.css">

    <style>

    </style>
</head>
<body>

<%@ include file="Header.jsp" %>

<div class="category_container">
    <div class="category-section">


        <c:forEach items="${categories}" var="c">
            <div class="category-group" id="cat-${c.id}">

                <h2 class="category-header-title">${c.name}</h2>

                <div class="category-section__grid page active">

                    <c:forEach var="p" items="${productList}">

                        <c:if test="${p.categoryId == c.id}">

                            <div class="product-card" onclick="goToProduct(${p.id})">
                                <div class="product-card__image-wrapper">
                                    <img class="product-card__image" src="${p.imageUrl}" alt="${p.name}">
                                </div>
                                <div class="product-card__info">
                                    <p class="product-card__name">${p.name}</p>
                                    <div class="price-container">
                                        <span class="price">
                                            <fmt:formatNumber value="${p.price}" type="currency" currencySymbol="₫"/>
                                        </span>
                                        <c:if test="${p.discount > 0}">
                                            <span class="discount">-${p.discount}%</span>
                                        </c:if>
                                    </div>
                                    <div class="rating"><i class="fa-solid fa-star"></i> 4.9 (256)</div>
                                    <div class="button">
                                        <a href="add-cart?id=${p.id}&quantity=1">
                                            <button class="button-addcart btn">Thêm vào giỏ</button>
                                        </a>
                                        <button class="button-buy btn">
                                            <a href="checkout?id=${p.id}">Mua ngay</a>
                                        </button>
                                    </div>
                                </div>
                            </div>

                        </c:if> </c:forEach></div>
            </div>
        </c:forEach></div>
</div>

<script>
    function goToProduct(id) {

        window.location.href = "${pageContext.request.contextPath}/productdetails?id=" + id;
    }
</script>

</body>
</html>