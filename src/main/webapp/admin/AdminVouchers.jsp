<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" integrity="sha512-iecdLmaskl7CVkqkXNQ/ZH/XLlvWZOJyj7Yy7tcenmpD1ypASozpmT/E0iPtmFIB46ZmdtAc9eNBvH0H/ZpiBw==" crossorigin="anonymous" referrerpolicy="no-referrer" />

<div id="vouchers" class="main-content">

    <c:if test="${not empty errorMsg}">
        <div class="alert-message" style="background-color: #ffebee; color: #c62828; padding: 10px; margin-bottom: 15px; border-radius: 4px; border: 1px solid #ef9a9a;">
            <i class="fa-solid fa-triangle-exclamation"></i> ${errorMsg}
        </div>
    </c:if>

    <c:if test="${not empty sessionScope.successMsg}">
        <div class="alert-message" style="background-color: #e8f5e9; color: #2e7d32; padding: 10px; margin-bottom: 15px; border-radius: 4px; border: 1px solid #a5d6a7;">
            <i class="fa-solid fa-circle-check"></i> ${sessionScope.successMsg}
            <c:remove var="successMsg" scope="session"/>
        </div>
    </c:if>

    <div class="toolbar">
        <div class="search-container">
            <input type="text" id="search__voucher" name="search" placeholder="Tìm kiếm theo mã voucher" value="${searchKeyword}">
            <button id="btn-search-voucher"><i class="fa-solid fa-magnifying-glass"></i></button>
        </div>
        <c:if test="${fn:contains(sessionScope.userRoles, 'admin') || fn:contains(sessionScope.userPermissions, 'voucher_management.create')}">
        <button id="btn-addvoucher">+ Thêm mã giảm giá</button>
        </c:if>
    </div>

    <div class="table-wrapper">
        <table class="table-container">
            <thead>
            <tr>
                <th>Mã Voucher</th>
                <th>Tiêu đề</th>
                <th>Mức Giảm</th>
                <th>Điều kiện (Min Order)</th>
                <th>Thời gian</th>
                <th>Đã dùng</th>
                <th>Trạng thái</th>
                <th>Thao tác</th>
            </tr>
            </thead>
            <tbody id="productTableBody">
            <fmt:setLocale value="vi_VN"/>
            <c:forEach items="${voucherList}" var="v">
                <tr class="product-row">
                    <td><strong>${v.voucherCode}</strong></td>
                    <td>${v.title}</td>
                    <td>
                        <c:choose>
                            <c:when test="${v.type == 'Phần trăm(%)'}">
                                Giảm <fmt:formatNumber value="${v.value}" type="number" maxFractionDigits="1"/>%<br>
                                <small>(Tối đa: <fmt:formatNumber value="${v.maxDiscountAmount}" type="currency" currencySymbol="₫"/>)</small>
                            </c:when>
                            <c:otherwise>
                                Giảm <fmt:formatNumber value="${v.value}" type="currency" currencySymbol="₫"/>
                            </c:otherwise>
                        </c:choose>
                    </td>
                    <td>Từ <fmt:formatNumber value="${v.minOrderValue}" type="currency" currencySymbol="₫"/></td>
                    <td>
                        <fmt:formatDate value="${v.startDate}" pattern="dd/MM/yyyy"/> -
                        <fmt:formatDate value="${v.endDate}" pattern="dd/MM/yyyy"/>
                    </td>
                    <td>${v.usageCount} / ${v.usageLimit}</td>
                    <td>
                        <span class="status ${v.statusText == 'Hoạt động' ? 'active' : 'inactive'}">
                                ${v.statusText}
                        </span>
                    </td>
                    <td>
                        <c:if test="${fn:contains(sessionScope.userRoles, 'admin') || fn:contains(sessionScope.userPermissions, 'voucher_management.update')}">

                        <a href="javascript:void(0);" class="edit-voucher-btn" title="Sửa"
                               data-id="${v.id}" data-code="${v.voucherCode}" data-title="${v.title}" data-desc="${v.description}"
                               data-type="${v.type}" data-scope="${v.applyScope}" data-value="${v.value}"
                               data-min_order="${v.minOrderValue}" data-max_discount="${v.maxDiscountAmount}"
                               data-start="${v.startDate}" data-end="${v.endDate}" data-limit="${v.usageLimit}"
                               data-user_limit="${v.limitPerUser}" data-active="${v.isActive}">
                                <i class="fa-solid fa-pen-to-square"></i>
                            </a>
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
            <h2 class="form-title">Mã giảm giá</h2>

            <form action="${pageContext.request.contextPath}/admin/voucher" method="post" class="voucher-form">
                <input type="hidden" name="action" id="voucher_action" value="add">
                <input type="hidden" name="id" id="voucher_id">

                <div class="form-group">
                    <label>Mã Voucher</label>
                    <input type="text" id="voucher_code" name="voucherCode" required>
                </div>
                <div class="form-group">
                    <label>Tiêu đề</label>
                    <input type="text" id="title-voucher" name="title" required>
                </div>
                <div class="form-group">
                    <label>Mô tả</label>
                    <textarea id="description-voucher" name="description"></textarea>
                </div>

                <div class="form-group">
                    <label>Loại giảm giá</label>
                    <select id="type" name="type" required>
                        <option value="Phần trăm(%)">Phần trăm(%)</option>
                        <option value="Tiền mặt">Tiền mặt</option>
                    </select>
                </div>

                <div class="form-group">
                    <label>Mức giảm (Số % hoặc Số tiền)</label>
                    <input type="number" id="value" name="value" required>
                </div>

                <div class="form-group" id="max_discount_wrapper">
                    <label>Giá trị giảm tối đa (Chỉ dành cho loại %)</label>
                    <input type="number" id="max_order_value" name="maxDiscountAmount" value="0">
                </div>

                <div class="form-group">
                    <label>Giá trị đơn hàng tối thiểu (Min Order)</label>
                    <input type="number" id="min_order_value" name="minOrderValue" value="0" required>
                </div>

                <div class="form-group">
                    <label>Bắt đầu</label>
                    <input type="date" id="start_date" name="startDate" required>
                </div>
                <div class="form-group">
                    <label>Kết thúc</label>
                    <input type="date" id="end_date" name="endDate" required>
                </div>
                <div class="form-group">
                    <label>Tổng lượt dùng</label>
                    <input type="number" id="usage_limit" name="usageLimit" required>
                </div>
                <div class="form-group">
                    <label>Giới hạn / 1 User</label>
                    <input type="number" id="limit_per_user" name="limitPerUser" value="1" required>
                </div>
                <div class="form-group">
                    <label>Trạng thái kích hoạt</label>
                    <select id="active" name="isActive" required>
                        <option value="1">Kích hoạt</option>
                        <option value="0">Tạm dừng</option>
                    </select>
                </div>
                <button type="submit" class="btn-submit">Lưu Voucher</button>
            </form>
        </div>
    </div>
</div>

