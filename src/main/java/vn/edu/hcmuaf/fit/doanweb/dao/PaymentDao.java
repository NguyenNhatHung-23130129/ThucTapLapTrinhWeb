package vn.edu.hcmuaf.fit.doanweb.dao;
import java.sql.*;
import java.util.List;

import vn.edu.hcmuaf.fit.doanweb.model.Payment;



public class PaymentDao extends BaseDao {
    public boolean insertPayment(int orderId, String paymentMethod, String paymentStatus) {
        try {
            int result = get().withHandle(handle ->
                    handle.createUpdate("INSERT INTO payments (order_id, payment_method, payment_status, payment_date) VALUES (:orderId, :paymentMethod, :paymentStatus, NOW())")
                            .bind("orderId", orderId)
                            .bind("paymentMethod", paymentMethod)
                            .bind("paymentStatus", paymentStatus)
                            .execute()
            );
            return result > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public Payment getPaymentByOrderId(int orderId) {
        return get().withHandle(handle ->
                handle.createQuery("SELECT * FROM payments WHERE orderId = :orderId")
                        .bind("orderId", orderId)
                        .mapToBean(Payment.class)
                        .findOne()
                        .orElse(null)
        );
    }


    public List<Payment> getAllPayments() {
        return get().withHandle(handle ->
                handle.createQuery("SELECT * FROM payments ORDER BY paymentDate DESC")
                        .mapToBean(Payment.class)
                        .list()
        );
    }
}
