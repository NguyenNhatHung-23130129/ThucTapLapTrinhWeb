package vn.edu.hcmuaf.fit.doanweb.Cart;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import vn.edu.hcmuaf.fit.doanweb.dao.ProductDao;

import java.io.IOException;

@WebServlet(name = "DeleteProduct", value = "/del-cart")
public class DeleteProduct extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws
            ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
      HttpSession session = request.getSession();
        Cart cart = (Cart) session.getAttribute("cart");
        CartItem cartItem= cart.deleteProduct(id);
        if(cartItem == null){
            response.sendRedirect("error.jsp");
            return;
        }
        response.sendRedirect("cart");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws
            ServletException, IOException {
    }
}