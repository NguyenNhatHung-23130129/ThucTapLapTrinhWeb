package vn.edu.hcmuaf.fit.doanweb.Admin;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import vn.edu.hcmuaf.fit.doanweb.dao.OrderDao;
import vn.edu.hcmuaf.fit.doanweb.model.Order;
import vn.edu.hcmuaf.fit.doanweb.model.User;
import vn.edu.hcmuaf.fit.doanweb.services.PermissionService;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "AdminOrderManage", value = "/admin/order")
public class AdminOrderManage extends HttpServlet {
    OrderDao orderDao = new OrderDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws
            ServletException, IOException {
        List<Order> orders;
        String search = request.getParameter("search");
        if (search != null && !search.trim().isEmpty()) {
            orders = orderDao.searchOrders(search.trim());
        } else {
            orders = orderDao.getAllOrders();
        }


        request.setAttribute("searchKeyword", search);

        request.setAttribute("orderList", orders);
        request.setAttribute("activeTab", "orders");
        request.getRequestDispatcher("Admin.jsp").forward(request, response);

    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws
            ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        switch (action) {
            case "updateOrder":
                updateOrder(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/admin/order");
        }
    }
    private void updateOrder(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int orderId = Integer.parseInt(request.getParameter("id"));
        String newStatus = request.getParameter("status");
        orderDao.updateOrderStatus(orderId, newStatus);
        response.sendRedirect(request.getContextPath() + "/admin/order");
    }
}