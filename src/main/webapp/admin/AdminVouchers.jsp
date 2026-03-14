<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<div id="vouchers" class="main-content">
    <div class="toolbar">
        <div class="search-container">
            <input type="text" id="search__voucher" name="search"
                   placeholder="Tìm kiếm theo mã voucher"
                   value="${searchKeyword}">

            <button id="btn-search-voucher"><i class="fa-solid fa-magnifying-glass"></i></button>
        </div>
        <c:if test="${per >= 2}">
            <button id="btn-addvoucher">+ Thêm mã giảm giá</button>
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
                <th>Mã Voucher</th>
                <th>Tiêu đề</th>
                <th>Mô tả</th>
                <th>Giá trị</th>
                <th>Loại</th>
                <th>Phạm vi áp dụng</th>
                <th>Giá trị đơn hàng tối thiểu</th>
                <th>Giá trị đơn hàng tối đa</th>
                <th>Bắt đầu</th>
                <th>Kết thúc</th>
                <th>Giới hạn</th>
                <th>Trạng thái</th>
                <th>Thao tác</th>
            </tr>
            </thead>
            <tbody id="productTableBody">
            <c:forEach items="${voucherList}" var="v">
                <tr class="product-row">
                    <td>${v.voucherCode}</td>
                    <td>${v.title}</td>
                    <td>${v.description}</td>
                    <td>
                    <c:choose>
                        <c:when test="${v.type == 'Phần trăm(%)'}">
                            <fmt:formatNumber value="${v.value}" type="number" maxFractionDigits="1"/>%
                        </c:when>

                        <c:otherwise>
                            <fmt:setLocale value="vi_VN"/>
                            <fmt:formatNumber value="${v.value}" type="currency" currencySymbol="₫"/>
                        </c:otherwise>
                    </c:choose>
                    </td>
                    <td>${v.type}</td>
                    <td>${v.applyScope == 'all' ? 'Toàn bộ' : 'Tùy chọn'}</td>
                    <fmt:setLocale value="vi_VN"/>
                    <td><fmt:formatNumber value="${v.minOrderValue}" type="currency" currencySymbol="₫"/></td>
                    <td><fmt:formatNumber value="${v.maxDiscountAmount}" type="currency" currencySymbol="₫"/> </td>
                    <td><fmt:formatDate value="${v.startDate}" pattern="dd/MM/yyyy"/></td>
                    <td><fmt:formatDate value="${v.endDate}" pattern="dd/MM/yyyy"/></td>
                    <td>${v.usageLimit}</td>
                    <td>
                         <span class="status ${v.isActive == 1 ? 'active' : 'inactive'}">
                                 ${v.isActive == 1 ? 'Hoạt động' : 'Vô hiệu hóa'}
                         </span>
                    </td>
                    <td>
                        <c:if test="${per >= 2}">
                            <a href="${pageContext.request.contextPath}/voucher?action=edit&id=${v.id}" class="edit-voucher-btn" title="Sửa"
                               data-id="${v.id}"
                               data-code="${v.voucherCode}"
                               data-title="${v.title}"
                               data-desc="${v.description}"
                               data-type="${v.type}"
                               data-scope="${v.applyScope}"
                               data-value="${v.value}"
                               data-min_order="${v.minOrderValue}"
                               data-max_discount="${v.maxDiscountAmount}"
                               data-start="${v.startDate}"
                               data-end="${v.endDate}"
                               data-limit="${v.usageLimit}"
                               data-user_limit="${v.limitPerUser}"
                               data-active="${v.isActive}">
                                <i class="fa-solid fa-pen-to-square"></i>
                            </a>
                        </c:if>
                        <c:if test="${per >= 3}">
                            <form action="${pageContext.request.contextPath}/admin/voucher" method="post" style="display:inline;"
                                  class="delete-voucher-form">
                                <input type="hidden" name="action" value="delete">
                                <input type="hidden" name="id" value="${v.id}">
                                <button type="button" class="delete-voucher-btn">
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


    <div id="popupOverlayVoucher" class="popup-overlay hidden">
        <div class="form-container popup-form">
            <span id="closePopupVoucher" class="close-popup">&times;</span>
            <h2 class="form-title">Thêm mã giảm giá</h2>

            <form action="${pageContext.request.contextPath}/admin/voucher" method="post" class="voucher-form">
                <input type="hidden" name="action" id="voucher_action" value="add">
                <input type="hidden" name="id" id="voucher_id">

                <div class="form-group">
                    <label for="voucher_code" class="label-voucher-code">Mã Voucher</label>
                    <input type="text" id="voucher_code" name="voucherCode" required>
                </div>
                <div class="form-group">
                    <label for="title-voucher">Tiêu đề</label>
                    <input type="text" id="title-voucher" name="title" required>
                </div>
                <div class="form-group">
                    <label for="description-voucher">Mô tả</label>
                    <textarea id="description-voucher" name="description"></textarea>
                </div>

                <div class="form-group">
                    <label for="value">Giá trị</label>
                    <input type="number" id="value" name="value"  required>
                </div>
                <div class="form-group">
                    <label for="type">Loại</label>
                    <select id="type" name="type" required>
                        <option value="Phần trăm(%)">Phần trăm(%)</option>
                        <option value="Tiền mặt">Tiền mặt</option>
                    </select>
                </div>

                <div class="form-group">
                    <label for="usage_limit">Số lượng</label>
                    <input type="number" id="usage_limit" name="usageLimit" required>
                </div>
                <div class="form-group">
                    <label for="limit_per_user">Giới hạn mỗi người dùng</label>
                    <input type="number" id="limit_per_user" name="limitPerUser" required>
                </div>

                <div class="form-group">
                    <label style="font-weight: bold;">Phạm vi áp dụng:</label>
                    <div style="margin-top: 5px;">
                        <label for="scopeAll" style="display: inline-block; margin-right: 15px;">
                            <input type="radio" id="scopeAll" name="applyScope" value="all" checked
                                   onchange="toggleScope('all')">
                            Áp dụng cho tất cả sản phẩm
                        </label>
                        <label for="scopeCate" style="display: inline-block;">
                            <input type="radio" id="scopeCate" name="applyScope" value="specific"
                                   onchange="toggleScope('specific')">
                            Chọn theo danh mục/sản phẩm
                        </label>
                    </div>
                </div>

                <div id="specific-selection-container" class="hidden"
                     style="border: 1px solid #ddd; padding: 10px; margin-top: 10px; max-height: 300px; overflow-y: auto;">

                    <div class="category-group">
                        <h4>Chọn theo Danh mục</h4>
                        <div class="scrollable-list" style="display: flex; flex-wrap: wrap; gap: 10px;">
                            <c:forEach items="${categoryList}" var="category">
                                <div style="background: #f1f1f1; padding: 5px; border-radius: 4px;">
                                    <input type="checkbox"
                                           class="cat-checkbox"
                                           id="cat_${category.id}"
                                           value="${category.id}"
                                           onchange="handleCategoryChange(this)">
                                    <label for="cat_${category.id}">${category.name}</label>
                                </div>
                            </c:forEach>
                        </div>
                    </div>

                    <hr style="margin: 10px 0;">

                    <div class="product-group">
                        <h4>Danh sách sản phẩm chi tiết</h4>
                        <div class="scrollable-list">
                            <c:forEach items="${productList}" var="product">
                                <div class="product-item">

                                    <input type="checkbox"
                                           name="selected_products"
                                           class="prod-checkbox"
                                           id="prod_${product.id}"
                                           value="${product.id}"
                                           data-category-id="${product.categoryId}">
                                    <label for="prod_${product.id}">
                                        [${product.id}] ${product.name}
                                    </label>
                                </div>
                            </c:forEach>
                        </div>
                    </div>
                </div>
                <div class="form-group">
                    <label for="min_order_value">Giá trị đơn hàng tối thiểu</label>
                    <input type="number" id="min_order_value" name="minOrderValue"  required>
                </div>
                <div class="form-group">
                    <label for="max_order_value">Giá trị đơn hàng tối đa</label>
                    <input type="number" id="max_order_value" name="maxDiscountAmount"  required>
                </div>

                <div class="form-group">
                    <label for="start_date">Bắt đầu</label>
                    <input type="date" id="start_date" name="startDate" required>
                </div>
                <div class="form-group">
                    <label for="end_date">Kết thúc</label>
                    <input type="date" id="end_date" name="endDate" required>
                </div>
                <div class="form-group">
                    <label for="active">Trạng thái</label>
                    <select id="active" name="isActive" required>
                        <option value="1">Hoạt động</option>
                        <option value="0">Vô hiệu hóa</option>
                    </select>
                </div>
                <button type="submit" class="btn-submit">Thêm mã giảm giá</button>
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