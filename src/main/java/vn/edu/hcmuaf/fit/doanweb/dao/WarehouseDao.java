package vn.edu.hcmuaf.fit.doanweb.dao;

import vn.edu.hcmuaf.fit.doanweb.model.Warehouse;

import java.util.List;

public class WarehouseDao extends BaseDao {

    public void insert(Warehouse w) {
        get().useHandle(handle -> {

            handle.createUpdate("INSERT INTO WareHouses (product_id, supplier_id, status, import_price, quantity_imported, preservation_methods, import_date) " +
                            "VALUES (:productId, :supplierId, :status, :importPrice, :quantityImported, :preservationMethod, NOW())")
                    .bind("productId", w.getProductId())
                    .bind("supplierId", w.getSupplierId())
                    .bind("status", w.getStatus())
                    .bind("importPrice", w.getImportPrice())
                    .bind("quantityImported", w.getQuantityImported())
                    .bind("preservationMethod", w.getPreservationMethod())
                    .execute();
        });
    }


    public void update(int id, boolean newStatus) {
        get().useHandle(handle -> {

            Warehouse currentWh = handle.createQuery("SELECT * FROM warehouses WHERE id = :id")
                    .bind("id", id)
                    .mapToBean(Warehouse.class)
                    .first();


            if (!currentWh.getStatus() && newStatus) {
                handle.createUpdate("UPDATE products SET stock_quantity = stock_quantity + :qty WHERE id = :productId")
                        .bind("qty", currentWh.getQuantityImported())
                        .bind("productId", currentWh.getProductId())
                        .execute();
            }
            handle.createUpdate("UPDATE WareHouses SET status = :status WHERE id = :id")
                    .bind("status", newStatus)
                    .bind("id", id)
                    .execute();
        });
    }


    public List<Warehouse> getAllWarehouse() {
        return get().withHandle(handle ->
                handle.createQuery("SELECT w.*,p.name as productName, s.name as supplierName FROM warehouses w join products p on w.product_id = p.id join suppliers s on w.supplier_id = s.id ORDER BY w.import_date DESC")
                        .mapToBean(Warehouse.class)
                        .list()


        );
    }

    public List<Warehouse> searchWarehouses(String trim) {
        return get().withHandle(handle ->
                handle.createQuery("SELECT w.*,p.name as productName, s.name as supplierName FROM warehouses w join products p on w.product_id = p.id join suppliers s on w.supplier_id = s.id WHERE p.name LIKE :trim OR s.name LIKE :trim ORDER BY w.import_date DESC")
                        .bind("trim", "%" + trim + "%")
                        .mapToBean(Warehouse.class)
                        .list()
        );
    }
}
