package com.mycompany.eleganceapp.servlet;

import com.mycompany.eleganceapp.model.Article;
import com.mycompany.eleganceapp.service.ArticleServiceEJB;
import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/AddArticleServlet")
public class AddArticleServlet extends HttpServlet {

    @EJB
    private ArticleServiceEJB articleService;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String name = request.getParameter("name");
        String description = request.getParameter("description");
        double price = Double.parseDouble(request.getParameter("price"));
        String imageUrl = request.getParameter("imageUrl");

        Article article = new Article();
        article.setName(name);
        article.setDescription(description);
        article.setPrice(price);
        article.setImageUrl(imageUrl);

        articleService.addArticle(article);

        response.sendRedirect("admin.jsp");
    }
}

