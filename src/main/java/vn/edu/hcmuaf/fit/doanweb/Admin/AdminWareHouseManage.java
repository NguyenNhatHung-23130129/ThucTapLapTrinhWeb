package vn.edu.hcmuaf.fit.doanweb.Admin;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import vn.edu.hcmuaf.fit.doanweb.dao.ProductDao;
import vn.edu.hcmuaf.fit.doanweb.dao.SupplierDao;
import vn.edu.hcmuaf.fit.doanweb.dao.WarehouseDao;
import vn.edu.hcmuaf.fit.doanweb.model.User;
import vn.edu.hcmuaf.fit.doanweb.model.Warehouse;
import vn.edu.hcmuaf.fit.doanweb.services.PermissionService;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "AdminWareHouse", value = "/admin/inventory")
public class AdminWareHouseManage extends HttpServlet {

    WarehouseDao warehouseDao = new WarehouseDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws
            ServletException, IOException {



        ProductDao productDao = new ProductDao();
        request.setAttribute("productList", productDao.getProducts());

        SupplierDao supplierDao = new SupplierDao();
        request.setAttribute("supplierList", supplierDao.getAllSuppliers());

        String search = request.getParameter("search");
        List<Warehouse> warehouses ;

        if (search != null && !search.trim().isEmpty()) {
            warehouses = warehouseDao.searchWarehouses(search.trim());
        } else {
            warehouses = warehouseDao.getAllWarehouse();
        }
        request.setAttribute("searchKeyword", search);




        request.setAttribute("warehouseList", warehouses);
        request.setAttribute("activeTab", "inventory");
        request.getRequestDispatcher("Admin.jsp").forward(request, response);


    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws
            ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        if (action == null) action = "";



        switch (action) {
            case "add":
                addWarehouse(request, response);
                break;
            case "update":
                updateWarehouse(request, response);
                break;

            default:
                response.sendRedirect(request.getContextPath() + "/admin/inventory");


        }


    }

    private void updateWarehouse(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int inv = Integer.parseInt(request.getParameter("id"));
        boolean status = "1".equals(request.getParameter("status"));
        warehouseDao.update(inv, status);
        response.sendRedirect(request.getContextPath() + "/admin/inventory");
    }

    private void addWarehouse(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            Warehouse w = new Warehouse();
            w.setProductId(Integer.parseInt(request.getParameter("product_id")));
            w.setSupplierId(Integer.parseInt(request.getParameter("supplier_id")));
            w.setImportPrice(Double.parseDouble(request.getParameter("input_price")));
            w.setQuantityImported(Integer.parseInt(request.getParameter("quantity_imported")));
            w.setPreservationMethod(request.getParameter("preservation_methods"));
            w.setStatus(false);

            warehouseDao.insert(w);
        } catch (NumberFormatException e) {
            e.printStackTrace();
        }
        response.sendRedirect(request.getContextPath() + "/admin/inventory");
    }


}