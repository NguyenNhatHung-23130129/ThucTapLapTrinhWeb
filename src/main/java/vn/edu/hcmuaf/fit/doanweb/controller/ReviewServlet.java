package vn.edu.hcmuaf.fit.doanweb.controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import vn.edu.hcmuaf.fit.doanweb.dao.ReviewDao;
import vn.edu.hcmuaf.fit.doanweb.model.User;
import java.io.IOException;

@WebServlet(name = "ReviewServlet", value = "/post-review")
public class ReviewServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("auth");

        if (user == null) {
            response.sendRedirect("login"); // hoặc dangNhap.jsp
            return;
        }

        try {
            int productId = Integer.parseInt(request.getParameter("productId"));
            int rating = Integer.parseInt(request.getParameter("rating")); // 1-5
            String content = request.getParameter("review-content");

            ReviewDao dao = new ReviewDao();
            dao.saveReview(user.getId(), productId, rating, content);

            // Lưu xong thì load lại trang chi tiết món
            response.sendRedirect("Chitietmon?id=" + productId);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("home");
        }
    }
}