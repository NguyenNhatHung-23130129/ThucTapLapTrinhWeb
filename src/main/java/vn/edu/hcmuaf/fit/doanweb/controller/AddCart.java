package vn.edu.hcmuaf.fit.doanweb.controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import vn.edu.hcmuaf.fit.doanweb.Cart.Cart;
import vn.edu.hcmuaf.fit.doanweb.dao.ProductDao;
import vn.edu.hcmuaf.fit.doanweb.model.Product;
import java.io.IOException;

@WebServlet(name = "AddCart", value = "/add-cart")
public class AddCart extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        String idParam = request.getParameter("id");
        String qtyParam = request.getParameter("quantity");
        String fromCart = request.getParameter("fromCart");
        if (idParam == null) return;
        int id = Integer.parseInt(idParam);
        int quantity = (qtyParam != null) ? Integer.parseInt(qtyParam) : 1;
        HttpSession session = request.getSession();
        Cart cart = (Cart) session.getAttribute("cart");
        if (cart == null) cart = new Cart();
        ProductDao pd = new ProductDao();
        Product product = pd.getProductById(id);
        if (product != null) {
            cart.addProduct(product, quantity);
            session.setAttribute("cart", cart);
        }
        if ("true".equals(fromCart)) {

            response.sendRedirect("cart");
            return;
        }
        int totalQuantity = cart.getTotalQuantity();
        response.setContentType("text/html;charset=UTF-8");
        java.io.PrintWriter out = response.getWriter();
        out.println("<script>");
        out.println("var badge = window.parent.document.getElementById('cartCount');");
        out.println("if (badge) {");
        out.println("    badge.innerText = '" + totalQuantity + "';");
        out.println("}");
        out.println("</script>");
    }
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}