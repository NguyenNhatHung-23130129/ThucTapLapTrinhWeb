package vn.edu.hcmuaf.fit.doanweb.model;

public class OrderDetails {
    private int id;
    private int orderId;
    private int productId;
    private int quantity;
    private long unitPrice;
    private Product product;

    public OrderDetails() {
    }

    public OrderDetails(long unitPrice, int quantity, int productId, int orderId, int id, Product product) {
        this.unitPrice = unitPrice;
        this.quantity = quantity;
        this.productId = productId;
        this.orderId = orderId;
        this.id = id;
        this.product = product;
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

    public int getProductId() {
        return productId;
    }

    public void setProductId(int productId) {
        this.productId = productId;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public long getUnitPrice() {
        return unitPrice;
    }

    public void setUnitPrice(long unitPrice) {
        this.unitPrice = unitPrice;
    }

    public Product getProduct() {
        return product;
    }

    public void setProduct(Product product) {
        this.product = product;
    }
}