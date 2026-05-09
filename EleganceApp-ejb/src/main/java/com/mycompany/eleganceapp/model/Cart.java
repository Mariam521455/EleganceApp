package com.mycompany.eleganceapp.model;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

public class Cart implements Serializable {

    private List<OrderItem> items = new ArrayList<>();

    public void addItem(Article article, int quantity) {
        if (article == null || article.getId() == null) return;
        for (OrderItem item : items) {
            if (item.getArticle() != null && item.getArticle().getId() != null
                    && item.getArticle().getId().equals(article.getId())) {
                item.setQuantity(item.getQuantity() + quantity);
                return;
            }
        }
        // Price is captured at the moment of adding to cart (or could be dynamic, but
        // let's capture it)
        OrderItem newItem = new OrderItem(article, quantity, article.getPrice());
        items.add(newItem);
    }

    public void updateQuantity(Long articleId, int quantity) {
        if (quantity <= 0) {
            removeItem(articleId);
            return;
        }
        for (OrderItem item : items) {
            if (item.getArticle().getId().equals(articleId)) {
                item.setQuantity(quantity);
                return;
            }
        }
    }

    public void removeItem(Long articleId) {
        Iterator<OrderItem> it = items.iterator();
        while (it.hasNext()) {
            OrderItem item = it.next();
            if (item.getArticle().getId().equals(articleId)) {
                it.remove();
                break;
            }
        }
    }

    public void clear() {
        items.clear();
    }

    public List<OrderItem> getItems() {
        return items;
    }

    public double getTotal() {
        double total = 0;
        for (OrderItem item : items) {
            total += item.getPrice() * item.getQuantity();
        }
        return total;
    }

    public boolean isEmpty() {
        return items.isEmpty();
    }
}
