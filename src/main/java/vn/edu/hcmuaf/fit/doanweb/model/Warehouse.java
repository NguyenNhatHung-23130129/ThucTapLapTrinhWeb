package vn.edu.hcmuaf.fit.doanweb.model;

import java.io.Serializable;
import java.sql.Date;

public class Warehouse implements Serializable {
    private int id;
    private int productId;
    private int supplierId;
    private boolean status;
    private double importPrice;
    private int quantityImported;
    private int quantityIssued;
    private String preservationMethod;
    private Date importDate;

    private String productName;
    private String supplierName;


    public Warehouse() {
    }

    public Warehouse(int id, int productId, int supplierId, boolean status, double importPrice, int quantityImported, int quantityIssued, String preservationMethod, Date importDate) {
        this.id = id;
        this.productId = productId;
        this.supplierId = supplierId;
        this.status = status;
        this.importPrice = importPrice;
        this.quantityImported = quantityImported;
        this.quantityIssued = quantityIssued;
        this.preservationMethod = preservationMethod;
        this.importDate = importDate;
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

    public void setProductId(int productid) {
        this.productId = productid;
    }

    public int getSupplierId() {
        return supplierId;
    }

    public void setSupplierId(int supplierid) {
        this.supplierId = supplierid;
    }

    public boolean getStatus() {
        return status;
    }

    public void setStatus(boolean status) {
        this.status = status;
    }

    public double getImportPrice() {
        return importPrice;
    }

    public void setImportPrice(double importPrice) {
        this.importPrice = importPrice;
    }

    public int getQuantityImported() {
        return quantityImported;
    }

    public void setQuantityImported(int quantityImported) {
        this.quantityImported = quantityImported;
    }

    public int getQuantityIssued() {
        return quantityIssued;
    }

    public void setQuantityIssued(int quantityIssued) {
        this.quantityIssued = quantityIssued;
    }

    public String getPreservationMethod() {
        return preservationMethod;
    }

    public void setPreservationMethod(String preservationMethod) {
        this.preservationMethod = preservationMethod;
    }

    public Date getImportDate() {
        return importDate;
    }

    public void setImportDate(Date importDate) {
        this.importDate = importDate;
    }

    public String getProductName() {
        return productName;
    }

    public void setProductName(String productName) {
        this.productName = productName;
    }

    public String getSupplierName() {
        return supplierName;
    }

    public void setSupplierName(String supplierName) {
        this.supplierName = supplierName;
    }
}