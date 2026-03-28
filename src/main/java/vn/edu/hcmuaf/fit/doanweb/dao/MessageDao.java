package vn.edu.hcmuaf.fit.doanweb.dao;

import vn.edu.hcmuaf.fit.doanweb.model.Message;
import vn.edu.hcmuaf.fit.doanweb.model.User;

import java.util.List;

public class MessageDao extends BaseDao  {
    public void insertMessage(int reviewId, int userId, String message) {
        String sql = "INSERT INTO messages (review_id, user_id, message) VALUES (:reviewId, :userId, :message)";
        this.get().useHandle(handle ->
                handle.createUpdate(sql)
                        .bind("reviewId", reviewId)
                        .bind("userId", userId)
                        .bind("message", message)
                        .execute()
        );
    }

    public List<Message> getMessagesByReviewId(int reviewId) {

        String sql = "SELECT m.*, u.name, u.image_url, u.role_id  FROM messages m JOIN users u ON m.user_id = u.id  WHERE m.review_id = :reviewId ORDER BY m.id ASC";
        return this.get().withHandle(handle ->
                handle.createQuery(sql)
                        .bind("reviewId", reviewId)
                        .map((rs, ctx) -> {
                            Message m = new Message();
                            m.setId(rs.getInt("id"));
                            m.setReview_id(rs.getInt("review_id"));
                            m.setUser_id(rs.getInt("user_id"));
                            m.setMessage(rs.getString("message"));
                            User u = new User();
                            u.setId(rs.getInt("user_id"));
                            u.setName(rs.getString("name"));
                            u.setImageUrl(rs.getString("image_url"));
                            u.setRoleId(rs.getInt("role_id"));
                            m.setUser(u);
                            return m;
                        }).list()
        );
    }

}
