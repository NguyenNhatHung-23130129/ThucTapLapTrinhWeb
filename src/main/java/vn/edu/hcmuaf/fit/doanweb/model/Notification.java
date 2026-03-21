package vn.edu.hcmuaf.fit.doanweb.model;

import java.io.Serializable;
import java.sql.Date;

public class Notification implements Serializable {
    private int id;
    private int targetId;
    private String title;
    private String content;
    private String type;
    private String targetType;
    private boolean isRead;
    private Date createdAt;

    public Notification(int id, int userId, String title, String content, String type, String targetType, boolean isRead, Date createdAt) {
        this.id = id;
        this.targetId = userId;
        this.title = title;
        this.content = content;
        this.type = type;
        this.targetType = targetType;
        this.isRead = isRead;
        this.createdAt = createdAt;
    }

    public Notification() {
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getTargetId() {
        return targetId;
    }

    public void setTargetId(int targetId) {
        this.targetId = targetId;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public boolean getIsRead() {
        return isRead;
    }

    public void setIsRead(boolean read) {
        isRead = read;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }

    public String getTargetType() {
        return targetType;
    }

    public void setTargetType(String targetType) {
        this.targetType = targetType;
    }
}
