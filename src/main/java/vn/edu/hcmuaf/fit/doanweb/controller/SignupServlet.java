package vn.edu.hcmuaf.fit.doanweb.controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import vn.edu.hcmuaf.fit.doanweb.dao.UserDao;
import vn.edu.hcmuaf.fit.doanweb.model.User;
import vn.edu.hcmuaf.fit.doanweb.services.EmailService;
import vn.edu.hcmuaf.fit.doanweb.utils.MD5Utils;

import java.io.IOException;
import java.util.UUID;

@WebServlet(name = "SignupServlet", value = "/signup")
public class SignupServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("SignUp.jsp").forward(request, response);
    }
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirm_password");

        String errorMessage = null;

        if (email == null || !email.contains("@")) {
            errorMessage = "Email không hợp lệ.";
        } else if (password == null || password.trim().isEmpty()) {
                errorMessage = "Mật khẩu không được để trống.";
        } else if (password.length() < 8 || password.length() > 16 ) {
            errorMessage = "Mật khẩu phải có từ 8 ký tự đến 16 kí tự.";
        } else if (!password.matches(".*[A-Z].*"))  {
            errorMessage = "Mật khẩu phải chứa ít nhất 1 chữ cái viết hoa.";
        } else if (!password.matches(".*[a-z].*")) {
            errorMessage = "Mật khẩu phải chứa ít nhất 1 chữ cái viết thường.";
        } else if (!password.matches(".*[0-9].*")) {
            errorMessage = "Mật khẩu phải chứa ít nhất 1 chữ số.";
        } else if (password.contains(" ")) {
            errorMessage = "Mật khẩu không được chứa khoảng trắng.";
        } else if (!password.matches(".*[@#$%^&+=!._-].*")) {
            errorMessage = "Mật khẩu phải chứa ít nhất 1 ký tự đặc biệt";
        } else if (!password.equals(confirmPassword)) {
            errorMessage = "Mật khẩu nhập lại không khớp.";
        }

        // Neu co loi, chuyen ve trang dang ky va hien thi loi
        if (errorMessage != null) {
            request.setAttribute("error", errorMessage);
            request.setAttribute("email", email);
            request.getRequestDispatcher("SignUp.jsp").forward(request, response);
        } else {
            UserDao userDao = new UserDao();

            if (userDao.checkEmailExist(email)) {
                request.setAttribute("error", "Email này đã được đăng ký!");
                request.setAttribute("email", email);
                request.getRequestDispatcher("SignUp.jsp").forward(request, response);
            } else {
                String token = UUID.randomUUID().toString();
                String name = email.split("@")[0];

                // Ma hoa mat khau bang MD5 truoc khi luu vao database
                String hashedPassword = MD5Utils.encrypt(password);

                User newUser = new User(email, hashedPassword, token);
                newUser.setName(name);
                userDao.register(newUser);

                String link = "http://localhost:8080" + request.getContextPath() + "/verify?token=" + token;
                String msg = "<div style='font-family: Arial, sans-serif; padding: 20px; border: 1px solid #e0e0e0; border-radius: 10px; max-width: 500px; margin: auto; background-color: #f9f9f9;'>"
                        + "<h2 style='color: #2c3e50; text-align: center;'>Xác thực tài khoản</h2>"
                        + "<p>Xin chào <strong>" + name + "</strong>,</p>"
                        + "<p>Cảm ơn bạn đã đăng ký tài khoản tại Chay Tươi. Vui lòng nhấn vào nút bên dưới để kích hoạt tài khoản của bạn:</p>"
                        + "<div style='text-align: center; margin: 30px 0;'>"
                        + "<a href='" + link + "' style='background-color: #27ae60; color: white; padding: 12px 25px; text-decoration: none; border-radius: 5px; font-weight: bold; font-size: 16px;'>KÍCH HOẠT TÀI KHOẢN</a>"
                        + "</div>"
                        + "<p style='font-size: 12px; color: #7f8c8d; text-align: center;'>Nếu nút trên không hoạt động, hãy nhấp vào link này: <a href='" + link + "'>" + link + "</a></p>"
                        + "</div>";
                EmailService.send(email, "Xác thực tài khoản", msg);

                request.setAttribute("error", "Đăng ký thành công! Vui lòng kiểm tra email để kích hoạt.");
                request.getRequestDispatcher("SignUp.jsp").forward(request, response);
            }
        }
    }
}