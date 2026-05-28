package vn.edu.hcmuaf.fit.doanweb.Cart;

import com.google.gson.Gson;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import vn.edu.hcmuaf.fit.doanweb.dao.CartDao;
import vn.edu.hcmuaf.fit.doanweb.dao.ProductDao;
import vn.edu.hcmuaf.fit.doanweb.model.Product;
import vn.edu.hcmuaf.fit.doanweb.model.User;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.Map;

@WebServlet(name = "AddCart", value = "/add-cart")
public class AddCart extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        processRequest(request, response);
    }

    private void processRequest(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("auth");

        if (user == null) {
            out.print("{\"status\":\"error\",\"redirect\":\"login\"}");
            out.flush();
            return;
        }

        String idParam = request.getParameter("id");
        String qtyParam = request.getParameter("quantity");

        if (idParam == null || idParam.trim().isEmpty()) {
            out.print("{\"status\":\"error\"}");
            out.flush();
            return;
        }

        int id = Integer.parseInt(idParam);
        int quantity = (qtyParam != null) ? Integer.parseInt(qtyParam) : 1;

        Cart cart = (Cart) session.getAttribute("cart");
        if (cart == null) cart = new Cart();

        ProductDao pd = new ProductDao();
        Product dbProduct = pd.getProductById(id);

        if (dbProduct == null) {
            out.print("{\"status\":\"error\"}");
            out.flush();
            return;
        }

        cart.update(id, dbProduct);
        cart.addProduct(dbProduct, quantity);
        session.setAttribute("cart", cart);

        int finalItemQty = 0;
        double finalItemTotal = 0.0;

        try {
            CartDao cartDao = CartDao.getInstance();
            int cartId = cartDao.getOrCreateCartId(user.getId());

            CartItem updatedItem = cart.getList().stream()
                    .filter(i -> i.getProduct().getId() == dbProduct.getId())
                    .findFirst()
                    .orElse(null);

            if (updatedItem != null && updatedItem.getQuantity() > 0) {
                if (updatedItem.getQuantity() > dbProduct.getStockQuantity()) {
                    updatedItem.setQuantity(dbProduct.getStockQuantity());
                }

                finalItemQty = updatedItem.getQuantity();
                finalItemTotal = updatedItem.getTotal();

                cartDao.saveCartItemToDB(cartId, dbProduct.getId(), updatedItem.getQuantity());
            } else {
                cartDao.removeCartItemFromDB(cartId, dbProduct.getId());
            }
        } catch (Exception e) {
            System.err.println("DB Sync Error: " + e.getMessage());
        }
        Map<String, Object> jsonResponse = new java.util.HashMap<>();
        jsonResponse.put("status", "success");
        jsonResponse.put("itemQuantity", finalItemQty);
        jsonResponse.put("itemTotal", finalItemTotal);
        jsonResponse.put("cartTotalQuantity", cart.getTotalQuantity());
        Gson gson = new Gson();
        String jsonString = gson.toJson(jsonResponse);

        out.print(jsonString);
        out.flush();
    }
}