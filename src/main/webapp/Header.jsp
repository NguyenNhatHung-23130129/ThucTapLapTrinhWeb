<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<head>
    <meta charset="UTF-8">

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/normalize/8.0.1/normalize.min.css"
          integrity="sha512-NhSC1YmyruXifcj/KFRWoC561YpHpc5Jtzgvbuzx5VozKpWvQ+4nXhPdFgmx8xqexRcpAglTj9sIBWINXa8x5w=="
          crossorigin="anonymous" referrerpolicy="no-referrer"/>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.1/css/all.min.css"
          integrity="sha512-2SwdPD6INVrV/lHTZbO2nodKhrnDdJK9/kg2XD1r9uGqPo1cUbujc+IYdlYdEErWNu69gVcYgdxlmVmzTWnetw=="
          crossorigin="anonymous" referrerpolicy="no-referrer"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/Nav.css">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@500;600;800&display=swap" rel="stylesheet">

</head>

<header class="header">
    <div class="header__container">
        <div class="header__logo">
            <div class="header__logo-icon">
                <img class="header__logo-icon" src="assets/images/logoChiecla.png" alt="logo">
            </div>
            <span class="header__logo-text">Chay Tươi</span>
        </div>


        <nav class="header__nav">
            <a href="${pageContext.request.contextPath}/home" class="header__nav-link">Trang Chủ</a>
            <a href="${pageContext.request.contextPath}/products" class="header__nav-link">Sản Phẩm</a>
            <a href="ArticleDetails.jsp" class="header__nav-link">Tin tức</a>
        </nav>


        <div class="header__actions">
                <form id="searchForm" action="home" method="get" class="header__search">
                    <input id="searchInput" type="text" class="header__search-input" name="search"
                           placeholder="Tìm kiếm sản phẩm..." value="${searchKeyword}">

                    <button type="submit" class="header__icon-btn" aria-label="Tìm kiếm">
                        <i class="fa-duotone fa-solid fa-magnifying-glass"></i>
                    </button>
                </form>
            <a href="cart">
                <button class="header__icon-btn header__cart" aria-label="Giỏ hàng">
                    <i class="fa-solid fa-cart-shopping"></i>
                    <span class="header__cart-badge" id="cartCount">${sessionScope.cart != null ? sessionScope.cart.totalQuantity : 0}</span>
                </button>
            </a>

            <c:choose>
<%--                dang nhap roi thi hien menu nguoi dung--%>
                <c:when test="${not empty sessionScope.auth}">
                    <div class="header__user-menu">
                        <div class="header__user-info">
                            <img src="${sessionScope.auth.imageUrl}"
                                 alt="Avatar"
                                 class="header__user-avatar"
                                 style="object-fit: cover;"
                                 onerror="this.onerror=null; this.src='assets/images/userProfile.webp';">

                            <span class="header__user-name">${sessionScope.auth.name}</span>
                        </div>

                        <ul class="header__user-dropdown">
                            <li><a href="${pageContext.request.contextPath}/userinfor">Hồ Sơ</a></li>
                            <li><a href="${pageContext.request.contextPath}/orderhistory">Đơn Hàng</a></li>

<%--                              neu la admin hoac nhan vien thi hien link quan tri--%>
                            <c:if test="${sessionScope.auth.roleId == 1 || sessionScope.auth.roleId == 2}">
                                <li><a href="admin/dashboard">Quản Trị</a></li>
                            </c:if>

                            <li><a href="${pageContext.request.contextPath}/voucher">Voucher</a></li>
                            <li><a href="${pageContext.request.contextPath}/logout">Đăng Xuất</a></li>
                        </ul>
                    </div>
                </c:when>

<%--               neu chua dang nhap thi hien nut dang nhap va dang ky--%>
                <c:otherwise>
                    <a href="${pageContext.request.contextPath}/login" class="header__btn header__btn--outline">
                        Đăng Nhập
                    </a>

                    <a href="${pageContext.request.contextPath}/signup" class="header__btn header__btn--primary">
                        Đăng Ký
                    </a>
                </c:otherwise>
            </c:choose>


        </div>
    </div>
</header>

<script>
    document.addEventListener("DOMContentLoaded", function() {
        const searchForm = document.getElementById('searchForm');
        const searchInput = document.getElementById('searchInput');

        if (searchForm && searchInput) {
            searchForm.addEventListener('submit', function(e) {
                e.preventDefault();

                const keyword = searchInput.value.trim();
                if (!keyword) return;

                const encodedKeyword = encodeURIComponent(keyword);

                const contextPath = "${pageContext.request.contextPath}";

                window.location.href = contextPath + "/home?search=" + encodedKeyword;
            });
        }
    });
</script>
<script src="${pageContext.request.contextPath}/assets/js/Header.js"></script>

