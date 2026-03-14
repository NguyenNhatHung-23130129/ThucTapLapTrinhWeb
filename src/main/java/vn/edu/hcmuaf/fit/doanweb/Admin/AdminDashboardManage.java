package vn.edu.hcmuaf.fit.doanweb.Admin;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import vn.edu.hcmuaf.fit.doanweb.dao.AdminDao;
import vn.edu.hcmuaf.fit.doanweb.dao.CategoryDao;
import vn.edu.hcmuaf.fit.doanweb.dao.SlideShowDao;
import vn.edu.hcmuaf.fit.doanweb.model.User;
import vn.edu.hcmuaf.fit.doanweb.services.PermissionService;

import java.io.IOException;
import java.util.List;
import java.util.Map;

@WebServlet(name = "AdminServlet", value = "/admin/dashboard")
public class AdminDashboardManage extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws
            ServletException, IOException {
        String action = request.getParameter("action");

        if ("categories".equals(action)) {
            request.setAttribute("categories", new CategoryDao().getListCategory());
        } else if ("slideshow".equals(action)) {
            request.setAttribute("slideshowList", new SlideShowDao().getSlideShows());
        }

        AdminDao dashboardDao = new AdminDao();

      //lay du lieu tu db
        int totalUsers = dashboardDao.countTotalUsers();
        int totalOrders = dashboardDao.countTotalOrders();
        int totalProducts = dashboardDao.countTotalProducts();
        double totalRevenue = dashboardDao.getTotalRevenue();

        List<Map<String, Object>> revenueData = dashboardDao.getRevenueAndOrdersLast6Months();
        request.setAttribute("chartLabels", toJsonArray(revenueData, "month", true));
        request.setAttribute("chartRevenue", toJsonArray(revenueData, "revenue", false));
        request.setAttribute("chartOrders", toJsonArray(revenueData, "order_count", false));

        List<Map<String, Object>> productData = dashboardDao.getProductCountByCategory();
        request.setAttribute("cateLabels", toJsonArray(productData, "category_name", true));
        request.setAttribute("cateData", toJsonArray(productData, "product_count", false));

        List<Map<String, Object>> userData = dashboardDao.getNewUsersLast6Months();
        request.setAttribute("userLabels", toJsonArray(userData, "month", true));
        request.setAttribute("userData", toJsonArray(userData, "user_count", false));

        request.setAttribute("total_users", totalUsers);
        request.setAttribute("total_products", totalProducts);
        request.setAttribute("total_orders", totalOrders);
        request.setAttribute("total_revenue", totalRevenue);
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


    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws
            ServletException, IOException {

    }
}