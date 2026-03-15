package vn.edu.hcmuaf.fit.doanweb.dao;

import java.util.List;

import vn.edu.hcmuaf.fit.doanweb.model.Product;

public class ProductDao extends BaseDao {
    private static final int PRODUCTS_PER_PAGE = 20;

    public static ProductDao getInstance() {
        return new ProductDao();
    }

    public Product getProductById(int id) {
        return get().withHandle(handle -> handle.createQuery("SELECT * FROM products WHERE id = :id ")
                .bind("id", id)
                .mapToBean(Product.class)
                .findFirst()
                .orElse(null)
        );
    }

    // Lấy sản phẩm theo trang
    public List<Product> getProductsByPage(int page) {
        int offset = (page - 1) * PRODUCTS_PER_PAGE;
        return get().withHandle(handle ->

                handle.createQuery(
                                "SELECT p.* " +
                                        "FROM products p JOIN (SELECT id FROM products ORDER BY discount DESC LIMIT :limit OFFSET :offset) AS sub ON p.id = sub.id " +
                                        "WHERE p.active = 1 " +
                                        "ORDER BY p.discount DESC, p.id DESC"
                        )
                        .bind("limit", PRODUCTS_PER_PAGE)
                        .bind("offset", offset)
                        .mapToBean(Product.class)
                        .list()
        );
    }

    public List<Product> getProducts() {
        return get().withHandle(handle -> handle.createQuery("SELECT * FROM products  ORDER BY discount DESC, id DESC ")
                .mapToBean(Product.class)
                .list()
        );
    }

    // Lấy tổng số sản phẩm
    public int getTotalProducts() {
        return get().withHandle(handle ->
                handle.createQuery("SELECT COUNT(*) FROM products")
                        .mapTo(Integer.class)
                        .one()
        );
    }


    public List<Product> getAllProducts() {
        return get().withHandle(handle ->
                handle.createQuery("SELECT p.*, c.name as categoryName FROM products p join categories c on p.category_id = c.id order by p.id desc")
                        .mapToBean(Product.class)
                        .list()
        );
    }

    public void insertProduct(Product p) {
        get().useHandle(handle -> {
            handle.createUpdate("INSERT INTO products (name, category_id, price, discount, unit_of_measure, image_url, description, nutritional_information, production_date, expiry_date, active, stock_quantity) " +
                            "VALUES (:name, :categoryId, :price, :discount, :unitOfMeasure, :imageUrl, :description, :nutritionalInformation, :productionDate, :expiryDate, 1, 0)")
                    .bindBean(p)
                    .execute();
        });
    }

    public void deleteProduct(int id) {
        get().useHandle(handle ->
                handle.createUpdate("UPDATE products SET active = 0 WHERE id = :id").bind("id", id).execute()
        );
    }

    public void updateProduct(Product p) {
        get().useHandle(handle -> {
            handle.createUpdate("UPDATE products SET name=:name, category_id=:categoryId, price=:price, discount=:discount, unit_of_measure=:unitOfMeasure, image_url=:imageUrl, description=:description, nutritional_information=:nutritionalInformation, production_date=:productionDate, expiry_date=:expiryDate, active=:active " +
                            "WHERE id=:id")
                    .bindBean(p)
                    .execute();
        });
    }


    public List<Product> getRelatedProducts(int categoryId, int currentProductId) {
        return get().withHandle(handle -> handle.createQuery(
                        "SELECT * FROM products WHERE category_id = :categoryId AND id != :currentId LIMIT 4")
                .bind("categoryId", categoryId)
                .bind("currentId", currentProductId)
                .mapToBean(Product.class)
                .list()
        );

    }

    public List<Product> searchProducts(String trim) {
        return get().withHandle(handle -> handle.createQuery("SELECT * FROM products WHERE name LIKE :keyword AND active = 1")
                .bind("keyword", "%" + trim + "%")
                .mapToBean(Product.class)
                .list()
        );
    }
}