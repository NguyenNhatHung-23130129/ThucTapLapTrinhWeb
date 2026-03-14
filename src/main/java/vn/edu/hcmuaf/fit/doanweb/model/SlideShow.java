package vn.edu.hcmuaf.fit.doanweb.model;

import java.io.Serializable;
import java.sql.Date;


public class SlideShow implements Serializable {
    private int id;
    private int productId;
    private String voucherCode;
    private String title;
    private String description;
    private String imageUrl;
    private boolean status;
    private int displayOrder;
    private Date startDate;
    private Date endDate;

    public SlideShow() {
    }

    public SlideShow(int id, Date endDate, Date startDate, String imageUrl, boolean status, String description, String title, String voucherCode, int productId,int displayOrder) {
        this.id = id;
        this.endDate = endDate;
        this.startDate = startDate;
        this.imageUrl = imageUrl;
        this.status = status;
        this.description = description;
        this.title = title;
        this.voucherCode = voucherCode;
        this.productId = productId;
        this.displayOrder = displayOrder;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getProductId() {
        return productId;
    }

    public void setProductId(int productId) {
        this.productId = productId;
    }

    public String getVoucherCode() {
        return voucherCode;
    }

    public void setVoucherCode(String voucherCode) {
        this.voucherCode = voucherCode;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public boolean isStatus() {
        return status;
    }

    public void setStatus(boolean status) {
        this.status = status;
    }

    public Date getStartDate() {
        return startDate;
    }

    public void setStartDate(Date startDate) {
        this.startDate = startDate;
    }

    public Date getEndDate() {
        return endDate;
    }

    public void setEndDate(Date endDate) {
        this.endDate = endDate;
    }

    public int getDisplayOrder() {
        return displayOrder;
    }

    public void setDisplayOrder(int displayOrder) {
        this.displayOrder = displayOrder;
    }

    @Override
    public String toString() {
        return "SlideShow{" +
                "id=" + id +
                ", productId=" + productId +
                ", voucherCode='" + voucherCode + '\'' +
                ", title='" + title + '\'' +
                ", description='" + description + '\'' +
                ", imageUrl='" + imageUrl + '\'' +
                ", status=" + status +
                ", startDate=" + startDate +
                ", endDate=" + endDate +
                '}';

    }
}
