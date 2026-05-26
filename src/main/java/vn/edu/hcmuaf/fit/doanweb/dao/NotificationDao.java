package vn.edu.hcmuaf.fit.doanweb.dao;

import vn.edu.hcmuaf.fit.doanweb.model.Notification;
import java.util.List;

public class NotificationDao extends BaseDao {

    public List<Notification> getAllNotification() {
        return get().withHandle(handle -> handle.createQuery("SELECT * FROM notifications ORDER BY created_at DESC")
                .mapToBean(Notification.class)
                .list()
        );
    }

    public int insertNotification(Notification n) {
        Integer targetId = "ALL".equalsIgnoreCase(n.getTargetType()) ? null : n.getTargetId();

        return get().withHandle(handle -> handle.createUpdate(
                        "INSERT INTO notifications (target_id, title, content, type, target_type, is_read, created_at) " +
                                "VALUES (:targetId, :title, :content, :type, :targetType, 0, NOW())")
                .bind("targetId", targetId)
                .bind("title", n.getTitle())
                .bind("content", n.getContent())
                .bind("type", n.getType())
                .bind("targetType", n.getTargetType())
                .execute()
        );
    }
    public List<Notification> getNotiByUser(int userId) {
        return get().withHandle(handle -> handle.createQuery(
                        "SELECT n.id, n.target_id AS targetId, n.title, n.content, n.type, n.target_type AS targetType, n.is_read AS isRead, n.created_at AS createdAt " +
                                "FROM notifications n JOIN users u ON u.id = :userId " +
                                "WHERE (n.target_id = :userId) OR (n.target_type = 'all' AND n.created_at >= u.created_at) " +
                                "ORDER BY n.created_at DESC")
                .bind("userId", userId)
                .mapToBean(Notification.class)
                .list()
        );
    }

    public int countUnreadByUser(int userId) {
        return get().withHandle(handle -> handle.createQuery(
                        "SELECT COUNT(*) FROM notifications n JOIN users u ON u.id = :userId " +
                                "WHERE n.is_read = 0 AND ((n.target_id = :userId) OR (n.target_type = 'all' AND n.created_at >= u.created_at)) ")
                .bind("userId", userId)
                .mapTo(Integer.class)
                .one()
        );
    }

    public List<Notification> searchNotifications(String trim) {
        return get().withHandle(handle -> handle.createQuery(
                        "SELECT id, target_id AS targetId, title, content, type, target_type AS targetType, is_read AS isRead, created_at AS createdAt " +
                                "FROM notifications " +
                                "WHERE title LIKE :keyword OR content LIKE :keyword " +
                                "ORDER BY created_at DESC")
                .bind("keyword", "%" + trim + "%")
                .mapToBean(Notification.class)
                .list()
        );
    }
}