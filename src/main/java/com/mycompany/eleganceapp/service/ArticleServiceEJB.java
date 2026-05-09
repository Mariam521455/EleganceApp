package com.mycompany.eleganceapp.service;

import com.mycompany.eleganceapp.model.Article;
import jakarta.ejb.Stateless;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import java.util.List;

@Stateless
public class ArticleServiceEJB {

    @PersistenceContext(unitName = "ElegancePU")
    private EntityManager em;

    public Article create(Article article) {
        em.persist(article);
        return article;
    }

    public Article edit(Article article) {
        return em.merge(article);
    }

    public void remove(Article article) {
        em.remove(em.merge(article));
    }

    public void deleteArticle(Long id) {
        Article a = em.find(Article.class, id);
        if (a != null) {
            em.remove(a);
        }
    }

    public Article find(Object id) {
        return em.find(Article.class, id);
    }

    public List<Article> findAll() {
        return em.createQuery("SELECT a FROM Article a ORDER BY a.id DESC", Article.class).getResultList();
    }

    public List<Article> findByCategory(String categoryName) {
        return em
                .createQuery("SELECT a FROM Article a WHERE LOWER(a.category.name) = :categoryName ORDER BY a.id DESC",
                        Article.class)
                .setParameter("categoryName", categoryName.toLowerCase())
                .getResultList();
    }

    // Alias for compatibility/clarity
    public List<Article> getAllArticles() {
        return findAll();
    }

    public Article getArticleById(Long id) {
        return find(id);
    }

    public void addArticle(Article article) {
        create(article);
    }

    public void updateArticle(Article article) {
        edit(article);
    }

    public List<Article> getArticlesByCategory(String category) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    public Article findArticleById(Long id) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }
}
