<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>


<div class="dashboard main-content">

    <div class="dashboard__cards">
        <div class="card">
            <div class="card__content">
                <span class="card__label">Tổng Doanh Thu </span>
                <span class="card__value">
                    <i class="fa-solid fa-money-bill-wave" style="color: #10b981;"></i>
                    <span>
                        <fmt:setLocale value="vi_VN"/>
                        <fmt:formatNumber value="${requestScope.total_revenue}" type="currency" currencySymbol="₫"/>
                    </span>
                </span>
            </div>
        </div>
        <div class="card">
            <div class="card__content">
                <span class="card__label" style="color: #ef4444; font-weight: bold;">Đơn Hàng Cần Xử Lý</span>
                <span class="card__value">
                    <i class="fa-solid fa-box-open" style="color: #ef4444;"></i>
                    <span>${requestScope.pending_orders}</span>
                </span>
            </div>
        </div>
        <div class="card">
            <div class="card__content">
                <span class="card__label">Giá Trị Trung Bình / Đơn</span>
                <span class="card__value">
                    <i class="fa-solid fa-basket-shopping" style="color: #3b82f6;"></i>
                    <span>
                        <fmt:formatNumber value="${requestScope.aov}" type="currency" currencySymbol="₫"/>
                    </span>
                </span>
            </div>
        </div>
        <div class="card">
            <div class="card__content">
                <span class="card__label">Tỷ Lệ Hủy Đơn (30 ngày)</span>
                <span class="card__value">
                    <i class="fa-solid fa-triangle-exclamation" style="color: #f59e0b;"></i>
                    <span>
                        <fmt:formatNumber value="${requestScope.cancel_rate}" maxFractionDigits="1"/>%
                    </span>
                </span>
            </div>
        </div>
    </div>

    <div class="charts-container">
        <div class="chart-card">
            <h3>Doanh Thu, Giá Vốn & Lợi Nhuận (6 Tháng)</h3>
            <div class="chart-canvas-wrapper">
                <canvas id="revenueChart"></canvas>
            </div>
        </div>
        <div class="chart-card">
            <h3>Số lượng Đơn Giao Thành Công & Bị Hủy (6 Tháng)</h3>
            <div class="chart-canvas-wrapper">
                <canvas id="orderChart"></canvas>
            </div>
        </div>
        <div class="chart-card">
            <h3>Cơ Cấu Khách Hàng</h3>
            <div class="chart-canvas-wrapper">
                <canvas id="userChart"></canvas>
            </div>
        </div>
        <div class="chart-card">
            <h3>Doanh Thu & Lượt Bán Theo Danh Mục</h3>
            <div class="chart-canvas-wrapper">
                <canvas id="productChart"></canvas>
            </div>
        </div>
    </div>

    <div class="dashboard-tables">
        <div class="data-table-card">
            <h3>Top 10 Sản phẩm Bán Chạy (Tháng này)</h3>
            <table class="action-table">
                <tr>
                    <th>Sản phẩm</th>
                    <th>Đã bán</th>
                    <th>Doanh thu</th>
                </tr>
                <c:forEach var="p" items="${requestScope.bestSellers}">
                    <tr>
                        <td>
                            <div style="display: flex; align-items: center; gap: 10px;">
                                <img src="${p.image_url}" alt="">
                                <span style="white-space: nowrap; overflow: hidden; text-overflow: ellipsis; max-width: 120px;">${p.name}</span>
                            </div>
                        </td>
                        <td><strong>${p.total_sold}</strong></td>
                        <td style="color: #10b981;"><fmt:formatNumber value="${p.total_revenue}" type="currency"
                                                                      currencySymbol="₫"/></td>
                    </tr>
                </c:forEach>
            </table>
        </div>

        <div class="data-table-card">
            <h3>Top 10 Sản phẩm Bán Chậm (Tháng này)</h3>
            <table class="action-table">
                <tr>
                    <th>Sản phẩm</th>
                    <th>Đã bán</th>
                    <th>Doanh thu</th>
                </tr>
                <c:forEach var="p" items="${requestScope.slowSellers}">
                    <tr>
                        <td>
                            <div style="display: flex; align-items: center; gap: 10px;">
                                <img src="${p.image_url}" alt="">
                                <span style="white-space: nowrap; overflow: hidden; text-overflow: ellipsis; max-width: 120px;">${p.name}</span>
                            </div>
                        </td>
                        <td><strong>${p.total_sold}</strong></td>
                        <td style="color: #10b981;"><fmt:formatNumber value="${p.total_revenue}" type="currency"
                                                                      currencySymbol="₫"/></td>
                    </tr>
                </c:forEach>
            </table>
        </div>

        <div class="data-table-card">
            <h3>Cảnh Báo Sắp Hết Hàng</h3>
            <table class="action-table">
                <tr>
                    <th>Sản phẩm</th>
                    <th>Tồn kho</th>
                </tr>
                <c:forEach var="p" items="${requestScope.lowStockProducts}">
                <tr>
                    <td>
                        <div style="display: flex; align-items: center; gap: 10px;">
                            <img src="${p.image_url}" alt="">
                            <span style="white-space: nowrap; overflow: hidden; text-overflow: ellipsis; max-width: 120px;">${p.name}</span>
                        </div>
                    </td>
                    <td><span class="badge-danger">${p.stock_quantity}</span></td>
                    </c:forEach>
            </table>
        </div>

        <div class="data-table-card">
            <h3>Cảnh Báo Sắp Hết Hạn (30 Ngày)</h3>
            <table class="action-table">
                <tr>
                    <th>Sản phẩm</th>
                    <th>Ngày HH</th>
                    <th>Còn lại</th>
                </tr>
                <c:forEach var="p" items="${requestScope.expiringProducts}">
                    <tr>
                        <td>
                            <span style="white-space: nowrap; overflow: hidden; text-overflow: ellipsis; max-width: 150px; display: inline-block;">${p.name}</span>
                        </td>
                        <td><fmt:formatDate value="${p.expiry_date}" pattern="dd/MM/yyyy"/></td>
                        <td><span class="badge-warning">${p.days_left} ngày</span></td>
                    </tr>
                </c:forEach>
            </table>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

    <script>
        document.addEventListener("DOMContentLoaded", function () {

            const currencyFormat = new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' });

            new Chart(document.getElementById('revenueChart'), {
                type: 'bar',
                data: {
                    labels: ${requestScope.chartLabels},
                    datasets: [
                        {
                            type: 'line',
                            label: 'Lợi nhuận gộp',
                            data: ${requestScope.chartProfit},
                            borderColor: '#10b981',
                            backgroundColor: '#10b981',
                            borderWidth: 2,
                            tension: 0.3,
                            yAxisID: 'y'
                        },
                        {
                            type: 'bar',
                            label: 'Doanh thu',
                            data: ${requestScope.chartRevenue},
                            backgroundColor: 'rgba(54, 162, 235, 0.6)',
                            yAxisID: 'y'
                        },
                        {
                            type: 'bar',
                            label: 'Giá vốn',
                            data: ${requestScope.chartCost},
                            backgroundColor: 'rgba(239, 68, 68, 0.6)',
                            yAxisID: 'y'
                        }
                    ]
                },
                options: {
                    responsive: true, maintainAspectRatio: false,
                    scales: {
                        y: {
                            beginAtZero: true,
                            ticks: { callback: function (value) { return currencyFormat.format(value); } }
                        }
                    },
                    plugins: {
                        tooltip: {
                            callbacks: {
                                label: function (context) { return context.dataset.label + ': ' + currencyFormat.format(context.parsed.y); }
                            }
                        }
                    }
                }
            });

            new Chart(document.getElementById('orderChart'), {
                type: 'bar',
                data: {
                    labels: ${requestScope.chartLabels},
                    datasets: [
                        {
                            label: 'Giao Thành Công',
                            data: ${requestScope.orderSuccess},
                            backgroundColor: 'rgba(16, 185, 129, 0.7)'
                        },
                        {
                            label: 'Bị Hủy',
                            data: ${requestScope.orderCancel},
                            backgroundColor: 'rgba(239, 68, 68, 0.7)'
                        }
                    ]
                },
                options: {
                    responsive: true, maintainAspectRatio: false,
                    scales: {
                        x: { stacked: true },
                        y: { stacked: true, beginAtZero: true, ticks: { stepSize: 1 } }
                    }
                }
            });

            new Chart(document.getElementById('userChart'), {
                type: 'doughnut',
                data: {
                    labels: ['Khách mua lần đầu', 'Khách mua lại'],
                    datasets: [{
                        data: [${requestScope.newCustomers}, ${requestScope.returningCustomers}],
                        backgroundColor: ['rgba(54, 162, 235, 0.7)', 'rgba(255, 206, 86, 0.7)'],
                        borderWidth: 1
                    }]
                },
                options: {
                    responsive: true, maintainAspectRatio: false,
                    cutout: '60%',
                    plugins: {
                        title: { display: false, text: 'Tỷ lệ Retention' }
                    }
                }
            });

            new Chart(document.getElementById('productChart'), {
                type: 'bar',
                data: {
                    labels: ${requestScope.cateLabels},
                    datasets: [
                        {
                            label: 'Doanh thu (VND)',
                            data: ${requestScope.cateRevenue},
                            backgroundColor: 'rgba(153, 102, 255, 0.6)',
                            yAxisID: 'y'
                        },
                        {
                            type: 'line',
                            label: 'Số lượng (Cái/Hộp)',
                            data: ${requestScope.cateItemsSold},
                            borderColor: 'rgba(255, 159, 64, 1)',
                            backgroundColor: 'rgba(255, 159, 64, 1)',
                            borderWidth: 2,
                            yAxisID: 'y1'
                        }
                    ]
                },
                options: {
                    responsive: true, maintainAspectRatio: false,
                    scales: {
                        y: {
                            type: 'linear', display: true, position: 'left',
                            ticks: { callback: function (value) { return currencyFormat.format(value); } }
                        },
                        y1: {
                            type: 'linear', display: true, position: 'right',
                            grid: { drawOnChartArea: false },
                            ticks: { stepSize: 1 }
                        }
                    },
                    plugins: {
                        tooltip: {
                            callbacks: {
                                label: function (context) {
                                    let label = context.dataset.label || '';
                                    let val = context.parsed.y;
                                    return context.datasetIndex === 0 ? label + ': ' + currencyFormat.format(val) : label + ': ' + val;
                                }
                            }
                        }
                    }
                }
            });

        });
    </script>
</div>