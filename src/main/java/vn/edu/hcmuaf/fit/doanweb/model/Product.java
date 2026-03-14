package vn.edu.hcmuaf.fit.doanweb.model;

import java.io.Serializable;
import java.sql.Date;

public class Product implements Serializable {
    private int id;
    private String name;
    private String nutritionalInformation;
    private String description;
    private double price;
    private int categoryId;
    private double discount;
    private int stockQuantity;
    private String unitOfMeasure;
    private String imageUrl;
    private Date productionDate;
    private Date expiryDate;
    private boolean active;

    private String categoryName;

//    private int quantitySold;

    public Product() {
    }


    public Product(int id, String name, String nutritionalInformation, String description, double price, int categoryId, double discount, int stockQuantity, String unitOfMeasure, String imageUrl, Date productionDate, Date expiryDate, boolean active) {
        this.id = id;
        this.name = name;
        this.nutritionalInformation = nutritionalInformation;
        this.description = description;
        this.price = price;
        this.categoryId = categoryId;
        this.discount = discount;
        this.stockQuantity = stockQuantity;
        this.unitOfMeasure = unitOfMeasure;
        this.imageUrl = imageUrl;
        this.productionDate = productionDate;
        this.expiryDate = expiryDate;
        this.active = active;
    }

    public Product(int id, String name, double price, String imageUrl) {
        this.id = id;
        this.name = name;
        this.price = price;
        this.imageUrl = imageUrl;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }



    public String getNutritionalInformation() {
        return nutritionalInformation;
    }

    public void setNutritionalInformation(String nutritionalInformation) {
        this.nutritionalInformation = nutritionalInformation;
    }

    public boolean getActive() {
        return active;
    }

    public void setActive(boolean active) {
        this.active = active;
    }

    public Date getExpiryDate() {
        return expiryDate;
    }

    public void setExpiryDate(Date expiryDate) {
        this.expiryDate = expiryDate;
    }

    public Date getProductionDate() {
        return productionDate;
    }

    public void setProductionDate(Date productionDate) {
        this.productionDate = productionDate;
    }

    public String getUnitOfMeasure() {
        return unitOfMeasure;
    }

    public void setUnitOfMeasure(String unitOfMeasure) {
        this.unitOfMeasure = unitOfMeasure;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public int getStockQuantity() {
        return stockQuantity;
    }

    public void setStockQuantity(int stockQuantity) {
        this.stockQuantity = stockQuantity;
    }

    public double getDiscount() {
        return discount;
    }

    public void setDiscount(double discount) {
        this.discount = discount;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public int getCategoryId() {
        return categoryId;
    }

    public void setCategoryId(int categoryId) {
        this.categoryId = categoryId;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }


    public String formatPrice() {
        return String.format("%,.0f", this.price);
    }

    public String getCategoryName() {
        return categoryName;
    }

    public void setCategoryName(String categoryName) {
        this.categoryName = categoryName;
    }
}

