<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<div id="orders" class="main-content">
    <div class="toolbar">
        <div class="search__user-container">
            <div class="search-container">
            <input type="text" id="search__order" name="search"
                   placeholder="Tìm kiếm theo mã đơn hàng"
                   value="${searchKeyword}">

            <button id="btn-search-order"><i class="fa-solid fa-magnifying-glass"></i></button>
        </div>
        </div>
    </div>
    <div class="pagination-container">
        <div class="rows-per-page">
            <label for="rowsPerPage">Hiển thị:</label>
            <select id="rowsPerPage" >
                <option value="10"selected>10 dòng</option>
                <option value="20" >20 dòng</option>
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
                <th>Mã đơn hàng</th>
                <th>Khách hàng</th>
                <th>Sản phẩm</th>
                <th>Địa chỉ giao hàng</th>
                <th>Ghi chú</th>
                <th>Trạng thái</th>
                <th>Ngày tạo</th>
                <th>Tổng tiền</th>
                <th>Thao tác</th>
            </tr>
            </thead>
            <tbody id="productTableBody">
            <c:forEach items="${orderList}" var="order">
                <tr class="product-row">
                    <td>${order.id}</td>
                    <td>${order.userName}</td>
                    <td>${order.productName}</td>
                    <td>${order.address}</td>
                    <td>${order.note}</td>
                    <td>
                        <c:choose>
                            <c:when test="${order.status eq 'Đang xử lý'}">
                                <span class="status pending">Đang xử lý</span>
                            </c:when>
                            <c:when test="${order.status eq 'Đang giao hàng'}">
                                <span class="status shipping">Đang giao hàng</span>
                            </c:when>
                            <c:when test="${order.status == 'Đã giao'}">
                                <span class="status active">Đã giao</span>
                            </c:when>
                            <c:otherwise>
                                <span class="status inactive">Đã hủy</span>
                            </c:otherwise>
                        </c:choose>
                    </td>
                    <td><fmt:formatDate value="${order.orderDate}" pattern="dd/MM/yyyy"/></td>
                    <fmt:setLocale value="vi_VN"/>
                    <td><fmt:formatNumber value="${order.totalAmount}" type="currency" currencySymbol="₫"/></td>

                    <td>
                        <c:if test="${per >= 2}">
                        <a href="${pageContext.request.contextPath}/admin/order?action=edit&id=${order.id}" class="edit-btn edit-order-btn" title="Cập nhật trạng thái"
                           data-id="${order.id}"

                           data-status="${order.status}">
                            <i class="fa-solid fa-pen-to-square"></i>
                        </a>
                        </c:if>

                    </td>

                </tr>
            </c:forEach>
            </tbody>
        </table>
    </div>
    <div id="popupOrder" class="popup-overlay hidden">
        <div class="form-container popup-form order-form">
            <span class="close-popup" id="closePopupOrder">&times;</span>
            <h2 class="form-title">Cập nhật trạng thái đơn hàng</h2>
            <form id="orderUpdateForm" action="${pageContext.request.contextPath}/admin/order" method="post">
                <input type="hidden" id="order-action" name="action" value="updateOrder">
                <input type="hidden" id="order_id" name="id" value="">
                <div class="form-group">
                    <label for="order_status">Trạng thái:</label>
                    <select id="order_status" name="status">
                        <option value="Đang xử lý">Đang xử lý</option>
                        <option value="Đang giao hàng">Đang giao hàng</option>
                        <option value="Đã giao">Đã giao</option>
                        <option value="Đã hủy">Đã hủy</option>
                    </select>
                </div>
                <button type="submit" class="btn-submit order">Cập nhật trạng thái</button>
            </form>
        </div>
    </div>

</div>