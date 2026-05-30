package vn.edu.hcmuaf.fit.doanweb.controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import vn.edu.hcmuaf.fit.doanweb.services.ShippingService;
import java.io.IOException;

@WebServlet(name = "CalculateShippingServlet", value = "/api/calculate-shipping")
public class CalculateShippingServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String cityCode = request.getParameter("cityCode");
        String method = request.getParameter("method");

        if (method == null) method = "standard";

        int weight = 1000;
        double fee = ShippingService.calculateFee("700000", cityCode != null ? cityCode : "700000", weight, method);

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        response.getWriter().write("{\"fee\": " + (long) fee + "}");
    }
}