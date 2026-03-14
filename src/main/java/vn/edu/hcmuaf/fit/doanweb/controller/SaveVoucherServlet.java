package vn.edu.hcmuaf.fit.doanweb.controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import vn.edu.hcmuaf.fit.doanweb.dao.UserVoucherDao;
import vn.edu.hcmuaf.fit.doanweb.model.User;

import java.io.IOException;

@WebServlet(name = "SaveVoucherServlet", value = "/savevoucher")
public class SaveVoucherServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/plain; charset=UTF-8");

        HttpSession session = request.getSession();

        User user = (User) session.getAttribute("auth");

        if (user == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().write("Bạn cần đăng nhập để lưu voucher.");
            return;
        }

        String voucherCode = request.getParameter("voucherCode");

        if (voucherCode == null || voucherCode.trim().isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        int userId = user.getId();

        boolean isSaved = UserVoucherDao.getInstance().saveUserVoucher(userId, voucherCode);

        if (isSaved) {
            response.setStatus(HttpServletResponse.SC_OK);
            response.getWriter().write("Lưu thành công");
        } else {

            response.setStatus(HttpServletResponse.SC_CONFLICT);
            response.getWriter().write("Voucher này đã được lưu trước đó.");
        }
    }
}