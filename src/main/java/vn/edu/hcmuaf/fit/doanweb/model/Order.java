package vn.edu.hcmuaf.fit.doanweb.model;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

public class Order {
    private int id;
    private int userId;
    private int addressId;
    private int voucherId;
    private Date orderDate;
    private String status;
    private String note;
    private long totalAmount;
    private List<OrderDetails> orderDetails = new ArrayList<>();

    private String userName;
    private String productName;
    private String address;
    private String paymentStatus;

    private String recipientName;
    private String recipientPhone;
    private String shippingAddress;

    private String shippingCarrierId;
    private String trackingNumber;

    private double shippingFee;
    private String shipMethod;

    public Order() {
    }

    public Order(int id, int userId, int addressId, int voucherId, Date orderDate, String status, String note, long totalAmount, String paymentStatus) {
        this.id = id;
        this.userId = userId;
        this.addressId = addressId;
        this.voucherId = voucherId;
        this.orderDate = orderDate;
        this.status = status;
        this.note = note;
        this.totalAmount = totalAmount;
        this.paymentStatus = paymentStatus;
    }


    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public int getAddressId() { return addressId; }
    public void setAddressId(int addressId) { this.addressId = addressId; }

    public int getVoucherId() { return voucherId; }
    public void setVoucherId(int voucherId) { this.voucherId = voucherId; }

    public Date getOrderDate() { return orderDate; }
    public void setOrderDate(Date orderDate) { this.orderDate = orderDate; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getNote() { return note; }
    public void setNote(String note) { this.note = note; }

    public long getTotalAmount() { return totalAmount; }
    public void setTotalAmount(long totalAmount) { this.totalAmount = totalAmount; }

    public List<OrderDetails> getOrderDetails() { return orderDetails; }
    public void setOrderDetails(List<OrderDetails> orderDetails) { this.orderDetails = orderDetails; }

    public String getUserName() { return userName; }
    public void setUserName(String userName) { this.userName = userName; }

    public String getProductName() { return productName; }
    public void setProductName(String productName) { this.productName = productName; }

    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }

    public String getPaymentStatus() { return paymentStatus; }
    public void setPaymentStatus(String paymentStatus) { this.paymentStatus = paymentStatus; }

    public String getRecipientName() { return recipientName; }
    public void setRecipientName(String recipientName) { this.recipientName = recipientName; }

    public String getRecipientPhone() { return recipientPhone; }
    public void setRecipientPhone(String recipientPhone) { this.recipientPhone = recipientPhone; }

    public String getShippingAddress() { return shippingAddress; }
    public void setShippingAddress(String shippingAddress) { this.shippingAddress = shippingAddress; }

    public String getShippingCarrierId() { return shippingCarrierId; }
    public void setShippingCarrierId(String shippingCarrierId) { this.shippingCarrierId = shippingCarrierId; }

    public String getTrackingNumber() { return trackingNumber; }
    public void setTrackingNumber(String trackingNumber) { this.trackingNumber = trackingNumber; }

    public double getShippingFee() { return shippingFee; }
    public void setShippingFee(double shippingFee) { this.shippingFee = shippingFee; }

    public String getShipMethod() { return shipMethod; }
    public void setShipMethod(String shipMethod) { this.shipMethod = shipMethod; }
}