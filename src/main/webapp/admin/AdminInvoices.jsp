<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<div id="invoices" class="main-content">
    <div class="toolbar">
        <div class="search-container">
            <input type="text" id="search__invoice" name="search"
                   placeholder="Tìm kiếm theo mã đơn hàng hoặc tên khách hàng"
                   value="${searchKeyword}">

            <button id="btn-search-invoice"><i class="fa-solid fa-magnifying-glass"></i></button>
        </div>
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
                <th>Số Hóa Đơn</th>
                <th>Mã Đơn Hàng</th>
                <th>Khách Hàng</th>
                <th>Ngày Lập</th>
                <th>Tổng Tiền</th>
                <th>Trạng Thái</th>
                <th>Thao Tác</th>

            </tr>
            </thead>
            <tbody id="productTableBody">
            <c:forEach items="${invoicesList}" var="i">
                <tr class="product-row">
                    <td>${i.invoiceNumber}</td>
                    <td>${i.orderId}</td>
                    <td>${i.customerName}</td>
                    <td><fmt:formatDate value="${i.issuedDate}" pattern="dd/MM/yyyy"/></td>
                    <fmt:setLocale value="vi_VN"/>
                    <td><fmt:formatNumber value="${i.totalAmount}" type="currency" currencySymbol="₫"/></td>
                    <td>${i.paymentStatus}</td>
                    <td>
                        <a href="${pageContext.request.contextPath}/admin/invoice/detail?id=${i.id}" class="view-invoice-btn"
                           data-id="${i.id}" title="Xem chi tiết">
                            <i class="fa-solid fa-eye"></i>
                        </a>

                    </td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
    </div>
</div>