package com.mycompany.eleganceapp.servlet;

import jakarta.ejb.EJB;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import com.mycompany.eleganceapp.model.User;
import com.mycompany.eleganceapp.model.Article;
import com.mycompany.eleganceapp.service.ArticleServiceEJB;
import com.mycompany.eleganceapp.service.CategoryServiceEJB;

@WebServlet("/home")
public class HomeServlet extends HttpServlet {

    @EJB
    private ArticleServiceEJB articleService;

    @EJB
    private CategoryServiceEJB categoryService;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("currentUser") : null;

        if (currentUser == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        try {
            // Récupération des articles et catégories (jamais null)
            List<Article> articles = articleService.getAllArticles();
            if (articles == null) articles = java.util.Collections.emptyList();
            List<com.mycompany.eleganceapp.model.Category> categories = categoryService.findAll();
            if (categories == null) categories = java.util.Collections.emptyList();

            boolean isAdmin = "admin".equalsIgnoreCase(currentUser.getRole());
            request.setAttribute("currentUser", currentUser);
            request.setAttribute("isAdmin", isAdmin);
            request.setAttribute("articles", articles);
            request.setAttribute("categories", categories);
            // session already defined above, reuse it
            String successMsg = (String) session.getAttribute("success");
            if (successMsg != null) {
                request.setAttribute("success", successMsg);
                session.removeAttribute("success");
            }
        } catch (Exception ex) {
            request.setAttribute("error", "Erreur lors du chargement des données : " + ex.getMessage());
        }
        request.getRequestDispatcher("home.jsp").forward(request, response);
    }
}
