package vn.edu.hcmuaf.fit.doanweb.controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import vn.edu.hcmuaf.fit.doanweb.dao.ReviewDao;
import vn.edu.hcmuaf.fit.doanweb.model.User;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.nio.charset.StandardCharsets;

@WebServlet(name = "ReviewServlet", value = "/post-review")
@MultipartConfig
public class ReviewServlet extends HttpServlet {


    private String getParameterFromParts(HttpServletRequest request, String paramName) throws IOException, ServletException {
        Part part = request.getPart(paramName);
        if (part == null) return null;

        BufferedReader reader = new BufferedReader(new InputStreamReader(part.getInputStream(), StandardCharsets.UTF_8));
        StringBuilder value = new StringBuilder();
        String line;
        while ((line = reader.readLine()) != null) {
            value.append(line);
        }
        return value.toString().trim();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("auth");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {

            String productIdStr = getParameterFromParts(request, "productId");
            String ratingStr = getParameterFromParts(request, "rating");
            String content = getParameterFromParts(request, "review-content");


            if (productIdStr == null || productIdStr.isEmpty()) {
                System.out.println("LỖI: Lấy productId thất bại (bị null).");
                response.sendRedirect(request.getContextPath() + "/home");
                return;
            }

            if (ratingStr == null || ratingStr.isEmpty()) {
                System.out.println("LỖI: Người dùng chưa chọn sao đánh giá.");
                response.sendRedirect(request.getContextPath() + "/productdetails?id=" + productIdStr + "#review-section");
                return;
            }


            int productId = Integer.parseInt(productIdStr);
            int rating = Integer.parseInt(ratingStr);


            ReviewDao reviewDao = new ReviewDao();
            reviewDao.saveReview(user.getId(), productId, rating, content);


            response.sendRedirect(request.getContextPath() + "/productdetails?id=" + productId + "#review-section");

        } catch (Exception e) {
           
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/home");
        }
    }
}