<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<head>
    <meta charset="UTF-8">
    <title>Trang Quản Trị</title>
<%--    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/normalize/8.0.1/normalize.min.css"--%>
<%--          integrity="sha512-NhSC1YmyruXifcj/KFRWoC561YpHpc5Jtzgvbuzx5VozKpWvQ+4nXhPdFgmx8xqexRcpAglTj9sIBWINXa8x5w=="--%>
<%--          crossorigin="anonymous" referrerpolicy="no-referrer"/>--%>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"
          integrity="sha512-iecdLmaskl7CVkqkXNQ/ZH/XLlvWZOJyj7Yy7tcenmpD1ypASozpmT/E0iPtmFIB46ZmdtAc9eNBvH0H/ZpiBw=="
          crossorigin="anonymous" referrerpolicy="no-referrer"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/Admin.css">
</head>
<body>
<div class="layout">

    <aside class="sidebar">
        <div class="sidebar__header">
            <h1 class="sidebar__title">Hệ thống quản lý</h1>
        </div>

        <nav class="sidebar__nav">
            <a href="<%=request.getContextPath()%>/admin/dashboard"
               class="sidebar__nav-item ${activeTab == 'dashboard' ? 'active' : ''}">
                <span>Tổng quan</span>
            </a>
            <a href="<%=request.getContextPath()%>/admin/user"
               class="sidebar__nav-item ${activeTab == 'users' ? 'active' : ''}">
                <span>Quản lý người dùng</span>
            </a>
            <a href="<%=request.getContextPath()%>/admin/product"
               class="sidebar__nav-item ${activeTab == 'products' ? 'active' : ''} ">
                <span>Quản lý sản phẩm</span>
            </a>
            <a href="<%=request.getContextPath()%>/admin/order"
               class="sidebar__nav-item ${activeTab == 'orders' ? 'active' : ''} ">
                <span>Quản lý đơn hàng</span>
            </a>
            <a href="<%=request.getContextPath()%>/admin/slideshow"
               class="sidebar__nav-item ${activeTab == 'slideshows' ? 'active' : ''}">
                <span>Quản lý slideshow</span>
            </a>
            <a href="<%=request.getContextPath()%>/admin/voucher"
               class="sidebar__nav-item ${activeTab == 'vouchers' ? 'active' : ''}">
                <span>Quản lý mã giảm giá</span>
            </a>
            <a href="<%=request.getContextPath()%>/admin/category"
               class="sidebar__nav-item ${activeTab == 'category' ? 'active' : ''}">
                <span>Quản lý danh mục</span>
            </a>
            <a href="<%=request.getContextPath()%>/admin/supplier"
               class="sidebar__nav-item ${activeTab == 'suppliers' ? 'active' : ''}">
                <span>Quản lý nhà cung cấp</span>
            </a>
            <a href="<%=request.getContextPath()%>/admin/inventory"
               class="sidebar__nav-item ${activeTab == 'inventory' ? 'active' : ''}">
                <span>Quản lý phiếu nhập hàng</span>
            </a>
            <a href="<%=request.getContextPath()%>/admin/shipping"
               class="sidebar__nav-item ${activeTab == 'shipping' ? 'active' : ''}">
                <span>Quản lý vận chuyển</span>
            </a>
            <a href="<%=request.getContextPath()%>/admin/notification"
               class="sidebar__nav-item ${activeTab == 'notification' ? 'active' : ''}">
                <span>Quản lý thông báo</span>
            </a>
            <a href="<%=request.getContextPath()%>/admin/invoices"
               class="sidebar__nav-item ${activeTab == 'invoices' ? 'active' : ''}">
                <span>Quản lý hóa đơn</span>
            </a>

        </nav>
    </aside>

    <div class="container">

        <header class="header">
            <div class="header__greeting">
                <span class="header__greeting-text">Chào mừng trở lại,</span>
                <span class="header__greeting-name">Admin User</span>
            </div>
            <div class="header__user-info">
                <c:if test="${not empty sessionScope.auth}">
                    <img src="${sessionScope.auth.imageUrl}" alt="Avatar" class="header__user-avatar">
                    <div class="header__user-details">
                        <span class="header__user-name">${sessionScope.auth.name}</span>
                        <span class="header__user-role">
                ${sessionScope.auth.roleId == 1 ? 'Quản trị viên' : 'Nhân viên'}
            </span>
                    </div>
                </c:if>

                <ul class="header__user-dropdown">
                    <li><a href="${pageContext.request.contextPath}/userinfor">Hồ Sơ</a></li>
                    <li><a href="${pageContext.request.contextPath}/home">Trang chủ</a></li>
                    <li><a href="${pageContext.request.contextPath}/logout">Đăng Xuất</a></li>
                </ul>
            </div>
        </header>

        <main class="content-wrapper">
            <c:choose>
                <c:when test="${activeTab == 'dashboard'}">
                    <jsp:include page="AdminDashboard.jsp" />
                </c:when>
                <c:when test="${activeTab == 'users'}">
                    <jsp:include page="AdminUsers.jsp" />
                </c:when>
                <c:when test="${activeTab == 'products'}">
                    <jsp:include page="AdminProducts.jsp" />
                </c:when>
                <c:when test="${activeTab == 'orders'}">
                    <jsp:include page="AdminOrders.jsp" />
                </c:when>
                <c:when test="${activeTab == 'slideshows'}">
                    <jsp:include page="AdminSlideshows.jsp" />
                </c:when>
                <c:when test="${activeTab == 'vouchers'}">
                    <jsp:include page="AdminVouchers.jsp" />
                </c:when>
                <c:when test="${activeTab == 'category'}">
                    <jsp:include page="AdminCategories.jsp" />
                </c:when>
                <c:when test="${activeTab == 'suppliers'}">
                    <jsp:include page="AdminSuppliers.jsp" />
                </c:when>
                <c:when test="${activeTab == 'shipping'}">
                    <jsp:include page="AdminShipping.jsp" />
                </c:when>
                <c:when test="${activeTab == 'notification'}">
                    <jsp:include page="AdminNotification.jsp" />
                </c:when>
                <c:when test="${activeTab == 'invoices'}">
                    <jsp:include page="AdminInvoices.jsp" />
                </c:when>
                <c:otherwise >
                    <jsp:include page="AdminWarehouses.jsp" />
                </c:otherwise>

            </c:choose>
        </main>



        <div id="confirmDeletePopup" class="popup-overlay hidden">
            <div class="popup-form confirm-delete form-container">
                <h3>Bạn có chắc muốn xóa?</h3>
                <p>Hành động này không thể hoàn tác.</p>
                <div class="confirm-buttons">
                    <button id="confirmDeleteYes" class="btn-submit delete">Xóa</button>
                    <button id="confirmDeleteNo" class="btn-submit cancel">Hủy</button>
                </div>
            </div>
        </div>

    </div>
</div>

<script src="${pageContext.request.contextPath}/assets/js/Admin.js"></script>
</body>
</html>