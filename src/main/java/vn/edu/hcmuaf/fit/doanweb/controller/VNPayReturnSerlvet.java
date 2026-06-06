package vn.edu.hcmuaf.fit.doanweb.controller;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import vn.edu.hcmuaf.fit.doanweb.dao.OrderDao;

import java.io.IOException;

@WebServlet(name = "VnPayReturnServlet", value = "/vnpay-return")
public class VNPayReturnSerlvet extends HttpServlet{
    private OrderDao orderDao;
    @Override
    public void init() throws ServletException {
        orderDao = new OrderDao();
    }
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        String vnp_ResponseCode = request.getParameter("vnp_ResponseCode");
        String orderIdStr = request.getParameter("vnp_TxnRef");

        if (orderIdStr != null && !orderIdStr.isEmpty()) {
            int orderId = Integer.parseInt(orderIdStr);

            if ("00".equals(vnp_ResponseCode)) {

                orderDao.markAsPaid(orderId);
                response.sendRedirect("orderhistory");
            } else {

                response.sendRedirect("checkout?payment_error=true&id=" + orderIdStr);
            }
        } else {
            response.sendRedirect("home");
        }
    }
}
