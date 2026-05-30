package vn.edu.hcmuaf.fit.doanweb.controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;

@WebServlet(name = "VnPayCallbackServlet", value = "/vnpay-callback")
public class VnPayCallbackServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String responseCode = request.getParameter("vnp_ResponseCode");
        String orderId = request.getParameter("vnp_TxnRef");
        if ("00".equals(responseCode)) {
            response.sendRedirect(request.getContextPath() + "/orderhistory");
        } else {
            request.getSession().setAttribute("error", "Thanh toán qua VNPAY không thành công hoặc đã bị hủy.");
            response.sendRedirect(request.getContextPath() + "/checkout");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}