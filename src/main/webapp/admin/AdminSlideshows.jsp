<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<div id="slideshows" class="main-content">
    <div class="toolbar">
        <div class="search-container">
            <input type="text" id="search__slideshow" name="search"
                   placeholder="Tìm kiếm theo "
                   value="${searchKeyword}">

            <button id="btn-search-slideshow"><i class="fa-solid fa-magnifying-glass"></i></button>
        </div>
        <c:if test="${per >= 2}">
            <button id="btn-addslideshow">+ Thêm Slideshow</button>
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
                <th>Mã Slideshow</th>
                <th>Thời gian</th>
                <th>Thứ tự hiển thị</th>
                <th>Hình ảnh</th>
                <th>Trạng thái</th>
                <th>Thao tác</th>
            </tr>
            </thead>
            <tbody id="productTableBody">
            <c:forEach var="slide" items="${slideShowList}">
                <tr class="product-row">


                    <td>${slide.id}</td>
                    <td>
                        <fmt:formatDate value="${slide.startDate}" pattern="dd/MM/yyyy"/>
                        <span> - </span>
                        <fmt:formatDate value="${slide.endDate}" pattern="dd/MM/yyyy"/>
                    </td>
                    <td>${slide.displayOrder}</td>
                    <td>
                        <c:choose>
                            <c:when test="${fn:contains(slide.imageUrl, 'http')}">
                                <img src="${slide.imageUrl}" alt="image" style="height: 40px"/>
                            </c:when>

                            <c:otherwise>
                                <img src="${pageContext.request.contextPath}/${slide.imageUrl}" alt="image"
                                     style="height: 40px"/>
                            </c:otherwise>
                        </c:choose>
                    </td>

                    <td>
                        <c:choose>
                            <c:when test="${slide.status}">
                                <span class="status active">Hiển thị</span>
                            </c:when>
                            <c:otherwise>
                                <span class="status inactive">Ẩn</span>
                            </c:otherwise>
                        </c:choose>
                    </td>
                    <td>
                        <c:if test="${per >= 2}">
                            <a href="${pageContext.request.contextPath}/admin/slideshow?action=edit&id=${slide.id}"
                               class="edit-slideshow-btn"
                               data-id="${slide.id}"
                               data-title="${slide.title}"
                               data-imageurl="${slide.imageUrl}"
                               data-status="${slide.status ?1:0}"
                               data-description="${slide.description}"
                               data-displayorder="${slide.displayOrder}"
                               data-productid="${slide.productId}"
                               data-vouchercode="${slide.voucherCode}"
                               data-start_date="<fmt:formatDate value='${slide.startDate}' pattern='yyyy-MM-dd'/>"
                               data-end_date="<fmt:formatDate value='${slide.endDate}' pattern='yyyy-MM-dd'/>"

                               title="Sửa">
                                <i class="fa-solid fa-pen-to-square"></i>
                            </a>
                        </c:if>
                        <c:if test="${per >= 3}">
                            <form action="${pageContext.request.contextPath}/admin/slideshow" method="post"
                                  style="display:inline;"
                                  class="delete-slideshow-form">
                                <input type="hidden" name="action" value="delete">
                                <input type="hidden" name="id" value="${slide.id}">
                                <button type="button" class="delete-slideshow-btn">
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

    <div id="popupOverlayslideshow" class="popup-overlay hidden">
        <div class="form-container popup-form">
            <span id="closePopupslideshow" class="close-popup">&times;</span>
            <h2 class="form-title">Thêm Slideshow</h2>

            <form id="slideForm" action="${pageContext.request.contextPath}/admin/slideshow" method="post">
                <input type="hidden" name="action" id="slide_action" value="add">
                <input type="hidden" name="id" id="slide-id">

                <div class="form-group">
                    <label for="slide-title" class="label-title"></label>
                    <input type="hidden" id="slide-title" name="title">
                </div>
                <div class="form-group">
                    <label for="slide-desc" class="label-desc"></label>
                    <input type="hidden" id="slide-desc" name="description">
                </div>
                <div class="form-group">
                    <label for="slide-img" class="label-image">URL Ảnh</label>
                    <input type="text" id="slide-img" name="imageUrl" required>
                </div>
                <div class="form-group">
                    <label for="slide-productId"></label>
                    <input type="hidden" id="slide-productId" name="productId">
                </div>
                <div class="form-group">
                    <label for="slide-voucherCode"></label>
                    <input type="hidden" id="slide-voucherCode" name="voucherCode">
                </div>

                <div class="form-group">
                    <label for="slide-startDate">Ngày bắt đầu</label>
                    <input type="date" id="slide-startDate" name="startDate" required>
                </div>
                <div class="form-group">
                    <label for="slide-endDate">Ngày kết thúc</label>
                    <input type="date" id="slide-endDate" name="endDate" required>
                </div>
                <div class="form-group">
                    <label for="slide-order">Thứ tự hiển thị</label>
                    <input type="number" id="slide-order" name="displayOrder" min="1" required>
                </div>
                <div class="form-group">
                    <label for="slide-status">Trạng thái</label>
                    <select id="slide-status" name="status" required>
                        <option value="1">Hiển thị</option>
                        <option value="0">Ẩn</option>
                    </select>
                </div>
                <button type="submit" class="btn-submit slideshow">+ Lưu thay đổi</button>
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