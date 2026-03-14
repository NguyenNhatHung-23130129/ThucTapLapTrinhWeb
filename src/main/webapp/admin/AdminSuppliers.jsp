
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<div id="supplier" class="main-content">
    <div class="toolbar">
        <div class="search-container">
            <input type="text" id="search__supplier" name="search"
                   placeholder="Tìm kiếm theo tên nhà cung cấp"
                   value="${searchKeyword}">

            <button id="btn-search-supplier"><i class="fa-solid fa-magnifying-glass"></i></button>
        </div>
        <c:if test="${per >= 2}">
            <button class="add__supplier" id="btnAddSupplier">+ Thêm nhà cung cấp</button>
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
                <th>Tên nhà cung cấp</th>
                <th>Email</th>
                <th>Số điện thoại</th>
                <th>Địa chỉ</th>
                <th>Thao tác</th>
            </tr>
            </thead>
            <tbody id="productTableBody">

            <c:forEach var="supplier" items="${supplierList}">
                <tr class="product-row">
                    <td>${supplier.name}</td>
                    <td>${supplier.email}</td>
                    <td>${supplier.phone}</td>
                    <td>${supplier.address}</td>
                    <td>
                        <c:if test="${per >= 2}">
                            <a href="${pageContext.request.contextPath}/admin/supplier?action=edit&id=${supplier.id}" class="edit-supplier-btn"
                               data-id="${supplier.id}"
                               data-name="${supplier.name}"
                               data-email="${supplier.email}"
                               data-phone="${supplier.phone}"
                               data-address="${supplier.address}"
                               title="Sửa">
                                <i class="fa-solid fa-pen-to-square"></i>
                            </a>
                        </c:if>

                    </td>
                </tr>
            </c:forEach>

            </tbody>
        </table>
    </div>

    <div id="popupSupplier" class="popup-overlay hidden">
        <div class="form-container popup-form">
            <span id="closePopupSupplier" class="close-popup">&times</span>
            <h2 class="form-title">Thêm Nhà cung cấp</h2>

            <form id="addSupplierForm" action="${pageContext.request.contextPath}/admin/supplier" method="post">
                <input type="hidden" name="action" id="supplier-action" value="add">

                <input type="hidden" name="id" id="supplier-id">
                <div class="form-group">
                    <label for="supplier-name">Tên nhà cung cấp</label>
                    <input type="text" id="supplier-name" name="name" required>
                </div>

                <div class="form-group">
                    <label for="supplier-email">Email</label>
                    <input type="email" id="supplier-email" name="email" required>

                </div>


                <div class="form-group">
                    <label for="supplier-phone">SĐT</label>
                    <input type="text" id="supplier-phone" name="phone" required>
                </div>

               <div class="form-group">
                   <label for="supplier-address">Địa chỉ</label>
                   <input type="text" id="supplier-address" name="address" required>
                </div>

                <button type="submit" class="btn-submit supplier">+Thêm Nhà cung cấp</button>
            </form>
        </div>
    </div>

</div>