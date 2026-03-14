package vn.edu.hcmuaf.fit.doanweb.controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import vn.edu.hcmuaf.fit.doanweb.dao.UserDao;
import vn.edu.hcmuaf.fit.doanweb.model.User;
import vn.edu.hcmuaf.fit.doanweb.utils.MD5Utils;

import java.io.IOException;

@WebServlet(name = "LoginServlet", value = "/login")
public class LoginServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        if (session.getAttribute("error") != null) {
            request.setAttribute("error", session.getAttribute("error"));
            session.removeAttribute("error");
        }
        request.getRequestDispatcher("/Login.jsp").forward(request, response);
    }
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email = request.getParameter("email");
        String pass = request.getParameter("pass");
        String contextPath = request.getContextPath();

        String hashedPass = MD5Utils.encrypt(pass);

        UserDao userDao = new UserDao();
        User user = userDao.login(email, hashedPass);

        // Neu dang nhap thanh cong, luu thong tin nguoi dung vao session va chuyen huong den trang chu
        if (user != null) {
            HttpSession session = request.getSession();
            session.setAttribute("auth", user);
            if (user.getRoleId() == 1 || user.getRoleId() == 2) {
                //neu la admin thi ve trang quan tri
                response.sendRedirect(contextPath +"/admin/dashboard");
            } else {
                response.sendRedirect(contextPath+"/home");
            }
        } else {
            request.getSession().setAttribute("error", "Bạn nhập sai Email hoặc Password");
            response.sendRedirect(contextPath+"/login");
        }
    }
}