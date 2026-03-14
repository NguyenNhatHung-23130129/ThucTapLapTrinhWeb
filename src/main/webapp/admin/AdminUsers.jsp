<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<div id="users" class="main-content">
    <div class="toolbar">
        <div class="search-container">
            <input type="text" id="search__user" name="search"
                   placeholder="Tìm kiếm theo tên, email, số điện thoại"
                   value="${searchKeyword}">

            <button id="btn-search-user"><i class="fa-solid fa-magnifying-glass"></i></button>
        </div>
        <c:if test="${per >= 3}">
        <button class="add__user" id="btnAddUser">+ Thêm người dùng</button>
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
                <th>Tên</th>
                <th>Email</th>
                <th>Số điện thoại</th>
                <th>Vai trò</th>
                <th>Ngày tạo</th>
                <th>Url image</th>
                <th>Thao tác</th>
            </tr>
            </thead>
            <tbody id="productTableBody">

            <c:forEach var="user" items="${userList}">
                <tr class="product-row">
                    <td>${user.name}</td>
                    <td>${user.email}</td>
                    <td>${user.phone}</td>
                    <c:choose>
                        <c:when test="${user.roleId ==1}">
                            <td><span class="role-badge admin">Quản trị viên</span></td>
                        </c:when>
                        <c:when test="${user.roleId == 2}">
                            <td><span class="role-badge staff">Nhân viên</span></td>
                        </c:when>
                        <c:otherwise>
                            <td><span class="role-badge viewer">Người dùng</span></td>
                        </c:otherwise>
                    </c:choose>
                    <td><fmt:formatDate value="${user.createdAt}" pattern="dd/MM/yyyy"/></td>
                    <td><img src="${user.imageUrl}" alt="image" style="height: 40px;"></td>
                    <td>
                        <c:if test="${per >= 3}">
                            <a href="${pageContext.request.contextPath}/admin/user?action=edit&id=${user.id}" class="edit-user-btn"
                               data-id="${user.id}"
                               data-name="${user.name}"
                               data-email="${user.email}"
                               data-phone="${user.phone}"
                               data-role="${user.roleId}"
                               title="Sửa">
                                <i class="fa-solid fa-pen-to-square"></i>
                            </a>
                        </c:if>
                        <c:if test="${per >= 3}">
                            <form action="${pageContext.request.contextPath}/admin/user" method="post" class="delete-form">
                                <input type="hidden" name="action" value="delete">
                                <input type="hidden" id="delete-user-id" name="id" value="${user.id}">
                                <button type="button" class="delete-user-btn">
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

    <div id="popupUser" class="popup-overlay hidden">
        <div class="form-container popup-form">
            <span id="closePopupUser" class="close-popup">&times</span>
            <h2 class="form-title">Thêm Người Dùng</h2>

            <form id="addUserForm" action="${pageContext.request.contextPath}/admin/user" method="post">
                <input type="hidden" name="action" id="user-action" value="add">

                <input type="hidden" name="id" id="user-id">
                <div class="form-group">
                    <label for="user-name">Tên người dùng</label>
                    <input type="text" id="user-name" name="name" required>
                </div>

                <div class="form-group">
                    <label for="user-email">Email</label>
                    <input type="email" id="user-email" name="email" required>

                </div>


                <div class="form-group">
                    <label for="user-phone">SĐT</label>
                    <input type="text" id="user-phone" name="phone" required>
                </div>

                <div class="form-group category-group">
                    <label for="user-category">Vai trò</label>
                    <select id="user-category" name="role_name" required>
                        <option value="nguoidung">Người dùng</option>
                        <option value="nhanvien">Nhân viên</option>

                    </select>
                </div>

                <button type="submit" class="btn-submit user">+Thêm Người dùng</button>
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