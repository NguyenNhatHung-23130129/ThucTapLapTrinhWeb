package vn.edu.hcmuaf.fit.doanweb.controller;

import com.google.gson.Gson;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import vn.edu.hcmuaf.fit.doanweb.dao.ProductDao;
import vn.edu.hcmuaf.fit.doanweb.model.Product;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

@WebServlet("/search-suggest")
public class SearchServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String keyword = request.getParameter("keyword");
        if (keyword == null) keyword = "";

        List<Product> list = new ProductDao().searchProducts(keyword.trim());

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        response.getWriter().print(new Gson().toJson(list));
    }
}