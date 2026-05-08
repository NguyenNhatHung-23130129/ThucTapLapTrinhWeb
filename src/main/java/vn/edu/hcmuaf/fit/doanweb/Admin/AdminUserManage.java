package vn.edu.hcmuaf.fit.doanweb.Admin;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import vn.edu.hcmuaf.fit.doanweb.dao.RolePermissionDao;
import vn.edu.hcmuaf.fit.doanweb.dao.UserDao;
import vn.edu.hcmuaf.fit.doanweb.model.User;
import vn.edu.hcmuaf.fit.doanweb.services.EmailService;
import vn.edu.hcmuaf.fit.doanweb.utils.MD5Utils;

import java.io.IOException;
import java.time.LocalDate;
import java.sql.Date;
import java.util.List;
import java.util.UUID;

@WebServlet(name = "AdminUserManage", value = "/admin/user")
public class AdminUserManage extends HttpServlet {

    UserDao userDao = new UserDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String search = request.getParameter("search");
        List<User> users;
        if (search != null && !search.trim().isEmpty()) {
            users = userDao.searchUsers(search.trim());
        } else {
            users = userDao.getAllUsers();
        }

        RolePermissionDao roleDao = new RolePermissionDao();
        request.setAttribute("roleList", roleDao.getAllRoles());

        request.setAttribute("searchKeyword", search);
        request.setAttribute("userList", users);
        request.setAttribute("activeTab", "users");
        request.getRequestDispatcher("Admin.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");

        if (action == null) action = "";

        switch (action) {
            case "add":
                addUser(request, response);
                break;
            case "delete":
                deleteUser(request, response);
                break;
            case "update":
                updateUser(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/admin/user");
        }
    }

    private void addUser(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String roleStr = request.getParameter("role_id");

        if (name == null || email == null) {
            response.sendRedirect(request.getContextPath() + "/admin/user");
            return;
        }

        if (userDao.checkEmailExist(email)) {
            response.sendRedirect(request.getContextPath() + "/admin/user?error=EmailExisted");
            return;
        }

        int roleId = 3;
        if (roleStr != null && !roleStr.isEmpty()) {
            try {
                roleId = Integer.parseInt(roleStr);
            } catch (NumberFormatException e) {
                roleId = 3;
            }
        }

        User u = new User();
        u.setName(name);
        u.setEmail(email);
        u.setPhone(phone);
        u.setRoleId(roleId);
        u.setCreatedAt(Date.valueOf(LocalDate.now()));
        u.setImageUrl("https://i.pinimg.com/736x/70/45/4f/70454fcbf7d745c7496b29ad5c1604b8.jpg");

        //ma hoa mat khau mac dinh
        String defaultPass = "Nguoidung123@";
        String hashedPass = MD5Utils.encrypt(defaultPass);
        u.setPassword(hashedPass);
        //  tao token xac nhan
        String token = UUID.randomUUID().toString();
        u.setVerificationToken(token);

        userDao.addUserFromAdmin(u);

        String scheme = request.getScheme();
        String serverName = request.getServerName();
        int serverPort = request.getServerPort();
        String contextPath = request.getContextPath();

        String verifyLink = scheme + "://" + serverName + ":" + serverPort + contextPath + "/verify?token=" + token;

        // thong bao qua email
        String subject = "Thông báo tạo tài khoản mới";
        String content = "<div style='font-family: Arial, sans-serif; padding: 20px; border: 1px solid #ddd;'>"
                + "<h2 style='color: #28a745;'>Chào mừng đến với Chay Tươi!</h2>"
                + "<p>Xin chào <strong>" + name + "</strong>,</p>"
                + "<p>Tài khoản của bạn đã được quản trị viên tạo thành công.</p>"
                + "<ul>"
                + "<li>Email đăng nhập: <strong>" + email + "</strong></li>"
                + "<li>Mật khẩu mặc định: <strong>" + defaultPass + "</strong></li>"
                + "</ul>"
                + "<p>Vui lòng nhấn vào nút dưới đây để kích hoạt tài khoản:</p>"
                + "<a href='" + verifyLink + "' style='background-color: #28a745; color: white; padding: 10px 20px; text-decoration: none; border-radius: 5px;'>Kích hoạt tài khoản</a>"
                + "</div>";

        new Thread(() -> {
            EmailService.send(email, subject, content);
        }).start();

        response.sendRedirect(request.getContextPath() + "/admin/user");
    }

    private void deleteUser(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String idStr = request.getParameter("id");
        if (idStr != null) {
            try {
                int id = Integer.parseInt(idStr);
                userDao.deleteUserById(id);
            } catch (NumberFormatException e) {
                e.printStackTrace();
            }
        }
        response.sendRedirect(request.getContextPath() + "/admin/user");
    }

    private void updateUser(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String idStr = request.getParameter("id");
        if(idStr == null || idStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/user");
            return;
        }

        int id = Integer.parseInt(idStr);
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String roleStr = request.getParameter("role_id"); // Lấy theo ID RBAC
        String activeStr = request.getParameter("active");

        boolean isActive = "1".equals(activeStr);

        int roleId = 3;
        if (roleStr != null && !roleStr.isEmpty()) {
            try {
                roleId = Integer.parseInt(roleStr);
            } catch (NumberFormatException e) {
                roleId = 3;
            }
        }

        User oldUser = userDao.getUserById(id);

        User u = new User();
        u.setId(id);
        u.setName(name);
        u.setEmail(email);
        u.setPhone(phone);
        u.setRoleId(roleId);
        u.setActive(isActive);

        userDao.updateUser(u);

        // Gửi email nếu tài khoản bị khóa
        if (oldUser != null && oldUser.isActive() && !isActive) {
            final String finalBlockReason = "Vi phạm tiêu chuẩn cộng đồng hoặc chính sách của Chay Tươi.";
            String subject = "Thông báo: Tài khoản của bạn đã bị khóa";
            String content = "<div style='font-family: Arial, sans-serif; padding: 20px; border: 1px solid #ddd; border-radius: 5px;'>"
                    + "<h2 style='color: #dc3545;'>Thông báo khóa tài khoản</h2>"
                    + "<p>Xin chào <strong>" + name + "</strong>,</p>"
                    + "<p>Tài khoản của bạn tại hệ thống <strong>Chay Tươi</strong> đã bị quản trị viên khóa.</p>"
                    + "<p style='padding: 10px; background-color: #f8d7da; border-left: 4px solid #dc3545; color: #721c24;'>"
                    + "<strong>Lý do khóa:</strong> " + finalBlockReason
                    + "</p>"
                    + "</div>";

            new Thread(() -> {
                EmailService.send(email, subject, content);
            }).start();
        }

      // huy quyen nang neu chinh nguoi dang nhap bi xoa hoac thay doi quyen
        HttpSession session = request.getSession();
        User loggedInUser = (User) session.getAttribute("auth");
        if(loggedInUser != null && loggedInUser.getId() == id) {
            session.removeAttribute("userRoles");
            session.removeAttribute("userPermissions");
        }

        response.sendRedirect(request.getContextPath() + "/admin/user");
    }
}