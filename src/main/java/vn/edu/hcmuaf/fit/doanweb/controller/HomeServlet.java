package vn.edu.hcmuaf.fit.doanweb.controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import vn.edu.hcmuaf.fit.doanweb.dao.CategoryDao;
import vn.edu.hcmuaf.fit.doanweb.dao.ProductDao;
import vn.edu.hcmuaf.fit.doanweb.dao.SlideShowDao;
import vn.edu.hcmuaf.fit.doanweb.model.Category;
import vn.edu.hcmuaf.fit.doanweb.model.Product;
import vn.edu.hcmuaf.fit.doanweb.model.SlideShow;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "HomeServlet", value = "/home")
public class HomeServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws
            ServletException, IOException {
        //category
        CategoryDao categoryDao = new CategoryDao();
        List<Category> listCategories = categoryDao.getListCategory();
        request.setAttribute("categories", listCategories);


        //slideshow
        SlideShowDao slideShowDao = new SlideShowDao();
        List<SlideShow> listSlideShows = slideShowDao.getActiveSlideShows();
        request.setAttribute("slideShowList", listSlideShows);

        // Products
        ProductDao dao = new ProductDao();
        List<Product> products;

        String keyword = request.getParameter("search");
        String pageStr = request.getParameter("page");
        int currentPage = (pageStr == null) ? 1 : Integer.parseInt(pageStr);
        int totalPages = 1;

        if (keyword != null && !keyword.trim().isEmpty()) {
            // goi ham tu dao de tim kiem san pham
            products = dao.searchProducts(keyword.trim());

            totalPages = 1;

            request.setAttribute("searchKeyword", keyword);
        } else {
            // phan trang
            products = dao.getProductsByPage(currentPage);

            int totalProducts = dao.getTotalProducts();
            totalPages = (int) Math.ceil((double) totalProducts / 20);
        }

        //  gui sang jsp
        request.setAttribute("productList", products);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("currentPage", currentPage);


        request.getRequestDispatcher("TrangChu.jsp").forward(request, response);

    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws
            ServletException, IOException {
        doGet(request, response);
    }
}