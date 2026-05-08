<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<fmt:setLocale value="vi_VN"/>


<div id="invoices" class="main-content">
    <div class="toolbar">
        <div class="search-container">
            <form action="${pageContext.request.contextPath}/admin/invoices" method="get" style="display: flex;">
                <input type="text" id="search__invoice" name="search"
                       placeholder="Tìm mã hóa đơn hoặc tên khách..."
                       value="${searchKeyword}">
                <button type="submit" id="btn-search-invoice"><i class="fa-solid fa-magnifying-glass"></i></button>
            </form>
        </div>
        <c:if test="${fn:contains(sessionScope.userRoles, 'admin') || fn:contains(sessionScope.userPermissions, 'invoice_management.read')}">
            <button id="btn-export-invoice" class="add"><i class="fa-solid fa-file-export"></i> Xuất báo cáo</button>
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
                <th>Số Hóa Đơn</th>
                <th>Khách Hàng</th>
                <th>Ngày Lập</th>
                <th>Tổng Tiền</th>
                <th>Thanh Toán</th>
                <th>Thao Tác</th>
            </tr>
            </thead>
            <tbody id="productTableBody">
            <c:forEach var="inv" items="${invoicesList}">
                <tr class="product-row">
                    <td>#${inv.invoiceNumber}</td>
                    <td>${inv.customerName}</td>
                    <td><fmt:formatDate value="${inv.issuedDate}" pattern="dd/MM/yyyy"/></td>
                    <td><fmt:formatNumber value="${inv.totalAmount}" type="currency" currencySymbol="₫"/></td>
                    <td>
             <span class="status ${inv.paymentStatus eq 'Đã thanh toán' ? 'active' : 'inactive'}">
                     ${inv.paymentStatus}
             </span>
                    </td>

                    <td>
                        <c:if test="${fn:contains(sessionScope.userRoles, 'admin') || fn:contains(sessionScope.userPermissions, 'invoices_management.read')}">

                            <a href="${pageContext.request.contextPath}/admin/invoices?action=edit&id=${inv.id}"
                               class="view-invoice-btn"
                               title="Xem chi tiết"
                               data-id="${inv.id}"
                               data-number="${inv.invoiceNumber}"
                               data-customer="${inv.customerName}"
                               data-date="<fmt:formatDate value='${inv.issuedDate}' pattern='dd/MM/yyyy'/>"
                               data-total="<fmt:formatNumber value='${inv.totalAmount}' type='currency' currencySymbol='₫'/>"
                               data-tax="${inv.taxAmount}"
                               data-subtotal="${inv.subTotal}"
                               data-status="${inv.paymentStatus}">
                                <i class="fa-solid fa-eye"></i>
                            </a>
                        </c:if>
                    </td>

                </tr>
            </c:forEach>
            </tbody>
        </table>
    </div>

    <div id="invoicePopupOverlay" class="popup-overlay hidden">
        <div class="form-container popup-form" style="width: 700px; max-width: 90%;">
            <span id="closePopupInvoice" class="close-popup">&times;</span>

            <h2 class="form-title">Chi Tiết Hóa Đơn</h2>

            <div id="invoiceDetailContent">
                <div class="info-grid">
                    <p><strong>Mã hóa đơn:</strong> <span id="pop-inv-number"></span></p>
                    <p><strong>Khách hàng:</strong> <span id="pop-inv-customer"></span></p>
                    <p><strong>Ngày lập:</strong> <span id="pop-inv-date"></span></p>
                    <p><strong>Trạng thái:</strong> <span id="pop-inv-status" style="display: inline-block"></span></p>
                </div>
                <hr>
                <div style="text-align: right; padding: 10px;">
                    <h3 style="color: #2e7d32;font-size: 1.4rem">Tổng tiền:<span id="pop-inv-total"></span></h3>
                </div>
            </div>

            <div class="button-group" style="margin-top: 20px;">
                <button type="button" id="btnPrintInvoice" class="btn-submit user" style="background-color: #0288d1;">
                    <i class="fa-solid fa-print"></i> In Hóa Đơn
                </button>
                <button type="button" class="btn-submit btn-secondary close-btn-modal">Đóng</button>
            </div>
        </div>
    </div>
</div>

