package vn.edu.hcmuaf.fit.doanweb.Cart;

import vn.edu.hcmuaf.fit.doanweb.model.Product;
import java.io.Serializable;
import java.util.*;
import java.util.concurrent.atomic.AtomicInteger;
import java.util.concurrent.atomic.AtomicReference;

public class Cart implements Serializable {

    private Map<Integer, CartItem> data = new HashMap<>();

    public Cart() {
    }

    public void addProduct(Product p, int quantity) {
        if (data == null) data = new HashMap<>();

        if (data.containsKey(p.getId())) {
            CartItem item = data.get(p.getId());
            item.upQuantity(quantity);

            if (item.getQuantity() <= 0) {
                data.remove(p.getId());
            }
        } else {

            if (quantity > 0) {
                data.put(p.getId(), new CartItem(p, p.getPrice(), quantity));
            }
        }
    }

    public CartItem deleteProduct(int id) {
        if (data == null) return null;
        return data.remove(id);
    }

    public List<CartItem> getList() {
        if (data == null) return new ArrayList<>();
        return new ArrayList<>(data.values());
    }

    public int getTotalQuantity() {
        if (data == null) return 0;

        return data.size();
    }

    public double getTotal() {
        if (data == null) return 0;
        AtomicReference<Double> total = new AtomicReference<>((double) 0);
        data.values().forEach(item -> total.updateAndGet(v -> (v + item.getQuantity() * item.getPrice())));
        return total.get();
    }


    public boolean update(int id, Product p){
        if(data.containsKey(id)){
            data.put(id, new CartItem(p, p.getPrice(), data.get(id).getQuantity()));
            return true;
        }
        return false;
    }

}