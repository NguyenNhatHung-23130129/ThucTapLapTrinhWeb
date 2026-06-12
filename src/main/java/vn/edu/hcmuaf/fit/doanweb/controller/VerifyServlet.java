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

        if (token == null || token.trim().isEmpty()) {
            response.sendRedirect(contextPath + "/signup?status=invalid_token");
            return;
        }

        if (userDao.verifyAccount(token)) {
            // Thanh cong -> Chuyen den trang LOGIN
            response.sendRedirect(contextPath + "/login?status=verified");
        } else {
            // That bai (sai token, het han qua 2 phut) -> Chuyen den trang SIGNUP
            response.sendRedirect(contextPath + "/signup?status=expired_or_invalid");
        }
    }
}