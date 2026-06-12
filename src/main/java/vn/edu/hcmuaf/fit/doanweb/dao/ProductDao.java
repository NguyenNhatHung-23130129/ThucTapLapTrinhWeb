package vn.edu.hcmuaf.fit.doanweb.dao;

import java.util.Collections;
import java.util.List;

import vn.edu.hcmuaf.fit.doanweb.model.Product;

public class ProductDao extends BaseDao {
    private static final int PRODUCTS_PER_PAGE = 20;

    public static ProductDao getInstance() {
        return new ProductDao();
    }

    public Product getProductById(int id) {
        return get().withHandle(handle -> handle.createQuery("SELECT p.*, COALESCE(AVG(r.rating), 0.0) AS averageRating, COUNT(r.id) AS ratingCount FROM products p LEFT JOIN reviews r ON p.id = r.product_id WHERE p.id = :id GROUP BY p.id")
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

                handle.createQuery("SELECT p.*, COALESCE(AVG(r.rating), 0.0) AS averageRating, COUNT(r.id) AS ratingCount FROM products p JOIN (SELECT id FROM products ORDER BY discount DESC LIMIT :limit OFFSET :offset) AS sub ON p.id = sub.id LEFT JOIN reviews r ON p.id = r.product_id WHERE p.active = 1 GROUP BY p.id ORDER BY p.discount DESC, p.id DESC")
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
                        "SELECT p.*, COALESCE(AVG(r.rating), 0.0) AS averageRating, COUNT(r.id) AS ratingCount FROM products p LEFT JOIN reviews r ON p.id = r.product_id WHERE p.category_id = :categoryId AND p.id != :currentId GROUP BY p.id LIMIT 4")
                .bind("categoryId", categoryId)
                .bind("currentId", currentProductId)
                .mapToBean(Product.class)
                .list()
        );

    }


    public List<Product> searchProducts(String keyword) {
        if (keyword == null || keyword.trim().isEmpty()) {
            return Collections.emptyList();
        }

        String cleanKeyword = keyword.trim().toLowerCase();
        String sql;

        if (cleanKeyword.length() <= 3) {
            sql = "SELECT id, name, image_url FROM products " +
                    "WHERE active = 1 AND name COLLATE utf8mb4_unicode_ci LIKE :likeKeyword COLLATE utf8mb4_unicode_ci " +
                    "ORDER BY CASE WHEN name COLLATE utf8mb4_unicode_ci LIKE :startKeyword COLLATE utf8mb4_unicode_ci THEN 1 ELSE 2 END ASC, CHAR_LENGTH(name) ASC, name ASC " +
                    "LIMIT 10";

            return get().withHandle(handle -> handle.createQuery(sql)
                    .bind("likeKeyword", "%" + cleanKeyword + "%")
                    .bind("startKeyword", cleanKeyword + "%")
                    .mapToBean(Product.class)
                    .list()
            );
        }
        else {
            String[] words = cleanKeyword.split("\\s+");
            StringBuilder ftKeyword = new StringBuilder();
            for (String word : words) {
                if (!word.isEmpty()) {
                    ftKeyword.append("+").append(word).append("* ");
                }
            }

            sql = "SELECT id, name, image_url, MATCH(name) AGAINST(:ftKeyword IN BOOLEAN MODE) AS score " +
                    "FROM products " +
                    "WHERE active = 1 AND MATCH(name) AGAINST(:ftKeyword IN BOOLEAN MODE) " +
                    "ORDER BY " +
                    "  score DESC, " +
                    "  CASE " +
                    "    WHEN name LIKE :startKeyword THEN 1 " +
                    "    ELSE 2 " +
                    "  END ASC, " +
                    "  LENGTH(name) ASC, " +
                    "  name ASC " +
                    "LIMIT 10";

            return get().withHandle(handle -> handle.createQuery(sql)
                    .bind("ftKeyword", ftKeyword.toString().trim())
                    .bind("startKeyword", cleanKeyword + "%")
                    .mapToBean(Product.class)
                    .list()
            );
        }
    }
    public List<Product> getProductsByCategoryId(int cid) {
        return get().withHandle(handle ->
                handle.createQuery("SELECT * FROM products WHERE category_id = :cid AND active = 1 ORDER BY id DESC")
                        .bind("cid", cid)
                        .mapToBean(Product.class)
                        .list()
        );
    }

    public boolean decreaseStock(int productId, int quantity, org.jdbi.v3.core.Handle handle) {
        int rowsUpdated = handle.createUpdate(
                        "UPDATE products SET stock_quantity = stock_quantity - :qty WHERE id = :productId AND stock_quantity >= :qty")
                .bind("qty", quantity)
                .bind("productId", productId)
                .execute();

        return rowsUpdated > 0;
    }
}