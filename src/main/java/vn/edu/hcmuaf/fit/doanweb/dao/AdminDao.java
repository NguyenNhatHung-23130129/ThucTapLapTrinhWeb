package vn.edu.hcmuaf.fit.doanweb.dao;

import java.util.List;
import java.util.Map;

public class AdminDao extends BaseDao {
    public int countTotalUsers() {
        return get().withHandle(handle ->
                handle.createQuery("SELECT COUNT(*) FROM users")
                        .mapTo(Integer.class)
                        .one()
        );
    }

    public int countTotalOrders() {
        return get().withHandle(handle ->
                handle.createQuery("SELECT COUNT(*) FROM orders")
                        .mapTo(Integer.class)
                        .one()
        );
    }

    public int countTotalProducts() {
        return get().withHandle(handle ->
                handle.createQuery("SELECT COUNT(*) FROM products")
                        .mapTo(Integer.class)
                        .one()
        );
    }

    public double getTotalRevenue() {
        return get().withHandle(handle ->
                handle.createQuery("SELECT COALESCE(SUM(total_amount), 0) FROM orders WHERE status ='Đã giao'")
                        .mapTo(Double.class)
                        .one()
        );
    }

    // doanh thu trong 6 thang
    public List<Map<String, Object>> getRevenueAndOrdersLast6Months() {
        return get().withHandle(handle -> handle.createQuery("SELECT DATE_FORMAT(order_date, '%m/%Y') as month, SUM(total_amount) as revenue, COUNT(id) as order_count " +
                        "FROM orders WHERE status = 'Đã giao' AND order_date >= DATE_SUB(NOW(), INTERVAL 6 MONTH) GROUP BY DATE_FORMAT(order_date, '%m/%Y'), YEAR(order_date), MONTH(order_date) " +
                        "ORDER BY YEAR(order_date) ASC, MONTH(order_date) ASC")
                .mapToMap().list());
    }


    public List<Map<String, Object>> getProductCountByCategory() {
        return get().withHandle(handle ->
                handle.createQuery("SELECT c.name as category_name, COUNT(p.id) as product_count " +
                                "FROM categories c LEFT JOIN products p ON c.id = p.category_id " +
                                "GROUP BY c.id, c.name")
                        .mapToMap().list()
        );
    }

    public List<Map<String, Object>> getNewUsersLast6Months() {
        return get().withHandle(handle -> handle.createQuery("SELECT DATE_FORMAT(created_at, '%m/%Y') as month, COUNT(id) as user_count " +
                        "FROM users WHERE created_at >= DATE_SUB(NOW(), INTERVAL 6 MONTH) " +
                        "GROUP BY DATE_FORMAT(created_at, '%m/%Y'), YEAR(created_at), MONTH(created_at) ORDER BY YEAR(created_at) ASC, MONTH(created_at) ASC")
                .mapToMap().list());
    }


}
