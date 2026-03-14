<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%--
  Created by IntelliJ IDEA.
  User: DELL
  Date: 04/12/2025
  Time: 20:01
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<html>
<head>
    <title>category</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/Nav.css">
</head>
<body>

<section class="category-section">
    <div class="category-container">
        <div class="section-header">
            <h2 class="section-title">Danh Mục</h2>
        </div>

        <div class="category-grid">
            <c:forEach items="${categories}" var="c">
                <div class="card-item-${c.id}">
                    <a href="products?cid=${c.id}#cat-${c.id}" class="category-card">
                        <img src="${c.imageUrl}" alt="${c.name}" class="card-image"
                             onerror="this.src='assets/images/default.jpg'">
                        <p class="card-title">${c.name}</p>
                    </a>

                </div>
            </c:forEach>


        </div>
    </div>
</section>
</body>
</html>
