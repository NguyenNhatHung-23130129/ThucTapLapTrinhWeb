package vn.edu.hcmuaf.fit.doanweb.dao;

public class CartDao extends BaseDao {
    private static CartDao instance;

    public static CartDao getInstance() {
        if (instance == null) {
            instance = new CartDao();
        }
        return instance;
    }

    public CartDao() {
        super();
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

    public int saveCartItemToDB(int cartId, int productId, int finalQuantity) {
        return get().withHandle(handle ->
                handle.createUpdate("INSERT INTO cart_items (cart_id, product_id, quantity) VALUES (:cartId, :productId, :quantity) " +
                                "ON DUPLICATE KEY UPDATE quantity = :quantity")
                        .bind("cartId", cartId)
                        .bind("productId", productId)
                        .bind("quantity", finalQuantity)
                        .execute()
        );
    }

    public int removeCartItemFromDB(int cartId, int productId) {
        return get().withHandle(handle ->
                handle.createUpdate("DELETE FROM cart_items WHERE cart_id = :cartId AND product_id = :productId")
                        .bind("cartId", cartId)
                        .bind("productId", productId)
                        .execute()
        );
    }
}
