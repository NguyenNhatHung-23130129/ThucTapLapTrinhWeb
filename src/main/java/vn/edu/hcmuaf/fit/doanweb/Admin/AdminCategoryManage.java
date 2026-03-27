package vn.edu.hcmuaf.fit.doanweb.Admin;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import vn.edu.hcmuaf.fit.doanweb.dao.CategoryDao;
import vn.edu.hcmuaf.fit.doanweb.model.Category;
import vn.edu.hcmuaf.fit.doanweb.utils.CloudinaryUpload;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "CategoryServlet", value = "/admin/category")
@MultipartConfig(maxFileSize = 10 * 1024 * 1024)
public class AdminCategoryManage extends HttpServlet {
    CategoryDao categoryDao = new CategoryDao();


    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws
            ServletException, IOException {

        String search = request.getParameter("search");
        List<Category> list;
        if (search != null && !search.trim().isEmpty()) {

            list = categoryDao.searchCategories(search.trim());
        } else {
            list = categoryDao.getListCategory();
        }


        request.setAttribute("searchKeyword", search);
        request.setAttribute("categories", list);
        request.setAttribute("activeTab", "category");
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
                addCategory(request, response);
                break;
            case "update":
                updateCategory(request, response);
                break;
            case "delete":
                deleteCategory(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/admin/category");
        }
    }

    private void addCategory(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String imageUrl = CloudinaryUpload.handleUpload(request, "fileImage", "category", "image_url");
        request.setAttribute("cloudinary_url", imageUrl);
        String name = request.getParameter("name");
        String desc = request.getParameter("description");


        Category c = new Category(0, name, desc, imageUrl);
        categoryDao.insert(c);

        response.sendRedirect(request.getContextPath() + "/admin/category");
    }

    private void updateCategory(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String imageUrl = CloudinaryUpload.handleUpload(request, "fileImage", "category", "image_url");
        request.setAttribute("cloudinary_url", imageUrl);
        int id = Integer.parseInt(request.getParameter("id"));
        String name = request.getParameter("name");
        String desc = request.getParameter("description");

        Category c = new Category(id, name, desc, imageUrl);
        categoryDao.updateCategory(c);

        response.sendRedirect(request.getContextPath() + "/admin/category");
    }

    private void deleteCategory(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        int id = Integer.parseInt(request.getParameter("id"));

        if (categoryDao.hasProducts(id)) {
            request.setAttribute("errorMessage", "Không thể xóa! Danh mục này đang chứa sản phẩm.");
            doGet(request, response);
        } else {
            categoryDao.delete(id);
            response.sendRedirect(request.getContextPath() + "/admin/category");
        }
    }
}
