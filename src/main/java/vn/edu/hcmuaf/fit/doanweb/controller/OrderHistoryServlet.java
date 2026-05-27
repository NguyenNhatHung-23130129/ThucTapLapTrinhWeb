package vn.edu.hcmuaf.fit.doanweb.controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import vn.edu.hcmuaf.fit.doanweb.dao.OrderDao;
import vn.edu.hcmuaf.fit.doanweb.model.Order;
import vn.edu.hcmuaf.fit.doanweb.model.User;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "OrderHistoryServlet", value = "/orderhistory")
public class OrderHistoryServlet extends HttpServlet {
    private OrderDao orderDao;

    @Override
    public void init() throws ServletException {
        orderDao = new OrderDao();
    }
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("auth");
        if (user == null) {
            response.sendRedirect("Login.jsp");
            return;
        }
        List<Order> orderList = orderDao.getOrdersByUserId(user.getId());
        request.setAttribute("orderList", orderList);
        request.getRequestDispatcher("OrderHistory.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
            String action = request.getParameter("action");
            if ("cancel".equals(action)) {
                HttpSession session = request.getSession();
                User user = (User) session.getAttribute("auth");
                if (user == null) {response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                    return;
                }
                String orderIdStr = request.getParameter("orderId");
                if (orderIdStr != null) {
                    try {
                        int orderId = Integer.parseInt(orderIdStr);
                        boolean isCancelled = orderDao.cancelOrder(orderId);
                        if (isCancelled) { response.setStatus(HttpServletResponse.SC_OK);
                        } else { response.setStatus(HttpServletResponse.SC_BAD_REQUEST); }
                    } catch (NumberFormatException e) {
                        response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    }
                }
            } else {

                doGet(request, response);
            }
        }

}