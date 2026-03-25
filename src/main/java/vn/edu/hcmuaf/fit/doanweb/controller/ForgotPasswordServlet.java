package vn.edu.hcmuaf.fit.doanweb.controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import vn.edu.hcmuaf.fit.doanweb.dao.UserDao;
import vn.edu.hcmuaf.fit.doanweb.services.EmailService;

import java.io.IOException;
import java.util.Random;

@WebServlet(name = "ForgotPasswordServlet", value = "/forgotpassword")
public class ForgotPasswordServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("ForgotPassword.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email = request.getParameter("email");
        UserDao userDao = new UserDao();

        if (userDao.checkEmailExist(email)) {
            Random rnd = new Random();
            int number = rnd.nextInt(999999);
            String otp = String.format("%06d", number);

            String subject = "Mã xác thực Quên Mật Khẩu - Chay Tươi";
            String body = "<h3>Mã OTP của bạn là: <span style='color:red'>" + otp + "</span></h3>" +
                    "<p>Mã này sẽ hết hạn sau 2 phút.</p>";

            new Thread(() -> EmailService.send(email, subject, body)).start();

            HttpSession session = request.getSession();
            session.setAttribute("otp", otp);
            session.setAttribute("emailReset", email);
            session.setMaxInactiveInterval(120);

            response.sendRedirect(request.getContextPath() + "/validateotp");
        } else {
            request.setAttribute("error", "Email này chưa được đăng ký!");
            request.getRequestDispatcher("ForgotPassword.jsp").forward(request, response);
        }
    }
}