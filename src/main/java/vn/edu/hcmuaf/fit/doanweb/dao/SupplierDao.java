package vn.edu.hcmuaf.fit.doanweb.dao;

import org.jdbi.v3.core.statement.PreparedBatch;
import vn.edu.hcmuaf.fit.doanweb.model.Supplier;

import java.util.List;

public class SupplierDao extends BaseDao {

    public List<Supplier> getAllSuppliers() {
        return get().withHandle(handle -> handle.createQuery("SELECT * FROM suppliers")
                .mapToBean(Supplier.class)
                .list()
        );

    }

    public List<Supplier> searchSupplier(String trim) {
        return  get().withHandle(handle ->
            handle.createQuery("SELECT * FROM suppliers WHERE name LIKE :keyword ")
                    .bind("keyword", "%" + trim + "%")
                    .mapToBean(Supplier.class)
                    .list()
        );

    }
    public void insertSupplier(Supplier supplier) {
        get().withHandle(handle ->
            handle.createUpdate("INSERT INTO suppliers (name, address, phone, email) VALUES (:name, :address, :phone, :email)")
                    .bind("name", supplier.getName())
                    .bind("address", supplier.getAddress())
                    .bind("phone", supplier.getPhone())
                    .bind("email", supplier.getEmail())
                    .execute()
        );
    }
    public void updateSupplier(Supplier supplier) {
        get().withHandle(handle ->
            handle.createUpdate("UPDATE suppliers SET name = :name, address = :address, phone = :phone, email = :email WHERE id = :id")
                    .bind("name", supplier.getName())
                    .bind("address", supplier.getAddress())
                    .bind("phone", supplier.getPhone())
                    .bind("email", supplier.getEmail())
                    .bind("id", supplier.getId())
                    .execute()
        );
    }

}
