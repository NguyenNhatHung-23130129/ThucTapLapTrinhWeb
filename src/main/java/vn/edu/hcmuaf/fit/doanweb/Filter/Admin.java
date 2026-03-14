package vn.edu.hcmuaf.fit.doanweb.Filter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.*;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import vn.edu.hcmuaf.fit.doanweb.model.User;
import vn.edu.hcmuaf.fit.doanweb.services.PermissionService;

import java.io.IOException;

@WebFilter(urlPatterns = {"/admin/*"})
public class Admin implements Filter {
    public void init(FilterConfig config) throws ServletException {
    }

    public void destroy() {
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws
            ServletException, IOException {
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        HttpSession session = httpRequest.getSession();
        String contextPath = httpRequest.getContextPath();

        //lay user da dang nhap tu session
        User auth = (User) session.getAttribute("auth");

        // kiem tra dang nhap
        if (auth == null) {
            httpResponse.sendRedirect(contextPath +"/login");
            return;
        }
        // kiem tra quyen admin
        if (auth.getRoleId() != 1 && auth.getRoleId() != 2) {
            httpResponse.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền truy cập Admin!");
            return;
        }
        // lay ten resource tu url
        String path = httpRequest.getServletPath();
        String resourceName = getResourceName(path);
        // kiem tra quyen truy cap resource
        int permission = PermissionService.getInstance().checkAccess(resourceName, auth.getId());
        

        if (permission == 0) {
            httpResponse.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền truy cập chức năng này!");
            return;
        }
        
       //kiem tra quyen them/sua/xoa theo action
        if ("POST".equalsIgnoreCase(httpRequest.getMethod())) {
            String action = httpRequest.getParameter("action");
            if (action != null) {
                if ("delete".equals(action) && permission < 3) {
                    httpResponse.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền xóa!");
                    return;
                }
                if (("add".equals(action) || "update".equals(action)) && permission < 2) {
                    httpResponse.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền thêm/sửa!");
                    return;
                }
            }
        }
        
        httpRequest.setAttribute("per", permission);

        chain.doFilter(request, response);
    }
    
    private String getResourceName(String path) {
        if (path.contains("/category")) {
            return "category_management";
        } else if (path.contains("/product")) {
            return "product_management";
        } else if (path.contains("/user")) {
            return "user_management";
        } else if (path.contains("/order")) {
            return "order_management";
        } else if (path.contains("/slideshow")) {
            return "slideshow_management";
        } else if (path.contains("/voucher")) {
            return "voucher_management";
        } else if (path.contains("/inventory")) {
            return "inventory_management";
        } else if (path.contains("voucher")) {
            return "voucher_management";
        } else if (path.contains("supplier")) {
            return "supplier_management";
        }
        return "dashboard_management";
    }
}