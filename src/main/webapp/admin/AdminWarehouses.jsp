<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<div id="inventory" class="main-content">
    <div class="toolbar">
       <div class="search-container">
            <input type="text" id="search__inventory" name="search"
                   placeholder="Tìm kiếm theo tên sản phẩm, nhà cung cấp"
                   value="${searchKeyword}">

            <button id="btn-search-inventory"><i class="fa-solid fa-magnifying-glass"></i></button>
        </div>
        <c:if test="${per >= 2}">
        <button class="add__user" id="btn-open-add-inventory">+ Nhập Hàng Mới</button>
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
                <th>Tên sản phẩm</th>
                <th>Nhà cung cấp</th>
                <th>Giá nhập</th>
                <th>Số lượng</th>
                <th>Trạng thái</th>
                <th>Ngày nhập</th>
                <th>Thao tác</th>
            </tr>
            </thead>
            <tbody id="productTableBody">

            <c:forEach items="${warehouseList}" var="i">
                <tr class="product-row">
                    <td>${i.productName}</td>
                    <td>${i.supplierName}</td>
                    <fmt:setLocale value="vi_VN"/>
                    <td><fmt:formatNumber value="${i.importPrice}" type="currency" currencySymbol="₫"/></td>
                    <td>${i.quantityImported}</td>
                    <td>
                    <span class="status ${i.status ? 'active' : 'inactive'}">
                        ${i.status ? 'Đã nhận hàng' : 'Chưa nhận hàng'}
                    </span>
                    </td>
                    <td><fmt:formatDate value="${i.importDate}" pattern="dd/MM/yyyy"/></td>
                    <td>
                        <c:if test="${per >= 2}">
                        <a href="${pageContext.request.contextPath}/admin/inventory?action=edit&id=${i.id}" class="edit-inventory-btn" title="Sửa"
                           data-id="${i.id}"
                           data-status="${i.status ? 1 : 0}">
                            <i class="fa-solid fa-pen-to-square"></i>
                        </a>
                        </c:if>
                    </td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
    </div>

    <div id="popupInventory" class="popup-overlay hidden">
        <div class="form-container popup-form">
            <span class="close-popup" id="btn-close-inventory">&times;</span>
            <h2 class="form-title">Nhập Hàng Mới</h2>

            <form id="form-inventory-add" action="${pageContext.request.contextPath}/admin/inventory" method="post">
                <input type="hidden" id="inv-action" name="action" value="add">
                <input type="hidden" id="inv-id" name="id" value="">
                <div class="form-group">
                    <label for="product_id">Sản phẩm</label>
                    <select id="product_id" name="product_id" class="select-category" required>
                        <c:forEach items="${productList}" var="p">
                            <option value="${p.id}">${p.name}</option>
                        </c:forEach>
                    </select>
                </div>

                <div class="form-group">
                    <label for="supplier_id">Nhà Cung Cấp</label>
                    <select id="supplier_id" name="supplier_id" class="select-category" required>
                        <c:forEach items="${supplierList}" var="s">
                            <option value="${s.id}">${s.name}</option>
                        </c:forEach>
                    </select>
                </div>

                <div class="form-group">
                    <label for="input_price">Giá Nhập (VNĐ)</label>
                    <input type="number" id="input_price" name="input_price" required min="0">
                </div>

                <div class="form-group">
                    <label for="quantity_imported">Số lượng</label>
                    <input type="number" id="quantity_imported" name="quantity_imported" required min="1">
                </div>


                <div class="form-group">
                    <label for="preservation_methods">Bảo quản</label>
                    <textarea id="preservation_methods" name="preservation_methods" rows="2"
                              placeholder="Ví dụ: Bảo quản lạnh..."></textarea>
                </div>
               <input type="hidden" id="inv_status" name="status" value="0">


                <button type="submit" class="btn-submit inventory">Xác nhận nhập kho</button>
            </form>
        </div>
    </div>
    <div id="popupInventoryStatus" class="popup-overlay hidden">
        <div class="form-container popup-form">
            <span class="close-popup" id="closePopupInventoryStatus">&times;</span>
            <h2 class="form-title">Cập nhật trạng thái phiếu nhập" </h2>
            <form id="inventoryStatusUpdateForm" action="${pageContext.request.contextPath}/admin/inventory" method="post">
                <input type="hidden" id="inv_status-action" name="action" value="update">
                <input type="hidden" id="inv_status_id" name="id" value="">
                <div class="form-group">
                    <label for="inventory_status">Trạng thái:</label>
                    <select id="inventory_status" name="status">
                        <option value="0">Chưa nhận hàng</option>
                        <option value="1">Đã nhận hàng</option>

                    </select>
                </div>
                <button type="submit" class="btn-submit inventory">Lưu thay đổi</button>
            </form>
        </div>
    </div>
</div>