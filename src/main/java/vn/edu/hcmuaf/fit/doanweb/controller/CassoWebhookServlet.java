package vn.edu.hcmuaf.fit.doanweb.controller;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import vn.edu.hcmuaf.fit.doanweb.dao.OrderDao;

import java.io.IOException;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

@WebServlet("/api/casso/webhook")
public class CassoWebhookServlet extends HttpServlet {
    private static final Pattern ORDER_ID_PATTERN = Pattern.compile("THANHTOAN\\s*DH(\\d+)", Pattern.CASE_INSENSITIVE);

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try {
            String body = request.getReader().lines().reduce("", String::concat);
            Integer orderId = extractOrderId(body);

            if (orderId == null) {
                response.getWriter().write("{\"success\": true, \"message\": \"IGNORED\"}");
                return;
            }

            OrderDao orderDao = new OrderDao();
            boolean markedPaid = orderDao.markOrderAsPaid(orderId);

            if (markedPaid) {
                response.getWriter().write("{\"success\": true, \"orderId\": " + orderId + "}");
            } else {
                response.getWriter().write("{\"success\": false, \"message\": \"ORDER_NOT_FOUND_OR_CANCELLED\"}");
            }
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"success\": false, \"message\": \"INTERNAL_ERROR\"}");
        }
    }

    private Integer extractOrderId(String body) {
        if (body == null || body.isEmpty()) return null;
        Matcher matcher = ORDER_ID_PATTERN.matcher(body);
        if (matcher.find()) {
            return Integer.parseInt(matcher.group(1));
        }
        return null;
    }
}
