package com.mycompany.eleganceapp.servlet;

import com.mycompany.eleganceapp.model.Article;
import com.mycompany.eleganceapp.service.ArticleServiceEJB;
import com.mycompany.eleganceapp.service.UserServiceEJB;
import java.io.IOException;
import java.util.List;
import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "DashboardServlet", urlPatterns = { "/Dashboard" })
public class DashboardServlet extends HttpServlet {

    @EJB
    private ArticleServiceEJB articleService;

    @EJB
    private UserServiceEJB userService;

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. Récupérer les statistiques
        long totalArticles = articleService.countArticles();
        long totalUsers = userService.countUsers();

        // 2. Récupérer les derniers articles ajoutés (ex: 5 derniers)
        List<Article> latestArticles = articleService.findLatest(5);

        // 3. Stocker dans les attributs de la requête
        request.setAttribute("totalArticles", totalArticles);
        request.setAttribute("totalUsers", totalUsers);
        request.setAttribute("latestArticles", latestArticles);

        // 4. Rediriger vers la JSP
        request.getRequestDispatcher("dashboard.jsp").forward(request, response);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Dashboard Servlet";
    }
}
