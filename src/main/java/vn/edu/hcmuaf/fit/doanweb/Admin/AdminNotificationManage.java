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
        List<Notification> notificationList = notificationDao.getAllNotification();
        request.setAttribute("notifications", notificationList);

     request.setAttribute("activeTab", "notification");
        request.getRequestDispatcher("Admin.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws
            ServletException, IOException {
    }
}