package vn.edu.hcmuaf.fit.doanweb.controller;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import vn.edu.hcmuaf.fit.doanweb.dao.OrderDao;
import vn.edu.hcmuaf.fit.doanweb.model.Order;
import java.io.IOException;

@WebServlet("/api/check-payment")
public class CheckPaymentServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String idStr = request.getParameter("orderId");
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try {
            int orderId = Integer.parseInt(idStr);
            OrderDao orderDao = new OrderDao();
            Order order = orderDao.getOrderById(orderId);


            if (order != null && "Đã thanh toán".equalsIgnoreCase(order.getStatus())) {
                response.getWriter().write("{\"status\": \"PAID\"}");
            } else {
                response.getWriter().write("{\"status\": \"PENDING\"}");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("{\"status\": \"ERROR\"}");
        }
    }
}