package com.mycompany.eleganceapp.service;

import com.mycompany.eleganceapp.model.Category;
import jakarta.ejb.Stateless;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import java.util.List;

@Stateless
public class CategoryServiceEJB {

    @PersistenceContext(unitName = "ElegancePU")
    private EntityManager em;

    public void create(Category category) {
        em.persist(category);
    }

    public void edit(Category category) {
        em.merge(category);
    }

    public void remove(Category category) {
        em.remove(em.merge(category));
    }

    public Category find(Object id) {
        return em.find(Category.class, id);
    }

    public List<Category> findAll() {
        return em.createNamedQuery("Category.findAll", Category.class).getResultList();
    }

    public Category findByName(String name) {
        try {
            return em.createNamedQuery("Category.findByName", Category.class)
                    .setParameter("name", name)
                    .getSingleResult();
        } catch (Exception e) {
            return null;
        }
    }

    // Methods needed for Servlet compatibility
    public List<Category> getAllCategories() {
        return findAll();
    }

    public Category findById(Long id) {
        return find(id);
    }

    public void deleteCategory(Long id) {
        Category c = find(id);
        if (c != null) {
            remove(c);
        }
    }
}
