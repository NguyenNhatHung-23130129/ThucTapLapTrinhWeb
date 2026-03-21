package vn.edu.hcmuaf.fit.doanweb.dao;


import vn.edu.hcmuaf.fit.doanweb.model.Order;
import vn.edu.hcmuaf.fit.doanweb.model.OrderDetails;
import java.util.List;

public class OrderDao extends BaseDao {

    private OrderDetailDao orderDetailDao = new OrderDetailDao();

    public int saveOrder(int userId, double totalAmount, int addressId) {
        return get().withHandle(handle ->

                handle.createUpdate("INSERT INTO orders (user_id, order_date, total_amount, status, address_id) " +
                                "VALUES (:userId, NOW(), :totalAmount, 'Đang xử lý', :addressId)")
                        .bind("userId", userId)
                        .bind("totalAmount", totalAmount)
                        .bind("addressId", addressId)
                        .executeAndReturnGeneratedKeys("id")
                        .mapTo(Integer.class)
                        .one()
        );
    }

    public List<Order> getOrdersByUserId(int userId) {

        List<Order> orders = get().withHandle(handle ->
                handle.createQuery("SELECT * FROM orders WHERE user_id = :userId ORDER BY id DESC")
                        .bind("userId", userId)
                        .mapToBean(Order.class)
                        .list()
        );


        for (Order order : orders) {

            List<OrderDetails> details = orderDetailDao.getDetailsByOrderId(order.getId());


            order.setOrderDetails(details);
        }

        return orders;
    }


    public boolean isValidVoucher(String voucherCode) {
        return get().withHandle(handle -> {
            int count = handle.createQuery("SELECT COUNT(*) FROM vouchers WHERE code = :voucherCode")
                    .bind("voucherCode", voucherCode)
                    .mapTo(Integer.class)
                    .one();
            return count > 0;
        });
    }


    public double applyVoucher(String voucherCode, double totalAmount) {
        return get().withHandle(handle -> {

            Double discount = handle.createQuery(" SELECT discount_amount FROM vouchers WHERE code = :voucherCode AND NOW() BETWEEN start_date AND end_date"
                    )
                    .bind("voucherCode", voucherCode)
                    .mapTo(Double.class)
                    .findOne()
                    .orElse(0.0);


            return Math.max(totalAmount - discount, 0);
        });
    }

    public List<Order> getAllOrders() {
        return get().withHandle(handle -> handle.createQuery("SELECT o.id, COALESCE(u.name, 'Người dùng đã xóa') AS userName, CONCAT_WS(', ', ua.address_line, ua.ward, ua.city) AS address, GROUP_CONCAT(p.name SEPARATOR ', <br>') AS productName, o.total_amount, o.status, o.order_date, o.note " +
                        "FROM orders o LEFT JOIN users u ON o.user_id = u.id LEFT JOIN user_address ua ON o.address_id = ua.id LEFT JOIN order_details od ON o.id = od.order_id LEFT JOIN products p ON od.product_id = p.id " +
                        "GROUP BY o.id ORDER BY o.id DESC, o.order_date DESC")
                .mapToBean(Order.class)
                .list()
        );
    }

    public void updateOrderStatus(int orderId, String status) {
        get().useHandle(handle -> {
            String currentStatus = handle.createQuery("SELECT status FROM orders WHERE id = :orderId")
                    .bind("orderId", orderId)
                    .mapTo(String.class)
                    .first();
            if ("Đã giao".equalsIgnoreCase(status) && !"Đã giao".equalsIgnoreCase(currentStatus)) {
                List<OrderDetails> orderDetails = handle.createQuery("SELECT product_id, quantity FROM order_details WHERE order_id = :orderId")
                        .bind("orderId", orderId)
                        .mapToBean(OrderDetails.class)
                        .list();
                for (OrderDetails detail : orderDetails) {
                    handle.createUpdate("UPDATE products SET stock_quantity = stock_quantity - :qty WHERE id = :productId")
                            .bind("qty", detail.getQuantity())
                            .bind("productId", detail.getProductId())
                            .execute();

                }
            }
            handle.createUpdate("UPDATE orders SET status = :status WHERE id = :orderId")
                    .bind("status", status)
                    .bind("orderId", orderId)
                    .execute();
        });
    }

    public List<Order> searchOrders(String trim) {
        return get().withHandle(handle ->
                handle.createQuery("SELECT o.id, u.name AS userName, CONCAT_WS(', ', ua.address_line, ua.ward, ua.city) AS address, GROUP_CONCAT(p.name SEPARATOR ', <br>') AS productName, COALESCE(SUM(od.quantity * od.unit_price), 0) AS total_amount, o.status, o.order_date, o.note FROM orders o JOIN users u ON o.user_id = u.id LEFT JOIN user_address ua ON o.address_id = ua.id LEFT JOIN order_details od ON o.id = od.order_id LEFT JOIN products p ON od.product_id = p.id WHERE o.id LIKE :trim GROUP BY o.id ORDER BY o.order_date DESC")
                        .bind("trim", "%" + trim + "%")
                        .mapToBean(Order.class)
                        .list()
        );
    }
    public double calculateTotalAmount(double subtotal, String voucherCode) {
        return subtotal;
    }

    public boolean checkUserBoughtProduct(int userId, int productId) {
        String sql = "SELECT COUNT(1) FROM orders o " + "JOIN order_details od ON o.id = od.order_id " + "WHERE o.user_id = :uid AND od.product_id = :pid " + "AND (o.status = 'Đã giao')";

        return get().withHandle(handle ->
                handle.createQuery(sql)
                        .bind("uid", userId)
                        .bind("pid", productId)
                        .mapTo(Integer.class)
                        .one() > 0
        );
    }
}
