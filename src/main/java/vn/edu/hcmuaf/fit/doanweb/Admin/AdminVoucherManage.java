package vn.edu.hcmuaf.fit.doanweb.Admin;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import vn.edu.hcmuaf.fit.doanweb.dao.CategoryDao;
import vn.edu.hcmuaf.fit.doanweb.dao.ProductDao;
import vn.edu.hcmuaf.fit.doanweb.dao.VoucherDao;
import vn.edu.hcmuaf.fit.doanweb.model.Category;
import vn.edu.hcmuaf.fit.doanweb.model.Product;
import vn.edu.hcmuaf.fit.doanweb.model.Voucher;
import vn.edu.hcmuaf.fit.doanweb.utils.ValidateDate;

import java.io.IOException;
import java.sql.Date;
import java.util.List;

@WebServlet(name = "AdminVoucherManage", value = "/admin/voucher")
public class AdminVoucherManage extends HttpServlet {
    private final VoucherDao voucherDao = new VoucherDao();
    private final ProductDao productDao = new ProductDao();
    private final CategoryDao categoryDao = new CategoryDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<Product> products = productDao.getAllProducts();
        List<Category> categories = categoryDao.getListCategory();
        String search = request.getParameter("search");
        List<Voucher> vouchers;

        if (search != null && !search.trim().isEmpty()) {
            vouchers = voucherDao.searchVouchers(search.trim());
        } else {
            vouchers = voucherDao.getAllVouchers();
        }

        request.setAttribute("productList", products);
        request.setAttribute("categoryList", categories);
        request.setAttribute("searchKeyword", search);
        request.setAttribute("voucherList", vouchers);
        request.setAttribute("activeTab", "vouchers");

        request.getRequestDispatcher("Admin.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        if (action == null) action = "";

        try {
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
        } catch (RuntimeException e) {
            // Bat loi nghiep vu, quang ve JSP de hien thi
            request.setAttribute("errorMsg", e.getMessage());
            doGet(request, response);
        }
    }

    private void addVoucher(HttpServletRequest request, HttpServletResponse response) throws IOException {
        Voucher v = getVoucherForm(request);
        voucherDao.insertVoucher(v);
        request.getSession().setAttribute("successMsg", "Thêm mã giảm giá thành công!");
        response.sendRedirect(request.getContextPath() + "/admin/voucher");
    }

    private void updateVoucher(HttpServletRequest request, HttpServletResponse response) throws IOException {
        Voucher v = getVoucherForm(request);
        int id = parseIntSafe(request.getParameter("id"));
        v.setId(id);
        voucherDao.updateVoucher(v);
        request.getSession().setAttribute("successMsg", "Cập nhật mã giảm giá thành công!");
        response.sendRedirect(request.getContextPath() + "/admin/voucher");
    }

    private void deleteVoucher(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int id = parseIntSafe(request.getParameter("id"));
        voucherDao.deleteVoucher(id);
        request.getSession().setAttribute("successMsg", "Đã xóa mã giảm giá!");
        response.sendRedirect(request.getContextPath() + "/admin/voucher");
    }

    // --- CORE LOGIC: Parse Form an toan ---
    private Voucher getVoucherForm(HttpServletRequest request) {
        Voucher v = new Voucher();
        v.setVoucherCode(request.getParameter("voucherCode"));
        v.setTitle(request.getParameter("title"));
        v.setDescription(request.getParameter("description"));
        v.setType(request.getParameter("type"));

        // Xu ly scope (Chuyen List String array thanh 1 string cach nhau boi dau phay)
        String applyScope = request.getParameter("applyScope");
        if ("specific".equals(applyScope)) {
            String[] selectedIds = request.getParameterValues("selected_products");
            if (selectedIds != null && selectedIds.length > 0) {
                v.setApplyScope(String.join(",", selectedIds)); // Luu xuong thanh "12,45,67"
            } else {
                v.setApplyScope("all"); // Fallback
            }
        } else {
            v.setApplyScope("all");
        }

        // Null-safe parsing
        v.setValue(parseDoubleSafe(request.getParameter("value")));
        v.setMinOrderValue(parseDoubleSafe(request.getParameter("minOrderValue")));

        // Neu loai la "Tien mat" thi khong co gia tri giam toi da
        if ("Tiền mặt".equals(v.getType())) {
            v.setMaxDiscountAmount(0);
        } else {
            v.setMaxDiscountAmount(parseDoubleSafe(request.getParameter("maxDiscountAmount")));
        }

        // Validate Ngay
        Date startDate = Date.valueOf(request.getParameter("startDate"));
        Date endDate = Date.valueOf(request.getParameter("endDate"));
        String dateError = ValidateDate.validateDateRange(startDate, endDate, "Lỗi: Ngày kết thúc phải sau hoặc bằng ngày bắt đầu!");
        if (dateError != null) {
            throw new RuntimeException(dateError);
        }
        v.setStartDate(startDate);
        v.setEndDate(endDate);

        v.setUsageLimit(parseIntSafe(request.getParameter("usageLimit")));
        v.setLimitPerUser(parseIntSafe(request.getParameter("limitPerUser")));
        v.setIsActive(parseIntSafe(request.getParameter("isActive")));

        return v;
    }

    private double parseDoubleSafe(String val) {
        if (val == null || val.trim().isEmpty()) return 0.0;
        try {
            return Double.parseDouble(val.trim());
        } catch (Exception e) {
            return 0.0;
        }
    }

    private int parseIntSafe(String val) {
        if (val == null || val.trim().isEmpty()) return 0;
        try {
            return Integer.parseInt(val.trim());
        } catch (Exception e) {
            return 0;
        }
    }
}