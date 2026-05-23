package vn.edu.hcmuaf.fit.doanweb.dao;

import java.util.List;

import vn.edu.hcmuaf.fit.doanweb.model.Product;

public class ProductDao extends BaseDao {
    private static final int PRODUCTS_PER_PAGE = 20;

    public static ProductDao getInstance() {
        return new ProductDao();
    }

    public Product getProductById(int id) {
        return get().withHandle(handle -> handle.createQuery("SELECT p.*, COALESCE(AVG(r.rating), 0.0) AS ratingAvg, COUNT(r.id) AS ratingCount FROM products p LEFT JOIN reviews r ON p.id = r.product_id WHERE p.id = :id GROUP BY p.id")
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

                handle.createQuery("SELECT p.*, COALESCE(AVG(r.rating), 0.0) AS ratingAvg, COUNT(r.id) AS ratingCount FROM products p JOIN (SELECT id FROM products ORDER BY discount DESC LIMIT :limit OFFSET :offset) AS sub ON p.id = sub.id LEFT JOIN reviews r ON p.id = r.product_id WHERE p.active = 1 GROUP BY p.id ORDER BY p.discount DESC, p.id DESC")
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
                            "VALUES (:name, :categoryId, :price, :discount, :unitOfMeasure, :imageUrl, :description, :nutritionalInformation, :productionDate, :expiryDate, 0, 0)")
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
                        "SELECT p.*, COALESCE(AVG(r.rating), 0.0) AS ratingAvg, COUNT(r.id) AS ratingCount FROM products p LEFT JOIN reviews r ON p.id = r.product_id WHERE p.category_id = :categoryId AND p.id != :currentId GROUP BY p.id LIMIT 4")
                .bind("categoryId", categoryId)
                .bind("currentId", currentProductId)
                .mapToBean(Product.class)
                .list()
        );

    }

    public List<Product> searchProducts(String keyword) {
        return get().withHandle(handle -> handle.createQuery("SELECT * FROM products WHERE name LIKE :likeKeyword AND active = 1 " +
                                "ORDER BY LOCATE(:exactKeyword, name) ASC, name ASC LIMIT 10" )
                .bind("likeKeyword", "%" + keyword + "%")
                .bind("exactKeyword", keyword)
                .mapToBean(Product.class)
                .list()
        );
    }

    public List<Product> getProductsByCategoryId(int cid) {
        return get().withHandle(handle ->
                handle.createQuery("SELECT * FROM products WHERE category_id = :cid AND active = 1 ORDER BY id DESC")
                        .bind("cid", cid)
                        .mapToBean(Product.class)
                        .list()
        );
    }
    public boolean decreaseStock(int productId, int quantity, java.sql.Connection connection) throws java.sql.SQLException {
        try (java.sql.PreparedStatement stmt = connection.prepareStatement(
                "UPDATE products SET stock_quantity = stock_quantity - ? WHERE id = ? AND stock_quantity >= ?")) {
            stmt.setInt(1, quantity);
            stmt.setInt(2, productId);
            stmt.setInt(3, quantity);
            int rowsUpdated = stmt.executeUpdate();
            return rowsUpdated > 0;
        }
    }
}