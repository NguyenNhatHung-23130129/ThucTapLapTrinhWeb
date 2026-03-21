package vn.edu.hcmuaf.fit.doanweb.dao;

import vn.edu.hcmuaf.fit.doanweb.model.Invoices;

import java.util.List;

public class InvoicesDao extends BaseDao {

    public List<Invoices> getAllInvoices() {
      return  get().withHandle(handle -> handle.createQuery("SELECT i.*,p.payment_status as paymentStatus  FROM invoices i Join payments p ON i.payment_id = p.id JOIN orders o ON i.order_id = o.id JOIN users u ON o.user_id = u.id ORDER BY i.issued_date DESC")
                .mapToBean(Invoices.class)
                .list());

    }

}
