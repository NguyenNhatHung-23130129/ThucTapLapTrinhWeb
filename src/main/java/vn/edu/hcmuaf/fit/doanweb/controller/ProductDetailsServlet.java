package vn.edu.hcmuaf.fit.doanweb.controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import vn.edu.hcmuaf.fit.doanweb.dao.ReviewDao;
import vn.edu.hcmuaf.fit.doanweb.model.Product;
import java.util.List;
import vn.edu.hcmuaf.fit.doanweb.dao.ProductDao;
import vn.edu.hcmuaf.fit.doanweb.model.Review;

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

                    // Lay danh sach san pham lien quan
                    List<Product> relatedProducts = ProductDao.getInstance().getRelatedProducts(p.getCategoryId(), id);
                    request.setAttribute("relatedProducts", relatedProducts);

                    // Lay danh sach danh gia cho san pham
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


    }
}