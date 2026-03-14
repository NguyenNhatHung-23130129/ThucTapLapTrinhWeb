package vn.edu.hcmuaf.fit.doanweb.Admin;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import vn.edu.hcmuaf.fit.doanweb.dao.CategoryDao;
import vn.edu.hcmuaf.fit.doanweb.dao.ProductDao;
import vn.edu.hcmuaf.fit.doanweb.dao.VoucherDao;
import vn.edu.hcmuaf.fit.doanweb.model.Category;
import vn.edu.hcmuaf.fit.doanweb.model.Product;
import vn.edu.hcmuaf.fit.doanweb.model.User;
import vn.edu.hcmuaf.fit.doanweb.model.Voucher;
import vn.edu.hcmuaf.fit.doanweb.services.PermissionService;

import java.io.IOException;
import java.sql.Date;
import java.util.List;

@WebServlet(name = "AdminVoucherManage", value = "/admin/voucher")
public class AdminVoucherManage extends HttpServlet {
    VoucherDao voucherDao = new VoucherDao();
    ProductDao productDao = new ProductDao();
    CategoryDao categoryDao = new CategoryDao();



    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws
            ServletException, IOException {

        List<Product> products = productDao.getAllProducts();
        request.setAttribute("productList", products);
        List<Category> categories = categoryDao.getListCategory();

         String search = request.getParameter("search");
        List<Voucher> vouchers ;
        if (search != null && !search.trim().isEmpty()) {
            vouchers = voucherDao.searchVouchers(search.trim());
        } else {
            vouchers = voucherDao.getAllVouchers();
        }
        request.setAttribute("searchKeyword", search);
        request.setAttribute("voucherList", vouchers);




        request.setAttribute("categoryList", categories);
        request.setAttribute("activeTab", "vouchers");
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
                addVoucher(request, response);
                break;
            case "update":
                updateVoucher(request, response);
                break;
            case "delete":
                deleteVoucher(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/admin/voucher");
                break;
        }
    }

    private void deleteVoucher(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        voucherDao.deleteVoucher(id);
        response.sendRedirect(request.getContextPath() + "/admin/voucher");
    }

    private void updateVoucher(HttpServletRequest request, HttpServletResponse response) throws IOException {
        Voucher v = getVoucherForm(request);
        int id = Integer.parseInt(request.getParameter("id"));
        v.setId(id);
        voucherDao.updateVoucher(v);
        response.sendRedirect(request.getContextPath() + "/admin/voucher");

    }

    private void addVoucher(HttpServletRequest request, HttpServletResponse response) throws
            ServletException, IOException {
        Voucher v = getVoucherForm(request);
        voucherDao.insertVoucher(v);
        response.sendRedirect(request.getContextPath() + "/admin/voucher");


    }

    private Voucher getVoucherForm(HttpServletRequest request) {
        String voucherCode = request.getParameter("voucherCode");
        String title = request.getParameter("title");
        String description = request.getParameter("description");
        String type = request.getParameter("type");
        String applyScope = request.getParameter("applyScope");

        double value = Double.parseDouble(request.getParameter("value"));
        double minOrderValue = Double.parseDouble(request.getParameter("minOrderValue"));
        double maxDiscountAmount = Double.parseDouble(request.getParameter("maxDiscountAmount"));
        Date startDate = Date.valueOf(request.getParameter("startDate"));
        Date endDate = Date.valueOf(request.getParameter("endDate"));
        int usageLimit = Integer.parseInt(request.getParameter("usageLimit"));
        int limitPerUser = Integer.parseInt(request.getParameter("limitPerUser"));
        int isActive = Integer.parseInt(request.getParameter("isActive"));


        Voucher v = new Voucher();
        v.setVoucherCode(voucherCode);
        v.setTitle(title);
        v.setDescription(description);
        v.setType(type);
        v.setApplyScope(applyScope);
        v.setValue(value);
        v.setMinOrderValue(minOrderValue);
        v.setMaxDiscountAmount(maxDiscountAmount);
        v.setStartDate(startDate);
        v.setEndDate(endDate);
        v.setUsageLimit(usageLimit);
        v.setLimitPerUser(limitPerUser);
        v.setIsActive(isActive);

        if ("specific".equals(applyScope)) {
            String[] selectedIds = request.getParameterValues("selected_products");
            if (selectedIds != null) {
                for (String id : selectedIds) {
                    v.addAppliedProductId(id);
                }
            }
        }

        return v;
    }


}