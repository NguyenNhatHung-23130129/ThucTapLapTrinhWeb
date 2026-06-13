<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<fmt:setLocale value="vi_VN"/>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${p.name} | Chay Tươi</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/normalize/8.0.1/normalize.min.css"/>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.1/css/all.min.css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/ProductDetails.css">
</head>
<body>
<%@ include file="Header.jsp"%>

<div class="product-detail-container">
    <div class="product-top">
        <div class="product-image">
            <img src="${p.imageUrl}" alt="${p.name}">
        </div>

        <div class="product-info">
            <h2>${p.name}</h2>
            <div class="rating">
                <i class="fa-solid fa-star"></i>
                <span><fmt:formatNumber value="${p.averageRating}" pattern="0.0"/></span> (${p.ratingCount})
                <span class="price"><fmt:formatNumber value="${p.price}" type="currency" currencySymbol="₫"/></span>
            </div>

            <h3 class="nutrition-title">Thông tin dinh dưỡng</h3>
            <div class="nutrition">${p.nutritionalInformation}</div>

            <div class="quantity">
                <label>Số lượng:</label>
                <div class="quantity-box">
                    <button onclick="decreaseQty()">-</button>
                    <input type="text" id="qtyInput" value="1" readonly>
                    <button onclick="increaseQty()">+</button>
                </div>
            </div>

            <div class="buttons">
                <div class="add-cart-form">
                    <button type="button" class="add-to-cart-main" onclick="submitAddCartMain(${p.id})">Thêm vào giỏ</button>
                </div>

                <button class="buy-now" onclick="buyNow(${p.id})">Mua ngay</button>
            </div>
        </div>
    </div>

    <div class="product-description">
        <h3>Mô tả sản phẩm</h3>
        <p class="desc">${p.description}</p>
    </div>

    <div class="review-form-container" id="review-section">
        <h3>Viết Đánh Giá Của Bạn</h3>

        <c:choose>
            <c:when test="${not empty sessionScope.auth}">

                <c:choose>
                    <c:when test="${canReview}">
                        <form class="review-form" action="${pageContext.request.contextPath}/post-review" method="post" enctype="multipart/form-data">
                            <input type="hidden" name="productId" value="${p.id}">

                            <div class="form-group">
                                <label>Người đánh giá:</label>
                                <div class="reviewer-info">
                                    <img src="${sessionScope.auth.imageUrl}"
                                         onerror="this.src='${pageContext.request.contextPath}/assets/images/userProfile.webp'"
                                         class="reviewer-avatar">
                                    <span class="reviewer-name">
                                            ${sessionScope.auth.name}
                                    </span>
                                </div>
                            </div>

                            <div class="form-group rating-selection">
                                <label>Xếp hạng:</label>
                                <div class="stars">
                                    <input type="radio" id="star5" name="rating" value="5" required><label for="star5" title="Tuyệt vời">★</label>
                                    <input type="radio" id="star4" name="rating" value="4"><label for="star4" title="Rất tốt">★</label>
                                    <input type="radio" id="star3" name="rating" value="3"><label for="star3" title="Tốt">★</label>
                                    <input type="radio" id="star2" name="rating" value="2"><label for="star2" title="Tạm được">★</label>
                                    <input type="radio" id="star1" name="rating" value="1"><label for="star1" title="Tệ">★</label>
                                </div>
                                <span class="rating-value" id="rating-display">(0.0)</span>
                            </div>

                            <div class="form-group">
                                <label for="review-content">Nội dung đánh giá:</label>
                                <textarea id="review-content" name="review-content" rows="5" placeholder="Chia sẻ cảm nhận..." required></textarea>
                            </div>

                            <div class="form-group file-upload-group">
                                <input type="file" id="review-image" name="reviewImage" accept="image/*" onchange="previewImage(event)">
                                <label for="review-image" class="custom-file-upload">
                                    <i class="fas fa-camera"></i> Thêm hình ảnh
                                </label>
                                <div id="image-preview-container">
                                    <img id="image-preview" src="">
                                    <span class="remove-image-btn" onclick="removeImage()">✖</span>
                                </div>
                            </div>

                            <div class="form-actions">
                                <button type="submit" class="submit-review-btn">Gửi Đánh Giá</button>
                            </div>
                        </form>
                    </c:when>

                    <c:otherwise>
                        <p class="login-prompt">Bạn chưa mua sản phẩm này.</p>
                    </c:otherwise>
                </c:choose>
            </c:when>
            <c:otherwise>
                <p class="login-prompt">Vui lòng <a href="${pageContext.request.contextPath}/login"
                                                    class="login-link">đăng nhập</a> để viết đánh giá.</p>
            </c:otherwise>
        </c:choose>
    </div>
    <div class="product-reviews">
        <h3>Đánh giá & Bình luận</h3>

        <c:if test="${not empty reviewList}">
            <c:forEach var="r" items="${reviewList}">
                <div class="review">
                    <div class="avatar">
                        <c:choose>
                            <c:when test="${not empty r.user.imageUrl}">
                                <img src="${r.user.imageUrl}" alt="Avt">
                            </c:when>
                            <c:otherwise>U</c:otherwise>
                        </c:choose>
                    </div>
                    <div class="review-content">
                        <strong>${r.user.name}</strong> &nbsp;
                        <span class="review-stars-list">
                            <c:forEach begin="1" end="${r.rating}">★</c:forEach>
                        </span>
                        <span class="review-date">
                            <fmt:formatDate value="${r.reviewDate}" pattern="dd/MM/yyyy"/>
                        </span>
                        <p>${r.content}</p>
                        <div class="review-actions">
                            <c:if test="${not empty sessionScope.auth and (sessionScope.auth.id == r.user.id or sessionScope.auth.roleId < 3)}">
                                <span class="action-btn reply-btn-small" onclick="toggleReplyForm(${r.id}, this)">Trả lời</span>
                            </c:if>

                            <c:if test="${not empty messageMap[r.id] and messageMap[r.id].size() > 0}">
                                <span class="action-btn " onclick="toggleReplies(${r.id})">Xem câu trả lời</span>
                            </c:if>
                        </div>

                        <div id="reply-form-${r.id}" class="reply-form-container" style="display:none;">
                            <form action="${pageContext.request.contextPath}/post-message" method="post">
                                <input type="hidden" name="reviewId" value="${r.id}">
                                <input type="hidden" name="productId" value="${p.id}"> <textarea name="message" rows="2" placeholder="Nhập câu trả lời của bạn..." required></textarea>
                                <button type="submit" class="submit-reply-btn">Gửi</button>
                            </form>
                        </div>

                        <div id="replies-${r.id}" class="replies-container" style="display:none;">
                            <c:forEach var="msg" items="${messageMap[r.id]}" varStatus="status">
                                <div class="reply-item ${status.index >= 3 ? 'hidden-reply' : ''}">
                                    <div class="avatar">
                                        <c:choose>
                                            <c:when test="${msg.user.roleId < 3}">
                                                <div class="admin-avatar">A</div>
                                            </c:when>
                                            <c:otherwise>
                                                <img src="${pageContext.request.contextPath}/${msg.user.imageUrl}" onerror="this.src='${pageContext.request.contextPath}/assets/images/userProfile.webp'">
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                    <div class="reply-content">
                                        <strong>
                                            <c:choose>
                                                <c:when test="${msg.user.roleId < 3}">Admin</c:when>
                                                <c:otherwise>${msg.user.name}</c:otherwise>
                                            </c:choose>
                                        </strong>
                                        <p>${msg.message}</p>

                                        <c:if test="${not empty sessionScope.auth and (sessionScope.auth.id == r.user.id or sessionScope.auth.roleId < 3)}">
                                            <span class="action-btn reply-btn-small" onclick="toggleReplyForm(${r.id}, this)">Trả lời</span>
                                        </c:if>
                                    </div>
                                </div>
                            </c:forEach>
                            <c:if test="${messageMap[r.id].size() > 3}">
                                <span class="action-btn load-more-btn" onclick="showAllReplies(${r.id}, this)">Xem thêm câu trả lời</span>
                            </c:if>
                        </div>
                    </div>
                </div>
                <c:if test="${not empty r.imageUrl}">
                    <div class="review-image-wrapper">
                        <c:choose>
                            <c:when test="${fn:startsWith(r.imageUrl, 'http')}">
                                <img src="${r.imageUrl}" alt="Ảnh đánh giá của khách hàng" class="review-uploaded-image">
                            </c:when>
                            <c:otherwise>
                                <img src="${pageContext.request.contextPath}/${r.imageUrl}" alt="Ảnh đánh giá của khách hàng" class="review-uploaded-image">
                            </c:otherwise>
                        </c:choose>
                    </div>
                </c:if>
            </c:forEach>
        </c:if>
        <c:if test="${empty reviewList}">
            <p class="no-reviews">Chưa có đánh giá nào.</p>
        </c:if>

    </div>
</div>

<div class="category_container">
    <div class="category-section">
        <h2 class="category-title">Sản Phẩm Cùng Loại</h2>

        <div class="category-section__grid active">
            <c:forEach var="rp" items="${relatedProducts}">
                <div class="product-card" onclick="goToProduct(${rp.id})">
                    <div class="product-card__image-wrapper">
                        <img class="product-card__image" src="${rp.imageUrl}" alt="${rp.name}">
                    </div>
                    <div class="product-card__info">
                        <p class="product-card__name">${rp.name}</p>
                        <div class="price-container">
                            <span class="price"><fmt:formatNumber value="${rp.price}" type="currency" currencySymbol="₫"/></span>
                        </div>
                        <div class="button">
                            <button type="button" class="add-to-cart-related" onclick="submitAddCartRelated(event, ${rp.id})">Thêm vào giỏ</button>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>
    </div>
</div>

<%@ include file="Footer.jsp"%>
<iframe name="hiddenFrame" class="hidden-iframe"></iframe>

<script>
    function goToProduct(id) {
        window.location.href = "${pageContext.request.contextPath}/productdetails?id=" + id;
    }

    function increaseQty() {
        let input = document.getElementById("qtyInput");
        input.value = parseInt(input.value) + 1;
    }

    function decreaseQty() {
        let input = document.getElementById("qtyInput");
        if(parseInt(input.value) > 1) {
            input.value = parseInt(input.value) - 1;
        }
    }
    function submitAddCartMain(productId) {
        let qty = document.getElementById("qtyInput").value;
        addToCartAjax(contextPath, productId, parseInt(qty));
    }

    function submitAddCartRelated(event, productId) {
        event.stopPropagation();
        addToCartAjax(contextPath, productId, 1);
    }
    function addToCartAjax(contextPath, productId, quantity) {
        fetch(contextPath + '/add-cart', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8'
            },
            body: 'id=' + productId + '&quantity=' + quantity
        })
            .then(response => response.json())
            .then(data => {
                if (data.redirect) {
                    window.location.href = contextPath + '/' + data.redirect;
                    return;
                }

                if (data.status === 'success') {
                    const badge = document.getElementById('cartCount');
                    if (badge) {
                        badge.innerText = data.cartTotalQuantity;
                    }

                }
            })
            .catch(err => console.error('Lỗi hệ thống AJAX:', err));
    }


    function buyNow(id) {
        let qty = document.getElementById("qtyInput").value;
        window.location.href = "checkout?id=" + id + "&quantity=" + qty + "&action=buynow";
    }

    document.addEventListener("DOMContentLoaded", function() {
        const stars = document.querySelectorAll('.stars input[type="radio"]');
        const ratingDisplay = document.getElementById('rating-display');

        if (stars && ratingDisplay) {
            stars.forEach(star => {
                star.addEventListener('change', function() {
                    if (this.checked) {
                        ratingDisplay.innerText = "(" + this.value + ".0)";
                        ratingDisplay.style.color = "gold";
                    }
                });
            });
        }
    });
    function previewImage(event) {
        const file = event.target.files[0];
        const previewContainer = document.getElementById('image-preview-container');
        const previewImage = document.getElementById('image-preview');

        if (file) {
            const reader = new FileReader();
            reader.onload = function(e) {
                previewImage.src = e.target.result;
                previewContainer.style.display = 'block';
            }
            reader.readAsDataURL(file);
        }
    }

    function removeImage() {
        document.getElementById('review-image').value = '';
        document.getElementById('image-preview-container').style.display = 'none';
        document.getElementById('image-preview').src = '';
    }
    function toggleReplyForm(reviewId, btnElement) {
        if (!btnElement) {
            console.error("Lỗi:'this'.");
            return;
        }
        const form = document.getElementById('reply-form-' + reviewId);
        const targetPosition = btnElement.classList.contains('reply-btn-small') ? btnElement : btnElement.closest('.review-actions');
        if (form.previousElementSibling === targetPosition && form.style.display === 'block') {
            form.style.display = 'none';
        } else {
            targetPosition.insertAdjacentElement('afterend', form);
            form.style.display = 'block';
            const textarea = form.querySelector('textarea');
            if (textarea) {
                textarea.focus();
        }

    }}

    function toggleReplies(reviewId) {
        const container = document.getElementById('replies-' + reviewId);
        container.style.display = container.style.display === 'none' ? 'block' : 'none';
    }

    function showAllReplies(reviewId, btnElement) {
        const container = document.getElementById('replies-' + reviewId);
        const hiddenReplies = container.querySelectorAll('.hidden-reply');
        hiddenReplies.forEach(el => el.classList.remove('hidden-reply'));
        btnElement.style.display = 'none';
    }
</script>
</body>
</html>