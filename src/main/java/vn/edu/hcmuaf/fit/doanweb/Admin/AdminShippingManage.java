package vn.edu.hcmuaf.fit.doanweb.Admin;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import vn.edu.hcmuaf.fit.doanweb.dao.ShippingDao;
import vn.edu.hcmuaf.fit.doanweb.model.Shipping;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "AdminShippingManage", value = "/admin/shipping")
public class AdminShippingManage extends HttpServlet {
    ShippingDao shippingDao = new ShippingDao();
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws
            ServletException, IOException {
        List<Shipping> shippingList = shippingDao.getShippingMethods();


        request.setAttribute("shipping", shippingList);
        request.setAttribute("activeTab", "shipping");
        request.getRequestDispatcher("Admin.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws
            ServletException, IOException {
    }
}