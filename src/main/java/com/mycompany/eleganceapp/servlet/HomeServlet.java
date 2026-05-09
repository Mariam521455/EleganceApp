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
import com.mycompany.eleganceapp.service.UserServiceEJB;

@WebServlet("/home")
public class HomeServlet extends HttpServlet {

    @EJB
    private ArticleServiceEJB articleService;

    @EJB
    private CategoryServiceEJB categoryService;

    @EJB
    private UserServiceEJB userService;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("currentUser") : null;

        if (currentUser == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // Retrieve all articles and categories
        List<Article> articles = articleService.getAllArticles();
        List<com.mycompany.eleganceapp.model.Category> categories = categoryService.findAll();

        // Pre-load favorites to avoid LazyInitializationException in JSP
        List<Article> userFavorites = userService.getFavorites(currentUser.getId());

        boolean isAdmin = "admin".equalsIgnoreCase(currentUser.getRole());
        request.setAttribute("currentUser", currentUser);
        request.setAttribute("isAdmin", isAdmin);
        request.setAttribute("articles", articles);
        request.setAttribute("categories", categories);
        request.setAttribute("userFavorites", userFavorites);
        // session already defined above, reuse it
        String successMsg = (String) session.getAttribute("success");
        if (successMsg != null) {
            request.setAttribute("success", successMsg);
            session.removeAttribute("success");
        }

        request.getRequestDispatcher("home.jsp").forward(request, response);
    }
}
