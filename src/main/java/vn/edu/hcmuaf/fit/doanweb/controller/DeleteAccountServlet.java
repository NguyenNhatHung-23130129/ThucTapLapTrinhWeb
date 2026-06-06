package vn.edu.hcmuaf.fit.doanweb.controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import vn.edu.hcmuaf.fit.doanweb.dao.UserDao;
import vn.edu.hcmuaf.fit.doanweb.model.User;
import java.io.IOException;

@WebServlet(name = "DeleteAccountServlet", value = "/deleteaccount")
public class DeleteAccountServlet extends HttpServlet {
    private final UserDao userDao = new UserDao();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("auth");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }

        int userId = user.getId();

        if (userDao.isLastAdmin(userId)) {
            session.setAttribute("message", "Vô hiệu hóa thất bại: Bạn là Admin duy nhất của hệ thống, không thể đóng tài khoản này!");
            response.sendRedirect(request.getContextPath() + "/userinfor");
            return;
        }

        if (userDao.hasUnfinishedOrders(userId)) {
            session.setAttribute("message", "Vô hiệu hóa thất bại: Bạn đang có đơn hàng chưa hoàn tất. Vui lòng hoàn thành hoặc hủy đơn trước khi xóa tài khoản!");
            response.sendRedirect(request.getContextPath() + "/userinfor");
            return;
        }

        userDao.deleteUserById(userId);

        session.invalidate();

        HttpSession newSession = request.getSession(true);
        newSession.setAttribute("message", "Tài khoản của bạn đã được vô hiệu hóa thành công!");

        response.sendRedirect(request.getContextPath() + "/Login.jsp");
    }
}