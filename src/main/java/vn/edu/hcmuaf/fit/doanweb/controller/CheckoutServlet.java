package vn.edu.hcmuaf.fit.doanweb.controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import vn.edu.hcmuaf.fit.doanweb.Cart.Cart;
import vn.edu.hcmuaf.fit.doanweb.Cart.CartItem;
import vn.edu.hcmuaf.fit.doanweb.dao.*;
import vn.edu.hcmuaf.fit.doanweb.model.Product;
import vn.edu.hcmuaf.fit.doanweb.model.User;
import vn.edu.hcmuaf.fit.doanweb.model.UserAdderss;
import vn.edu.hcmuaf.fit.doanweb.model.Voucher;
import vn.edu.hcmuaf.fit.doanweb.services.ShippingService;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "CheckoutServlet", value = "/checkout")
public class CheckoutServlet extends HttpServlet {
    private OrderDao orderDao;
    private ProductDao productDao;
    private UserAddressDao userAddressDao;

    @Override
    public void init() throws ServletException {
        orderDao = new OrderDao();
        productDao = new ProductDao();
        userAddressDao = new UserAddressDao();
    }

    private void loadCheckoutData(HttpServletRequest request, HttpSession session, User user) {
        String chosenAddrIdStr = request.getParameter("chosenAddrId");
        UserAdderss address = null;

        if (chosenAddrIdStr != null && !chosenAddrIdStr.isEmpty()) {
            address = userAddressDao.getAddressById(Integer.parseInt(chosenAddrIdStr));
        }
        if (address == null) {
            address = userAddressDao.getOneAddressByUserId(user.getId());
        }

        List<CartItem> listItems = new ArrayList<>();
        double subTotal = 0;
        boolean hasFrozen = false;

        String targetId = request.getParameter("buyNowId");
        if (targetId == null || targetId.isEmpty()) targetId = request.getParameter("id");

        if (targetId != null && !targetId.isEmpty()) {
            int id = Integer.parseInt(targetId);
            String qtyStr = request.getParameter("buyNowQty");
            if (qtyStr == null || qtyStr.isEmpty()) qtyStr = request.getParameter("quantity");
            int quantity = (qtyStr != null && !qtyStr.isEmpty()) ? Integer.parseInt(qtyStr) : 1;

            Product product = productDao.getProductById(id);
            if (product != null) {
                CartItem item = new CartItem(product, product.getPrice(), quantity);
                listItems.add(item);
                subTotal = item.getTotal();
                if (product.getCategoryId() == 1) hasFrozen = true;
            }
        } else {
            Cart cart = (Cart) session.getAttribute("cart");
            String idsParam = request.getParameter("ids");

            if (cart != null && idsParam != null && !idsParam.isEmpty()) {
                String[] idArray = idsParam.split(",");
                for (String idStr : idArray) {
                    int id = Integer.parseInt(idStr);
                    for (CartItem item : cart.getList()) {
                        if (item.getProduct().getId() == id) {
                            listItems.add(item);
                            subTotal += item.getTotal();
                            if (item.getProduct().getCategoryId() == 1) hasFrozen = true;
                            break;
                        }
                    }
                }
            }
        }

        String shipMethod = request.getParameter("shipMethod");
        if (shipMethod == null) shipMethod = "standard";

        if (hasFrozen && !"cold".equals(shipMethod)) {
            shipMethod = "cold";
        }

        String cityCode = (address != null) ? address.getCity() : "700000";
        double shippingFee = ShippingService.calculateFee("700000", cityCode, 1000, shipMethod);

        double discount = 0;
        String voucherCode = request.getParameter("voucherCode");

        if (voucherCode != null && !voucherCode.isEmpty()) {
            Voucher voucher = VoucherDao.getInstance().getVoucherByCode(voucherCode.toUpperCase());
            if (voucher != null) {
                if ("freeship".equalsIgnoreCase(voucher.getType())) {
                    discount = shippingFee;
                } else if ("percent".equalsIgnoreCase(voucher.getType())) {
                    discount = subTotal * (voucher.getValue() / 100.0);
                    if (voucher.getMaxDiscountAmount() > 0 && discount > voucher.getMaxDiscountAmount()) {
                        discount = voucher.getMaxDiscountAmount();
                    }
                } else {
                    discount = voucher.getValue();
                }
            }
        }

        double total = subTotal + shippingFee - discount;
        if (total < 0) total = 0;

        request.setAttribute("user", user);
        request.setAttribute("userAddress", address);
        request.setAttribute("selectedProducts", listItems);
        request.setAttribute("subtotal", subTotal);
        request.setAttribute("shippingFee", shippingFee);
        request.setAttribute("shipMethod", shipMethod);
        request.setAttribute("hasFrozen", hasFrozen);
        request.setAttribute("discount", discount);
        request.setAttribute("total", total);
        request.setAttribute("voucherCode", voucherCode);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("auth");
        if (user == null) {
            response.sendRedirect("login");
            return;
        }
        loadCheckoutData(request, session, user);
        request.getRequestDispatcher("Checkout.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("auth");
        String isAjax = request.getParameter("isAjax");

        if (user == null) {
            if ("true".equals(isAjax)) {
                response.getWriter().write("{\"success\": false, \"message\": \"SESSION_EXPIRED\"}");
            } else {
                response.sendRedirect("login");
            }
            return;
        }

        try {
            loadCheckoutData(request, session, user);

            Double calculatedTotal = (Double) request.getAttribute("total");
            List<CartItem> itemsToSave = (List<CartItem>) request.getAttribute("selectedProducts");
            Double shippingFee = (Double) request.getAttribute("shippingFee");
            String shipMethod = (String) request.getAttribute("shipMethod");

            String addressIdStr = request.getParameter("addressId");
            int addressId = (addressIdStr != null && !addressIdStr.isEmpty()) ? Integer.parseInt(addressIdStr) : 0;

            if (addressId == 0) {
                addressId = userAddressDao.saveAddress(user.getId(), request.getParameter("finalAddress"),
                        request.getParameter("finalWard"), request.getParameter("finalCity"));
            }

            int orderId = orderDao.createOrderWithStockCheck(user.getId(), calculatedTotal, addressId, itemsToSave, shippingFee, shipMethod);

            String appliedVoucher = (String) request.getAttribute("voucherCode");
            if (appliedVoucher != null) {
                UserVoucherDao.getInstance().markVoucherAsUsed(user.getId(), appliedVoucher, orderId);
            }

            Cart cart = (Cart) session.getAttribute("cart");
            if (cart != null && request.getParameter("buyNowId") == null) {
                for (CartItem item : itemsToSave) {
                    cart.deleteProduct(item.getProduct().getId());
                }
                session.setAttribute("cart", cart);
            }

            if ("true".equals(isAjax)) {
                response.setContentType("application/json");
                response.getWriter().write(String.format("{\"success\": true, \"orderId\": %d}", orderId));
            } else {
                response.sendRedirect("orderhistory");
            }
        } catch (Exception e) {
            e.printStackTrace();
            if ("true".equals(isAjax)) {
                response.getWriter().write("{\"success\": false, \"message\": \"" + e.getMessage() + "\"}");
            } else {
                request.setAttribute("error", e.getMessage());
                doGet(request, response);
            }
        }
    }
}