package vn.edu.hcmuaf.fit.doanweb.controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import vn.edu.hcmuaf.fit.doanweb.dao.ReviewDao;
import vn.edu.hcmuaf.fit.doanweb.model.User;

import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;

@WebServlet(name = "ReviewServlet", value = "/post-review")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2,
        maxFileSize = 1024 * 1024 * 10,
        maxRequestSize = 1024 * 1024 * 50
)
public class ReviewServlet extends HttpServlet {

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

            String productIdStr = request.getParameter("productId");
            String ratingStr = request.getParameter("rating");
            String content = request.getParameter("review-content");

            if (productIdStr == null || ratingStr == null) {
                response.sendRedirect(request.getContextPath() + "/home");
                return;
            }

            int productId = Integer.parseInt(productIdStr);
            int rating = Integer.parseInt(ratingStr);


            String imageUrl = null;
            Part filePart = request.getPart("reviewImage");

            if (filePart != null && filePart.getSize() > 0) {
                String uploadPath = request.getServletContext().getRealPath("/assets/images/reviews");
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) {
                    uploadDir.mkdirs();
                }
                String originalFileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
                String uniqueFileName = System.currentTimeMillis() + "_" + originalFileName;
                String filePath = uploadPath + File.separator + uniqueFileName;
                filePart.write(filePath);
                imageUrl = "assets/images/reviews/" + uniqueFileName;
            }
            ReviewDao reviewDao = new ReviewDao();
            reviewDao.saveReview(user.getId(), productId, rating, content, imageUrl);
            response.sendRedirect(request.getContextPath() + "/productdetails?id=" + productId + "#review-section");

        } catch (Exception e) {
            e.printStackTrace();

        }
    }
}