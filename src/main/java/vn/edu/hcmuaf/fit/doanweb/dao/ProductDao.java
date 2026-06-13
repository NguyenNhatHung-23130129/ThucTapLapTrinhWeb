package vn.edu.hcmuaf.fit.doanweb.dao;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

import org.jdbi.v3.core.statement.Query;
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

        String cleanKeyword = keyword.trim().toLowerCase().replaceAll("\\s+", " ");
        String[] rawWords = cleanKeyword.split("\\s+");

        List<String> words = new ArrayList<>();
        for (String word : rawWords) {
            if (!word.isEmpty() && !words.contains(word)) {
                words.add(word);
            }
        }

        if (words.isEmpty()) {
            return Collections.emptyList();
        }

        String whereWords = "";
        String scoreWords = "";

        for (int i = 0; i < words.size(); i++) {
            whereWords += " AND LOWER(name) LIKE :word" + i;
            scoreWords += " + CASE " +
                    "WHEN BINARY LOWER(name) LIKE BINARY :word" + i + " THEN 120 " +
                    "WHEN LOWER(name) LIKE :word" + i + " THEN 80 " +
                    "ELSE 0 END";
        }

        String sql = "SELECT id, name, image_url, (" +
                "CASE " +
                "WHEN BINARY LOWER(name) = BINARY :exactKeyword THEN 1200 " +
                "WHEN BINARY LOWER(name) LIKE BINARY :startKeyword THEN 1000 " +
                "WHEN BINARY LOWER(name) LIKE BINARY :fullKeyword THEN 900 " +
                "WHEN LOWER(name) = :exactKeyword THEN 700 " +
                "WHEN LOWER(name) LIKE :startKeyword THEN 500 " +
                "WHEN LOWER(name) LIKE :fullKeyword THEN 300 " +
                "ELSE 0 END" +
                scoreWords + ") AS score " +
                "FROM products " +
                "WHERE active = 1 AND (LOWER(name) LIKE :fullKeyword OR (1 = 1" + whereWords + ")) " +
                "ORDER BY score DESC, CHAR_LENGTH(name) ASC, name ASC LIMIT 10";

        final String finalSql = sql;
        final List<String> finalWords = words;

        return get().withHandle(handle -> {
            Query query = handle.createQuery(finalSql)
                    .bind("exactKeyword", cleanKeyword)
                    .bind("startKeyword", cleanKeyword + "%")
                    .bind("fullKeyword", "%" + cleanKeyword + "%");

            for (int i = 0; i < finalWords.size(); i++) {
                query.bind("word" + i, "%" + finalWords.get(i) + "%");
            }

            return query.mapToBean(Product.class).list();
        });
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