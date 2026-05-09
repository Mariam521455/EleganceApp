package com.mycompany.eleganceapp.servlet;

import com.mycompany.eleganceapp.model.User;
import com.mycompany.eleganceapp.service.OrderServiceEJB;
import com.mycompany.eleganceapp.service.UserServiceEJB;
import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/manageUsers")
public class UserManagementServlet extends HttpServlet {

    @EJB
    private UserServiceEJB userService;

    @EJB
    private OrderServiceEJB orderService;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Vérification d'accès admin
        User currentUser = (User) request.getSession().getAttribute("currentUser");
        if (currentUser == null || !"admin".equalsIgnoreCase(currentUser.getRole())) {
            response.sendRedirect("home");
            return;
        }

        // Standardiser pour JSP
        request.setAttribute("currentUser", currentUser);
        request.setAttribute("isAdmin", true);

        List<User> users = userService.getAllUsers();
        request.setAttribute("users", users);
        request.getRequestDispatcher("manageUsers.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if ("delete".equals(action)) {
            try {
                // Vérification d'accès admin
                User currentUser = (User) request.getSession().getAttribute("currentUser");
                if (currentUser == null || !"admin".equalsIgnoreCase(currentUser.getRole())) {
                    request.getSession().setAttribute("error", "Accès refusé.");
                } else {
                    String idParam = request.getParameter("id");
                    if (idParam != null && !idParam.isEmpty()) {
                        Long id = Long.parseLong(idParam);
                        if (currentUser.getId() != null && currentUser.getId().equals(id)) {
                            request.getSession().setAttribute("error", "Vous ne pouvez pas supprimer votre propre compte.");
                        } else {
                            // Supprimer d'abord les commandes associées (Cascade manuel)
                            orderService.deleteOrdersByUser(id);

                            // Puis supprimer l'utilisateur
                            userService.deleteUser(id);
                            request.getSession().setAttribute("success", "Utilisateur et ses données supprimés avec succès.");
                        }
                    } else {
                        request.getSession().setAttribute("error", "Identifiant invalide.");
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
                request.getSession().setAttribute("error", "Erreur lors de la suppression : " + e.getMessage());
            }
        }

        if ("XMLHttpRequest".equals(request.getHeader("X-Requested-With"))) {
            response.setStatus(HttpServletResponse.SC_OK);
        } else {
            response.sendRedirect("manageUsers");
        }
    }

}
