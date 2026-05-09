package com.mycompany.eleganceapp.servlet;

import com.mycompany.eleganceapp.model.User;
import com.mycompany.eleganceapp.service.UserServiceEJB;
import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

/**
 * Servlet pour afficher les statistiques des favoris dans le dashboard admin
 */
@WebServlet(name = "AdminFavoritesServlet", urlPatterns = { "/admin/favorites" })
public class AdminFavoritesServlet extends HttpServlet {

    @EJB
    private UserServiceEJB userService;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("currentUser") : null;

        // Vérification de l'authentification et du rôle admin
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        if (!"admin".equalsIgnoreCase(currentUser.getRole())) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }

        try {
            // Récupérer les statistiques des favoris
            List<Object[]> favoriteStats = userService.getFavoriteStatistics();
            request.setAttribute("favoriteStats", favoriteStats);

            // Récupérer les articles les plus populaires (top 10)
            List<Object[]> mostFavorited = userService.getMostFavoritedArticles(10);
            request.setAttribute("mostFavorited", mostFavorited);

            // Calculer les statistiques générales
            int totalFavorites = 0;
            int totalArticlesWithFavorites = 0;
            int topArticleCount = 0;

            if (favoriteStats != null && !favoriteStats.isEmpty()) {
                for (Object[] stat : favoriteStats) {
                    Integer count = (Integer) stat[2];
                    totalFavorites += count;
                    if (count > 0) {
                        totalArticlesWithFavorites++;
                    }
                }

                // Le premier article est le plus populaire
                topArticleCount = (Integer) favoriteStats.get(0)[2];
            }

            // Calculer la moyenne
            double averageFavorites = totalArticlesWithFavorites > 0 ? 
                (double) totalFavorites / totalArticlesWithFavorites : 0;

            // Arrondir la moyenne pour l'affichage
            if (averageFavorites < 1 && averageFavorites > 0) {
                averageFavorites = 1; // Afficher au moins 1 s'il y a des favoris
            } else {
                averageFavorites = Math.round(averageFavorites);
            }

            // Définir les attributs pour la JSP
            request.setAttribute("currentUser", currentUser);
            request.setAttribute("isAdmin", true);
            request.setAttribute("totalFavorites", totalFavorites);
            request.setAttribute("totalArticlesWithFavorites", totalArticlesWithFavorites);
            request.setAttribute("averageFavorites", (int) averageFavorites);
            request.setAttribute("topArticleCount", topArticleCount);

            // Forward vers la page JSP
            request.getRequestDispatcher("admin-favorites.jsp").forward(request, response);

        } catch (Exception e) {
            System.err.println("Erreur dans AdminFavoritesServlet: " + e.getMessage());
            e.printStackTrace();

            // En cas d'erreur, définir des valeurs par défaut
            request.setAttribute("currentUser", currentUser);
            request.setAttribute("isAdmin", true);
            request.setAttribute("favoriteStats", null);
            request.setAttribute("mostFavorited", null);
            request.setAttribute("totalFavorites", 0);
            request.setAttribute("totalArticlesWithFavorites", 0);
            request.setAttribute("averageFavorites", 0);
            request.setAttribute("topArticleCount", 0);

            request.getRequestDispatcher("admin-favorites.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Rediriger les POST vers GET pour éviter les soumissions multiples
        doGet(request, response);
    }
}
