package com.mycompany.eleganceapp.servlet;

import com.mycompany.eleganceapp.model.Cart;
import com.mycompany.eleganceapp.model.Order;
import com.mycompany.eleganceapp.model.OrderItem;
import com.mycompany.eleganceapp.model.User;
import com.mycompany.eleganceapp.service.OrderServiceEJB;
import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/order")
public class OrderServlet extends HttpServlet {

    @EJB
    private OrderServiceEJB orderService;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("currentUser");

        if (currentUser == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        Cart cart = (Cart) session.getAttribute("cart");
        if (cart == null || cart.isEmpty()) {
            response.sendRedirect("cart.jsp");
            return;
        }

        // Create Order
        Order order = new Order(currentUser, java.time.LocalDateTime.now(), cart.getTotal());

        // Convert Cart items to Order items
        for (OrderItem cartItem : cart.getItems()) {
            // Need to create new OrderItem objects to ensure they are managed correctly
            // with the new Order
            // Although Cart items are detached OrderItem objects, we can reuse them if we
            // attach them to the order
            // But Cart uses "Article" reference which is correct.
            // Ideally we clone or just use them. Since OrderItem in Cart is not an Entity
            // yet (no ID), it's fine.
            cartItem.setOrder(order);
            order.getItems().add(cartItem);
        }

        try {
            orderService.createOrder(order);
            session.removeAttribute("cart"); // Clear cart
            response.sendRedirect("orderSuccess.jsp");
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Erreur lors de la validation de la commande.");
            // Ensure currentUser/isAdmin are available to cart.jsp
            currentUser = (User) session.getAttribute("currentUser");
            request.setAttribute("currentUser", currentUser);
            request.setAttribute("isAdmin", currentUser != null && "admin".equalsIgnoreCase(currentUser.getRole()));
            request.getRequestDispatcher("cart.jsp").forward(request, response);
        }
    }
}
