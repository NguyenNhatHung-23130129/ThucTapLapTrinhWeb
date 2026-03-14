<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<div id="products" class="main-content">
    <div class="toolbar">
        <div class="search-container">
            <input type="text" id="search__product" name="search"
                   placeholder="Tìm kiếm theo tên sản phẩm"
                   value="${searchKeyword}">

            <button id="btn-search-product"><i class="fa-solid fa-magnifying-glass"></i></button>
        </div>
        <c:if test="${per >= 2}">
        <button id="btn-addproduct" class="add">+ Thêm sản phẩm</button>
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
                <th>Danh mục</th>
                <th>Giá</th>
                <th>Tồn kho</th>
                <th>Trạng thái</th>
                <th>Thao tác</th>
            </tr>
            </thead>
            <tbody id="productTableBody">
            <c:forEach var="p" items="${productList}">
                <tr class="product-row">
                    <td>${p.name}</td>
                    <td>${p.categoryName}</td>
                    <fmt:setLocale value="vi_VN"/>
                    <td><fmt:formatNumber value="${p.price}" type="currency" currencySymbol="₫"/></td>

                    <td>
                        <c:choose>
                            <c:when test="${p.stockQuantity > 0}">
                            <span class="stock normal"
                                  style="color: green; font-weight: bold;">${p.stockQuantity}</span>
                            </c:when>
                            <c:otherwise>
                                <span class="stock out" style="color: red; font-weight: bold;">Hết hàng</span>
                            </c:otherwise>
                        </c:choose>
                    </td>

                    <td>

                        <span class="status ${p.active ? 'active' : 'inactive'}">
                                ${p.active ? 'Đang bán' : 'Ngừng KD'}
                        </span>
                    </td>


                    <td>
                        <c:if test="${per >= 2}">
                            <a href="${pageContext.request.contextPath}/admin/product?action=edit&id=${p.id}"

                               class="edit-btn prod-edit-btn" title="Sửa"
                               data-id="${p.id}"
                               data-name="${p.name}"
                               data-cate="${p.categoryId}"
                               data-price="${p.price}"
                               data-discount="${p.discount}"
                               data-unit="${p.unitOfMeasure}"
                               data-img="${p.imageUrl}"
                               data-desc="${p.description}"
                               data-nutrition="${p.nutritionalInformation}"
                               data-pdate="${p.productionDate}"
                               data-edate="${p.expiryDate}"
                               data-active="${p.active}">
                                <i class="fa-solid fa-pen-to-square"></i>
                            </a>
                        </c:if>
                        <c:if test="${per >= 3}">
                            <form action="${pageContext.request.contextPath}/admin/product" method="post" style="display:inline;"
                                  class="delete-product-form">
                                <input type="hidden" name="action" value="delete">
                                <input type="hidden" name="id" value="${p.id}">
                                <button type="button" class="delete-product-btn">
                                    <i class="fa-solid fa-trash"></i>
                                </button>
                            </form>
                        </c:if>
                    </td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
    </div>

    <div id="popupOverlay" class="popup-overlay hidden">
        <div class="form-container popup-form product-form">
            <span id="closePopupProduct" class="close-popup">&times;</span>

            <h2 class="form-title">Thêm Sản Phẩm Mới</h2>

            <form id="addProductForm" action="${pageContext.request.contextPath}/admin/product" method="post">
                <input type="hidden" id="prod-action" name="action" value="add">
                <input type="hidden" id="prod-id" name="id" value="">

                <div class="form-group">
                    <label>Tên sản phẩm</label>
                    <input type="text" id="prod-name" name="name" required>
                </div>

                <div class="form-group">
                    <label>Danh mục</label>
                    <select id="prod-category" name="category_id" required>
                        <c:forEach var="c" items="${categoryList}">
                            <option value="${c.id}">${c.name}</option>
                        </c:forEach>
                    </select>
                </div>

                <div class="form-row" style="display: flex; gap: 15px;">
                    <div class="form-group" style="flex: 1;">
                        <label>Giá (VNĐ)</label>
                        <input type="number" id="prod-price" name="price" required>
                    </div>
                    <div class="form-group" style="flex: 1;">
                        <label>Giảm giá (VNĐ)</label>
                        <input type="number" id="prod-discount" name="discount" value="0">
                    </div>
                </div>

                <div class="form-group">
                    <label>Đơn vị tính</label>
                    <select id="prod-unit" name="unit_of_measure">
                        <option value="kg">Kg</option>
                        <option value="hop">Hộp</option>
                        <option value="bich">Gói</option>
                        <option value="chai">Chai</option>
                        <option value="bo">Bó</option>
                    </select>
                </div>

                <div class="form-row" style="display: flex; gap: 15px;">
                    <div class="form-group" style="flex: 1;">
                        <label>Ngày sản xuất</label>
                        <input type="date" id="prod-pDate" name="production_date" required>
                    </div>
                    <div class="form-group" style="flex: 1;">
                        <label>Hạn sử dụng</label>
                        <input type="date" id="prod-eDate" name="expiry_date" required>
                    </div>
                </div>

                <div class="form-group">
                    <label>Link hình ảnh</label>
                    <input type="text" id="prod-img" name="image_url">
                </div>
                <div class="form-group">
                    <label>Thông tin dinh dưỡng</label>
                    <textarea id="prod-nutrition" name="nutritional_information" rows="2"
                              placeholder="Ví dụ: Calo: 200, Protein: 10g..."></textarea>
                </div>

                <div class="form-group">
                    <label>Mô tả</label>
                    <textarea id="prod-desc" name="description" rows="3"></textarea>
                </div>
                <div class="form-row">
                    <div class="form-group">
                        <label>Trạng thái kinh doanh</label>
                        <select id="prod-active" name="active">
                            <option value="1">Đang kinh doanh</option>
                            <option value="0">Ngừng kinh doanh</option>
                        </select>
                    </div>
                </div>

                <button type="submit" class="btn-submit user">Lưu Sản Phẩm</button>
            </form>
        </div>
    </div>

    <div id="confirmDeletePopup" class="popup-overlay hidden">
        <div class="form-container popup-form">
            <span id="closeDeletePopup" class="close-popup">&times;</span>
            <h2 class="form-title">Xác Nhận Xóa</h2>
            <p class="title-delete">Bạn có chắc chắn muốn xóa không?</p>
            <div class="button-group">
                <button id="confirmDeleteBtn" class="btn-submit btn-danger">Xóa</button>
                <button id="cancelDeleteBtn" class="btn-submit btn-secondary">Hủy</button>
            </div>
        </div>
    </div>
</div>