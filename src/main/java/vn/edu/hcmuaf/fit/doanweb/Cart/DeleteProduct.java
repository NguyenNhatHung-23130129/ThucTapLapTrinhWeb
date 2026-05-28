package vn.edu.hcmuaf.fit.doanweb.Cart;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import vn.edu.hcmuaf.fit.doanweb.dao.CartDao;
import vn.edu.hcmuaf.fit.doanweb.model.User;

import java.io.IOException;

@WebServlet(name = "DeleteProduct", value = "/del-cart")
public class DeleteProduct extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws
            ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("auth");

        if (user == null) {
            response.sendRedirect("login");
            return;
        }

        String idParam = request.getParameter("id");
        if (idParam == null || idParam.trim().isEmpty()) {
            response.sendRedirect("cart");
            return;
        }

        int productId = Integer.parseInt(idParam);
        Cart cart = (Cart) session.getAttribute("cart");

        if (cart != null) {
            CartItem removedItem = cart.deleteProduct(productId);
            session.setAttribute("cart", cart);

            if (removedItem != null) {
                CartDao cartDao = CartDao.getInstance();
                int cartId = cartDao.getOrCreateCartId(user.getId());
                cartDao.removeCartItemFromDB(cartId, productId);
            }
        }


        response.sendRedirect("cart");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws
            ServletException, IOException {
        doGet(request, response);
    }
}