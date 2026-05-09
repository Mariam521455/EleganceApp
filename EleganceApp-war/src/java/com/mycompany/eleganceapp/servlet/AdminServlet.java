package com.mycompany.eleganceapp.servlet;

import com.mycompany.eleganceapp.model.Article;
import com.mycompany.eleganceapp.model.Category;
import com.mycompany.eleganceapp.model.Order;
import com.mycompany.eleganceapp.model.User;
import com.mycompany.eleganceapp.service.ArticleServiceEJB;
import com.mycompany.eleganceapp.service.CategoryServiceEJB;
import com.mycompany.eleganceapp.service.OrderServiceEJB;
import com.mycompany.eleganceapp.service.UserServiceEJB;
import jakarta.ejb.EJB;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.Collections;
import java.util.List;

@WebServlet("/admin")
public class AdminServlet extends HttpServlet {

    @EJB
    private ArticleServiceEJB articleService;

    @EJB
    private CategoryServiceEJB categoryService;

    @EJB
    private UserServiceEJB userService;

    @EJB
    private OrderServiceEJB orderService;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null || !"admin".equalsIgnoreCase(currentUser.getRole())) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }

        request.setAttribute("currentUser", currentUser);
        request.setAttribute("isAdmin", true);

        String action = request.getParameter("action");

        if ("orders".equals(action)) {
            String mode = request.getParameter("mode");
            if (mode == null || mode.isEmpty()) {
                mode = "list";
            }

            if ("view".equals(mode)) {
                String idStr = request.getParameter("id");
                if (idStr != null && !idStr.isEmpty()) {
                    try {
                        Long orderId = Long.parseLong(idStr);
                        Order order = orderService.findById(orderId);
                        request.setAttribute("selectedOrder", order);
                    } catch (NumberFormatException ignored) {
                        request.setAttribute("selectedOrder", null);
                    }
                }
            }

            List<Order> orders;
            try {
                orders = orderService.getAllOrders();
            } catch (Exception e) {
                orders = Collections.emptyList();
                session.setAttribute("error", "Erreur lors du chargement des commandes : " + e.getMessage());
            }
            request.setAttribute("orders", orders);

            // Flash messages (reuse header.jsp mechanism)
            if (request.getAttribute("flashSuccess") == null) {
                request.setAttribute("flashSuccess", session.getAttribute("success"));
                session.removeAttribute("success");
            }
            if (request.getAttribute("flashError") == null) {
                request.setAttribute("flashError", session.getAttribute("error"));
                session.removeAttribute("error");
            }

            request.getRequestDispatcher("manageOrders.jsp").forward(request, response);
            return;
        }

        if ("users".equals(action)) {
            List<User> users = userService.getAllUsers();
            request.setAttribute("users", users);

            // Flash messages (reuse header.jsp mechanism)
            if (request.getAttribute("flashSuccess") == null) {
                request.setAttribute("flashSuccess", session.getAttribute("success"));
                session.removeAttribute("success");
            }
            if (request.getAttribute("flashError") == null) {
                request.setAttribute("flashError", session.getAttribute("error"));
                session.removeAttribute("error");
            }

            request.getRequestDispatcher("manageUsers.jsp").forward(request, response);
            return;
        }

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

        // Page principale admin - Vérifier s'il y a des articles
        List<Article> allArticles = articleService.getAllArticles();
        if (allArticles == null || allArticles.isEmpty()) {
            // Si aucun article, rediriger vers home avec message info
            session.setAttribute("info", "Aucun article à gérer. Ajoutez un nouvel article pour commencer.");
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }

        List<Category> allCategories = categoryService.findAll();
        request.setAttribute("allArticles", allArticles);
        request.setAttribute("categories", allCategories);

        // Messages de session
        String successMsg = (String) session.getAttribute("success");
        String errorMsg = (String) session.getAttribute("error");
        if (successMsg != null) {
            request.setAttribute("successMsg", successMsg);
            session.removeAttribute("success");
        }
        if (errorMsg != null) {
            request.setAttribute("errorMsg", errorMsg);
            session.removeAttribute("error");
        }

        request.getRequestDispatcher("admin.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null || !"admin".equalsIgnoreCase(currentUser.getRole())) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }

        String action = request.getParameter("action");
        if (action == null) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }

        try {
            switch (action) {
                case "order_delete": {
                    String idStr = request.getParameter("id");
                    if (idStr != null && !idStr.isEmpty()) {
                        orderService.deleteById(Long.parseLong(idStr));
                        session.setAttribute("success", "Commande supprimée avec succès.");
                    }
                    response.sendRedirect(request.getContextPath() + "/home");
                    return;
                }

                case "order_update": {
                    String idStr = request.getParameter("id");
                    String totalStr = request.getParameter("totalAmount");
                    if (idStr != null && !idStr.isEmpty()) {
                        Long id = Long.parseLong(idStr);
                        Order order = orderService.findById(id);
                        if (order != null && totalStr != null && !totalStr.isEmpty()) {
                            try {
                                order.setTotalAmount(Double.parseDouble(totalStr));
                                orderService.update(order);
                                session.setAttribute("success", "Commande mise à jour avec succès.");
                            } catch (NumberFormatException nfe) {
                                session.setAttribute("error", "Montant invalide.");
                            }
                        }
                    }
                    response.sendRedirect(request.getContextPath() + "/home");
                    return;
                }

                case "add":
                    Article newArticle = new Article();
                    updateArticleFromRequest(newArticle, request);
                    articleService.create(newArticle);
                    session.setAttribute("success", "Article ajouté avec succès.");
                    response.sendRedirect(request.getContextPath() + "/home");
                    return;

                case "delete":
                    String idStr = request.getParameter("id");
                    if (idStr != null) {
                        articleService.deleteArticle(Long.parseLong(idStr));
                        session.setAttribute("success", "Article supprimé avec succès.");
                        
                        // Vérifier s'il reste des articles
                        List<Article> remainingArticles = articleService.getAllArticles();
                        if (remainingArticles == null || remainingArticles.isEmpty()) {
                            session.setAttribute("info", "Tous les articles ont été supprimés. Ajoutez un nouvel article pour repeuplir votre collection.");
                        }
                    }
                    response.sendRedirect(request.getContextPath() + "/home");
                    return;

                case "update":
                    String editIdStr = request.getParameter("id");
                    if (editIdStr != null) {
                        Article editArticle = articleService.find(Long.parseLong(editIdStr));
                        if (editArticle != null) {
                            updateArticleFromRequest(editArticle, request);
                            articleService.edit(editArticle);
                            session.setAttribute("success", "Article modifié avec succès.");

                            // Redirection vers /home après modification
                            response.sendRedirect(request.getContextPath() + "/home");
                            return;  // Très important pour arrêter l'exécution
                        }
                    }
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("error", "Erreur lors de l'opération : " + e.getMessage());
        }

        // Par défaut, pour les autres actions (add/delete), on retourne à /home
        response.sendRedirect(request.getContextPath() + "/home");
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
        String enabledStr = request.getParameter("enabled");
        article.setEnabled(enabledStr != null && !enabledStr.isEmpty());
    }
}