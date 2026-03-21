package vn.edu.hcmuaf.fit.doanweb.dao;

import vn.edu.hcmuaf.fit.doanweb.model.Review;
import vn.edu.hcmuaf.fit.doanweb.model.User;
import java.util.List;

public class ReviewDao extends BaseDao {
    public void saveReview(int userId, int productId, int rating, String content, String imageUrl) {
        String sql = "INSERT INTO reviews (customer_id, product_id, rating, content, image_url, review_date) " +
                "VALUES (:uid, :pid, :rate, :content, :imgUrl, CURRENT_DATE())";
        get().useHandle(handle ->
                handle.createUpdate(sql)
                        .bind("uid", userId)
                        .bind("pid", productId)
                        .bind("rate", rating)
                        .bind("content", content)
                        .bind("imgUrl", imageUrl)
                        .execute()
        );
    }
    public List<Review> getReviewsByProductId(int productId) {
        String sql = "SELECT r.*, u.name, u.image_url AS user_avatar " +
                "FROM reviews r JOIN users u ON r.customer_id = u.id " +
                "WHERE r.product_id = :pid ORDER BY r.review_date DESC";

        return get().withHandle(handle ->
                handle.createQuery(sql)
                        .bind("pid", productId)
                        .map((rs, ctx) -> {


                            User u = new User();
                            u.setId(rs.getInt("customer_id"));
                            u.setName(rs.getString("name"));
                            u.setImageUrl(rs.getString("user_avatar"));

                            Review review = new Review();
                            review.setId(rs.getInt("id"));
                            review.setCustomerId(rs.getInt("customer_id"));
                            review.setProductId(rs.getInt("product_id"));
                            review.setRating(rs.getInt("rating"));
                            review.setContent(rs.getString("content"));
                            review.setReviewDate(rs.getTimestamp("review_date"));
                            review.setImageUrl(rs.getString("image_url"));
                            review.setUser(u);

                            return review;
                        })
                        .list()
        );
    }
}