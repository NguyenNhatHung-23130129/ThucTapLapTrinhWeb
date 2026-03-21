<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<div id="notification" class="main-content">
    <div class="toolbar">
        <div class="search-container">
            <input type="text" id="search__notification" name="search"
                   placeholder="Tìm kiếm theo tiêu đề thông báo"
                   value="${searchKeyword}">

            <button id="btn-search-notification"><i class="fa-solid fa-magnifying-glass"></i></button>
        </div>
        <c:if test="${per >= 2}">
            <button type="button" id="add-notification-btn">+ Thêm thông báo</button>
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
                <th>Đối tượng nhận</th>
                <th>Ngày tạo</th>
                <th>Thao tác</th>

            </tr>
            </thead>
            <tbody id="productTableBody">
            <c:forEach items="${notifications}" var="n">
                <tr class="product-row">
                    <td>${n.title}</td>
                    <td>${n.targetType}</td>
                    <td>${n.targetId}</td>
                    <td><fmt:formatDate value="${n.createdAt}" pattern="dd/MM/yyyy"/></td>
                    <td>
                        <c:if test="${per >= 2}">
                            <a href="${pageContext.request.contextPath}/admin/notification?action=view&id=${n.id}" class="view-notification-btn"
                               data-id="${n.id}"
                               data-title="${n.title}"
                               data-content="${n.content}"
                               data-created-at="${n.createdAt}"
                               data-is-read="${n.isRead}"
                               data-type="${n.type}"
                               data-target-type="${n.targetType}"
                               data-target-id="${n.targetId}"


                               title="View Details">
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
