package vn.edu.hcmuaf.fit.doanweb.model;

import java.sql.Date;
import java.util.ArrayList;
import java.util.List;

public class Voucher {
    private int id;
    private String voucherCode;
    private String title;
    private String description;
    private String type;        // percentage, fixed, freeship, special
    private String applyScope;  // all, ...
    private double value;
    private double minOrderValue;
    private double maxDiscountAmount;
    private Date startDate;
    private Date endDate;
    private int usageLimit;
    private int usageCount;
    private int limitPerUser;
    private int isActive;
    private List<String> appliedProductIds = new ArrayList<>();

    public Voucher() {
    }

    public Voucher(String voucherCode, String title, String description, String type,
                   String applyScope, double value, double minOrderValue, double maxDiscountAmount,
                   Date startDate, Date endDate, int usageLimit) {
        this.id = id;
        this.voucherCode = voucherCode;
        this.title = title;
        this.description = description;
        this.type = type;
        this.applyScope = applyScope;
        this.value = value;
        this.minOrderValue = minOrderValue;
        this.maxDiscountAmount = maxDiscountAmount;
        this.startDate = startDate;
        this.endDate = endDate;
        this.usageCount = usageCount;
        this.usageLimit = usageLimit;
        this.limitPerUser = 1;
        this.isActive = 1;
    }
    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getVoucherCode() { return voucherCode; }
    public void setVoucherCode(String voucherCode) { this.voucherCode = voucherCode; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getType() { return type; }
    public void setType(String type) { this.type = type; }

    public Date getStartDate() { return startDate; }
    public void setStartDate(Date startDate) { this.startDate = startDate; }

    public Date getEndDate() { return endDate; }
    public void setEndDate(Date endDate) { this.endDate = endDate; }

    public double getValue() { return value; }
    public void setValue(double value) { this.value = value; }

    public String getApplyScope() { return applyScope; }

    public void setApplyScope(String applyScope) { this.applyScope = applyScope; }

    public int getUsageLimit() { return usageLimit; }

    public void setUsageLimit(int usageLimit) { this.usageLimit = usageLimit; }

    public int getUsageCount() { return usageCount; }

    public void setUsageCount(int usageCount) { this.usageCount = usageCount; }

    public int getLimitPerUser() { return limitPerUser; }

    public void setLimitPerUser(int limitPerUser) { this.limitPerUser = limitPerUser; }

    public int getIsActive() { return isActive; }

    public void setIsActive(int isActive) { this.isActive = isActive; }

    @Override
    public String toString() {
        return "Voucher{" +
                "voucherCode='" + voucherCode + '\'' +
                ", title='" + title + '\'' +
                ", value=" + value +
                '}';
    }

    public double getMinOrderValue() {
        return minOrderValue;
    }

    public void setMinOrderValue(double minOrderValue) {
        this.minOrderValue = minOrderValue;
    }

    public double getMaxDiscountAmount() {
        return maxDiscountAmount;
    }

    public void setMaxDiscountAmount(double maxDiscountAmount) {
        this.maxDiscountAmount = maxDiscountAmount;
    }

    public List<String> getAppliedProductIds() {
        return appliedProductIds;
    }

    public void setAppliedProductIds(List<String> appliedProductIds) {
        this.appliedProductIds = appliedProductIds;
    }
    public void addAppliedProductId(String id) {
        this.appliedProductIds.add(id);
    }
}