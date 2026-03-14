package vn.edu.hcmuaf.fit.doanweb.Cart;

import vn.edu.hcmuaf.fit.doanweb.model.Product;
import java.io.Serializable; // <--- THÊM IMPORT NÀY

public class CartItem implements Serializable {
    private Product product;
    private double price;
    private int quantity;


    public CartItem(Product product, double price, int quantity) {
        this.product = product;
        this.price = price;
        this.quantity = quantity;
    }


    public double getTotal() { return price * quantity; }
    public int getQuantity() { return quantity; }
    public void upQuantity(int quantity) {

        this.quantity += quantity;
    }
    public Product getProduct() { return product; }
    public void setProduct(Product product) { this.product = product; }
    public void setQuantity(int quantity) { this.quantity = quantity; }
    public double getPrice() { return price; }
    public void setPrice(int price) { this.price = price; }
}