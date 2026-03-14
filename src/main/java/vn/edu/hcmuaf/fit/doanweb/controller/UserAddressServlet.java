package vn.edu.hcmuaf.fit.doanweb.controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import vn.edu.hcmuaf.fit.doanweb.dao.UserAddressDao;
import vn.edu.hcmuaf.fit.doanweb.model.User;

import java.io.IOException;

@WebServlet(name = "UserAddressServlet", value = "/useraddress")
public class UserAddressServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");
        if (action == null) action = "";

        UserAddressDao dao = new UserAddressDao();
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("auth");

        if (user == null) {
            response.sendRedirect("Login.jsp");
            return;
        }

        switch (action) {
            //  Them dia chi moi
            case "add":
                String newAddr = request.getParameter("address");
                String newWard = request.getParameter("ward");
                String newCity = request.getParameter("city");
                dao.addAddress(user.getId(), newAddr, newWard, newCity);
                session.setAttribute("message", "Thêm địa chỉ mới thành công!");
                break;
            // Cap nhat dia chi
            case "update":
                int updateId = Integer.parseInt(request.getParameter("id"));
                String upAddr = request.getParameter("address");
                String upWard = request.getParameter("ward");
                String upCity = request.getParameter("city");
                dao.updateAddress(updateId, upAddr, upWard, upCity);
                session.setAttribute("message", "Cập nhật địa chỉ thành công!");
                break;
            // Xoa dia chi
            case "delete":
                int deleteId = Integer.parseInt(request.getParameter("id"));
                dao.deleteAddress(deleteId);
                session.setAttribute("message", "Đã xóa địa chỉ!");
                break;
        }

        response.sendRedirect("userInfor");
    }
}