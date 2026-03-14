package vn.edu.hcmuaf.fit.doanweb.controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import vn.edu.hcmuaf.fit.doanweb.dao.UserAddressDao;
import vn.edu.hcmuaf.fit.doanweb.model.User;
import vn.edu.hcmuaf.fit.doanweb.model.UserAdderss;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "UserInforServlet", value = "/userinfor")
public class UserInforServlet extends HttpServlet {
    private final UserAddressDao userAddressDao = new UserAddressDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("auth");

        if (user == null) {
            response.sendRedirect("Login.jsp");
            return;
        }

        List<UserAdderss> addresses = userAddressDao.getAllAddressesByUserId(user.getId());

        request.setAttribute("addresses", addresses);
        request.getRequestDispatcher("UserInfor.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("auth");

        if (user != null) {
            String newName = request.getParameter("name");
            String newPhone = request.getParameter("phone");

            user.setName(newName);
            user.setPhone(newPhone);

            userAddressDao.updateUserInfor(user);

            session.setAttribute("auth", user);
            request.setAttribute("message", "Cập nhật thông tin thành công!");
        }
        doGet(request, response);
    }
}