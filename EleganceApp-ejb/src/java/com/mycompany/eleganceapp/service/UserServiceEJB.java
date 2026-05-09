package com.mycompany.eleganceapp.service;

import com.mycompany.eleganceapp.model.User;
import jakarta.ejb.Stateless;
import jakarta.persistence.EntityManager;
import jakarta.persistence.NoResultException;
import jakarta.persistence.PersistenceContext;
import java.util.List;

@Stateless
public class UserServiceEJB {

    @PersistenceContext(unitName = "ElegancePU")
    private EntityManager em;

    // Vérifie si un username existe déjà
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

    // Enregistrement d'un nouvel utilisateur
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

    // Récupérer tous les utilisateurs
    public List<User> getAllUsers() {
        return em.createQuery("SELECT u FROM User u ORDER BY u.username ASC", User.class)
                .getResultList();
    }

    // Trouver utilisateur par ID
    public User findUserById(Long id) {
        return em.find(User.class, id);
    }

    // Supprimer un utilisateur
    public void deleteUser(Long id) {
        User u = findUserById(id);
        if (u != null) {
            em.remove(u);
        }
    }

    public long countUsers() {
        return em.createQuery("SELECT COUNT(u) FROM User u", Long.class).getSingleResult();
    }

    public void updateUserRole(Long id, String role) {
        if (id == null || role == null || role.isEmpty()) {
            return;
        }

        User u = findUserById(id);
        if (u != null) {
            u.setRole(role);
            em.merge(u);
        }
    }
}
