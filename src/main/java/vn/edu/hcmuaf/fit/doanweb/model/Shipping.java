package vn.edu.hcmuaf.fit.doanweb.model;

import java.io.Serializable;
import java.sql.Date;

public class Shipping implements Serializable {
    private int id;
    private int orderId;
    private String shippingMethod;
    private String carrierName;
    private String trackingNumber;
    private String shippingStatus;
    private Date estimatedDeliveryDate;
    private Date actualDeliveryDate;
    private double shippingFee;
    private String customerName;

    public Shipping(int id, int orderId, String shippingMethod, String carrierName, String trackingNumber, String shippingStatus, Date estimatedDeliveryDate, Date actualDeliveryDate, double shippingFee, String customerName) {
        this.id = id;
        this.orderId = orderId;
        this.shippingMethod = shippingMethod;
        this.carrierName = carrierName;
        this.trackingNumber = trackingNumber;
        this.shippingStatus = shippingStatus;
        this.estimatedDeliveryDate = estimatedDeliveryDate;
        this.actualDeliveryDate = actualDeliveryDate;
        this.shippingFee = shippingFee;
        this.customerName = customerName;
    }

    public Shipping() {
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getOrderId() {
        return orderId;
    }

    public void setOrderId(int orderId) {
        this.orderId = orderId;
    }

    public String getShippingMethod() {
        return shippingMethod;
    }

    public void setShippingMethod(String shippingMethod) {
        this.shippingMethod = shippingMethod;
    }

    public String getCarrierName() {
        return carrierName;
    }

    public void setCarrierName(String carrierName) {
        this.carrierName = carrierName;
    }

    public String getTrackingNumber() {
        return trackingNumber;
    }

    public void setTrackingNumber(String trackingNumber) {
        this.trackingNumber = trackingNumber;
    }

    public String getShippingStatus() {
        return shippingStatus;
    }

    public void setShippingStatus(String shippingStatus) {
        this.shippingStatus = shippingStatus;
    }

    public Date getEstimatedDeliveryDate() {
        return estimatedDeliveryDate;
    }

    public void setEstimatedDeliveryDate(Date estimatedDeliveryDate) {
        this.estimatedDeliveryDate = estimatedDeliveryDate;
    }

    public Date getActualDeliveryDate() {
        return actualDeliveryDate;
    }

    public void setActualDeliveryDate(Date actualDeliveryDate) {
        this.actualDeliveryDate = actualDeliveryDate;
    }

    public double getShippingFee() {
        return shippingFee;
    }

    public void setShippingFee(double shippingFee) {
        this.shippingFee = shippingFee;
    }

    public String getCustomerName() {
        return customerName;
    }

    public void setCustomerName(String customerName) {
        this.customerName = customerName;
    }
}