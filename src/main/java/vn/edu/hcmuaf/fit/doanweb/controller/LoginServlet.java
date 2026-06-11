package vn.edu.hcmuaf.fit.doanweb.controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import vn.edu.hcmuaf.fit.doanweb.Cart.Cart;
import vn.edu.hcmuaf.fit.doanweb.Cart.CartItem;
import vn.edu.hcmuaf.fit.doanweb.dao.CartDao;
import vn.edu.hcmuaf.fit.doanweb.dao.PermissionDao;
import vn.edu.hcmuaf.fit.doanweb.dao.UserDao;
import vn.edu.hcmuaf.fit.doanweb.model.User;
import vn.edu.hcmuaf.fit.doanweb.utils.MD5Utils;

import java.io.IOException;
import java.util.List;

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
        request.setCharacterEncoding("UTF-8");
        String email = request.getParameter("email");
        String pass = request.getParameter("pass");
        String contextPath = request.getContextPath();

        email = email != null ? email.trim() : "";
        pass = pass != null ? pass.trim() : "";
        // Kiem tra email, mat khau co rong khong
        if (email.isEmpty() || pass.isEmpty()) {
            request.getSession().setAttribute("error", "Email và mật khẩu không được để trống");
            response.sendRedirect(contextPath + "/login");
            return;
        }

        String hashedPass = MD5Utils.encrypt(pass);

        UserDao userDao = new UserDao();
        User user = userDao.login(email, hashedPass);

        // Neu dang nhap thanh cong, luu thong tin nguoi dung vao session va chuyen huong den trang chu
        if (user != null) {
            if (user.getIsVerified() == 0) {
                request.getSession().setAttribute("error", "Tài khoản chưa được xác thực, vui lòng kiểm tra email để xác thực.");
                response.sendRedirect(contextPath + "/login");
                return;
            }

            if (!user.isActive()) {
                request.getSession().setAttribute("error", "Tài khoản của bạn đã bị khóa, vui lòng gửi mail để biết thêm chi tiết.");
                response.sendRedirect(contextPath + "/login");
                return;
            }

            HttpSession session = request.getSession();
            session.invalidate();
            session = request.getSession(true);
            session.setAttribute("auth", user);

            PermissionDao permissionDao = PermissionDao.getInstance();
            List<String> roles = permissionDao.getUserRoles(user.getId());
            List<String> permissions = permissionDao.getUserPermissions(user.getId());

            Cart dbCart = new Cart();
            CartDao cartDao = CartDao.getInstance();
            List<CartItem> dbCartItems = cartDao.getCartItemsByUserId(user.getId());
            if(dbCartItems != null) {
                for (CartItem item : dbCartItems) {
                    dbCart.addProduct(item.getProduct(), item.getQuantity());
                }
            }
            session.setAttribute("cart", dbCart);


            session.setAttribute("userRoles", roles);
            session.setAttribute("userPermissions", permissions);

            if (roles != null && (roles.contains("admin") || roles.contains("staff"))) {
                response.sendRedirect(contextPath + "/admin/dashboard");
            } else {
                response.sendRedirect(contextPath + "/home");
            }
        } else {
            request.getSession().setAttribute("error", "Bạn nhập sai Email hoặc Password");
            response.sendRedirect(contextPath+"/login");
        }
    }
}