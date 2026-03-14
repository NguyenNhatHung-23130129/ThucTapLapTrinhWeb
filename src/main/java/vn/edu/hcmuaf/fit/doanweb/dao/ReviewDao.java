package vn.edu.hcmuaf.fit.doanweb.dao;

import vn.edu.hcmuaf.fit.doanweb.model.Review;
import vn.edu.hcmuaf.fit.doanweb.model.User;
import java.util.List;

public class ReviewDao extends BaseDao {

    // Lưu đánh giá mới
    public void saveReview(int userId, int productId, int rating, String content) {
        String sql = "INSERT INTO reviews (customer_id, product_id, rating, content, review_date) VALUES (:uid, :pid, :rate, :content, CURRENT_DATE())";
        get().useHandle(handle ->
                handle.createUpdate(sql)
                        .bind("uid", userId)
                        .bind("pid", productId)
                        .bind("rate", rating)
                        .bind("content", content)
                        .execute()
        );
    }


    public List<Review> getReviewsByProductId(int productId) {
        String sql = "SELECT r.*, u.name, u.image_url " +
                "FROM reviews r JOIN users u ON r.customer_id = u.id " +
                "WHERE r.product_id = :pid ORDER BY r.review_date DESC";

        return get().withHandle(handle ->
                handle.createQuery(sql)
                        .bind("pid", productId)
                        .map((rs, ctx) -> {

                            User u = new User();
                            u.setId(rs.getInt("customer_id"));
                            u.setName(rs.getString("name"));
                            u.setImageUrl(rs.getString("image_url"));

                            return new Review(
                                    rs.getInt("id"),
                                    rs.getInt("customer_id"),
                                    rs.getInt("product_id"),
                                    rs.getInt("rating"),
                                    rs.getString("content"),
                                    rs.getTimestamp("review_date"),
                                    u
                            );
                        })
                        .list()
        );
    }
}