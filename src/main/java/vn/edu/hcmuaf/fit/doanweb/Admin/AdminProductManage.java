package vn.edu.hcmuaf.fit.doanweb.Admin;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import vn.edu.hcmuaf.fit.doanweb.dao.CategoryDao;
import vn.edu.hcmuaf.fit.doanweb.dao.ProductDao;
import vn.edu.hcmuaf.fit.doanweb.model.Product;
import vn.edu.hcmuaf.fit.doanweb.model.User;
import vn.edu.hcmuaf.fit.doanweb.services.PermissionService;

import java.io.IOException;
import java.sql.Date;
import java.util.List;

@WebServlet(name = "AdminProductManage", value = "/admin/product")
public class AdminProductManage extends HttpServlet {
    ProductDao productDao = new ProductDao();
    CategoryDao categoryDao = new CategoryDao();


    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws
            ServletException, IOException {
        List<Product> products ;

        String search = request.getParameter("search");
        if (search != null && !search.trim().isEmpty()) {
            products = productDao.searchProducts(search.trim());
        } else {
            products = productDao.getAllProducts();
        }
        request.setAttribute("searchKeyword", search);



        request.setAttribute("categoryList", categoryDao.getListCategory());
        request.setAttribute("productList", products);
        request.setAttribute("activeTab", "products");
        request.getRequestDispatcher("Admin.jsp").forward(request, response);


    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws
            ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");
        if (action == null) action = "";



        switch (action) {
            case "add":
                addProduct(request, response);
                break;
            case "update":
                updateProduct(request, response);
                break;
            case "delete":
                deleteProduct(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/admin/product");
        }
    }

    private void addProduct(HttpServletRequest request, HttpServletResponse response) throws IOException {
        Product p = getProductForm(request);
        productDao.insertProduct(p);
        response.sendRedirect(request.getContextPath() + "/admin/product");
    }

    private void updateProduct(HttpServletRequest request, HttpServletResponse response) throws IOException {
        Product p = getProductForm(request);
        int id = Integer.parseInt(request.getParameter("id"));
        p.setId(id);
        productDao.updateProduct(p);
        response.sendRedirect(request.getContextPath() + "/admin/product");
    }

    private void deleteProduct(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        productDao.deleteProduct(id);
        response.sendRedirect(request.getContextPath() + "/admin/product");
    }

    private Product getProductForm(HttpServletRequest request) {
        String name = request.getParameter("name");
        int cateId = Integer.parseInt(request.getParameter("category_id"));
        double price = Double.parseDouble(request.getParameter("price"));
        double discount = Double.parseDouble(request.getParameter("discount"));

        String unit = request.getParameter("unit_of_measure");
        String img = request.getParameter("image_url");
        String desc = request.getParameter("description");
        String nutrition = request.getParameter("nutritional_information");
        Date pDate = Date.valueOf(request.getParameter("production_date"));
        Date eDate = Date.valueOf(request.getParameter("expiry_date"));
        String activeStr = request.getParameter("active");
        boolean isActive = true;
        if (activeStr != null) {
            isActive = "1".equals(activeStr);
        }

        Product p = new Product();
        p.setName(name);
        p.setCategoryId(cateId);
        p.setPrice(price);
        p.setDiscount(discount);
        p.setUnitOfMeasure(unit);
        p.setImageUrl(img);
        p.setDescription(desc);
        p.setNutritionalInformation(nutrition);
        p.setProductionDate(pDate);
        p.setExpiryDate(eDate);
        p.setActive(isActive);

        return p;
    }

}