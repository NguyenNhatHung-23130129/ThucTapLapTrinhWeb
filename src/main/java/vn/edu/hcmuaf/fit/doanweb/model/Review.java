package vn.edu.hcmuaf.fit.doanweb.model;

import java.util.Date;

public class Review {
    private int id;
    private int customerId;
    private int productId;
    private int rating;
    private String content;
    private Date reviewDate;


    private User user;

    public Review() {}

    public Review(int id, int customerId, int productId, int rating, String content, Date reviewDate, User user) {
        this.id = id;
        this.customerId = customerId;
        this.productId = productId;
        this.rating = rating;
        this.content = content;
        this.reviewDate = reviewDate;
        this.user = user;
    }

    public User getUser() { return user; }
    public void setUser(User user) { this.user = user; }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public int getCustomerId() { return customerId; }
    public void setCustomerId(int customerId) { this.customerId = customerId; }
    public int getProductId() { return productId; }
    public void setProductId(int productId) { this.productId = productId; }
    public int getRating() { return rating; }
    public void setRating(int rating) { this.rating = rating; }
    public String getContent() { return content; }
    public void setContent(String content) { this.content = content; }
    public Date getReviewDate() { return reviewDate; }
    public void setReviewDate(Date reviewDate) { this.reviewDate = reviewDate; }
}