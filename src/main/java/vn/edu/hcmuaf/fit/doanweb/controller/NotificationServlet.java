package vn.edu.hcmuaf.fit.doanweb.controller;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import vn.edu.hcmuaf.fit.doanweb.dao.NotificationDao;
import vn.edu.hcmuaf.fit.doanweb.model.Notification;
import vn.edu.hcmuaf.fit.doanweb.model.User;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet(name = "NotificationServlet", value = "/api/notifications")
public class NotificationServlet extends HttpServlet {

    private final NotificationDao notificationDao = new NotificationDao();
    private final Gson gson = new GsonBuilder().setDateFormat("yyyy-MM-dd HH:mm:ss").create();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        Object authObj = (session != null) ? session.getAttribute("auth") : null;

        if (authObj == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }

        User auth = (User) authObj;
        int userId = auth.getId();

        int unreadCount = notificationDao.countUnreadByUser(userId);
        List<Notification> notifications = notificationDao.getNotiByUser(userId);

        Map<String, Object> responseData = new HashMap<>();
        responseData.put("unreadCount", unreadCount);
        responseData.put("notifications", notifications);

        response.setContentType("application/json;charset=UTF-8");
        response.getWriter().print(gson.toJson(responseData));
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    }
}