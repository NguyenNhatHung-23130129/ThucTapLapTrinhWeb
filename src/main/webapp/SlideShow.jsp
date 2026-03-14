<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:if test="${not empty slideShowList}">
    <section class="hero-section">
        <div class="main">
            <img src="${slideShowList[0].imageUrl}"
                 alt="${slideShowList[0].title}"
                 class="image-feature"
                 id="main-hero-image">

            <button class="control prev" id="btn-prev"><i class="fa-solid fa-less-than"></i></button>
            <button class="control next" id="btn-next"><i class="fa-solid fa-greater-than"></i></button>

            <div class="list-image">
                <c:forEach var="slide" items="${slideShowList}">
                    <img src="${slide.imageUrl}"
                         alt="${slide.title}"
                         class="hero-image"
                         data-title="${slide.title}"
                         data-desc="${slide.description}"
                         data-link="${pageContext.request.contextPath}/product-detail?id=${slide.productId}">
                </c:forEach>
            </div>
        </div>

        <div class="content-wrapper">
            <h1 class="hero-title" id="hero-title">${slideShowList[0].title}</h1>

            <p class="hero-description" id="hero-description">${slideShowList[0].description}</p>

            <a hidden="" href="${pageContext.request.contextPath}/product-detail?id=${slideShowList[0].productId} "
               class="cta-button"
               id="cta-button">Xem Thêm</a>
        </div>
    </section>
</c:if>

<c:if test="${empty slideShowList}">
    <section class="hero-section">
        <div class="main">
            <img src="${pageContext.request.contextPath}/assets/images/hero.png" alt="Default" class="image-feature">
        </div>
        <div class="content-wrapper">
            <h1 class="hero-title">Chào mừng đến với DOANWEB</h1>
            <p class="hero-description">Hiện chưa có slide nào được kích hoạt.</p>
            <button class="cta-button">Khám phá ngay</button>
        </div>
    </section>
</c:if>

<script src="${pageContext.request.contextPath}/assets/js/Header.js"></script>