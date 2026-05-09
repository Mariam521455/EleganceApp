package com.mycompany.eleganceapp.service;

import com.mycompany.eleganceapp.model.Category;
import jakarta.annotation.PostConstruct;
import jakarta.ejb.Singleton;
import jakarta.ejb.Startup;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import java.util.List;

@Singleton
@Startup
public class DataInitializerEJB {

    @PersistenceContext(unitName = "ElegancePU")
    private EntityManager em;

    @PostConstruct
    public void init() {
        try {
            // Vérifier si des catégories existent déjà
            List<Category> categories = em.createQuery("SELECT c FROM Category c", Category.class)
                                          .getResultList();

            if (categories.isEmpty()) {
                // Ajouter les catégories par défaut
                persistCategory("Mode");
                persistCategory("Beauté");
                persistCategory("Accessoires");
                persistCategory("Parfum");

                System.out.println("💡 Catégories initialisées automatiquement !");
            } else {
                System.out.println("💡 Les catégories existent déjà, aucune insertion nécessaire.");
            }
        } catch (Exception e) {
            System.err.println("❌ Erreur lors de l'initialisation des catégories : " + e.getMessage());
            e.printStackTrace();
        }
    }

    // Méthode utilitaire pour créer et persister une catégorie
    private void persistCategory(String name) {
        Category category = new Category();
        category.setName(name);
        em.persist(category);
    }
}
