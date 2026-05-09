package com.mycompany.eleganceapp.servlet;

import com.mycompany.eleganceapp.model.Article;
import com.mycompany.eleganceapp.model.Cart;
import com.mycompany.eleganceapp.model.User;
import com.mycompany.eleganceapp.service.ArticleServiceEJB;
import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/cart")
public class CartServlet extends HttpServlet {

    @EJB
    private ArticleServiceEJB articleService;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("cart.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("currentUser");

        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        Cart cart = (Cart) session.getAttribute("cart");
        if (cart == null) {
            cart = new Cart();
            session.setAttribute("cart", cart);
        }

        String action = request.getParameter("action");
        String idStr = request.getParameter("id");

        if (idStr != null && !idStr.isEmpty()) {
            try {
                Long id = Long.parseLong(idStr);

                if ("add".equals(action)) {
                    Article article = articleService.getArticleById(id);
                    if (article != null) {
                        cart.addItem(article, 1); // Default quantity 1
                    }
                } else if ("remove".equals(action)) {
                    cart.removeItem(id);
                } else if ("update".equals(action)) {
                    String qtyStr = request.getParameter("quantity");
                    if (qtyStr != null) {
                        int qty = Integer.parseInt(qtyStr);
                        cart.updateQuantity(id, qty);
                    }
                }
            } catch (NumberFormatException e) {
                // Ignore invalid numbers
            }
        }

        if ("XMLHttpRequest".equals(request.getHeader("X-Requested-With"))) {
            response.setStatus(HttpServletResponse.SC_OK);
        } else {
            response.sendRedirect("cart"); // Redirect to GET to avoid resubmission
        }
    }
}
