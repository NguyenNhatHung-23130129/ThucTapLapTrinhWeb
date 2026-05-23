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

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "CheckoutServlet", value = "/checkout")
public class CheckoutServlet extends HttpServlet {
    private OrderDao orderDao;
    private ProductDao productDao;
    private UserAddressDao userAddressDao;
    private OrderDetailDao orderDetailDao;

    @Override
    public void init() throws ServletException {
        orderDao = new OrderDao();
        productDao = new ProductDao();
        userAddressDao = new UserAddressDao();
        orderDetailDao = new OrderDetailDao();
    }



    private void loadCheckoutData(HttpServletRequest request, HttpSession session, User user) {
        String chosenAddrIdStr = request.getParameter("chosenAddrId");
        UserAdderss address = null;
        if (chosenAddrIdStr != null && !chosenAddrIdStr.trim().isEmpty()) {
            try {
                int chosenId = Integer.parseInt(chosenAddrIdStr);
                address = userAddressDao.getAddressById(chosenId);
            } catch (NumberFormatException e) {
                e.printStackTrace();
            }
        }
        if (address == null) {
            address = userAddressDao.getOneAddressByUserId(user.getId());
        }
        request.setAttribute("user", user);
        request.setAttribute("userAddress", address);
        String pId = request.getParameter("id");
        String buyNowId = request.getParameter("buyNowId");
        String idParam = request.getParameter("id");
        String targetId = (buyNowId != null && !buyNowId.isEmpty()) ? buyNowId : idParam;

        List<CartItem> listItems = new ArrayList<>();
        double subTotal = 0;
        if (targetId != null && !targetId.isEmpty()) {
            try {
                int id = Integer.parseInt(targetId);
                int quantity = 1;
                String qtyStr = request.getParameter("buyNowQty");
                if (qtyStr == null || qtyStr.isEmpty()) qtyStr = request.getParameter("quantity");

                if (qtyStr != null && !qtyStr.isEmpty()) {
                    quantity = Integer.parseInt(qtyStr);
                }

                Product product = productDao.getProductById(id);
                if (product != null) {
                    CartItem item = new CartItem(product, product.getPrice(), quantity);
                    listItems.add(item);
                    subTotal = item.getTotal();
                }
            } catch (NumberFormatException e) { e.printStackTrace(); }
        }  else {
        Cart cart = (Cart) session.getAttribute("cart");
        if (cart != null) {
            String idsParam = request.getParameter("ids");
            if (idsParam != null && !idsParam.isEmpty()) {
                String[] idArray = idsParam.split(",");
                for (String idStr : idArray) {
                    try {
                        int id = Integer.parseInt(idStr);
                        for (CartItem item : cart.getList()) {
                            if (item.getProduct().getId() == id) {
                                listItems.add(item);
                                subTotal += item.getTotal();
                                break;
                            }
                        }
                    } catch (NumberFormatException e) {
                        continue;
                    }
                }
            } else {
                listItems = cart.getList();
                subTotal = cart.getTotal();
            }
        }
        }
        String shipMethod = request.getParameter("finalShipMethod");
        double shippingFee = 30000;
        if ("express".equals(shipMethod)) {
            shippingFee = 50000;
        } else if ("cold".equals(shipMethod)) {
            shippingFee = 100000;
        }
        double discount = 0;
        String voucherCode = request.getParameter("voucherCode");
        if (voucherCode != null && !voucherCode.trim().isEmpty()) {
            String code = voucherCode.trim().toUpperCase();

            Voucher voucher = VoucherDao.getInstance().getVoucherByCode(code);

            if (voucher != null) {
                String type = voucher.getType();
                double value = voucher.getValue();

                if ("freeship".equalsIgnoreCase(type)) {
                    discount = shippingFee;
                } else if ("percent".equalsIgnoreCase(type) || "percentage".equalsIgnoreCase(type)) {
                    discount = subTotal * (value / 100.0);
                    if (voucher.getMaxDiscountAmount() > 0 && discount > voucher.getMaxDiscountAmount()) {
                        discount = voucher.getMaxDiscountAmount();
                    }
                } else {
                    discount = value;
                }
            }
            if (discount > (subTotal + shippingFee)) discount = subTotal + shippingFee;
        }

        double total = subTotal + shippingFee - discount;
        if (total < 0) total = 0;
        request.setAttribute("selectedProducts", listItems);
        request.setAttribute("subtotal", subTotal);
        request.setAttribute("shippingFee", shippingFee);
        request.setAttribute("voucherCode", voucherCode);
        request.setAttribute("discount", discount);
        request.setAttribute("total", total);
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
        if (user == null) {
            String isAjax = request.getParameter("isAjax");
            if ("true".equals(isAjax)) {
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                response.getWriter().write("{\"success\": false, \"message\": \"SESSION_EXPIRED\"}");
                return;
            }
            response.sendRedirect("login");
            return;
        }
        try {

            String name = request.getParameter("finalName");
            String phone = request.getParameter("finalPhone");
            String rawAddress = request.getParameter("finalAddress");
            String ward = request.getParameter("finalWard");
            String city = request.getParameter("finalCity");
            if (name == null || name.trim().isEmpty() ||
                    phone == null || phone.trim().isEmpty() ||
                    rawAddress == null || rawAddress.trim().isEmpty() ||
                    ward == null || ward.trim().isEmpty() ||
                    city == null || city.trim().isEmpty()) {

                throw new Exception("Vui lòng cung cấp đầy đủ thông tin giao hàng.");
            }
            loadCheckoutData(request, session, user);
            Double calculatedTotal = (Double) request.getAttribute("total");
            if (calculatedTotal == null) throw new Exception("Lỗi tính toán tổng tiền.");

            UserDao userDao = new UserDao();
            userDao.updateContact(user.getId(), name, phone);
            user.setName(name);
            user.setPhone(phone);
            session.setAttribute("auth", user);
            String addressIdStr = request.getParameter("addressId");
            int addressId = 0;
            if (addressIdStr != null && !addressIdStr.isEmpty()) {
                addressId = Integer.parseInt(addressIdStr);
            } else {
                addressId = userAddressDao.saveAddress(user.getId(), rawAddress, ward, city);
            }
            List<CartItem> itemsToSave = (List<CartItem>) request.getAttribute("selectedProducts");
            if (itemsToSave == null || itemsToSave.isEmpty()) {
                throw new Exception("Danh sách sản phẩm trống, không thể thanh toán.");
            }
            int orderId = orderDao.createOrderWithStockCheck(user.getId(), calculatedTotal, addressId, itemsToSave);

            String appliedVoucher = request.getParameter("voucherCode");
            if (appliedVoucher != null && !appliedVoucher.trim().isEmpty()) {
                UserVoucherDao.getInstance().markVoucherAsUsed(user.getId(), appliedVoucher.trim().toUpperCase(), orderId);
            }
            String payType = request.getParameter("payType");
            String isAjax = request.getParameter("isAjax");

            String buyNowId = request.getParameter("buyNowId");
            if (buyNowId == null || buyNowId.isEmpty()) {
                Cart cart = (Cart) session.getAttribute("cart");
                if (cart != null && itemsToSave != null) {
                    for (CartItem item : itemsToSave) {
                        cart.deleteProduct(item.getProduct().getId());
                    }
                    session.setAttribute("cart", cart);
                }
            }
            if ("ewallet".equals(payType) && "true".equals(isAjax)) {
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                String json = String.format("{\"success\": true, \"orderId\": %d, \"total\": %.0f}", orderId, calculatedTotal);
                response.getWriter().write(json);
                return;
            } else {
            response.sendRedirect("orderhistory");}

        } catch (Exception e) {
            String isAjax = request.getParameter("isAjax");
            if ("true".equals(isAjax)) {
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                String errorMsg = e.getMessage() != null ? e.getMessage() : "Lỗi hệ thống không xác định.";
                errorMsg = errorMsg.replace("\"", "'").replace("\n", " ");
                response.getWriter().write("{\"success\": false, \"message\": \"" + errorMsg + "\"}");
            }
            else {
                loadCheckoutData(request, session, user);
                request.setAttribute("error", e.getMessage());
                request.getRequestDispatcher("Checkout.jsp").forward(request, response);
            }
        }
    }
}