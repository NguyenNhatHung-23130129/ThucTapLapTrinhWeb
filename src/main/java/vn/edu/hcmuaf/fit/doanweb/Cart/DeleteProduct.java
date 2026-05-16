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
        String idParam = request.getParameter("id");
        if (idParam == null || idParam.trim().isEmpty()) {
            response.sendRedirect("cart");
            return;
        }

        try {
            int productId = Integer.parseInt(idParam);
            HttpSession session = request.getSession();
            Cart cart = (Cart) session.getAttribute("cart");

            if (cart != null) {
                CartItem removedItem = cart.deleteProduct(productId);

                if (removedItem != null) {
                    User user = (User) session.getAttribute("user");
                    if (user != null) {
                        CartDao cartDao = CartDao.getInstance();
                        int cartId = cartDao.getOrCreateCartId(user.getId());
                        cartDao.removeCartItemFromDB(cartId, productId);
                    }
                }
            }
        } catch (NumberFormatException e) {
            e.printStackTrace();
        }

        response.sendRedirect("cart");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws
            ServletException, IOException {
    }
}