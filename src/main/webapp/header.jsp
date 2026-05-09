<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ page import="com.mycompany.eleganceapp.model.User" %>
        <% User headerUser=(User) session.getAttribute("currentUser"); boolean headerIsAdmin=headerUser !=null
            && "admin" .equalsIgnoreCase(headerUser.getRole()); %>
            <header>
                <div class="nav-container">
                    <div class="logo-wrapper">
                        <a href="home">
                            <img src="images/elegance-logo.png.PNG" alt="Élégance Logo" class="luxury-logo">
                        </a>
                    </div>

                    <% if (request.getServletPath().equals("/home.jsp") || request.getServletPath().endsWith("/home")) {
                        %>
                        <div class="search-wrapper">
                            <span class="search-icon">🔍</span>
                            <input type="text" id="searchInput" class="search-input"
                                placeholder="Rechercher une pièce d'exception..." onkeyup="handleSearch()">
                        </div>
                        <% } %>

                            <nav class="nav-links">
                                <% if (headerUser !=null) { %>
                                    <span class="welcome-msg" style="font-size: 1rem; margin-right: 15px;">
                                        <%= headerUser.getUsername() %>
                                            <% if(headerIsAdmin) { %><span class="badge-admin">Admin</span>
                                                <% } %>
                                    </span>
                                    <a href="home" class="nav-link">🏠 Accueil</a>
                                    <a href="cart" class="nav-link">🛒 Panier</a>
                                    <% if (headerIsAdmin) { %>
                                        <a href="admin" class="nav-link">🛍️ Articles</a>
                                        <a href="manageUsers" class="nav-link">👥 Utilisateurs</a>
                                        <% } %>
                                            <a href="logout" class="nav-link text-gold">Quitter</a>
                                            <% } else { %>
                                                <a href="login.jsp" class="nav-link">Connexion</a>
                                                <a href="register.jsp" class="nav-link">S'inscrire</a>
                                                <% } %>
                            </nav>
                </div>
            </header>