package vn.edu.hcmuaf.fit.doanweb.controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import vn.edu.hcmuaf.fit.doanweb.dao.UserAddressDao;
import vn.edu.hcmuaf.fit.doanweb.model.User;
import vn.edu.hcmuaf.fit.doanweb.model.UserAdderss;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "AddressServlet", value = "/address")
public class AddressServlet extends HttpServlet {
    private UserAddressDao addressDao = new UserAddressDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("auth");
        if (user == null) {
            response.sendRedirect("login");
            return;
        }
        request.setAttribute("returnTo", request.getParameter("returnTo"));

        List<UserAdderss> list = addressDao.getAllAddressesByUserId(user.getId());
        request.setAttribute("addresses", list);
        request.getRequestDispatcher("Address.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        User user = (User) request.getSession().getAttribute("auth");
        if (user == null) return;

        String action = request.getParameter("action");
        String returnTo = request.getParameter("returnTo");
        String ids = request.getParameter("ids");
        String buyNowId = request.getParameter("buyNowId");
        String buyNowQty = request.getParameter("buyNowQty");
        String voucherCode = request.getParameter("voucherCode");
        StringBuilder extraParams = new StringBuilder();
        if (ids != null && !ids.isEmpty()) extraParams.append("&ids=").append(ids);
        if (buyNowId != null && !buyNowId.isEmpty()) extraParams.append("&buyNowId=").append(buyNowId);
        if (buyNowQty != null && !buyNowQty.isEmpty()) extraParams.append("&buyNowQty=").append(buyNowQty);
        if (voucherCode != null && !voucherCode.isEmpty()) extraParams.append("&voucherCode=").append(voucherCode);
        if ("add".equals(action)) {
            String receiverName = request.getParameter("receiverName");
            String receiverPhone = request.getParameter("receiverPhone");
            String address = request.getParameter("address");
            String ward = request.getParameter("ward");
            String city = request.getParameter("city");
            addressDao.addAddress(user.getId(), address, ward, city, receiverName, receiverPhone);
        } else if ("setDefault".equals(action) || "setIsDefault".equals(action)) {
            int addrId = Integer.parseInt(request.getParameter("addressId"));
            addressDao.setDefaultAddress(user.getId(), addrId);
        } else if ("delete".equals(action)) {
            int addrId = Integer.parseInt(request.getParameter("addressId"));
            addressDao.deleteAddress(addrId);
        } else if ("choose".equals(action)) {
            int addrId = Integer.parseInt(request.getParameter("addressId"));
            addressDao.setDefaultAddress(user.getId(), addrId);
            if (returnTo != null && returnTo.trim().equals("checkout")) {
                String redirectUrl = "checkout";
                if (extraParams.length() > 0) {
                    redirectUrl += "?" + extraParams.substring(1);
                }
                response.sendRedirect(redirectUrl);
                return;
            }
        }
        String queryString = (returnTo != null && !returnTo.trim().isEmpty()) ? "?returnTo=" + returnTo.trim() : "";
        if (queryString.isEmpty() && extraParams.length() > 0) {
            queryString = "?" + extraParams.substring(1);
        } else {
            queryString += extraParams.toString();
        }
        response.sendRedirect("address" + queryString);
    }
}