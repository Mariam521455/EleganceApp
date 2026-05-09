package com.mycompany.eleganceapp.servlet;

import com.mycompany.eleganceapp.model.User;
import com.mycompany.eleganceapp.service.UserServiceEJB;
import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;
import java.io.IOException;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    @EJB
    private UserServiceEJB service;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        if (service.usernameExists(username)) {
            response.sendRedirect("register.jsp?error=exists");
        } else {
            User user = new User(username, password, "user");
            service.register(user);

            HttpSession session = request.getSession();
            session.setAttribute("currentUser", user);
            response.sendRedirect(request.getContextPath() + "/home");
        }
    }
}
