package vn.edu.hcmuaf.fit.doanweb.controller;




import jakarta.servlet.*;
        import jakarta.servlet.http.*;
        import jakarta.servlet.annotation.*;
        import vn.edu.hcmuaf.fit.doanweb.dao.CategoryDao;
import vn.edu.hcmuaf.fit.doanweb.dao.ProductDao;
import vn.edu.hcmuaf.fit.doanweb.model.Category;
import vn.edu.hcmuaf.fit.doanweb.model.Product;

import java.io.IOException;
import java.util.Collections;
import java.util.List;

@WebServlet(name = "ProductListingServlet", value = "/products")
public class ProductListServlet extends HttpServlet {
        private ProductDao productDao;
        private CategoryDao categoryDao;

        @Override
        public void init() throws ServletException {
            productDao = new ProductDao();
            categoryDao = new CategoryDao();
        }
        @Override
        protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
            String cidParam = request.getParameter("cid");
            List<Category> categories = categoryDao.getListCategory();
            request.setAttribute("categories", categories);
            List<Product> products = productDao.getProducts();
            if (cidParam != null && !cidParam.isEmpty()) {
                int cid = Integer.parseInt(cidParam);
                products = productDao.getProductsByCategoryId(cid);
                categories = java.util.Collections.singletonList(categoryDao.getCategoryById(cid));
            } else {
                categories = categoryDao.getListCategory();
                products = productDao.getProducts();
            }
            request.setAttribute("productList", products);
            request.getRequestDispatcher("/ProductList.jsp").forward(request, response);
        }
        @Override
        protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
            doGet(request, response);
        }
    }