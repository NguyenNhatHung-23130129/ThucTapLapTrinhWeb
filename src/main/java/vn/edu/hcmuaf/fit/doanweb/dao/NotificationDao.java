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
}