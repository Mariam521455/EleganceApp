package com.mycompany.eleganceapp.servlet;

import com.mycompany.eleganceapp.model.Article;
import com.mycompany.eleganceapp.service.ArticleServiceEJB;

import jakarta.ejb.EJB;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;
import java.io.IOException;

@WebServlet("/editArticle")
public class EditArticleServlet extends HttpServlet {

    @EJB
    private ArticleServiceEJB articleService;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Récupérer l'ID passé en paramètre
        String idParam = request.getParameter("id");
        if (idParam == null || idParam.isEmpty()) {
            response.sendRedirect("admin.jsp"); // Redirection si pas d'ID
            return;
        }

        Long id;
        try {
            id = Long.parseLong(idParam);
        } catch (NumberFormatException e) {
            response.sendRedirect("admin.jsp"); // Redirection si ID invalide
            return;
        }

        // ✅ Récupérer l'article depuis la base
        Article article = articleService.findArticleById(id);

        if (article == null) {
            response.sendRedirect("admin.jsp"); // Redirection si article non trouvé
            return;
        }

        // Passer l'article à la JSP d'édition
        request.setAttribute("article", article);
        RequestDispatcher dispatcher = request.getRequestDispatcher("editArticle.jsp");
        dispatcher.forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Récupérer les champs du formulaire
        Long id = Long.parseLong(request.getParameter("id"));
        String name = request.getParameter("name");
        String priceStr = request.getParameter("price");
        String category = request.getParameter("category");
        String imageUrl = request.getParameter("imageUrl");

        Double price = 0.0;
        try {
            price = Double.parseDouble(priceStr);
        } catch (NumberFormatException e) {
            // garder price = 0.0 si invalide
        }

        // Récupérer l'article existant
        Article article = articleService.findArticleById(id);
        if (article == null) {
            response.sendRedirect("admin.jsp");
            return;
        }

        // Mettre à jour les champs
        article.setName(name);
        article.setPrice(price);
        article.setImageUrl(imageUrl);
        // Pour la catégorie, il faut éventuellement récupérer l'objet Category depuis AdminServiceEJB
        // Ici on suppose que l'objet Category est déjà existant et géré côté Admin

        // Sauvegarder les modifications
        articleService.updateArticle(article);

        // Redirection vers la page admin
        response.sendRedirect("AdminServlet");
    }
}

