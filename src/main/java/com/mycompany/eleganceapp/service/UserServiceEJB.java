package com.mycompany.eleganceapp.service;

import com.mycompany.eleganceapp.model.User;
import jakarta.ejb.Stateless;
import jakarta.persistence.EntityManager;
import jakarta.persistence.NoResultException;
import jakarta.persistence.PersistenceContext;

@Stateless
public class UserServiceEJB {

    @PersistenceContext(unitName = "ElegancePU")
    private EntityManager em;

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

    public java.util.List<User> getAllUsers() {
        return em.createQuery("SELECT u FROM User u", User.class).getResultList();
    }

    public User findUserById(Long id) {
        return em.find(User.class, id);
    }

    public void deleteUser(Long id) {
        User u = findUserById(id);
        if (u != null) {
            em.remove(u);
        }
    }
}
