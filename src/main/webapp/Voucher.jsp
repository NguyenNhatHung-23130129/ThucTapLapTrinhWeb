<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Kho voucher ưu đãi | Chay Tươi</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/Voucher.css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/Nav.css">
    <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@400;500;600;700&display=swap"
          rel="stylesheet"/>
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons+Outlined" rel="stylesheet"/>
    <style>
        @keyframes slideDown {
            from {
                opacity: 0;
                transform: translateY(-20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .newly-added {
            animation: slideDown 0.5s ease-out;
            border-color: #49ef83;
        }
    </style>
</head>
<body>
<%@ include file="Header.jsp" %>
<div class="container">
    <div class="header-voucher">
        <h1>Kho Voucher Ưu Đãi</h1>
        <p>Khám phá và lưu lại các mã giảm giá hấp dẫn để thưởng thức ẩm thực chay lành mạnh với chi phí tốt nhất.</p>
    </div>

    <div class="section">
        <h2>Voucher Đang Có Hiệu Lực</h2>
        <c:choose>
            <c:when test="${empty listVoucher}">
                <div class="empty-alert" style="text-align: center; padding: 40px; color: #64748b;">
                    <span class="material-icons-outlined" style="font-size: 48px; color: #cbd5e1; margin-bottom: 16px;">sentiment_dissatisfied</span>
                    <p>Hiện tại không có voucher nào khả dụng.</p>
                </div>
            </c:when>
            <c:otherwise>
                <div class="voucher-grid" id="featured-grid">
                    <c:forEach var="v" items="${listVoucher}">
                        <div class="voucher-card">
                            <div class="card-content-top">
                                <div class="icon-row">
                                    <div class="icon-box">
                                        <c:choose>
                                            <c:when test="${v.type == 'freeship'}">
                                                <span class="material-icons-outlined">local_shipping</span>
                                            </c:when>
                                            <c:when test="${v.type == 'special'}">
                                                <span class="material-icons-outlined">card_giftcard</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="material-icons-outlined">local_offer</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                    <div>
                                        <h3>${v.title}</h3>
                                        <p>${v.description}</p>
                                        <input type="hidden" class="hidden-code" value="${v.voucherCode}"/>
                                    </div>
                                </div>
                                <p class="expire">
                                    HSD:
                                    <fmt:formatDate value="${v.endDate}" pattern="dd/MM/yyyy"/>
                                </p>
                            </div>
                            <c:set var="isSaved" value="false"/>
                            <c:forEach var="saved" items="${listSavedVoucher}">
                                <c:if test="${saved.voucherCode == v.voucherCode}">
                                    <c:set var="isSaved" value="true"/>
                                </c:if>
                            </c:forEach>
                            <c:choose>
                                <c:when test="${isSaved}">
                                    <button class="btn-disabled" disabled>Đã lưu</button>
                                </c:when>
                                <c:otherwise>
                                    <button class="btn-primary" onclick="saveVoucher(this, '${v.voucherCode}')">Lưu
                                        voucher
                                    </button>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </c:forEach>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
    <div class="section">
        <h2>Voucher Của Bạn</h2>
        <div class="voucher-grid" id="saved-grid">
            <c:forEach var="s" items="${listSavedVoucher}">
                <div class="voucher-card">
                    <div class="content">
                        <div class="icon-row">
                            <div class="icon-box gray">
                                <c:choose>
                                    <c:when test="${s.type == 'freeship'}">
                                        <span class="material-icons-outlined">local_shipping</span>
                                    </c:when>
                                    <c:when test="${s.type == 'special'}">
                                        <span class="material-icons-outlined">card_giftcard</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="material-icons-outlined">restaurant_menu</span>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            <div>
                                <h3>${s.title}</h3>
                                <p>${s.description}</p>
                            </div>
                        </div>
                        <div class="code-row">
                            <div class="code-box">${s.voucherCode}</div>
                            <button class="link" onclick="copyCode(this)">Sao chép</button>
                        </div>
                    </div>
                    <div class="footer">
                        <p class="expire">
                            HSD: <fmt:formatDate value="${s.endDate}" pattern="dd/MM/yyyy"/>
                        </p>

                        <c:url var="applyLink" value="checkout">
                            <c:param name="voucherCode" value="${s.voucherCode}"/>

                            <c:if test="${not empty param.id}">
                                <c:param name="id" value="${param.id}"/>
                                <c:param name="quantity" value="${param.quantity}"/>
                            </c:if>
                        </c:url>

                        <a href="${applyLink}" class="btn-primary"
                           style="text-decoration: none; text-align: center; line-height: 3rem; display: inline-block;">
                            Áp dụng
                        </a>
                    </div>
                </div>
            </c:forEach>

            <c:if test="${empty listSavedVoucher}">
                <p style="color: #64748b; grid-column: 1/-1; text-align: center;">Bạn chưa lưu voucher nào.</p>
            </c:if>
        </div>
    </div>
</div>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<script>
    function saveVoucher(button, voucherCode) {
        const originalText = button.innerText;
        button.innerText = "Đang lưu...";
        button.disabled = true;

        $.ajax({
            url: "${pageContext.request.contextPath}/savevoucher",
            type: "POST",
            data: {
                voucherCode: voucherCode
            },
            success: function (response) {

                button.innerText = "Đã lưu";
                button.classList.remove("btn-primary");
                button.classList.add("btn-disabled");
                button.disabled = true;
                button.onclick = null;

                addVoucherToSavedList(button, voucherCode);
            },
            error: function (xhr) {
                if (xhr.status === 409) {
                    button.innerText = "Đã lưu";
                    button.classList.remove("btn-primary");
                    button.classList.add("btn-disabled");
                    button.disabled = true;
                } else {
                    alert("Lưu thất bại! Vui lòng đăng nhập.");
                    button.innerText = "Lưu voucher";
                    button.disabled = false;
                }
            }
        });
    }

    function addVoucherToSavedList(button, code) {
        const originalCard = button.closest(".voucher-card");
        const icon = originalCard.querySelector(".material-icons-outlined")?.innerText || "local_offer";
        const title = originalCard.querySelector("h3")?.innerText || "Voucher";
        const descElement = originalCard.querySelector(".icon-row > div:last-child > p");
        const description = descElement ? descElement.innerText : "";
        const expiryText = originalCard.querySelector(".expire")?.innerText || "";

        const newCard = document.createElement("div");
        newCard.className = "voucher-card newly-added";

        newCard.innerHTML = `
            <div class="content">
                <div class="icon-row">
                    <div class="icon-box gray">
                         <span class="material-icons-outlined">\${icon}</span>
                    </div>
                    <div>
                        <h3>\${title}</h3>
                         <p>\${description}</p>
                    </div>
                </div>
                <div class="code-row">
                    <div class="code-box">\${code}</div>
                    <button class="link" onclick="copyCode(this)">Sao chép</button>
                </div>
            </div>
            <div class="footer">
                <p class="expire">\${expiryText}</p>
                <button href="checkout" class="btn-primary">Áp dụng</button>
            </div>
        `;

        const savedGrid = document.getElementById("saved-grid");
        const emptyMsg = savedGrid.querySelector("p[style*='text-align: center']");
        if (emptyMsg) emptyMsg.remove();

        if (savedGrid) {
            savedGrid.prepend(newCard);
        }
    }

    function copyCode(button) {
        const codeBox = button.previousElementSibling;
        const textToCopy = codeBox.innerText;

        navigator.clipboard.writeText(textToCopy).then(() => {
            const originalText = button.innerText;
            button.innerText = "Đã chép";
            button.classList.add("link-disabled");

            setTimeout(() => {
                button.innerText = originalText;
                button.classList.remove("link-disabled");
            }, 2000);
        }).catch(err => console.error('Lỗi sao chép:', err));
    }
</script>
</body>
</html>
