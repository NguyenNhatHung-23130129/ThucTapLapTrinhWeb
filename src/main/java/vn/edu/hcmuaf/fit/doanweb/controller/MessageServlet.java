package vn.edu.hcmuaf.fit.doanweb.controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import vn.edu.hcmuaf.fit.doanweb.dao.MessageDao;
import vn.edu.hcmuaf.fit.doanweb.model.User;

@WebServlet(name = "MessageServlet", value = "/post-message")
public class MessageServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("auth");
        if (user != null) {
            try {
                int reviewId = Integer.parseInt(request.getParameter("reviewId"));
                int productId = Integer.parseInt(request.getParameter("productId"));
                String message = request.getParameter("message");
                MessageDao messageDao = new MessageDao();
                messageDao.insertMessage(reviewId, user.getId(), message);
                response.sendRedirect("productdetails?id=" + productId + "#review-section");
            } catch (Exception e) {
                e.printStackTrace();
                response.setContentType("text/plain;charset=UTF-8");
                response.getWriter().write("LỖI GỬI TRẢ LỜI: " + e.toString());
            }

        } else {
            response.sendRedirect("login");
        }
    }
}