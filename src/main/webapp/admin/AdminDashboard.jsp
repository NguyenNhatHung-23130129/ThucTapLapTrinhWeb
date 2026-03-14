<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<div class="dashboard main-content">
    <div class="dashboard__cards">
        <div class="card">
            <div class="card__content"><span class="card__label">Tổng người dùng</span> <span
                    class="card__value"> <i
                    class="fa-solid fa-users"></i> <span>${requestScope.total_users}</span></span></div>
        </div>
        <div class="card">
            <div class="card__content"><span class="card__label">Tổng sản phẩm</span> <span class="card__value"> <i
                    class="fa-solid fa-boxes-packing"></i> <span>${requestScope.total_products}</span> </span>
            </div>
        </div>
        <div class="card">
            <div class="card__content"><span class="card__label">Đơn hàng mới</span> <span class="card__value"> <i
                    class="fa-solid fa-cart-shopping"></i> <span>${requestScope.total_orders}</span> </span>
            </div>
        </div>
        <div class="card">
            <div class="card__content"><span class="card__label">Doanh thu</span> <span class="card__value">  <span>
                <fmt:setLocale value="vi_VN"/>
                <fmt:formatNumber value="${requestScope.total_revenue}" type="currency" currencySymbol="₫"/>
               </span> </span>
            </div>
        </div>
    </div>
    <div class="charts-container">

        <div class="chart-card">
            <h3>Doanh thu 6 tháng (VND)</h3>
            <div class="chart-canvas-wrapper">
                <canvas id="revenueChart"></canvas>
            </div>
        </div>

        <div class="chart-card">
            <h3>Số lượng đơn hàng</h3>
            <div class="chart-canvas-wrapper">
                <canvas id="orderChart"></canvas>
            </div>
        </div>

        <div class="chart-card">
            <h3>Người dùng đăng ký mới</h3>
            <div class="chart-canvas-wrapper">
                <canvas id="userChart"></canvas>
            </div>
        </div>

        <div class="chart-card">
            <h3>Tỉ lệ sản phẩm theo danh mục</h3>
            <div class="chart-canvas-wrapper">
                <canvas id="productChart"></canvas>
            </div>
        </div>

    </div>

    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

    <script>
        document.addEventListener("DOMContentLoaded", function () {

            // doanh thu
            new Chart(document.getElementById('revenueChart'), {
                type: 'bar',
                data: {
                    labels: ${requestScope.chartLabels}, // Tháng
                    datasets: [{
                        label: 'Doanh thu',
                        data: ${requestScope.chartRevenue},
                        backgroundColor: 'rgba(54, 162, 235, 0.6)',
                        borderColor: 'rgba(54, 162, 235, 1)',
                        borderWidth: 1
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    scales: {
                        y: {
                            beginAtZero: true,
                            ticks: {
                                callback: function (value) {
                                    return value.toLocaleString('vi-VN', {style: 'currency', currency: 'VND'});
                                }
                            }
                        }
                    },
                    plugins: {
                        tooltip: {
                            callbacks: {
                                label: function (context) {
                                    return new Intl.NumberFormat('vi-VN', {
                                        style: 'currency',
                                        currency: 'VND'
                                    }).format(context.parsed.y);
                                }
                            }
                        }
                    }
                }
            });

            // don hang
            new Chart(document.getElementById('orderChart'), {
                type: 'line',
                data: {
                    labels: ${requestScope.chartLabels},
                    datasets: [{
                        label: 'Đơn hàng',
                        data: ${requestScope.chartOrders},
                        backgroundColor: 'rgba(255, 159, 64, 0.2)',
                        borderColor: 'rgba(255, 159, 64, 1)',
                        borderWidth: 2,
                        tension: 0.3, //duong cong
                        fill: true
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    scales: {y: {beginAtZero: true, ticks: {stepSize: 1}}}
                }
            });

            // nguoi dung
            new Chart(document.getElementById('userChart'), {
                type: 'bar',
                data: {
                    labels: ${requestScope.userLabels},
                    datasets: [{
                        label: 'Thành viên mới',
                        data: ${requestScope.userData},
                        backgroundColor: 'rgba(75, 192, 192, 0.6)',
                        borderColor: 'rgba(75, 192, 192, 1)',
                        borderWidth: 1
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    scales: {y: {beginAtZero: true, ticks: {stepSize: 1}}}
                }
            });

            //san pham
            new Chart(document.getElementById('productChart'), {
                type: 'doughnut',
                data: {
                    labels: ${requestScope.cateLabels},
                    datasets: [{
                        label: 'Số lượng SP',
                        data: ${requestScope.cateData},
                        backgroundColor: [
                            'rgba(255, 99, 132, 0.7)',
                            'rgba(54, 162, 235, 0.7)',
                            'rgba(255, 206, 86, 0.7)',
                            'rgba(75, 192, 192, 0.7)',
                            'rgba(153, 102, 255, 0.7)',
                            'rgba(255, 159, 64, 0.7)'
                        ],
                        borderWidth: 1
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                }
            });
        });
    </script>
</div>