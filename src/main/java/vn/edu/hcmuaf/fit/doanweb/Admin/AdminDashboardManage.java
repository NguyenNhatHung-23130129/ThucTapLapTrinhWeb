package vn.edu.hcmuaf.fit.doanweb.Admin;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import vn.edu.hcmuaf.fit.doanweb.dao.AdminDao;
import vn.edu.hcmuaf.fit.doanweb.dao.CategoryDao;
import vn.edu.hcmuaf.fit.doanweb.dao.SlideShowDao;

import java.io.IOException;
import java.util.List;
import java.util.Map;

@WebServlet(name = "AdminServlet", value = "/admin/dashboard")
public class AdminDashboardManage extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        if ("categories".equals(action)) {
            request.setAttribute("categories", new CategoryDao().getListCategory());
        } else if ("slideshow".equals(action)) {
            request.setAttribute("slideshowList", new SlideShowDao().getSlideShows());
        }

        AdminDao dashboardDao = new AdminDao();

        List<Map<String, Object>> financeData = dashboardDao.getFinancialPerformanceLast6Months();
        request.setAttribute("chartLabels", toJsonArray(financeData, "month", true));
        request.setAttribute("chartRevenue", toJsonArray(financeData, "revenue", false));
        request.setAttribute("chartCost", toJsonArray(financeData, "cost", false));
        request.setAttribute("chartProfit", toJsonArray(financeData, "profit", false));

        List<Map<String, Object>> orderStatusData = dashboardDao.getOrderStatusLast6Months();
        request.setAttribute("orderSuccess", toJsonArray(orderStatusData, "success_orders", false));
        request.setAttribute("orderCancel", toJsonArray(orderStatusData, "cancel_orders", false));

        List<Map<String, Object>> retentionData = dashboardDao.getCustomerRetention();
        if (!retentionData.isEmpty()) {
            request.setAttribute("newCustomers", retentionData.get(0).get("new_customers"));
            request.setAttribute("returningCustomers", retentionData.get(0).get("returning_customers"));
        } else {
            request.setAttribute("newCustomers", 0);
            request.setAttribute("returningCustomers", 0);
        }

        List<Map<String, Object>> categoryData = dashboardDao.getCategoryPerformance();
        request.setAttribute("cateLabels", toJsonArray(categoryData, "category_name", true));
        request.setAttribute("cateRevenue", toJsonArray(categoryData, "category_revenue", false));
        request.setAttribute("cateItemsSold", toJsonArray(categoryData, "items_sold", false));


        request.setAttribute("pending_orders", dashboardDao.countPendingOrders());
        request.setAttribute("aov", dashboardDao.getAverageOrderValue());
        request.setAttribute("total_revenue", dashboardDao.getTotalRevenue());
        request.setAttribute("cancel_rate", dashboardDao.getCancellationRate());


        request.setAttribute("bestSellers", dashboardDao.getBestSellers());
        request.setAttribute("slowSellers", dashboardDao.getSlowSellers());
        request.setAttribute("lowStockProducts", dashboardDao.getLowStockProducts());
        request.setAttribute("expiringProducts", dashboardDao.getExpiringProducts());

        request.setAttribute("activeTab", "dashboard");
        request.getRequestDispatcher("Admin.jsp").forward(request, response);
    }

    private String toJsonArray(List<Map<String, Object>> data, String key, boolean isString) {
        StringBuilder sb = new StringBuilder();
        sb.append("[");
        for (int i = 0; i < data.size(); i++) {
            Object value = data.get(i).get(key);
            if (isString) {
                sb.append("\"").append(value).append("\"");
            } else {
                sb.append(value);
            }
            if (i < data.size() - 1) {
                sb.append(",");
            }
        }
        sb.append("]");
        return sb.toString();
    }
}