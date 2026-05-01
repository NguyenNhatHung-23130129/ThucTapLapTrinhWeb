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
                        "SELECT id, target_id AS targetId, title, content, type, target_type AS targetType, is_read AS isRead, created_at AS createdAt " +
                                "FROM notifications " +
                                "WHERE target_id = :userId OR target_type = 'all' " +
                                "ORDER BY created_at DESC")
                .bind("userId", userId)
                .mapToBean(Notification.class)
                .list()
        );
    }

    public int countUnreadByUser(int userId) {
        return get().withHandle(handle -> handle.createQuery(
                        "SELECT COUNT(*) FROM notifications " +
                                "WHERE (target_id = :userId OR target_type = 'all') AND is_read = 0")
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