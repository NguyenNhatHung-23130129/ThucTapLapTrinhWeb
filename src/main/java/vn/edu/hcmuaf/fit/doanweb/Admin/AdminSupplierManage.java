package vn.edu.hcmuaf.fit.doanweb.Admin;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import vn.edu.hcmuaf.fit.doanweb.dao.SupplierDao;
import vn.edu.hcmuaf.fit.doanweb.model.Supplier;
import vn.edu.hcmuaf.fit.doanweb.model.User;
import vn.edu.hcmuaf.fit.doanweb.services.PermissionService;

import java.io.IOException;
import java.util.LinkedList;
import java.util.List;

@WebServlet(name = "AdminSupplierManage", value = "/admin/supplier")
public class AdminSupplierManage extends HttpServlet {
    SupplierDao supplierDao = new SupplierDao();


    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws
            ServletException, IOException {
        String search = request.getParameter("search");
        List<Supplier> suppliers ;
        if (search != null && !search.trim().isEmpty()) {
            suppliers = supplierDao.searchSupplier(search.trim());
        } else {
            suppliers = supplierDao.getAllSuppliers();
        }

        request.setAttribute("searchKeyword", search);
        request.setAttribute("supplierList", suppliers);
        request.setAttribute("activeTab", "suppliers");
        request.getRequestDispatcher("Admin.jsp").forward(request, response);


    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws
            ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");

       switch (action){
           case "add":
               Supplier newSupplier = getSupplierForm(request);
               supplierDao.insertSupplier(newSupplier);
               response.sendRedirect(request.getContextPath() + "/admin/supplier");
               break;
           case "update":
               Supplier updateSupplier = getSupplierForm(request);
               String id = request.getParameter("id");
               updateSupplier.setId(Integer.parseInt(id));
               supplierDao.updateSupplier(updateSupplier);
               response.sendRedirect(request.getContextPath() + "/admin/supplier");
               break;
       }
    }
    public Supplier getSupplierForm(HttpServletRequest request) {
        String id = request.getParameter("id");
        String name = request.getParameter("name");
        String address = request.getParameter("address");
        String phone = request.getParameter("phone");
        String email = request.getParameter("email");

        Supplier supplier = new Supplier();

        supplier.setName(name);
        supplier.setAddress(address);
        supplier.setPhone(phone);
        supplier.setEmail(email);

        return supplier;
    }
}