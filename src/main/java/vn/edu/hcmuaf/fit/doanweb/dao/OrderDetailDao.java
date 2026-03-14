package vn.edu.hcmuaf.fit.doanweb.dao;

import vn.edu.hcmuaf.fit.doanweb.model.OrderDetails;
import vn.edu.hcmuaf.fit.doanweb.model.Product;
import java.util.List;

public class OrderDetailDao extends BaseDao {


    public void saveDetail(int orderId, int productId, double price, int quantity) {

        String sql = "INSERT INTO order_details (order_id, product_id, unit_price, quantity) VALUES (:orderId, :productId, :price, :quantity)";

        get().useHandle(handle ->
                handle.createUpdate(sql)
                        .bind("orderId", orderId)
                        .bind("productId", productId)
                        .bind("price", price) // Gửi giá tiền vào
                        .bind("quantity", quantity)
                        .execute()
        );
    }


    public List<OrderDetails> getDetailsByOrderId(int orderId) {
        String sql = "SELECT od.id, od.order_id, od.quantity, p.price, " +
                "p.id as p_id, p.name, p.image_url " +
                "FROM order_details od " +
                "JOIN products p ON od.product_id = p.id " +
                "WHERE od.order_id = :orderId";

        return get().withHandle(handle ->
                handle.createQuery(sql)
                        .bind("orderId", orderId)
                        .map((rs, ctx) -> {
                            Product p = new Product();
                            p.setId(rs.getInt("p_id"));
                            p.setName(rs.getString("name"));
                            p.setImageUrl(rs.getString("image_url"));

                            int quantity = rs.getInt("quantity");
                            long currentPrice = rs.getLong("price");

                            OrderDetails od = new OrderDetails();
                            od.setId(rs.getInt("id"));
                            od.setOrderId(rs.getInt("order_id"));
                            od.setQuantity(quantity);
                            od.setUnitPrice(currentPrice * quantity);
                            od.setProduct(p);

                            return od;
                        })
                        .list()
        );
    }
}