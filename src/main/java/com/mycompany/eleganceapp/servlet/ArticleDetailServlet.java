package com.mycompany.eleganceapp.servlet;

import com.mycompany.eleganceapp.model.Article;
import com.mycompany.eleganceapp.model.User;
import com.mycompany.eleganceapp.service.ArticleServiceEJB;
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

@WebServlet("/article")
public class ArticleDetailServlet extends HttpServlet {

    @EJB
    private ArticleServiceEJB articleService;

    @EJB
    private UserServiceEJB userService;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("currentUser") : null;

        String idParam = request.getParameter("id");

        if (idParam == null || idParam.trim().isEmpty()) {
            response.sendRedirect("home");
            return;
        }

        try {
            Long id = Long.parseLong(idParam);
            Article article = articleService.getArticleById(id);

            if (article != null) {
                request.setAttribute("article", article);
                String status = Boolean.TRUE.equals(article.getEnabled()) ? "Disponible" : "Indisponible";
                request.setAttribute("status", status);

                // Articles Similaires (Même catégorie, exclure l'actuel)
                if (article.getCategory() != null) {
                    List<Article> similarArticles = articleService.findByCategory(article.getCategory().getName());
                    List<Article> filteredSimilar = similarArticles.stream()
                            .filter(a -> !a.getId().equals(article.getId()))
                            .limit(4)
                            .collect(java.util.stream.Collectors.toList());
                    request.setAttribute("similarArticles", filteredSimilar);
                }

                if (currentUser != null) {
                    List<Article> userFavorites = userService.getFavorites(currentUser.getId());
                    request.setAttribute("userFavorites", userFavorites);
                }

                request.getRequestDispatcher("articleDetails.jsp").forward(request, response);
            } else {
                request.setAttribute("errorMessage", "Article non trouvé.");
                request.getRequestDispatcher("home").forward(request, response);
            }
        } catch (NumberFormatException e) {
            response.sendRedirect("home");
        }
    }
}
