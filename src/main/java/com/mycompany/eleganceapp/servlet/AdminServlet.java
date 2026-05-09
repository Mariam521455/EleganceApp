package com.mycompany.eleganceapp.servlet;

import com.mycompany.eleganceapp.model.Article;
import com.mycompany.eleganceapp.model.Category;
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
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@WebServlet("/admin")
public class AdminServlet extends HttpServlet {

    @EJB
    private ArticleServiceEJB articleService;

    @EJB
    private CategoryServiceEJB categoryService;

    @EJB
    private OrderServiceEJB orderService;

    @EJB
    private UserServiceEJB userService;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null || !"admin".equalsIgnoreCase(currentUser.getRole())) {
            response.sendRedirect("home");
            return;
        }

        // Prepare data for view
        String action = request.getParameter("action");
        if ("edit".equals(action)) {
            String idStr = request.getParameter("id");
            if (idStr != null) {
                Article article = articleService.find(Long.parseLong(idStr));
                request.setAttribute("articleToEdit", article);
                // Load categories for dropdown
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

        // Default: Admin Dashboard Overview
        request.setAttribute("articleCount", articleService.countArticles());
        request.setAttribute("userCount", userService.countUsers());
        request.setAttribute("orderCount", orderService.countAllOrders());
        request.setAttribute("totalSales", orderService.sumTotalSales());

        List<Article> allArticles = articleService.findAll();
        request.setAttribute("allArticles", allArticles);

        // Data for Category Distribution Chart
        Map<String, Long> categoryCounts = allArticles.stream()
                .collect(Collectors.groupingBy(
                        a -> a.getCategory() != null ? a.getCategory().getName() : "Autres",
                        Collectors.counting()));
        request.setAttribute("categoryCounts", categoryCounts);

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
                    break;

                case "delete":
                    String idStr = request.getParameter("id");
                    if (idStr != null) {
                        articleService.deleteArticle(Long.parseLong(idStr));
                    }
                    break;

                case "update":
                    String editIdStr = request.getParameter("id");
                    if (editIdStr != null) {
                        Article editArticle = articleService.find(Long.parseLong(editIdStr));
                        if (editArticle != null) {
                            updateArticleFromRequest(editArticle, request);
                            articleService.edit(editArticle);
                        }
                    }
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace(); // Log error
            request.setAttribute("errorMessage", "Erreur lors de l'opération: " + e.getMessage());
        }

        response.sendRedirect("home");
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
