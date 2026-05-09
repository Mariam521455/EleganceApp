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
                // Provide currentUser/isAdmin to JSP if present in session
                User currentUser = (User) request.getSession().getAttribute("currentUser");
                request.setAttribute("currentUser", currentUser);
                request.setAttribute("isAdmin", currentUser != null && "admin".equalsIgnoreCase(currentUser.getRole()));
                request.getRequestDispatcher("articleDetails.jsp").forward(request, response);
            } else {
                // Rediriger vers l'accueil avec message d'erreur en session
                request.getSession().setAttribute("error", "Article non trouvé.");
                response.sendRedirect("home");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect("home");
        }
    }
}
