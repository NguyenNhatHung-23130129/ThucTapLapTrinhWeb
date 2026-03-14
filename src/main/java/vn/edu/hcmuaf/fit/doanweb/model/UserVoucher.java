package vn.edu.hcmuaf.fit.doanweb.model;

import java.sql.Date;

public class UserVoucher {
    private int id;
    private int userId;
    private String voucherCode;
    private int status; // 0: đã dùng; 1: chưa dùng; 2: đã hết hạn
    private Date assignedAt;
    private Date usedAt;
    private int orderId;

    public UserVoucher() {
    }

    public UserVoucher(int id, int userId, String voucherCode, int status, Date assignedAt, Date usedAt, int orderId) {
        this.id = id;
        this.userId = userId;
        this.voucherCode = voucherCode;
        this.status = status;
        this.assignedAt = assignedAt;
        this.usedAt = usedAt;
        this.orderId = orderId;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getVoucherCode() { return voucherCode; }
    public void setVoucherCode(String voucherCode) { this.voucherCode = voucherCode; }

    public int getStatus() { return status; }
    public void setStatus(int status) { this.status = status; }

    public Date getAssignedAt() { return assignedAt; }
    public void setAssignedAt(Date assignedAt) { this.assignedAt = assignedAt; }

    public Date getUsedAt() { return usedAt; }
    public void setUsedAt(Date usedAt) { this.usedAt = usedAt; }

    public int getOrderId() { return orderId; }
    public void setOrderId(int orderId) { this.orderId = orderId; }

    @Override
    public String toString() {
        return "UserVoucher{" +
                "id=" + id +
                ", userId=" + userId +
                ", voucherCode='" + voucherCode + '\'' +
                ", status=" + status +
                ", assignedAt=" + assignedAt +
                ", usedAt=" + usedAt +
                ", orderId=" + orderId +
                '}';
    }
}
