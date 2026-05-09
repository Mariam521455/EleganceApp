package com.mycompany.eleganceapp.service;

import com.mycompany.eleganceapp.model.Order;
import com.mycompany.eleganceapp.model.OrderItem;
import jakarta.ejb.Stateless;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import java.util.List;

@Stateless
public class OrderServiceEJB {

    @PersistenceContext(unitName = "ElegancePU")
    private EntityManager em;

    public void createOrder(Order order) {
        em.persist(order);
    }

    public List<Order> getOrdersByUser(Long userId) {
        return em.createQuery("SELECT o FROM Order o WHERE o.user.id = :userId ORDER BY o.orderDate DESC", Order.class)
                .setParameter("userId", userId)
                .getResultList();
    }

    public long countOrdersByUser(Long userId) {
        return em.createQuery("SELECT COUNT(o) FROM Order o WHERE o.user.id = :userId", Long.class)
                .setParameter("userId", userId)
                .getSingleResult();
    }

    public List<Order> getAllOrders() {
        return em.createQuery(
                "SELECT DISTINCT o FROM Order o "
                + "JOIN FETCH o.user "
                + "LEFT JOIN FETCH o.items i "
                + "LEFT JOIN FETCH i.article "
                + "ORDER BY o.orderDate DESC",
                Order.class)
                .getResultList();
    }

    public Order findById(Long id) {
        return em.find(Order.class, id);
    }

    public Order update(Order order) {
        return em.merge(order);
    }

    public void deleteById(Long id) {
        if (id == null) {
            return;
        }

        // Ensure children are deleted first to avoid FK constraint violations
        em.createQuery("DELETE FROM OrderItem oi WHERE oi.order.id = :orderId")
                .setParameter("orderId", id)
                .executeUpdate();

        Order managed = em.find(Order.class, id);
        if (managed != null) {
            em.remove(managed);
        }
    }
}
