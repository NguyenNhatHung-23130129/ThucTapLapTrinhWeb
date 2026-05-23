<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<div id="roles" class="main-content role-main">
    <div class="toolbar role-header">
        <h2 class="role-title">Quản lý Phân quyền</h2>
    </div>

    <c:if test="${param.success == '1'}">
        <div class="role-alert-success">
            <i class="fa-solid fa-circle-check"></i> Cập nhật quyền thành công! (Lưu ý: Nhân viên thuộc vai trò này cần
            đăng xuất và đăng nhập lại để áp dụng).
        </div>
    </c:if>

    <div class="role-container">

        <div class="role-sidebar">
            <h3 class="role-sidebar-title">Danh sách Vai trò</h3>
            <ul class="role-list">
                <c:forEach var="role" items="${roles}">
                    <c:if test="${role.id != 3 && role.id != 1}">
                        <li class="role-list-item">
                            <a href="${pageContext.request.contextPath}/admin/role?id=${role.id}"
                               class="role-link ${role.id == activeRoleId ? 'active' : ''}">
                                    ${role.name}
                            </a>
                        </li>
                    </c:if>
                </c:forEach>
            </ul>
        </div>

        <div class="role-content">
            <h3 class="role-content-title">
                Cấu hình quyền cho:
                <span class="role-highlight">
                    <c:forEach var="r" items="${roles}"><c:if
                            test="${r.id == activeRoleId}">${r.name}</c:if></c:forEach>
                </span>
            </h3>

            <form action="${pageContext.request.contextPath}/admin/role" method="post">
                <input type="hidden" name="role_id" value="${activeRoleId}">

                <table class="role-table">
                    <thead>
                    <tr>
                        <th>Danh mục quản lý</th>
                        <th>Hành động cho phép</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:set var="currentResource" value=""/>

                    <c:forEach var="perm" items="${permissions}">
                    <c:if test="${perm.resource != currentResource}">
                    <c:if test="${not empty currentResource}">
                        </td></tr>
                    </c:if>

                    <c:set var="resourceNameVN">
                        <c:choose>
                            <c:when test="${perm.resource == 'dashboard_management'}">Tổng quan</c:when>
                            <c:when test="${perm.resource == 'user_management'}">Quản lý người dùng</c:when>
                            <c:when test="${perm.resource == 'product_management'}">Quản lý sản phẩm</c:when>
                            <c:when test="${perm.resource == 'order_management'}">Quản lý đơn hàng</c:when>
                            <c:when test="${perm.resource == 'slideshow_management'}">Quản lý slideshow</c:when>
                            <c:when test="${perm.resource == 'voucher_management'}">Quản lý mã giảm giá</c:when>
                            <c:when test="${perm.resource == 'category_management'}">Quản lý danh mục</c:when>
                            <c:when test="${perm.resource == 'supplier_management'}">Quản lý nhà cung cấp</c:when>
                            <c:when test="${perm.resource == 'inventory_management'}">Quản lý phiếu nhập</c:when>
                            <c:when test="${perm.resource == 'notification_management'}">Quản lý thông báo</c:when>
                            <c:when test="${perm.resource == 'role_management'}">Quản lý phân quyền</c:when>
                            <c:otherwise>${perm.resource}</c:otherwise>
                        </c:choose>
                    </c:set>

                    <tr>
                        <td class="resource-name">${resourceNameVN}</td>
                        <td class="actions-group">
                            <c:set var="currentResource" value="${perm.resource}"/>
                            </c:if>

                            <label class="checkbox-label">
                                <c:set var="isChecked" value="false"/>
                                <c:forEach var="activeId" items="${activePermIds}">
                                    <c:if test="${activeId == perm.id}">
                                        <c:set var="isChecked" value="true"/>
                                    </c:if>
                                </c:forEach>

                                <input type="checkbox" name="permissionIds" value="${perm.id}"
                                    ${isChecked ? 'checked' : ''}
                                    ${activeRoleId == 1 ? 'disabled' : ''}> <span>
                                    <c:choose>
                                        <c:when test="${perm.action == 'read'}">Xem</c:when>
                                        <c:when test="${perm.action == 'create'}">Thêm</c:when>
                                        <c:when test="${perm.action == 'update'}">Sửa</c:when>
                                        <c:when test="${perm.action == 'delete'}"><span
                                                class="action-delete">Xóa</span></c:when>
                                        <c:otherwise>${perm.action}</c:otherwise>
                                    </c:choose>
                                </span>
                            </label>

                            </c:forEach>

                            <c:if test="${not empty currentResource}">
                        </td>
                    </tr>
                    </c:if>
                    </tbody>
                </table>

                <div class="role-footer">
                    <button type="submit" class="btn-save-role">
                        <i class="fa-solid fa-floppy-disk"></i> Lưu Cấu Hình Quyền
                    </button>

                </div>
            </form>
        </div>
    </div>
</div>