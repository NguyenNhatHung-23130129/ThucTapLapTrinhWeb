package vn.edu.hcmuaf.fit.doanweb.Admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import vn.edu.hcmuaf.fit.doanweb.dao.RolePermissionDao;
import vn.edu.hcmuaf.fit.doanweb.model.Permission;
import vn.edu.hcmuaf.fit.doanweb.model.Role;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "AdminRoleManage", value = "/admin/role")
public class AdminRoleManage extends HttpServlet {

    RolePermissionDao dao = new RolePermissionDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<Role> roles = dao.getAllRoles();
        List<Permission> permissions = dao.getAllPermissions();


        int activeRoleId = roles.isEmpty() ? 0 : roles.get(0).getId();
        String roleIdStr = request.getParameter("id");
        if (roleIdStr != null && !roleIdStr.isEmpty()) {
            try {
                activeRoleId = Integer.parseInt(roleIdStr);
            } catch (NumberFormatException ignored) {}
        }

        List<Integer> activePermIds = dao.getPermissionIdsByRole(activeRoleId);

        request.setAttribute("roles", roles);
        request.setAttribute("permissions", permissions);
        request.setAttribute("activeRoleId", activeRoleId);
        request.setAttribute("activePermIds", activePermIds);
        request.setAttribute("activeTab", "roles");

        request.getRequestDispatcher("Admin.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        String roleIdStr = request.getParameter("role_id");
        String[] permissionIdStrs = request.getParameterValues("permissionIds");

        if (roleIdStr != null && !roleIdStr.isEmpty()) {
            try {
                int roleId = Integer.parseInt(roleIdStr);
                List<Integer> permissionIds = new ArrayList<>();

                if (permissionIdStrs != null) {
                    for (String pId : permissionIdStrs) {
                        permissionIds.add(Integer.parseInt(pId));
                    }
                }

                dao.updateRolePermissions(roleId, permissionIds);

            } catch (NumberFormatException e) {
                e.printStackTrace();
            }
        }

        response.sendRedirect(request.getContextPath() + "/admin/role?id=" + roleIdStr + "&success=1");
    }
}