package vn.edu.hcmuaf.fit.doanweb.controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import vn.edu.hcmuaf.fit.doanweb.dao.ReviewDao;
import vn.edu.hcmuaf.fit.doanweb.model.User;
import vn.edu.hcmuaf.fit.doanweb.utils.CloudinaryUpload;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.charset.StandardCharsets;
import java.nio.file.Paths;

@WebServlet(name = "ReviewServlet", value = "/post-review")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2,
        maxFileSize = 1024 * 1024 * 10,
        maxRequestSize = 1024 * 1024 * 50
)
public class ReviewServlet extends HttpServlet {
    private String getValueFromPart(HttpServletRequest request, String fieldName) throws IOException, ServletException {
        Part part = request.getPart(fieldName);
        if (part == null) return null;
        try (InputStream is = part.getInputStream()) {
            return new String(is.readAllBytes(), StandardCharsets.UTF_8);
        }
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
            request.getParts();
        } catch (Exception e) {
            e.printStackTrace();
        }
        String productIdStr = getValueFromPart(request, "productId");
        String ratingStr = getValueFromPart(request, "rating");
        String content = getValueFromPart(request, "review-content");
        try {
            if (productIdStr == null || ratingStr == null) {
                System.out.println("LỖI: Dữ liệu bị null - PID: " + productIdStr + ", Rate: " + ratingStr);
                response.sendRedirect(request.getContextPath() + "/home");
                return;
            }

            int productId = Integer.parseInt(productIdStr.trim());
            int rating = Integer.parseInt(ratingStr.trim());
            String imageUrl = null;
            Part filePart = request.getPart("reviewImage");

            if (filePart != null && filePart.getSize() > 0) {
                imageUrl = CloudinaryUpload.handleUpload(request, "reviewImage", "reviews", "");
                if (imageUrl != null && imageUrl.trim().isEmpty()) {
                    imageUrl = null;
                }
            }
            ReviewDao reviewDao = new ReviewDao();
            reviewDao.saveReview(user.getId(), productId, rating, content, imageUrl);

            response.sendRedirect(request.getContextPath() + "/productdetails?id=" + productId + "#review-section");


        } catch (Exception e) {
            e.printStackTrace();

            try {
                String fallbackId = getValueFromPart(request, "productId");
                if (fallbackId != null && !fallbackId.trim().isEmpty()) {
                    response.sendRedirect(request.getContextPath() + "/productdetails?id=" + fallbackId.trim());
                } else {
                    response.sendRedirect(request.getContextPath() + "/home");
                }
            } catch (Exception ex) {
                response.sendRedirect(request.getContextPath() + "/home");
            }

        }
    }
}