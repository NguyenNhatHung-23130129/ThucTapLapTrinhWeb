package vn.edu.hcmuaf.fit.doanweb.controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import vn.edu.hcmuaf.fit.doanweb.dao.UserDao;
import vn.edu.hcmuaf.fit.doanweb.utils.MD5Utils;

import java.io.IOException;

@WebServlet(name = "ResetPasswordServlet", value = "/resetpassword")
public class ResetPasswordServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("ResetPassword.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirm_password");
        HttpSession session = request.getSession();
        String email = (String) session.getAttribute("emailReset");
        String errorMessage = null;

        if (email == null) {
            response.sendRedirect(request.getContextPath() + "/forgotpassword");
            return;
        }

        if (password == null || password.trim().isEmpty()) {
            errorMessage = "Mật khẩu không được để trống.";
        } else if (password.length() < 8 || password.length() > 16) {
            errorMessage = "Mật khẩu phải có từ 8 ký tự đến 16 kí tự.";
        } else if (password.contains(" ")) {
            errorMessage = "Mật khẩu không được chứa khoảng trắng.";
        } else if (!password.matches(".*[A-Z].*")) {
            errorMessage = "Mật khẩu phải chứa ít nhất 1 chữ cái viết hoa.";
        } else if (!password.matches(".*[a-z].*")) {
            errorMessage = "Mật khẩu phải chứa ít nhất 1 chữ cái viết thường.";
        } else if (!password.matches(".*[0-9].*")) {
            errorMessage = "Mật khẩu phải chứa ít nhất 1 chữ số.";
        } else if (!password.matches(".*[@#$%^&+=!._-].*")) {
            errorMessage = "Mật khẩu phải chứa ít nhất 1 ký tự đặc biệt (@, #, $, ...).";
        } else if (!password.equals(confirmPassword)) {
            errorMessage = "Mật khẩu nhập lại không khớp.";
        }

        if (errorMessage != null) {
            request.setAttribute("error", errorMessage);
            request.getRequestDispatcher("ResetPassword.jsp").forward(request, response);
            return;
        }

        String hashedPassword = MD5Utils.encrypt(password);

        UserDao userDao = new UserDao();
        userDao.updatePassword(email, hashedPassword);

        session.removeAttribute("otp");
        session.removeAttribute("emailReset");

        response.sendRedirect(request.getContextPath() + "/login?status=reset_success");
    }
}