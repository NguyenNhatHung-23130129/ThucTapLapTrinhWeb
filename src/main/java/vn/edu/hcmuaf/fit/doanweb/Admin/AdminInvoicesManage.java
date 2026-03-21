package vn.edu.hcmuaf.fit.doanweb.Admin;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import vn.edu.hcmuaf.fit.doanweb.dao.InvoicesDao;
import vn.edu.hcmuaf.fit.doanweb.model.Invoices;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "AdminInvoicesManage", value = "/admin/invoices")
public class AdminInvoicesManage extends HttpServlet {
    InvoicesDao invoicesDao = new InvoicesDao();
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws
            ServletException, IOException {
        List<Invoices> invoicesList = invoicesDao.getAllInvoices();
        request.setAttribute("invoicesList", invoicesList);

        request.setAttribute("activeTab", "invoices");
        request.getRequestDispatcher("Admin.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws
            ServletException, IOException {
    }
}