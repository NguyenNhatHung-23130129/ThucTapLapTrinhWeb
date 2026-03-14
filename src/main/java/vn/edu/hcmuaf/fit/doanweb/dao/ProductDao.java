package vn.edu.hcmuaf.fit.doanweb.dao;

import java.util.List;


import org.jdbi.v3.core.statement.PreparedBatch;

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
            handle.createUpdate("INSERT INTO products (name, category_id, price, discount, unit_of_measure, image_url, description,nutritional_information, production_date, expiry_date, active, stock_quantity) " +
                            "VALUES (:name, :cateId, :price, :discount, :unit, :img, :desc,:nutrition, :pDate, :eDate, 1, 0)")
                    .bind("name", p.getName())
                    .bind("cateId", p.getCategoryId())
                    .bind("price", p.getPrice())
                    .bind("discount", p.getDiscount())
                    .bind("unit", p.getUnitOfMeasure())
                    .bind("img", p.getImageUrl())
                    .bind("desc", p.getDescription())
                    .bind("nutrition", p.getNutritionalInformation())
                    .bind("pDate", p.getProductionDate())
                    .bind("eDate", p.getExpiryDate())
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
            handle.createUpdate("UPDATE products SET name=:name, category_id=:cateId, price=:price, discount=:discount,unit_of_measure=:unit, image_url=:img, description=:desc,nutritional_information=:nutrition, production_date=:pDate, expiry_date=:eDate,active=:isActive " +
                            "WHERE id=:id")
                    .bind("name", p.getName())
                    .bind("cateId", p.getCategoryId())
                    .bind("price", p.getPrice())
                    .bind("discount", p.getDiscount())
                    .bind("unit", p.getUnitOfMeasure())
                    .bind("img", p.getImageUrl())
                    .bind("desc", p.getDescription())
                    .bind("nutrition", p.getNutritionalInformation())
                    .bind("pDate", p.getProductionDate())
                    .bind("eDate", p.getExpiryDate())
                    .bind("isActive", p.getActive())
                    .bind("id", p.getId())
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