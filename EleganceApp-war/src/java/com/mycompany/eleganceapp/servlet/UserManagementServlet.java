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
import jakarta.servlet.http.HttpSession;
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

        if (!isAdmin(request)) {
            response.sendRedirect("home");
            return;
        }

        List<User> users = userService.getAllUsers();
        request.setAttribute("users", users);
        request.getRequestDispatcher("manageUsers.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!isAdmin(request)) {
            response.sendRedirect("home");
            return;
        }

        String action = request.getParameter("action");

        if ("delete".equals(action)) {
            try {
                Long id = Long.parseLong(request.getParameter("id"));
                User currentUser = (User) request.getSession().getAttribute("currentUser");

                if (currentUser.getId().equals(id)) {
                    request.getSession().setAttribute("error", "Vous ne pouvez pas supprimer votre propre compte.");
                } else {
                    long orderCount = orderService.countOrdersByUser(id);
                    if (orderCount > 0) {
                        request.getSession().setAttribute("error",
                                "Impossible de supprimer cet utilisateur : il a des commandes.");
                    } else {
                        userService.deleteUser(id);
                        request.getSession().setAttribute("success", "Utilisateur supprimé avec succès.");
                    }
                }
            } catch (Exception e) {
                request.getSession().setAttribute("error", "Erreur lors de la suppression.");
            }
        }

        if ("updateRole".equals(action)) {
            try {
                Long id = Long.parseLong(request.getParameter("id"));
                String role = request.getParameter("role");
                User currentUser = (User) request.getSession().getAttribute("currentUser");

                if (currentUser != null && currentUser.getId().equals(id)) {
                    request.getSession().setAttribute("error", "Vous ne pouvez pas modifier votre propre rôle.");
                } else {
                    userService.updateUserRole(id, role);
                    request.getSession().setAttribute("success", "Rôle mis à jour avec succès.");
                }
            } catch (Exception e) {
                request.getSession().setAttribute("error", "Erreur lors de la mise à jour du rôle.");
            }
        }

        response.sendRedirect("manageUsers");
    }

    private boolean isAdmin(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session != null) {
            User user = (User) session.getAttribute("currentUser");
            return user != null && "admin".equalsIgnoreCase(user.getRole());
        }
        return false;
    }
}
