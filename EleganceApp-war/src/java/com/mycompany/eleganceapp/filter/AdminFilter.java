package com.mycompany.eleganceapp.filter;

import com.mycompany.eleganceapp.model.User;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebFilter(urlPatterns = { "/admin", "/manageUsers", "/addArticle.jsp", "/editArticle.jsp" })
public class AdminFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        HttpSession session = httpRequest.getSession(false);

        User currentUser = (session != null) ? (User) session.getAttribute("currentUser") : null;

        if (currentUser != null && "admin".equalsIgnoreCase(currentUser.getRole())) {
            // User is admin, proceed
            chain.doFilter(request, response);
        } else {
            // Not an admin, redirect to login or home
            if (currentUser == null) {
                session = httpRequest.getSession(true);
                session.setAttribute("error", "Veuillez vous connecter pour accéder à cette page.");
                httpResponse.sendRedirect("login.jsp");
            } else {
                session.setAttribute("error", "Accès refusé. Vous n'avez pas les droits d'administrateur.");
                httpResponse.sendRedirect("home");
            }
        }
    }

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Initialization logic if needed
    }

    @Override
    public void destroy() {
        // Cleanup logic if needed
    }
}
