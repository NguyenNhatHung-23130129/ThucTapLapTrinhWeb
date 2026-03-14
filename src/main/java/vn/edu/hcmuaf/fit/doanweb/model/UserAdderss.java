package vn.edu.hcmuaf.fit.doanweb.model;

public class UserAdderss {
    private int id;
    private int userId;
    private String addressLine;
    private String city;
    private String ward;
    private boolean isDefault;

    public UserAdderss() {

    }

    public UserAdderss(boolean isDefault, int id, int userId, String addressLine, String city, String ward) {
        this.isDefault = isDefault;
        this.id = id;
        this.userId = userId;
        this.addressLine = addressLine;
        this.city = city;
        this.ward = ward;
    }

    public boolean isDefault() {
        return isDefault;
    }

    public void setDefault(boolean aDefault) {
        isDefault = aDefault;
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
}
