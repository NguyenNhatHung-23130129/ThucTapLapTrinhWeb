package vn.edu.hcmuaf.fit.doanweb.dao;

import java.util.List;
import java.util.Map;

public class AdminDao extends BaseDao {

    public List<Map<String, Object>> getFinancialPerformanceLast6Months() {
        return get().withHandle(handle -> handle.createQuery(
                        "SELECT DATE_FORMAT(o.order_date, '%m/%Y') as month, " +
                                "SUM(od.quantity * od.unit_price) as revenue, " +
                                "SUM(od.quantity * COALESCE((SELECT import_price FROM warehouses w WHERE w.product_id = od.product_id ORDER BY w.id DESC LIMIT 1), 0)) as cost, " +
                                "SUM(od.quantity * (od.unit_price - COALESCE((SELECT import_price FROM warehouses w WHERE w.product_id = od.product_id ORDER BY w.id DESC LIMIT 1), 0))) as profit " +
                                "FROM orders o JOIN order_details od ON o.id = od.order_id " +
                                "WHERE o.status = 'Đã giao' AND o.order_date >= DATE_SUB(NOW(), INTERVAL 6 MONTH) " +
                                "GROUP BY DATE_FORMAT(o.order_date, '%m/%Y'), YEAR(o.order_date), MONTH(o.order_date) " +
                                "ORDER BY YEAR(o.order_date) ASC, MONTH(o.order_date) ASC")
                .mapToMap().list()
        );
    }

    public List<Map<String, Object>> getOrderStatusLast6Months() {
        return get().withHandle(handle -> handle.createQuery(
                        "SELECT DATE_FORMAT(order_date, '%m/%Y') as month, COUNT(CASE WHEN status = 'Đã giao' THEN 1 END) as success_orders, " +
                                "COUNT(CASE WHEN status = 'Đã hủy' THEN 1 END) as cancel_orders " +
                                "FROM orders " +
                                "WHERE order_date >= DATE_SUB(NOW(), INTERVAL 6 MONTH) " +
                                "GROUP BY DATE_FORMAT(order_date, '%m/%Y'), YEAR(order_date), MONTH(order_date) " +
                                "ORDER BY YEAR(order_date) ASC, MONTH(order_date) ASC")
                .mapToMap().list()
        );
    }

    public List<Map<String, Object>> getCustomerRetention() {
        return get().withHandle(handle -> handle.createQuery(
                        "SELECT COUNT(CASE WHEN order_count = 1 THEN 1 END) as new_customers, " +
                                "COUNT(CASE WHEN order_count > 1 THEN 1 END) as returning_customers " +
                                "FROM (SELECT user_id, COUNT(id) as order_count FROM orders WHERE status = 'Đã giao' GROUP BY user_id) as user_orders")
                .mapToMap().list()
        );
    }

    public List<Map<String, Object>> getCategoryPerformance() {
        return get().withHandle(handle -> handle.createQuery(
                        "SELECT c.name as category_name,SUM(od.quantity * od.unit_price) as category_revenue, " +
                                "SUM(od.quantity) as items_sold " +
                                "FROM order_details od JOIN orders o ON od.order_id = o.id JOIN products p ON od.product_id = p.id JOIN categories c ON p.category_id = c.id " +
                                "WHERE o.status = 'Đã giao' AND MONTH(o.order_date) = MONTH(CURRENT_DATE) " +
                                "GROUP BY c.id, c.name")
                .mapToMap().list()
        );
    }

    public Object getTotalRevenue() {
        return get().withHandle(handle ->
                handle.createQuery("SELECT COALESCE(SUM(total_amount), 0) FROM orders WHERE status = 'Đã giao'")
                        .mapTo(Double.class)
                        .one()
        );
    }

    public int countPendingOrders() {
        return get().withHandle(handle ->
                handle.createQuery("SELECT COUNT(*) FROM orders WHERE status IN ('Đang xử lý')")
                        .mapTo(Integer.class)
                        .one()
        );
    }

    public double getAverageOrderValue() {
        return get().withHandle(handle ->
                handle.createQuery("SELECT COALESCE(SUM(total_amount) / NULLIF(COUNT(id), 0), 0) FROM orders WHERE status = 'Đã giao' AND MONTH(order_date) = MONTH(CURRENT_DATE)")
                        .mapTo(Double.class)
                        .one()
        );
    }

    public double getCancellationRate() {
        return get().withHandle(handle ->
                handle.createQuery("SELECT COALESCE((COUNT(CASE WHEN status = 'Đã hủy' THEN 1 END) * 100.0 / NULLIF(COUNT(id), 0)), 0) FROM orders WHERE order_date >= DATE_SUB(CURRENT_DATE, INTERVAL 30 DAY)")
                        .mapTo(Double.class)
                        .one()
        );
    }

    public List<Map<String, Object>> getBestSellers() {
        return get().withHandle(handle -> handle.createQuery(
                        "SELECT p.id, p.name, p.image_url, SUM(od.quantity) as total_sold, SUM(od.quantity * od.unit_price) as total_revenue " +
                                "FROM order_details od JOIN orders o ON od.order_id = o.id JOIN products p ON od.product_id = p.id " +
                                "WHERE o.status = 'Đã giao' AND MONTH(o.order_date) = MONTH(CURRENT_DATE) " +
                                "GROUP BY p.id, p.name, p.image_url ORDER BY total_sold DESC, total_revenue DESC LIMIT 10")
                .mapToMap().list());
    }

    public List<Map<String, Object>> getLowStockProducts() {
        return get().withHandle(handle -> handle.createQuery(
                        "SELECT id, name, stock_quantity, image_url FROM products WHERE active = 1 AND stock_quantity < 20 ORDER BY stock_quantity ASC LIMIT 10")
                .mapToMap().list());
    }

    public List<Map<String, Object>> getExpiringProducts() {
        return get().withHandle(handle -> handle.createQuery(
                        "SELECT id, name, expiry_date, DATEDIFF(expiry_date, CURRENT_DATE) as days_left " +
                                "FROM products " +
                                "WHERE active = 1 AND expiry_date IS NOT NULL AND expiry_date BETWEEN CURRENT_DATE AND DATE_ADD(CURRENT_DATE, INTERVAL 30 DAY) " +
                                "ORDER BY expiry_date ASC LIMIT 10")
                .mapToMap().list());
    }


}
