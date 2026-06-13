
package vn.edu.hcmuaf.fit.doanweb.dao;


import vn.edu.hcmuaf.fit.doanweb.model.Order;
import vn.edu.hcmuaf.fit.doanweb.model.OrderDetails;

import java.util.List;
import java.util.Map;

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
                handle.createQuery("SELECT o.*, u.name AS userName, u.phone AS recipientPhone, CONCAT_WS(', ', ua.address_line, ua.ward, ua.city) AS address,p.payment_status FROM orders o LEFT JOIN users u ON o.user_id = u.id LEFT JOIN user_address ua ON o.address_id = ua.id LEFT JOIN payments p ON o.id = p.order_id WHERE o.user_id = :userId ORDER BY o.id DESC")
                        .bind("userId", userId)
                        .map((rs, ctx) -> {
                            Order order = new Order();
                            order.setId(rs.getInt("id"));
                            order.setUserId(rs.getInt("user_id"));
                            order.setAddressId(rs.getInt("address_id"));
                            order.setOrderDate(rs.getTimestamp("order_date"));
                            order.setStatus(rs.getString("status"));
                            order.setTotalAmount(rs.getLong("total_amount"));
                            order.setUserName(rs.getString("userName"));
                            order.setRecipientPhone(rs.getString("recipientPhone"));
                            order.setAddress(rs.getString("address"));
                            order.setPaymentStatus(rs.getString("payment_status"));
                            order.setShipMethod(rs.getString("ship_method"));
                            return order;
                        })
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
        return get().withHandle(handle -> handle.createQuery("SELECT o.id, COALESCE(u.name, 'Người dùng đã xóa') AS userName, CONCAT_WS(', ', ua.address_line, ua.ward, ua.city) AS address, GROUP_CONCAT(p.name SEPARATOR ', <br>') AS productName, o.total_amount, o.status, o.order_date, o.note, pm.payment_status AS paymentStatus " +
                        "FROM orders o LEFT JOIN users u ON o.user_id = u.id LEFT JOIN user_address ua ON o.address_id = ua.id LEFT JOIN order_details od ON o.id = od.order_id LEFT JOIN products p ON od.product_id = p.id LEFT JOIN payments pm ON o.id = pm.order_id " +
                        "GROUP BY o.id, u.name,  ua.address_line,  ua.ward,  ua.city, o.total_amount,  o.status, o.order_date,  o.note, pm.payment_status " +
                        " ORDER BY o.id DESC, o.order_date DESC")
                .mapToBean(Order.class)
                .list()
        );
    }

    public void updateOrderStatus(int orderId, String newStatus) {
        get().useHandle(handle -> {
            String currentStatus = handle.createQuery("SELECT status FROM orders WHERE id = :orderId")
                    .bind("orderId", orderId)
                    .mapTo(String.class)
                    .findOne()
                    .orElse(null);

            if (currentStatus == null || currentStatus.equalsIgnoreCase(newStatus)) {
                return;
            }

            validateStatusTransition(currentStatus, newStatus);

            if ("Đã hủy".equalsIgnoreCase(newStatus)) {
                handleOrderCancellation(orderId, currentStatus);
            }

            if ("Đã giao".equalsIgnoreCase(newStatus)) {
                handleOrderDelivery(orderId);
            }

            handle.createUpdate("UPDATE orders SET status = :status WHERE id = :orderId")
                    .bind("status", newStatus)
                    .bind("orderId", orderId)
                    .execute();
        });
    }

    private void validateStatusTransition(String currentStatus, String newStatus) {
        boolean validTransition = false;
        switch (currentStatus) {
            case "Đang xử lý":
                validTransition = newStatus.equals("Đang giao hàng") || newStatus.equals("Đã hủy");
                break;
            case "Đang giao hàng":
                validTransition = newStatus.equals("Đã giao") || newStatus.equals("Đã hủy");
                break;
            case "Đã giao":
            case "Đã hủy":
                validTransition = false;
                break;
        }

        if (!validTransition) {
            throw new IllegalStateException("Hành vi bất hợp pháp: Không thể chuyển từ [" + currentStatus + "] sang [" + newStatus + "]");
        }
    }

    private void handleOrderCancellation(int orderId, String currentStatus) {
        get().useHandle(handle -> {
            List<OrderDetails> orderDetails = handle.createQuery("SELECT id, order_id AS orderId, product_id AS productId, quantity FROM order_details WHERE order_id = :orderId")
                    .bind("orderId", orderId)
                    .mapToBean(OrderDetails.class)
                    .list();

            for (OrderDetails detail : orderDetails) {
                handle.createUpdate("UPDATE products SET stock_quantity = stock_quantity + :qty WHERE id = :productId")
                        .bind("qty", detail.getQuantity())
                        .bind("productId", detail.getProductId())
                        .execute();

                if ("Đã giao".equalsIgnoreCase(currentStatus)) {
                    int qtyToReturn = detail.getQuantity();

                    List<Map<String, Object>> issuedBatches = handle.createQuery(
                                    "SELECT id, quantity_issued FROM warehouses WHERE product_id = :productId AND quantity_issued > 0 ORDER BY import_date DESC, id DESC")
                            .bind("productId", detail.getProductId())
                            .mapToMap()
                            .list();

                    for (Map<String, Object> batch : issuedBatches) {
                        if (qtyToReturn <= 0) break;

                        int batchId = ((Number) batch.get("id")).intValue();
                        int issued = ((Number) batch.get("quantity_issued")).intValue();

                        if (issued >= qtyToReturn) {
                            handle.createUpdate("UPDATE warehouses SET quantity_issued = quantity_issued - :qty WHERE id = :id")
                                    .bind("qty", qtyToReturn)
                                    .bind("id", batchId)
                                    .execute();
                            qtyToReturn = 0;
                        } else {
                            handle.createUpdate("UPDATE warehouses SET quantity_issued = 0 WHERE id = :id")
                                    .bind("id", batchId)
                                    .execute();
                            qtyToReturn -= issued;
                        }
                    }

                    handle.createUpdate("UPDATE order_details SET import_price = 0 WHERE id = :id")
                            .bind("id", detail.getId())
                            .execute();
                }
            }
        });
    }

    private void handleOrderDelivery(int orderId) {
        get().useHandle(handle -> {
            handle.createUpdate("UPDATE payments SET payment_status = 'Đã thanh toán', payment_date = CURDATE() WHERE order_id = :orderId")
                    .bind("orderId", orderId)
                    .execute();

            List<OrderDetails> items = handle.createQuery(
                            "SELECT id, order_id AS orderId, product_id AS productId, quantity, unit_price AS unitPrice FROM order_details WHERE order_id = :orderId")
                    .bind("orderId", orderId)
                    .mapToBean(OrderDetails.class)
                    .list();

            for (OrderDetails item : items) {
                int qtyNeeded = item.getQuantity();
                int initialQty = qtyNeeded;
                long totalCostOfItem = 0;

                List<Map<String, Object>> activeBatches = handle.createQuery(
                                "SELECT id, import_price, quantity_imported, quantity_issued " +
                                        "FROM warehouses WHERE product_id = :productId AND quantity_imported > quantity_issued " +
                                        "ORDER BY import_date ASC, id ASC")
                        .bind("productId", item.getProductId())
                        .mapToMap()
                        .list();

                for (Map<String, Object> batch : activeBatches) {
                    if (qtyNeeded <= 0) break;

                    int batchId = ((Number) batch.get("id")).intValue();
                    long importPrice = ((Number) batch.get("import_price")).longValue();
                    int imported = ((Number) batch.get("quantity_imported")).intValue();
                    int issued = ((Number) batch.get("quantity_issued")).intValue();
                    int available = imported - issued;

                    if (available >= qtyNeeded) {
                        handle.createUpdate("UPDATE warehouses SET quantity_issued = quantity_issued + :qty WHERE id = :id")
                                .bind("qty", qtyNeeded)
                                .bind("id", batchId)
                                .execute();

                        totalCostOfItem += importPrice * qtyNeeded;
                        qtyNeeded = 0;
                    } else {
                        handle.createUpdate("UPDATE warehouses SET quantity_issued = quantity_imported WHERE id = :id")
                                .bind("id", batchId)
                                .execute();

                        totalCostOfItem += importPrice * available;
                        qtyNeeded -= available;
                    }
                }

                if (qtyNeeded > 0) {
                    Long fallbackPrice = handle.createQuery(
                                    "SELECT import_price FROM warehouses WHERE product_id = :productId ORDER BY id DESC LIMIT 1")
                            .bind("productId", item.getProductId())
                            .mapTo(Long.class)
                            .findOne()
                            .orElse((long) (item.getUnitPrice() * 0.6));

                    totalCostOfItem += fallbackPrice * qtyNeeded;
                }

                long finalUnitCost = Math.round((double) totalCostOfItem / initialQty);

                handle.createUpdate("UPDATE order_details SET import_price = :importPrice WHERE id = :id")
                        .bind("importPrice", finalUnitCost)
                        .bind("id", item.getId())
                        .execute();
            }
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

    public Order getOrderById(int orderId) {
        return get().withHandle(handle ->
                handle.createQuery("SELECT * FROM orders WHERE id = :orderId")
                        .bind("orderId", orderId)
                        .mapToBean(Order.class)
                        .findOne()
                        .orElse(null)
        );
    }

    public void markAsPaid(int orderId) {
        get().useHandle(handle -> {
            handle.createUpdate("UPDATE payments SET payment_status = 'Đã thanh toán', payment_date = CURDATE() WHERE order_id = :orderId")
                    .bind("orderId", orderId)
                    .execute();
        });
    }

    public void markAsCancelled(int orderId) {
        updateOrderStatus(orderId, "Đã hủy");
    }

    public boolean isPaid(int orderId) {
        return get().withHandle(handle ->
                handle.createQuery("SELECT payment_status FROM payments WHERE order_id = :orderId")
                        .bind("orderId", orderId)
                        .mapTo(String.class)
                        .findOne()
                        .map(status -> "Đã thanh toán".equalsIgnoreCase(status))
                        .orElse(false)
        );
    }

    private static final Object STOCK_LOCK = new Object();

    public int createOrderWithStockCheck(int userId, double totalAmount, int addressId, List<vn.edu.hcmuaf.fit.doanweb.Cart.CartItem> items, double shippingFee, String shipMethod) throws Exception {
        synchronized (STOCK_LOCK) {
            return get().inTransaction(handle -> {
                int orderId = handle.createUpdate("INSERT INTO orders (user_id, order_date, total_amount, status, address_id, shipping_fee, ship_method) " +
                                "VALUES (:userId, NOW(), :totalAmount, 'Đang xử lý', :addressId, :shippingFee, :shipMethod)")
                        .bind("userId", userId)
                        .bind("totalAmount", totalAmount)
                        .bind("addressId", addressId)
                        .bind("shippingFee", shippingFee)
                        .bind("shipMethod", shipMethod)
                        .executeAndReturnGeneratedKeys("id")
                        .mapTo(Integer.class)
                        .one();

                if (orderId <= 0) {
                    throw new Exception("Không thể tạo đơn hàng.");
                }
                vn.edu.hcmuaf.fit.doanweb.dao.ProductDao productDao = new vn.edu.hcmuaf.fit.doanweb.dao.ProductDao();
                for (vn.edu.hcmuaf.fit.doanweb.Cart.CartItem item : items) {
                    int productId = item.getProduct().getId();
                    int orderQty = item.getQuantity();
                    boolean isStockDecreased = productDao.decreaseStock(productId, orderQty, handle);

                    if (!isStockDecreased) {
                        String prodName = handle.createQuery("SELECT name FROM products WHERE id = :id")
                                .bind("id", productId)
                                .mapTo(String.class)
                                .findOne().orElse("Sản phẩm");
                        throw new Exception("Sản phẩm [" + prodName + "] đã hết hàng hoặc không đủ số lượng tồn kho, vui lòng chọn sản phẩm khác.");
                    }
                    handle.createUpdate("INSERT INTO order_details (order_id, product_id, unit_price, quantity, import_price) VALUES (:orderId, :productId, :price, :qty, 0)")
                            .bind("orderId", orderId)
                            .bind("productId", productId)
                            .bind("price", item.getPrice())
                            .bind("qty", orderQty)
                            .execute();
                }
                return orderId;
            });
        }
    }

    public boolean cancelOrder(int orderId) {
        try {
            int rowsUpdated = get().withHandle(handle ->
                    handle.createUpdate("UPDATE orders SET status = 'Đã hủy' WHERE id = :orderId AND status = 'Đang xử lý'")
                            .bind("orderId", orderId)
                            .execute()
            );
            return rowsUpdated > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}
