package vn.edu.hcmuaf.fit.doanweb.model;

public class UserAdderss {
    private int id;
    private int userId;
    private String addressLine;
    private String city;
    private String ward;
    private int isDefault;
    private String orderName;
    private String orderSdt;

    public UserAdderss() {

    }

    public UserAdderss(int isDefault, int id, int userId, String addressLine, String city, String ward, String orderName, String orderSdt) {
        this.isDefault = isDefault;
        this.id = id;
        this.userId = userId;
        this.addressLine = addressLine;
        this.city = city;
        this.ward = ward;
        this.orderName = orderName;
        this.orderSdt = orderSdt;
    }

    public int getIsDefault() {
        return isDefault;
    }

    public void setIsDefault(int isDefault) {
        this.isDefault = isDefault;
    }

    public String getWard() {
        return ward;
    }

    public void setWard(String ward) {
        this.ward = ward;
    }

    public String getCity() {
        return city;
    }

    public void setCity(String city) {
        this.city = city;
    }

    public String getAddressLine() {
        return addressLine;
    }

    public void setAddressLine(String addressLine) {
        this.addressLine = addressLine;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getOrderName() {
        return orderName;
    }

    public void setOrderName(String orderName) {
        this.orderName = orderName;
    }

    public String getOrderSdt() {
        return orderSdt;
    }

    public void setOrderSdt(String orderSdt) {
        this.orderSdt = orderSdt;
    }
}
