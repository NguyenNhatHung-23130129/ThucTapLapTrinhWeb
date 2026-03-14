package vn.edu.hcmuaf.fit.doanweb.controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import vn.edu.hcmuaf.fit.doanweb.dao.UserVoucherDao;
import vn.edu.hcmuaf.fit.doanweb.dao.VoucherDao;
import vn.edu.hcmuaf.fit.doanweb.model.User;
import vn.edu.hcmuaf.fit.doanweb.model.Voucher;

import java.util.ArrayList;
import java.util.List;
import java.io.IOException;

@WebServlet(name = "VoucherServlet", value = "/voucher")
public class VoucherServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Lay danh sach voucher tu database
        List<Voucher> listVoucher = VoucherDao.getInstance().getAvailableVouchers();
        request.setAttribute("listVoucher", listVoucher);

        // Lay thong tin nguoi dung tu session
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("auth");

        List<Voucher> savedList = new ArrayList<>();

        // Lay danh sach voucher da luu cua nguoi dung
        if (user != null) {
            savedList = UserVoucherDao.getInstance().getVouchersByUserId(user.getId());
        }

        request.setAttribute("listSavedVoucher", savedList);

        // Chuyen huong den trang Voucher.jsp
        request.getRequestDispatcher("Voucher.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }
}