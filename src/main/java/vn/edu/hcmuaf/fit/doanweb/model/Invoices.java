package vn.edu.hcmuaf.fit.doanweb.model;

import java.io.Serializable;
import java.sql.Date;

public class Invoices implements Serializable {
    private int id;
    private int orderId;
    private String invoiceNumber;
    private Date issuedDate;
    private String taxCode;
    private double subTotal;
    private double taxAmount;
    private double totalAmount;
    private int paymentId;
    private String customerName;
    private String paymentStatus;

    public Invoices(int id, int orderId, String invoiceNumber, Date issuedDate, String taxCode, double subTotal, double taxAmount, double totalAmount, int paymentId, String customerName, String paymentStatus) {
        this.id = id;
        this.orderId = orderId;
        this.invoiceNumber = invoiceNumber;
        this.issuedDate = issuedDate;
        this.taxCode = taxCode;
        this.subTotal = subTotal;
        this.taxAmount = taxAmount;
        this.totalAmount = totalAmount;
        this.paymentId = paymentId;
        this.customerName = customerName;
        this.paymentStatus = paymentStatus;
    }

    public Invoices() {
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

    public String getInvoiceNumber() {
        return invoiceNumber;
    }

    public void setInvoiceNumber(String invoiceNumber) {
        this.invoiceNumber = invoiceNumber;
    }

    public Date getIssuedDate() {
        return issuedDate;
    }

    public void setIssuedDate(Date issuedDate) {
        this.issuedDate = issuedDate;
    }

    public String getTaxCode() {
        return taxCode;
    }

    public void setTaxCode(String taxCode) {
        this.taxCode = taxCode;
    }

    public double getSubTotal() {
        return subTotal;
    }

    public void setSubTotal(double subTotal) {
        this.subTotal = subTotal;
    }

    public double getTaxAmount() {
        return taxAmount;
    }

    public void setTaxAmount(double taxAmount) {
        this.taxAmount = taxAmount;
    }

    public double getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(double totalAmount) {
        this.totalAmount = totalAmount;
    }

    public int getPaymentId() {
        return paymentId;
    }

    public void setPaymentId(int paymentId) {
        this.paymentId = paymentId;
    }

    public String getCustomerName() {
        return customerName;
    }

    public void setCustomerName(String customerName) {
        this.customerName = customerName;
    }

    public String getPaymentStatus() {
        return paymentStatus;
    }

    public void setPaymentStatus(String paymentStatus) {
        this.paymentStatus = paymentStatus;
    }
}
