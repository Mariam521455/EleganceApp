package com.mycompany.eleganceapp.servlet;

import com.mycompany.eleganceapp.model.Article;
import com.mycompany.eleganceapp.model.Category;
import com.mycompany.eleganceapp.model.User;
import com.mycompany.eleganceapp.service.ArticleServiceEJB;
import com.mycompany.eleganceapp.service.CategoryServiceEJB;
import jakarta.ejb.EJB;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/admin")
public class AdminServlet extends HttpServlet {

    @EJB
    private ArticleServiceEJB articleService;

    @EJB
    private CategoryServiceEJB categoryService;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null || !"admin".equalsIgnoreCase(currentUser.getRole())) {
            response.sendRedirect("home");
            return;
        }

        // Standardiser pour JSP: fournir currentUser et isAdmin en request
        request.setAttribute("currentUser", currentUser);
        request.setAttribute("isAdmin", true);

        String action = request.getParameter("action");
        if ("edit".equals(action)) {
            String idStr = request.getParameter("id");
            if (idStr != null) {
                Article article = articleService.find(Long.parseLong(idStr));
                request.setAttribute("articleToEdit", article);
                List<Category> allCategories = categoryService.findAll();
                request.setAttribute("categories", allCategories);
                request.getRequestDispatcher("editArticle.jsp").forward(request, response);
                return;
            }
        } else if ("add_form".equals(action)) {
            List<Category> allCategories = categoryService.findAll();
            request.setAttribute("categories", allCategories);
            request.getRequestDispatcher("addArticle.jsp").forward(request, response);
            return;
        }
        // Affichage principal admin : toujours fournir les listes
        List<Article> allArticles = articleService.getAllArticles();
        List<Category> allCategories = categoryService.findAll();
        request.setAttribute("allArticles", allArticles);
        request.setAttribute("categories", allCategories);
        // Messages de succès/erreur depuis la session
        HttpSession sessionMsg = request.getSession();
        String successMsg = (String) sessionMsg.getAttribute("success");
        String errorMsg = (String) sessionMsg.getAttribute("error");
        if (successMsg != null) {
            request.setAttribute("successMsg", successMsg);
            sessionMsg.removeAttribute("success");
        }
        if (errorMsg != null) {
            request.setAttribute("errorMsg", errorMsg);
            sessionMsg.removeAttribute("error");
        }
        request.getRequestDispatcher("admin.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null || !"admin".equalsIgnoreCase(currentUser.getRole())) {
            response.sendRedirect("home");
            return;
        }

        String action = request.getParameter("action");
        if (action == null) {
            response.sendRedirect("home");
            return;
        }

        try {
            switch (action) {
                case "add":
                    Article newArticle = new Article();
                    updateArticleFromRequest(newArticle, request);
                    articleService.create(newArticle);
                    request.getSession().setAttribute("success", "Article ajouté avec succès.");
                    break;
                case "delete":
                    String idStr = request.getParameter("id");
                    if (idStr != null) {
                        articleService.deleteArticle(Long.parseLong(idStr));
                        request.getSession().setAttribute("success", "Article supprimé avec succès.");
                    }
                    break;
                case "update":
                    String editIdStr = request.getParameter("id");
                    if (editIdStr != null) {
                        Article editArticle = articleService.find(Long.parseLong(editIdStr));
                        if (editArticle != null) {
                            updateArticleFromRequest(editArticle, request);
                            articleService.edit(editArticle);
                            request.getSession().setAttribute("success", "Article modifié avec succès.");
                        }
                    }
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("error", "Erreur lors de l'opération : " + e.getMessage());
        }
        response.sendRedirect("admin");
    }

    private void updateArticleFromRequest(Article article, HttpServletRequest request) {
        article.setName(request.getParameter("name"));
        article.setDescription(request.getParameter("description"));
        try {
            article.setPrice(Double.parseDouble(request.getParameter("price")));
        } catch (NumberFormatException e) {
            article.setPrice(0.0);
        }
        article.setImageUrl(request.getParameter("imageUrl"));

        String catIdStr = request.getParameter("categoryId");
        if (catIdStr != null && !catIdStr.isEmpty()) {
            Category c = categoryService.find(Long.parseLong(catIdStr));
            article.setCategory(c);
        }

        // Checkbox handling: null if unchecked, 'on' or 'true' if checked
        String enabledStr = request.getParameter("enabled");
        article.setEnabled(enabledStr != null && !enabledStr.isEmpty());
    }
}
