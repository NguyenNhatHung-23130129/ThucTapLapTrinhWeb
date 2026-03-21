package vn.edu.hcmuaf.fit.doanweb.dao;

import vn.edu.hcmuaf.fit.doanweb.model.Shipping;

import java.util.List;

public class ShippingDao extends BaseDao {

    public List<Shipping> getShippingMethods() {
        return get().withHandle(handle -> handle.createQuery("SELECT shipping.*, users.name as customerName FROM shipping JOIN orders ON shipping.order_id = orders.id JOIN users ON orders.user_id = users.id ORDER BY shipping.id DESC")
                .mapToBean(Shipping.class)
                .list()
        );
    }

}
