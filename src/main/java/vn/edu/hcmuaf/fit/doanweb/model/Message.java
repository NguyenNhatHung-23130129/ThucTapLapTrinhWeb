package vn.edu.hcmuaf.fit.doanweb.model;

public class Message {
    private int id;
    private int review_id;
    private int user_id;
    private  String message;
    private User user;

    public Message(int id, int review_id, int user_id, String message) {
        this.id = id;
        this.review_id = review_id;
        this.user_id = user_id;
        this.message = message;
    }
    public Message(){}

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getReview_id() {
        return review_id;
    }

    public void setReview_id(int review_id) {
        this.review_id = review_id;
    }

    public int getUser_id() {
        return user_id;
    }

    public void setUser_id(int user_id) {
        this.user_id = user_id;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }
}
