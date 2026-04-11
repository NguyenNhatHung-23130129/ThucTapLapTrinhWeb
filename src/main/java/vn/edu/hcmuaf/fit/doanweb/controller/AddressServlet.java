package vn.edu.hcmuaf.fit.doanweb.controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import vn.edu.hcmuaf.fit.doanweb.dao.UserAddressDao;
import vn.edu.hcmuaf.fit.doanweb.model.User;
import vn.edu.hcmuaf.fit.doanweb.model.UserAdderss;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "AddressServlet", value = "/address")
public class AddressServlet extends HttpServlet {
    private UserAddressDao addressDao = new UserAddressDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("auth");
        if (user == null) {
            response.sendRedirect("login");
            return;
        }
        request.setAttribute("returnTo", request.getParameter("returnTo"));

        List<UserAdderss> list = addressDao.getAllAddressesByUserId(user.getId());
        request.setAttribute("addresses", list);
        request.getRequestDispatcher("Address.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("auth");
        if (user == null) return;

        String action = request.getParameter("action");
        String returnTo = request.getParameter("returnTo");

        if ("add".equals(action)) {
            String address = request.getParameter("address");
            String ward = request.getParameter("ward");
            String city = request.getParameter("city");
            addressDao.addAddress(user.getId(), address, ward, city);
        } else if ("setDefault".equals(action)) {
            int addrId = Integer.parseInt(request.getParameter("addressId"));
            addressDao.setDefaultAddress(user.getId(), addrId);
        }
        if ("checkout".equals(returnTo)) {
            response.sendRedirect("checkout");
        } else {
            response.sendRedirect("address");
        }
    }
}