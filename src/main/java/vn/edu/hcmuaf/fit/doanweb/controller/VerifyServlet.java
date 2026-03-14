package vn.edu.hcmuaf.fit.doanweb.controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import vn.edu.hcmuaf.fit.doanweb.dao.UserDao;
import java.io.IOException;

@WebServlet(name = "VerifyServlet", value = "/verify")
public class VerifyServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String token = request.getParameter("token");
        UserDao userDao = new UserDao();

        String contextPath = request.getContextPath();

        if (token != null && userDao.verifyAccount(token)) {
            // Thanh cong -> Chuyen den trang LOGIN
            response.sendRedirect(contextPath + "/login?status=verified");
        } else {
            // That bai -> Chuyen den trang SIGNUP
            response.sendRedirect(contextPath + "/signup?status=verify_failed");
        }
    }
}