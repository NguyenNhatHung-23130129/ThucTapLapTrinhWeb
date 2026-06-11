package vn.edu.hcmuaf.fit.doanweb.controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import vn.edu.hcmuaf.fit.doanweb.dao.UserDao;
import vn.edu.hcmuaf.fit.doanweb.model.User;
import vn.edu.hcmuaf.fit.doanweb.utils.CloudinaryUpload;
import java.io.IOException;

@WebServlet(name = "UserInforServlet", value = "/userinfor")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024,
        maxFileSize = 1024 * 1024 * 5,
        maxRequestSize = 1024 * 1024 * 10
)
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

        String roleName = userDao.getRoleNameById(user.getRoleId());
        request.setAttribute("roleName", roleName);

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
            String avatarUrl = CloudinaryUpload.handleUpload(request, "avatar", "avatars", "old_avatar");

            if (newPhone == null || newPhone.trim().isEmpty()) {
                request.setAttribute("message", "Cập nhật thất bại: Vui lòng không để trống số điện thoại!");
            } else if (newPhone.matches("^(0|\\+84)(3|5|7|8|9)[0-9]{8}$")) {
                user.setName(newName);
                user.setPhone(newPhone);
                user.setImageUrl(avatarUrl);

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