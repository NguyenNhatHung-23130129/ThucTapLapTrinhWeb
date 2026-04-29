package vn.edu.hcmuaf.fit.doanweb.controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import vn.edu.hcmuaf.fit.doanweb.dao.UserDao;
import vn.edu.hcmuaf.fit.doanweb.model.User;
import java.io.IOException;

@WebServlet(name = "UserInforServlet", value = "/userinfor")
public class UserInforServlet extends HttpServlet {
    private final UserDao userDao = new UserDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("auth");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/Login.jsp");
            return;
        }
        request.getRequestDispatcher("/UserInfor.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("auth");

        if (user != null) {
            String newName = request.getParameter("name");
            String newPhone = request.getParameter("phone");

            if (newPhone == null || newPhone.trim().isEmpty()) {
                request.setAttribute("message", "Cập nhật thất bại: Vui lòng không để trống số điện thoại!");
            } else if (newPhone.matches("^(0|\\+84)(3|5|7|8|9)[0-9]{8}$")) {
                user.setName(newName);
                user.setPhone(newPhone);

                userDao.updateUser(user);

                session.setAttribute("auth", user);
                request.setAttribute("message", "Cập nhật thông tin thành công!");
            } else {
                request.setAttribute("message", "Cập nhật thất bại: Số điện thoại không hợp lệ!");
            }
        }
        doGet(request, response);
    }
}