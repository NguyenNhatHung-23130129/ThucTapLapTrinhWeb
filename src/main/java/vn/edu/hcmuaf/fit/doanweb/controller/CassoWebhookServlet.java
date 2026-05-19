package vn.edu.hcmuaf.fit.doanweb.controller;

import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import vn.edu.hcmuaf.fit.doanweb.dao.OrderDao;

import java.io.BufferedReader;
import java.io.IOException;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

@WebServlet("/api/casso-webhook")
public class CassoWebhookServlet extends HttpServlet {
    private static final String CASSO_SECURE_TOKEN = "MACASSO_BIMAT_123";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String headerToken = request.getHeader("secure-token");
        if (headerToken == null || !headerToken.equals(CASSO_SECURE_TOKEN)) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().write("{\"error\": 401, \"message\": \"Token không hợp lệ!\"}");
            return;
        }
        StringBuilder sb = new StringBuilder();
        BufferedReader reader = request.getReader();
        String line;
        while ((line = reader.readLine()) != null) {
            sb.append(line);
        }
        try {
            Gson gson = new Gson();
            JsonObject jsonObject = gson.fromJson(sb.toString(), JsonObject.class);
            JsonArray dataArray = jsonObject.getAsJsonArray("data");
            if (dataArray != null && dataArray.size() > 0) {
                OrderDao orderDao = new OrderDao();
                for (int i = 0; i < dataArray.size(); i++) {
                    JsonObject transaction = dataArray.get(i).getAsJsonObject();
                    String description = transaction.get("description").getAsString();
                    Pattern pattern = Pattern.compile("DH(\\d+)");
                    Matcher matcher = pattern.matcher(description);

                    if (matcher.find()) {
                        int orderId = Integer.parseInt(matcher.group(1));

                        try {
                            orderDao.markAsPaid(orderId);
                            System.out.println("Casso Webhook: Cập nhật thành công đơn hàng " + orderId);
                        } catch (IllegalStateException e) {
                            System.err.println("Casso Webhook Lỗi: " + e.getMessage());
                        }
                    }
                }
            }


            response.setStatus(HttpServletResponse.SC_OK);
            response.setContentType("application/json");
            response.getWriter().write("{\"error\": 0, \"message\": \"Thành công\"}");

        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }
}