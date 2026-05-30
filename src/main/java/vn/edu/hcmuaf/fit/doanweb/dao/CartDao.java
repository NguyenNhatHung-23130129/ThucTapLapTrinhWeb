package vn.edu.hcmuaf.fit.doanweb.dao;

import vn.edu.hcmuaf.fit.doanweb.Cart.CartItem;
import vn.edu.hcmuaf.fit.doanweb.model.Product;

import java.util.List;

public class CartDao extends BaseDao {
    private static CartDao instance;

    public static CartDao getInstance() {
        if (instance == null) instance = new CartDao();
        return instance;
    }

    public int getOrCreateCartId(int userId) {
        return get().withHandle(handle -> {
            Integer cartId = handle.createQuery("SELECT id FROM carts WHERE user_id = :userId")
                    .bind("userId", userId)
                    .mapTo(Integer.class)
                    .findOne().orElse(null);

            if (cartId == null) {
                return handle.createUpdate("INSERT INTO carts (user_id) VALUES (:userId)")
                        .bind("userId", userId)
                        .executeAndReturnGeneratedKeys("id")
                        .mapTo(Integer.class)
                        .one();
            }
            return cartId;
        });
    }

    public void saveCartItemToDB(int cartId, int productId, int finalQuantity) {
        get().withHandle(handle ->
                handle.createUpdate("INSERT INTO cart_items (cart_id, product_id, quantity) " +
                                "VALUES (:cartId, :productId, :quantity) " +
                                "ON DUPLICATE KEY UPDATE quantity = :quantity")
                        .bind("cartId", cartId)
                        .bind("productId", productId)
                        .bind("quantity", finalQuantity)
                        .execute()
        );
    }

    public void removeCartItemFromDB(int cartId, int productId) {
        get().withHandle(handle ->
                handle.createUpdate("DELETE FROM cart_items WHERE cart_id = :cartId AND product_id = :productId")
                        .bind("cartId", cartId)
                        .bind("productId", productId)
                        .execute()
        );
    }

    public List<CartItem> getCartItemsByUserId(int userId) {
        String sql = "SELECT ci.product_id, ci.quantity, p.name, p.price, p.stock_quantity, p.image_url " +
                "FROM carts c JOIN cart_items ci ON c.id = ci.cart_id JOIN products p ON ci.product_id = p.id " +
                "WHERE c.user_id = :userId ";

        return get().withHandle(handle -> handle.createQuery(sql)
                .bind("userId", userId)
                .map((rs, ctx) -> {
                    Product product = new Product();
                    product.setId(rs.getInt("product_id"));
                    product.setName(rs.getString("name"));
                    product.setPrice(rs.getDouble("price"));
                    product.setStockQuantity(rs.getInt("stock_quantity"));
                    product.setImageUrl(rs.getString("image_url"));
                    return new CartItem(product, product.getPrice(), rs.getInt("quantity"));
                }).list()
        );
    }
}
