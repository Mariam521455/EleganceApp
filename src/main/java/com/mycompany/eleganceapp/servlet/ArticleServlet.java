package com.mycompany.eleganceapp.servlet;

import com.mycompany.eleganceapp.model.Article;
import com.mycompany.eleganceapp.service.ArticleServiceEJB;
import jakarta.ejb.EJB;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

public class ArticleServlet extends HttpServlet {

    @EJB
    private ArticleServiceEJB articleService;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Filtre optionnel par catégorie
        String category = request.getParameter("category");

        List<Article> articles;
        if (category != null && !category.isEmpty()) {
            articles = articleService.getArticlesByCategory(category);
        } else {
            articles = articleService.getAllArticles();
        }

        // Stocker la liste dans la requête pour la JSP
        request.setAttribute("articles", articles);

        // Forward vers la page JSP
        RequestDispatcher dispatcher = request.getRequestDispatcher("articles.jsp");
        dispatcher.forward(request, response);
    }

    // Si tu veux gérer les POST (ex: formulaire de filtre)
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
