package com.mycompany.eleganceapp.servlet;

import com.mycompany.eleganceapp.service.ArticleServiceEJB;
import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/deleteArticle")
public class DeleteArticleServlet extends HttpServlet {

    @EJB
    private ArticleServiceEJB articleService;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 🔹 On utilise Long.parseLong pour récupérer un Long depuis le paramètre
        Long id = Long.parseLong(request.getParameter("id"));
        articleService.deleteArticle(id);
        response.sendRedirect("admin.jsp");
    }
}


