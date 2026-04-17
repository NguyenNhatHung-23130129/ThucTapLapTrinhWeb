<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin-notification.css">

<div id="notification" class="main-content">
    <div class="toolbar">
        <div class="search-container">
            <input type="text" id="search__notification" name="search" placeholder="Tìm kiếm tiêu đề..."
                   value="${searchKeyword}">
            <button id="btn-search-notification"><i class="fa-solid fa-magnifying-glass"></i></button>
        </div>
        <c:if test="${per >= 2}">
            <button type="button" id="add-notification-btn" class="btn-primary">+ Thêm thông báo</button>
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
                <th>Tiêu đề</th>
                <th>Loại</th>
                <th>Đối tượng</th>
                <th>Ngày tạo</th>
                <th>Thao tác</th>
            </tr>
            </thead>
            <tbody id="productTableBody">
            <c:forEach items="${notifications}" var="n">
                <tr class="product-row">
                    <td>${n.title}</td>
                    <td>
                        <c:choose>
                            <c:when test="${n.type eq 'Cảnh báo'}">
                                <span class="badge badge-danger">${n.type}</span>
                            </c:when>
                            <c:when test="${n.type eq 'Khuyến mãi'}">
                                <span class="badge badge-warning">${n.type}</span>
                            </c:when>
                            <c:otherwise>
                                <span class="badge badge-success">${n.type}</span>
                            </c:otherwise>
                        </c:choose>
                    </td>

                    <td>
                            ${n.targetType}
                        <c:if test="${n.targetType == 'Người dùng cụ thể'}">- ID: ${n.targetId}</c:if>
                    </td>

                    <td><fmt:formatDate value="${n.createdAt}" pattern="dd/MM/yyyy"/></td>
                    <td>
                        <c:if test="${per >= 2}">
                            <a href="#" class="view-notification-btn"
                               data-title="${n.title}" data-content="${n.content}" data-created-at="${n.createdAt}"
                               data-is-read="${n.isRead}" data-type="${n.type}"
                               data-target-type="${n.targetType}" data-target-id="${n.targetId}"
                               title="Xem chi tiết">
                                <i class="fa-solid fa-eye"></i>
                            </a>
                        </c:if>
                    </td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
    </div>

    <div class="popup-overlay hidden" id="notiPopupOverlay">
        <div class="popup-content hidden" id="popupAddNoti">
            <span class="popup-close-btn" id="closeAddNoti">&times;</span>
            <h2 class="form-title">Thêm Thông Báo Mới</h2>

            <form id="addNotiForm" action="${pageContext.request.contextPath}/admin/notification" method="POST">
                <input type="hidden" name="action" value="add">

                <div class="form-group">
                    <label for="noti-title">Tiêu đề *</label>
                    <input type="text" id="noti-title" name="title" class="form-control" required>
                </div>

                <div class="form-group">
                    <label for="noti-type">Loại thông báo *</label>
                    <select id="noti-type" name="type" class="form-control" required>
                        <option value="Hệ thống">Hệ thống</option>
                        <option value="Khuyến mãi">Khuyến mãi</option>
                        <option value="Cảnh báo">Cảnh báo</option>
                    </select>
                </div>

                <div class="form-group">
                    <label for="noti-targetType">Đối tượng nhận *</label>
                    <select id="noti-targetType" name="targetType" class="form-control" required>
                        <option value="Tất cả khách hàng">Tất cả khách hàng</option>
                        <option value="Người dùng cụ thể">Người dùng cụ thể</option>
                    </select>
                </div>

                <div class="form-group hidden" id="targetIdWrapper">
                    <label for="noti-targetId">ID Khách hàng *</label>
                    <input type="number" id="noti-targetId" name="targetId" class="form-control" min="1"
                           placeholder="Nhập ID khách hàng">
                </div>

                <div class="form-group">
                    <label for="noti-content">Nội dung *</label>
                    <textarea id="noti-content" name="content" rows="4" class="form-control" required></textarea>
                </div>

                <button type="submit" class="btn-submit">Lưu Thông Báo</button>
            </form>
        </div>

        <div class="popup-content hidden" id="popupViewNoti">
            <span class="popup-close-btn" id="closeViewNoti">&times;</span>
            <h2 class="form-title">Chi Tiết Thông Báo</h2>
            <div class="noti-detail">
                <p><strong>Tiêu đề:</strong> <span id="view-title"></span></p>
                <p><strong>Ngày tạo:</strong> <span id="view-date"></span></p>
                <p><strong>Loại:</strong> <span id="view-type"></span></p>
                <p><strong>Đối tượng nhận:</strong> <span id="view-targetType"></span></p>
                <p><strong>Nội dung:</strong></p>
                <div id="view-content" class="noti-content-box"></div>
            </div>
        </div>
    </div>
</div>

<script src="${pageContext.request.contextPath}/assets/js/Admin.js"></script>