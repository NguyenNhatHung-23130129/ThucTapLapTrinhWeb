<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<div id="category" class="main-content">
    <div class="toolbar">
        <div class="search-container">
            <input type="text" id="search__category" name="search"
                   placeholder="Tìm kiếm theo tên danh mục"
                   value="${searchKeyword}">

            <button id="btn-search-category"><i class="fa-solid fa-magnifying-glass"></i></button>
        </div>
        <c:if test="${per >= 2}">
            <button type="button" id="add-category-btn">+ Thêm danh mục</button>
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
                <th>Mô tả</th>
                <th>Hình ảnh</th>
                <th>Thao tác</th>
            </tr>
            </thead>
            <tbody id="productTableBody">
            <c:forEach items="${categories}" var="c">
                <tr class="product-row">
                    <td>${c.name}</td>
                    <td>${c.description}</td>
                    <td>
                        <c:choose>
                            <c:when test="${fn:contains(c.imageUrl, 'http')}">
                                <img src="${c.imageUrl}" alt="image" style="height: 40px"/>
                            </c:when>

                            <c:otherwise>
                                <img src="${pageContext.request.contextPath}/${c.imageUrl}" alt="image"
                                     style="height: 40px"/>
                            </c:otherwise>
                        </c:choose>
                    </td>
                    <td>
                        <c:if test="${per >= 2}">
                            <a href="${pageContext.request.contextPath}/admin/category?action=edit&id=${c.id}"
                               class="edit-category-btn"
                               data-id="${c.id}"
                               data-name="${c.name}"
                               data-desc="${c.description}"
                               data-url="${c.imageUrl}"
                               title="Sửa">
                                <i class="fa-solid fa-pen-to-square"></i>
                            </a>
                        </c:if>
                        <c:if test="${per >= 3}">

                            <form action="${pageContext.request.contextPath}/admin/category" method="post"
                                  style="display:inline;"
                                  class="delete-category-form">
                                <input type="hidden" name="action" value="delete">
                                <input type="hidden" name="id" value="${c.id}">
                                <button type="button" class="btn-action delete-category-btn">
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

    <div id="popupOverlaycategory" class="popup-overlay hidden">
        <div class="form-container popup-form">
            <span id="closePopupcategory" class="close-popup">&times;</span>

            <h2 class="form-title" id="modalTitle">Thêm Category</h2>

            <form action="${pageContext.request.contextPath}/admin/category" method="post" class="category-form"
                  enctype="multipart/form-data">
                <input type="hidden" name="action" id="cat_action" value="add">

                <input type="hidden" name="id" id="cat_id">

                <div class="form-group">
                    <label for="category_name">Tên danh mục</label>
                    <input type="text" id="category_name" name="name" required>
                </div>

                <div class="form-group">
                    <label for="category_desc">Mô tả</label>
                    <textarea id="category_desc" name="description" rows="3"></textarea>
                </div>

                <div class="form-group">
                    <label for="category_url">Hình ảnh</label>
                    <input type="file" id="category_url" name="fileImage" accept="image/*">
                    <input type="hidden" id="cate-current-img" name="image_url" value="">
                    <img id="img-preview" src="" style="max-width:180px; display:none; margin-top:8px;">

                </div>

                <button type="submit" class="btn-submit category">+ Lưu</button>
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
    <c:if test="${not empty errorMessage}">
        <div id="error-toast">
            <i class="fa-solid fa-triangle-exclamation"></i>
                ${errorMessage}
        </div>
        <script>
            setTimeout(function () {
                var toast = document.getElementById("error-toast");
                if (toast) {
                    toast.style.display = "none";
                }
            }, 3000);
        </script>
    </c:if>
</div>