<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.mycompany.eleganceapp.model.User" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    User _headerUser = null;
    if (request.getAttribute("currentUser") != null) {
        _headerUser = (User) request.getAttribute("currentUser");
    } else if (pageContext.getAttribute("_headerUser") != null) {
        _headerUser = (User) pageContext.getAttribute("_headerUser");
    } else {
        _headerUser = (User) session.getAttribute("currentUser");
    }
    boolean _headerIsAdmin = _headerUser != null && "admin".equalsIgnoreCase(_headerUser.getRole());
%>

<%-- Central flash messages (success / error) --%>
<%
    String _flashSuccess = (String) session.getAttribute("success");
    String _flashError = (String) session.getAttribute("error");
    if (_flashSuccess != null) {
        session.removeAttribute("success");
    }
    if (_flashError != null) {
        session.removeAttribute("error");
    }
    // Expose to EL via request attributes so <c:if> can read them
    request.setAttribute("_flashSuccess", _flashSuccess);
    request.setAttribute("_flashError", _flashError);
%>

<header class="site-header">
    <div class="nav-container reveal-lux">
        <!-- Logo premium avec hover subtil -->
        <div class="logo-wrapper">
            <a href="home" aria-label="Retour à l'accueil">
                <img src="images/elegance-logo.png" alt="Élégance Boutique" class="luxury-logo">
            </a>
        </div>

        <!-- Barre de recherche uniquement sur la page d'accueil -->
        <% if (request.getServletPath().equals("/home.jsp") || request.getServletPath().endsWith("/home")) { %>
            <div class="search-wrapper reveal-lux" style="animation-delay: 0.3s;">
                <span class="search-icon"><i class="fas fa-search"></i></span>
                <input type="text" id="searchInput" class="search-input" 
                       placeholder="Rechercher une pièce d'exception..." 
                       onkeyup="handleSearch()" aria-label="Recherche">
            </div>
        <% } %>

        <!-- Navigation harmonisée et responsive -->
        <nav class="nav-links">
            <% if (_headerUser != null) { %>
                <span class="welcome-msg">
                    <i class="fas fa-user-circle"></i>
                    <%= _headerUser.getUsername() %>
                    <% if (_headerIsAdmin) { %>
                        <span class="badge-admin pulse-breath">Admin</span>
                    <% } %>
                </span>

                <a href="home" class="nav-link"><i class="fas fa-home"></i> Accueil</a>
                <% if (!_headerIsAdmin) { %>
                    <a href="cart" class="nav-link"><i class="fas fa-shopping-bag"></i> Panier</a>
                <% } %>
                <% if (_headerIsAdmin) { %>
                    <a href="admin" class="nav-link"><i class="fas fa-user-shield"></i> Administration</a>
                    <a href="manageUsers" class="nav-link"><i class="fas fa-users-cog"></i> Utilisateurs</a>
                <% } %>
                <a href="logout" class="nav-link logout-link" style="color:#c62828;font-weight:600;">
                    <i class="fas fa-sign-out-alt"></i> Quitter
                </a>
            <% } else { %>
                <a href="login.jsp" class="nav-link"><i class="fas fa-sign-in-alt"></i> Connexion</a>
                <a href="register.jsp" class="nav-link btn-outline btn-small">S'inscrire</a>
            <% } %>
        </nav>
    </div>
</header>

<c:if test="${not empty _flashError}">
    <div style="background:#ffeaea;color:#c62828;padding:1.2rem 2rem;text-align:center;font-weight:600;border-radius:12px;margin:1rem auto 1.5rem;max-width:720px;box-shadow:0 2px 12px #c6282822;">
        <i class="fas fa-exclamation-triangle" style="margin-right:8px;"></i>${_flashError}
    </div>
</c:if>
<c:if test="${not empty _flashSuccess}">
    <div style="background:#eafbe7;color:#388e3c;padding:1.2rem 2rem;text-align:center;font-weight:600;border-radius:12px;margin:1rem auto 1.5rem;max-width:720px;box-shadow:0 2px 12px #388e3c22;">
        <i class="fas fa-check-circle" style="margin-right:8px;"></i>${_flashSuccess}
    </div>
</c:if>

<style>
    /* ── Header premium harmonisé Élégance ─────────────────────────────── */
    .site-header {
        position: sticky;
        top: 0;
        z-index: 1000;
        background: rgba(253, 250, 248, 0.94);
        backdrop-filter: blur(20px);
        -webkit-backdrop-filter: blur(20px);
        border-bottom: 1px solid rgba(212, 175, 55, 0.12);
        box-shadow: 0 4px 24px rgba(0,0,0,0.04);
    }

    .nav-container {
        max-width: 1520px;
        margin: 0 auto;
        padding: 1.2rem 2.5rem;
        display: flex;
        align-items: center;
        justify-content: space-between;
        gap: 2rem;
        flex-wrap: wrap;
    }

    .logo-wrapper img {
        height: 44px;
        transition: transform 0.5s var(--ease-dreamy);
    }

    .logo-wrapper img:hover {
        transform: scale(1.06);
    }

    /* Recherche élégante */
    .search-wrapper {
        position: relative;
        flex: 1;
        max-width: 420px;
        min-width: 240px;
    }

    .search-icon {
        position: absolute;
        left: 1.2rem;
        top: 50%;
        transform: translateY(-50%);
        color: var(--gold);
        font-size: 1.1rem;
    }

    .search-input {
        width: 100%;
        padding: 0.9rem 1.2rem 0.9rem 3.2rem;
        border: 1px solid rgba(212,175,55,0.25);
        border-radius: var(--radius-pill);
        background: rgba(253,250,248,0.6);
        font-size: 0.96rem;
        transition: var(--transition-smooth);
    }

    .search-input:focus {
        outline: none;
        border-color: var(--gold);
        box-shadow: 0 0 0 3px rgba(212,175,55,0.15);
    }

    /* Navigation liens premium */
    .nav-links {
        display: flex;
        align-items: center;
        gap: 2.2rem;
        flex-wrap: wrap;
    }

    .nav-link {
        color: var(--text-light);
        text-decoration: none;
        font-weight: 500;
        font-size: 0.98rem;
        display: flex;
        align-items: center;
        gap: 0.5rem;
        transition: var(--transition-smooth);
        position: relative;
    }

    .nav-link:hover,
    .nav-link:focus {
        color: var(--gold);
        transform: translateY(-2px);
    }

    .nav-link::after {
        content: '';
        position: absolute;
        bottom: -8px;
        left: 0;
        width: 0;
        height: 2px;
        background: var(--gold);
        transition: width 0.5s var(--ease-luxe-out);
    }

    .nav-link:hover::after {
        width: 100%;
    }

    /* Badge admin animé */
    .badge-admin {
        background: var(--gold);
        color: white;
        padding: 0.25rem 0.7rem;
        border-radius: var(--radius-pill);
        font-size: 0.76rem;
        font-weight: 700;
        margin-left: 0.6rem;
    }

    /* Bouton inscription non connecté */
    .btn-outline.btn-small {
        padding: 0.65rem 1.4rem;
        font-size: 0.92rem;
        border: 1.5px solid var(--gold);
        color: var(--gold);
    }

    .btn-outline.btn-small:hover {
        background: var(--gold);
        color: white;
    }

    /* Logout plus visible */
    .logout-link {
        color: var(--color-danger);
    }

    .logout-link:hover {
        color: #b33d3d;
    }

    /* Animations header */
    .reveal-lux {
        opacity: 0;
        animation: luxuryReveal 1.2s var(--ease-luxe-out) forwards;
    }
</style>