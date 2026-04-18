package vn.edu.hcmuaf.fit.doanweb.dao;

import vn.edu.hcmuaf.fit.doanweb.model.Invoices;

import java.util.List;
import java.util.Map;

public class InvoicesDao extends BaseDao {

    public List<Invoices> searchInvoices(String keyword) {
        return get().withHandle(handle -> handle.createQuery("SELECT i.*, p.payment_status as paymentStatus, u.name as customerName " +
                        "FROM invoices i LEFT JOIN payments p ON i.payment_id = p.id LEFT JOIN orders o ON i.order_id = o.id LEFT JOIN users u ON o.user_id = u.id " +
                        "WHERE i.invoice_number LIKE :likeKw OR u.name LIKE :likeKw " +
                        "ORDER BY (i.invoice_number = :exactKw) DESC, (u.name = :exactKw) DESC, i.issued_date DESC")
                .bind("likeKw", "%" + keyword.trim() + "%")
                .bind("exactKw", keyword.trim())
                .mapToBean(Invoices.class)
                .list());
    }

    public List<Invoices> getAllInvoices() {
        return get().withHandle(handle -> handle.createQuery("SELECT i.*, p.payment_status as paymentStatus, u.name as customerName " +
                        "FROM invoices i LEFT JOIN payments p ON i.payment_id = p.id LEFT JOIN orders o ON i.order_id = o.id LEFT JOIN users u ON o.user_id = u.id " +
                        "ORDER BY i.issued_date DESC")
                .mapToBean(Invoices.class)
                .list());
    }
}
