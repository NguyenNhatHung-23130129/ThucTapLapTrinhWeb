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
        UserAdderss address = userAddressDao.getOneAddressByUserId(user.getId());
        request.setAttribute("user", user);
        request.setAttribute("userAddress", address);
        String pId = request.getParameter("id");
        String buyNowIdParams = request.getParameter("buyNowId");

        String targetId = (buyNowIdParams != null && !buyNowIdParams.isEmpty()) ? buyNowIdParams : pId;

        List<CartItem> listItems = new ArrayList<>();
        double subTotal = 0;
        if (targetId != null && !targetId.isEmpty()) {
            try {
                int id = Integer.parseInt(targetId);
                int quantity = 1;
                try {
                    String qtyStr = request.getParameter("buyNowQty");
                    if (qtyStr == null) qtyStr = request.getParameter("quantity");
                    if (qtyStr != null) quantity = Integer.parseInt(qtyStr);
                } catch (Exception e) { quantity = 1; }
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
        double shippingFee = 30000;
        double discount = 0;
        String voucherCode = request.getParameter("voucherCode");
        if (voucherCode != null && !voucherCode.trim().isEmpty()) {
            String code = voucherCode.trim().toUpperCase();
            if (code.equals("SALE20")) {
                discount = subTotal * 0.2;
            } else if (code.equals("GIAM50K")) {
                discount = 50000;
            } else if (code.equals("FREESHIP")) {
                discount = shippingFee;
            } else {
                discount = 10000;
            }
            if (discount > subTotal) discount = subTotal;
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
            response.sendRedirect("login");
            return;
        }
        try {
            loadCheckoutData(request, session, user);
            Double calculatedTotal = (Double) request.getAttribute("total");
            if (calculatedTotal == null) throw new Exception("Lỗi tính toán tổng tiền.");
            String name = request.getParameter("finalName");
            String phone = request.getParameter("finalPhone");
            String rawAddress = request.getParameter("finalAddress");
            String ward = request.getParameter("finalWard");
            String city = request.getParameter("finalCity");
            UserDao userDao = new UserDao();
            userDao.updateContact(user.getId(), name, phone);
            user.setName(name);
            user.setPhone(phone);
            session.setAttribute("auth", user);
            int addressId = userAddressDao.saveAddress(user.getId(), rawAddress, ward, city);
            int orderId = orderDao.saveOrder(user.getId(), calculatedTotal, addressId);
            if (orderId <= 0) throw new Exception("Không thể tạo đơn hàng.");
            List<CartItem> itemsToSave = (List<CartItem>) request.getAttribute("selectedProducts");
            if (itemsToSave != null && !itemsToSave.isEmpty()) {
                for (CartItem item : itemsToSave) {
                    orderDetailDao.saveDetail(
                            orderId,
                            item.getProduct().getId(),
                            item.getPrice(),
                            item.getQuantity()
                    );
                }
            } else {
                throw new Exception("Danh sách sản phẩm trống, không thể thanh toán.");
            }
            String buyNowId = request.getParameter("buyNowId");
            if (buyNowId == null || buyNowId.isEmpty()) {
                session.removeAttribute("cart");
            }
            response.sendRedirect("orderhistory");

        } catch (Exception e) {
            e.printStackTrace();
            loadCheckoutData(request, session, user);
            request.setAttribute("error", "Đặt hàng thất bại: " + e.getMessage());
            request.getRequestDispatcher("Checkout.jsp").forward(request, response);
        }
    }}