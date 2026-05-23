package vn.edu.hcmuaf.fit.doanweb.controller;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import vn.edu.hcmuaf.fit.doanweb.dao.OrderDao;

import java.io.BufferedReader;
import java.io.IOException;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet("/api/casso/webhook")
public class CassoWebhookServlet extends HttpServlet {
    private static final Pattern ORDER_ID_PATTERN = Pattern.compile("THANHTOAN\\s*DH(\\d+)", Pattern.CASE_INSENSITIVE);
    private static final Logger LOGGER = Logger.getLogger(CassoWebhookServlet.class.getName());

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try {
            String configuredSecret = System.getenv("CASSO_WEBHOOK_SECRET");
            String receivedSignature = request.getHeader("x-casso-signature");
            if (receivedSignature == null || receivedSignature.trim().isEmpty()) {
                receivedSignature = request.getHeader("X-Casso-Signature");
            }
            if (configuredSecret == null || configuredSecret.trim().isEmpty()) {
                LOGGER.warning("Missing CASSO_WEBHOOK_SECRET configuration.");
                response.setStatus(HttpServletResponse.SC_SERVICE_UNAVAILABLE);
                response.getWriter().write("{\"success\": false, \"message\": \"WEBHOOK_SECRET_NOT_CONFIGURED\"}");
                return;
            }
            if (!configuredSecret.equals(receivedSignature)) {
                LOGGER.warning("Rejected Casso webhook due to invalid signature header.");
                response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                response.getWriter().write("{\"success\": false, \"message\": \"INVALID_SIGNATURE\"}");
                return;
            }

            String body = readRequestBody(request);
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
            LOGGER.log(Level.SEVERE, "Failed to process Casso webhook.", e);
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"success\": false, \"message\": \"INTERNAL_ERROR\"}");
        }
    }

    private String readRequestBody(HttpServletRequest request) throws IOException {
        StringBuilder bodyBuilder = new StringBuilder();
        try (BufferedReader reader = request.getReader()) {
            String line;
            while ((line = reader.readLine()) != null) {
                bodyBuilder.append(line);
            }
        }
        return bodyBuilder.toString();
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
