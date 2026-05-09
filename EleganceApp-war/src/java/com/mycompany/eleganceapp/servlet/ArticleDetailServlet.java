package com.mycompany.eleganceapp.servlet;

import com.mycompany.eleganceapp.model.Article;
import com.mycompany.eleganceapp.model.User;
import com.mycompany.eleganceapp.service.ArticleServiceEJB;
import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/article")
public class ArticleDetailServlet extends HttpServlet {

    @EJB
    private ArticleServiceEJB articleService;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idParam = request.getParameter("id");

        if (idParam == null || idParam.trim().isEmpty()) {
            request.getSession().setAttribute("error", "ID d'article manquant.");
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }

        try {
            Long id = Long.parseLong(idParam.trim());
            Article article = articleService.getArticleById(id);

            if (article == null) {
                request.getSession().setAttribute("error", "Article introuvable.");
                response.sendRedirect(request.getContextPath() + "/home");
                return;
            }

            request.setAttribute("article", article);

            String status = Boolean.TRUE.equals(article.getEnabled())
                    ? "Disponible"
                    : "Indisponible";
            request.setAttribute("status", status);

            User currentUser = (User) request.getSession().getAttribute("currentUser");
            request.setAttribute("currentUser", currentUser);

            request.getRequestDispatcher("/articles.jsp")
                   .forward(request, response);

        } catch (NumberFormatException e) {
            request.getSession().setAttribute("error", "ID d'article invalide.");
            response.sendRedirect(request.getContextPath() + "/home");
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("error", "Erreur serveur.");
            response.sendRedirect(request.getContextPath() + "/home");
        }
    }
}
