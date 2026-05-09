package com.mycompany.eleganceapp.servlet;

import com.mycompany.eleganceapp.model.Article;
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

@WebServlet({ "/favorites" })
public class FavoriteServlet extends HttpServlet {

    @EJB
    private UserServiceEJB userService;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("currentUser");

        if (currentUser == null) {
            response.sendRedirect("login");
            return;
        }

        List<Article> favorites = userService.getFavorites(currentUser.getId());
        request.setAttribute("favorites", favorites);
        request.getRequestDispatcher("favorites.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("currentUser");

        if (currentUser == null) {
            System.out.println("[FavoriteServlet] Unauthorized POST request");
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().write("Veuillez vous connecter pour gérer vos favoris.");
            return;
        }

        String articleIdStr = request.getParameter("articleId");
        System.out.println("[FavoriteServlet] POST request for articleId: " + articleIdStr + " from user: "
                + currentUser.getUsername());
        if (articleIdStr != null) {
            try {
                Long articleId = Long.parseLong(articleIdStr);
                boolean added = userService.toggleFavorite(currentUser.getId(), articleId);

                // On renvoie un JSON simple
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                response.getWriter().write("{\"status\": \"success\", \"added\": " + added + "}");
            } catch (NumberFormatException e) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("ID d'article invalide.");
            }
        }
    }
}
