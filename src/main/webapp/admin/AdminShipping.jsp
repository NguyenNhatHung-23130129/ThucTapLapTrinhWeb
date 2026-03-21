<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<div id="shipping" class="main-content">
    <div class="toolbar">
        <div class="search-container">
            <input type="text" id="search__shipping" name="search"
                   placeholder="Tìm kiếm theo tên phương thức vận chuyển"
                   value="${searchKeyword}">

            <button id="btn-search-shipping"><i class="fa-solid fa-magnifying-glass"></i></button>
        </div>
        <c:if test="${per >= 2}">
            <button type="button" id="add-shipping-btn">+ Thêm phương thức vận chuyển</button>
        </c:if>

    </div>
    <div class="pagination-container">
        <div class="rows-per-page">
            <label for="rowsPerPage">Hiển thị:</label>
            <select id="rowsPerPage">
                <option value="10" selected>10 dòng</option>
                <option value="20">20 dòng</option>
                <option value="50">50 dòng</option>
                <option value="-1">Tất cả</option>
            </select>
        </div>
        <div class="pagination-controls" id="paginationControls">
        </div>
    </div>
    <div class="table-wrapper">
        <table class="table-container">
            <thead>
            <tr>
                <th>Mã Đơn</th>
                <th>Khách hàng</th>
                <th>Đơn vị vận chuyển</th>
                <th>Phương thức vận chuyển</th>
                <th>Mã vận đơn</th>
                <th>Trạng thái</th>
                <th>Ngày dự kiến</th>
                <th>Phí ship</th>
                <th>Thao tác</th>

            </tr>
            </thead>
            <tbody id="productTableBody">
            <c:forEach items="${shipping}" var="s">
                <tr class="product-row">
                    <td>${s.orderId}</td>
                    <td>${s.customerName}</td>
                    <td>${s.carrierName}</td>
                    <td>${s.shippingMethod}</td>
                    <td>${s.trackingNumber}</td>
                    <td>${s.shippingStatus}</td>
                    <td><fmt:formatDate value="${s.estimatedDeliveryDate}" pattern="dd/MM/yyyy"/></td>
                    <fmt:setLocale value="vi_VN"/>
                    <td><fmt:formatNumber value="${s.shippingFee}" type="currency" currencySymbol="₫"/></td>
                    <td>
                        <c:if test="${per >= 2}">
                            <a href="${pageContext.request.contextPath}/admin/shipping?action=view&id=${s.id}"
                               class="view-shipping-btn"
                               data-id="${s.orderId}"
                               data-name="${s.customerName}"
                               data-carrier="${s.carrierName}"
                               data-method="${s.shippingMethod}"
                               data-tracking="${s.trackingNumber}"
                               data-status="${s.shippingStatus}"
                               data-price="${s.shippingFee}"
                               data-date="${s.estimatedDeliveryDate}"
                               title="Sửa">
                                <i class="fa-solid fa-eye"></i>
                            </a>
                        </c:if>
                    </td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
    </div>
</div>
