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
            // Vérifier si des OrderItem référencent cet article
            Long count = em
                    .createQuery("SELECT COUNT(oi) FROM OrderItem oi WHERE oi.article.id = :articleId", Long.class)
                    .setParameter("articleId", id)
                    .getSingleResult();
            if (count != null && count > 0) {
                throw new IllegalStateException("Impossible de supprimer l'article : référencé par des commandes.");
            }
            em.remove(a);
        }
    }

    public Article find(Object id) {
        return em.find(Article.class, id);
    }

    public List<Article> findAll() {
        return em.createQuery("SELECT a FROM Article a ORDER BY a.id DESC", Article.class).getResultList();
    }

    public long countArticles() {
        return em.createQuery("SELECT COUNT(a) FROM Article a", Long.class).getSingleResult();
    }

    public List<Article> findByCategory(String categoryName) {
        return em
                .createQuery("SELECT a FROM Article a WHERE LOWER(a.category.name) = :categoryName ORDER BY a.id DESC",
                        Article.class)
                .setParameter("categoryName", categoryName.toLowerCase())
                .getResultList();
    }

    public List<Article> findLatest(int limit) {
        return em.createQuery("SELECT a FROM Article a ORDER BY a.id DESC", Article.class)
                .setMaxResults(limit)
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
}
