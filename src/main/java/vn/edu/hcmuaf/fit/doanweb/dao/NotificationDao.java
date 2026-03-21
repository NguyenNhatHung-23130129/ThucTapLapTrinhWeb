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


}
