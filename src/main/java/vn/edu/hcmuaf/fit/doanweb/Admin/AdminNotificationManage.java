package vn.edu.hcmuaf.fit.doanweb.Admin;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import vn.edu.hcmuaf.fit.doanweb.dao.NotificationDao;
import vn.edu.hcmuaf.fit.doanweb.model.Notification;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "AdminNotificationManage", value = "/admin/notification")
public class AdminNotificationManage extends HttpServlet {
    NotificationDao notificationDao = new NotificationDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws
            ServletException, IOException {
        String search = request.getParameter("search");
        List<Notification> notificationList ;
        if (search != null && !search.trim().isEmpty()) {
            notificationList = notificationDao.searchNotifications(search.trim());
        } else {
            notificationList = notificationDao.getAllNotification();
        }
        request.setAttribute("searchKeyword", search);
        request.setAttribute("notifications", notificationList);

        request.setAttribute("activeTab", "notification");
        request.getRequestDispatcher("Admin.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws
            ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");

        if ("add".equals(action)) {
            Notification n = new Notification();
            n.setTitle(request.getParameter("title"));
            n.setContent(request.getParameter("content"));
            n.setType(request.getParameter("type"));

            String targetType = request.getParameter("targetType");
            n.setTargetType(targetType);

            if ("user".equals(targetType)) {
                try {
                    n.setTargetId(Integer.parseInt(request.getParameter("targetId")));
                } catch (NumberFormatException e) {
                    n.setTargetId(null);
                }
            }

            notificationDao.insertNotification(n);

            response.sendRedirect(request.getContextPath() + "/admin/notification");
        }
    }

}