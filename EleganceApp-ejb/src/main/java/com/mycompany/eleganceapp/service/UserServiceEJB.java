package com.mycompany.eleganceapp.service;

import com.mycompany.eleganceapp.model.User;
import com.mycompany.eleganceapp.model.Article;
import jakarta.ejb.EJB;
import jakarta.ejb.Stateless;
import jakarta.persistence.EntityManager;
import jakarta.persistence.NoResultException;
import jakarta.persistence.PersistenceContext;

@Stateless
public class UserServiceEJB {

    @PersistenceContext(unitName = "ElegancePU")
    private EntityManager em;

    @EJB
    private OrderServiceEJB orderService;

    // Vérifie si le nom d'utilisateur existe déjà
    public boolean usernameExists(String username) {
        try {
            em.createQuery("SELECT u FROM User u WHERE u.username = :username", User.class)
                    .setParameter("username", username)
                    .getSingleResult();
            return true;
        } catch (NoResultException e) {
            return false;
        }
    }

    // Enregistre un nouvel utilisateur
    public void register(User user) {
        em.persist(user);
    }

    // Trouver utilisateur pour login
    public User findUserByUsernameAndPassword(String username, String password) {
        try {
            return em.createQuery(
                    "SELECT u FROM User u WHERE u.username = :username AND u.password = :password",
                    User.class)
                    .setParameter("username", username)
                    .setParameter("password", password)
                    .getSingleResult();
        } catch (NoResultException e) {
            return null;
        }
    }

    public long countUsers() {
        return em.createQuery("SELECT COUNT(u) FROM User u", Long.class).getSingleResult();
    }

    public java.util.List<User> getAllUsers() {
        return em.createQuery("SELECT u FROM User u", User.class).getResultList();
    }

    public User findUserById(Long id) {
        return em.find(User.class, id);
    }

    public void deleteUser(Long id) {
        User u = findUserById(id);
        if (u != null) {
            // Supprimer d'abord les commandes associées pour éviter les erreurs de
            // contrainte
            try {
                orderService.deleteOrdersByUser(id);
            } catch (Exception e) {
                // Si la suppression des commandes échoue, repropager l'exception
                throw e;
            }
            em.remove(em.contains(u) ? u : em.merge(u));
        }
    }

    public boolean toggleFavorite(Long userId, Long articleId) {
        User user = em.find(User.class, userId);
        Article article = em.find(Article.class, articleId);

        if (user != null && article != null) {
            boolean exists = false;
            for (Article a : user.getFavorites()) {
                if (a.getId().equals(articleId)) {
                    exists = true;
                    break;
                }
            }

            if (exists) {
                user.getFavorites().remove(article);
                em.merge(user);
                em.flush();
                return false; // Removed
            } else {
                user.getFavorites().add(article);
                em.merge(user);
                em.flush();
                return true; // Added
            }
        }
        return false;
    }

    public java.util.List<Article> getFavorites(Long userId) {
        User user = em.find(User.class, userId);
        if (user != null) {
            user.getFavorites().size(); // Force load
            return user.getFavorites();
        }
        return new java.util.ArrayList<>();
    }
}
