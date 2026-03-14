package vn.edu.hcmuaf.fit.doanweb.controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import vn.edu.hcmuaf.fit.doanweb.model.User;

import java.io.IOException;

@WebServlet(name = "AdminServlet", value = "/admin")
public class AdminServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws
            ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = (session !=null) ? (User) session.getAttribute("auth"): null;
        if(user == null){
            response.sendRedirect("login");
            return;
        }
        if(user.getRoleId() != 1){
            response.sendRedirect("home");
            return;
        }
        String kind = request.getParameter("kind");
        if(kind == null){
            kind = "dashboard";
        }
        request.setAttribute("activeTab", kind);
        request.getRequestDispatcher("Admin.jsp").forward(request,response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws
            ServletException, IOException {
    }
}