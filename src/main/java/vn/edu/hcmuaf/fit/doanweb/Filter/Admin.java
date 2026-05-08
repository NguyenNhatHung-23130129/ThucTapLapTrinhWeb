package vn.edu.hcmuaf.fit.doanweb.Filter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.*;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import vn.edu.hcmuaf.fit.doanweb.dao.PermissionDao;
import vn.edu.hcmuaf.fit.doanweb.model.User;

import java.io.IOException;
import java.util.List;

@WebFilter(urlPatterns = {"/admin/*"})
public class Admin implements Filter {
    public void init(FilterConfig config) throws ServletException {
    }

    public void destroy() {
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws ServletException, IOException {

        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        HttpSession session = httpRequest.getSession();

        User auth = (User) session.getAttribute("auth");

        if (auth == null) {
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/login");
            return;
        }

        PermissionDao permissionDao = PermissionDao.getInstance();

        List<String> roles = (List<String>) session.getAttribute("userRoles");
        List<String> permissions = (List<String>) session.getAttribute("userPermissions");

        if (roles == null || permissions == null) {
            roles = permissionDao.getUserRoles(auth.getId());
            permissions = permissionDao.getUserPermissions(auth.getId());
            session.setAttribute("userRoles", roles);
            session.setAttribute("userPermissions", permissions);
        }

        if (roles != null && roles.contains("admin")) {
            chain.doFilter(request, response);
            return;
        }

        if (roles == null || roles.isEmpty() || roles.contains("user")) {
            httpResponse.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền truy cập Admin!");
            return;
        }

        String path = httpRequest.getServletPath();
        String resource = getResourceName(path);
        if ("user_management".equals(resource) && "POST".equalsIgnoreCase(httpRequest.getMethod())) {
            String roleIdParam = httpRequest.getParameter("role_id");

            if ("1".equals(roleIdParam)) {
                permissionDao.logAudit(auth.getId(), "security.privilege_escalation_attempt",
                        "User tried to create/update an Admin account without permission.");

                httpResponse.sendError(HttpServletResponse.SC_FORBIDDEN,
                        "CẢNH BÁO BẢO MẬT: Bạn không có quyền cấp phát hoặc chỉnh sửa tài khoản Quản trị viên!");
                return;
            }
        }

        String action = "read";
        if ("POST".equalsIgnoreCase(httpRequest.getMethod())) {
            String actionParam = httpRequest.getParameter("action");
            if (actionParam != null) {
                if ("delete".equals(actionParam)) {
                    action = "delete";
                } else if ("add".equals(actionParam) || "create".equals(actionParam)) {
                    action = "create";
                } else if ("update".equals(actionParam) || "edit".equals(actionParam)) {
                    action = "update";
                }
            }
        }

        String requiredPermission = resource + "." + action;

        if (permissions == null || !permissions.contains(requiredPermission)) {
            permissionDao.logAudit(auth.getId(), "permission.denied", "Truy cập bị từ chối: " + requiredPermission);
            httpResponse.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền thực hiện hành động này!");
            return;
        }

        chain.doFilter(request, response);
    }

    private String getResourceName(String path) {
        if (path.startsWith("/admin/category"))
            return "category_management";
        if (path.startsWith("/admin/product"))
            return "product_management";
        if (path.startsWith("/admin/user"))
            return "user_management";
        if (path.startsWith("/admin/order"))
            return "order_management";
        if (path.startsWith("/admin/slideshow"))
            return "slideshow_management";
        if (path.startsWith("/admin/voucher"))
            return "voucher_management";
        if (path.startsWith("/admin/inventory"))
            return "inventory_management";
        if (path.startsWith("/admin/supplier"))
            return "supplier_management";
        if (path.startsWith("/admin/shipping"))
            return "shipping_management";
        if (path.startsWith("/admin/invoices"))
            return "invoices_management";
        if (path.startsWith("/admin/notification"))
            return "notification_management";

        return "dashboard_management";
    }
}