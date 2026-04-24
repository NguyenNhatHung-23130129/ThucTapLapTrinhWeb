package vn.edu.hcmuaf.fit.doanweb.controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import vn.edu.hcmuaf.fit.doanweb.dao.UserDao;
import vn.edu.hcmuaf.fit.doanweb.model.User;
import vn.edu.hcmuaf.fit.doanweb.utils.MD5Utils;

import java.io.IOException;

@WebServlet(name = "ChangePasswordServlet", value = "/changepassword")
public class ChangePasswordServlet extends HttpServlet {
    private final UserDao userDao = new UserDao();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User auth = (User) session.getAttribute("auth");

        if (auth == null) {
            response.sendRedirect(request.getContextPath() + "/Login.jsp");
            return;
        }

        String currentPassword = request.getParameter("current_password");
        String newPassword = request.getParameter("new_password");
        String confirmPassword = request.getParameter("confirm_new_password");

        String hashedCurrent = MD5Utils.encrypt(currentPassword);
        if (!hashedCurrent.equals(auth.getPassword())) {
            request.setAttribute("message", "Thất bại: Mật khẩu hiện tại không chính xác!");
            request.getRequestDispatcher("/UserInfor.jsp").forward(request, response);
            return;
        }

        String errorMessage = validatePassword(newPassword, confirmPassword);
        if (errorMessage != null) {
            request.setAttribute("message", "Thất bại: " + errorMessage);
            request.getRequestDispatcher("/UserInfor.jsp").forward(request, response);
            return;
        }

        String hashedNew = MD5Utils.encrypt(newPassword);
        userDao.updatePassword(auth.getEmail(), hashedNew);

        auth.setPassword(hashedNew);
        session.setAttribute("auth", auth);

        request.setAttribute("message", "Đổi mật khẩu thành công!");
        request.getRequestDispatcher("/UserInfor.jsp").forward(request, response);
    }

    private String validatePassword(String password, String confirmPassword) {
        if (password == null || password.trim().isEmpty()) return "Mật khẩu không được để trống.";
        if (password.length() < 8 || password.length() > 16) return "Mật khẩu phải từ 8-16 ký tự.";
        if (password.contains(" ")) return "Mật khẩu không được chứa khoảng trắng.";
        if (!password.matches(".*[A-Z].*")) return "Mật khẩu phải chứa ít nhất 1 chữ cái viết hoa.";
        if (!password.matches(".*[a-z].*")) return "Mật khẩu phải chứa ít nhất 1 chữ cái viết thường.";
        if (!password.matches(".*[0-9].*")) return "Mật khẩu phải chứa ít nhất 1 chữ số.";
        if (!password.matches(".*[@#$%^&+=!._-].*")) return "Mật khẩu phải chứa ít nhất 1 ký tự đặc biệt.";
        if (!password.equals(confirmPassword)) return "Mật khẩu xác nhận không khớp.";
        return null;
    }
}