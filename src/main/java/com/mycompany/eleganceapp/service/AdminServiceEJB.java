package com.mycompany.eleganceapp.service;

import com.mycompany.eleganceapp.model.Article;
import com.mycompany.eleganceapp.model.Category;
import com.mycompany.eleganceapp.model.User;
import jakarta.ejb.Stateless;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import java.util.List;

@Stateless
public class AdminServiceEJB {

    @PersistenceContext(unitName = "ElegancePU")
    private EntityManager em;

    // ===== Gestion Articles =====
    public void addArticle(Article article) {
        em.persist(article);
    }

    public void updateArticle(Article article) {
        em.merge(article);
    }

    public void deleteArticle(Long id) {
        Article a = em.find(Article.class, id);
        if (a != null) em.remove(a);
    }

    public List<Article> getAllArticles() {
        return em.createQuery("SELECT a FROM Article a", Article.class)
                 .getResultList();
    }

    // ===== Gestion Categories =====
    public void addCategory(Category category) {
        em.persist(category);
    }

    public void updateCategory(Category category) {
        em.merge(category);
    }

    public void deleteCategory(Long id) {
        Category c = em.find(Category.class, id);
        if (c != null) em.remove(c);
    }

    public List<Category> getAllCategories() {
        return em.createQuery("SELECT c FROM Category c", Category.class)
                 .getResultList();
    }

    // ===== Gestion Utilisateurs =====
    public void addUser(User user) {
        em.persist(user);
    }

    public User findUserByUsername(String username) {
        List<User> users = em.createQuery("SELECT u FROM User u WHERE u.username = :uname", User.class)
                             .setParameter("uname", username)
                             .getResultList();
        return users.isEmpty() ? null : users.get(0);
    }

    public void deleteUser(Long id) {
        User u = em.find(User.class, id);
        if (u != null) em.remove(u);
    }
}
