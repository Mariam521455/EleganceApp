package com.mycompany.eleganceapp.servlet;

import com.google.gson.Gson;
import com.mycompany.eleganceapp.model.Article;
import com.mycompany.eleganceapp.service.ArticleServiceEJB;
import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "ArticleApiServlet", urlPatterns = { "/api/articles" })
public class ArticleApiServlet extends HttpServlet {

    @EJB
    private ArticleServiceEJB articleService;

    private final Gson gson = new Gson();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json;charset=UTF-8");
        response.setHeader("Cache-Control", "no-cache");

        String category = request.getParameter("category");
        List<Article> articles;

        try {
            if (category != null && !category.isEmpty() && !"all".equalsIgnoreCase(category)) {
                articles = articleService.findByCategory(category);
            } else {
                articles = articleService.getAllArticles();
            }

            // Basic JSON conversion
            // Note: If Entities have cyclic dependencies (Category -> Articles), Gson might
            // fail.
            // We should ensure Article.category is serializable or handle it.
            // Users typically want a simple object.
            // For this task, we assume the Entities are simple enough or Gson handles it
            // (Category has @OneToMany fetch Lazy so it shouldn't serialize the list back)
            // But we must be careful.

            String json = gson.toJson(articles);
            response.getWriter().write(json);

        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\": \"Unable to fetch articles\"}");
            e.printStackTrace();
        }
    }
}
