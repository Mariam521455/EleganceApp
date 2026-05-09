package com.mycompany.eleganceapp.service;

import com.mycompany.eleganceapp.model.Order;
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

    public void deleteOrdersByUser(Long userId) {
        // Supprimer d'abord les articles des commandes de l'utilisateur
        em.createQuery(
                "DELETE FROM OrderItem oi WHERE oi.order.id IN (SELECT o.id FROM Order o WHERE o.user.id = :userId)")
                .setParameter("userId", userId)
                .executeUpdate();

        // Puis supprimer les commandes elles-mêmes
        em.createQuery("DELETE FROM Order o WHERE o.user.id = :userId")
                .setParameter("userId", userId)
                .executeUpdate();
    }
}
