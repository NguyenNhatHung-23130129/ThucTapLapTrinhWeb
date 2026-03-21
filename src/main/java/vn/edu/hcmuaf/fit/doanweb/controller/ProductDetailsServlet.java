package vn.edu.hcmuaf.fit.doanweb.controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import vn.edu.hcmuaf.fit.doanweb.dao.ReviewDao;
import vn.edu.hcmuaf.fit.doanweb.model.Product;
import java.util.List;
import vn.edu.hcmuaf.fit.doanweb.dao.ProductDao;
import vn.edu.hcmuaf.fit.doanweb.model.Review;
import vn.edu.hcmuaf.fit.doanweb.model.User;
import vn.edu.hcmuaf.fit.doanweb.dao.OrderDao;

import java.io.IOException;

@WebServlet(name = "ProductDetailsServlet", value = "/productdetails")
public class ProductDetailsServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idStr = request.getParameter("id");
        if (idStr != null) {
            try {
                int id = Integer.parseInt(idStr);
                Product p = ProductDao.getInstance().getProductById(id);
                if (p != null) {
                    request.setAttribute("p", p);
                    boolean canReview = false;
                    HttpSession session = request.getSession();
                    User user = (User) session.getAttribute("auth");
                    if (user != null) {
                        OrderDao orderDao = new OrderDao();
                        canReview = orderDao.checkUserBoughtProduct(user.getId(), id);
                    }
                    request.setAttribute("canReview", canReview);
                    List<Product> relatedProducts = ProductDao.getInstance().getRelatedProducts(p.getCategoryId(), id);
                    request.setAttribute("relatedProducts", relatedProducts);
                    ReviewDao reviewDao = new ReviewDao();
                    List<Review> reviews = reviewDao.getReviewsByProductId(id);
                    request.setAttribute("reviewList", reviews);

                }
            } catch (NumberFormatException e) {
                e.printStackTrace();
            }
        }
        request.getRequestDispatcher("ProductDetails.jsp").forward(request, response);
    }
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("auth");

        String productIdStr = request.getParameter("productId");
        try {
            int productId = Integer.parseInt(productIdStr);
            int rating = Integer.parseInt(request.getParameter("rating"));
            String content = request.getParameter("review-content");

            ReviewDao reviewDao = new ReviewDao();
            reviewDao.saveReview(user.getId(), productId, rating, content, null);

            response.sendRedirect("productdetails?id=" + productId + "#review-section");
        } catch (Exception e) {
            e.printStackTrace();

            response.sendRedirect("productdetails?id=" + productIdStr);
        }
    }}
