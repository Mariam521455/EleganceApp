<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ page import="com.mycompany.eleganceapp.model.User" %>
        <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
            <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

                <% // Récupération sécurisée de l'utilisateur (priorité request> session)
                    User headerUser = (User) request.getAttribute("currentUser");
                    if (headerUser == null) {
                    headerUser = (User) session.getAttribute("currentUser");
                    }

                    // Vérification si admin
                    boolean headerIsAdmin = headerUser != null && "admin".equalsIgnoreCase(headerUser.getRole());

                    // Flash messages (consommés immédiatement)
                    String flashSuccess = (String) session.getAttribute("success");
                    String flashError = (String) session.getAttribute("error");
                    String flashInfo = (String) session.getAttribute("info");
                    if (flashSuccess != null) session.removeAttribute("success");
                    if (flashError != null) session.removeAttribute("error");
                    if (flashInfo != null) session.removeAttribute("info");

                    // Exposition aux EL
                    request.setAttribute("flashSuccess", flashSuccess);
                    request.setAttribute("flashError", flashError);
                    request.setAttribute("flashInfo", flashInfo);
                    request.setAttribute("currentUser", headerUser);
                    request.setAttribute("isAdmin", headerIsAdmin);
                    %>

                    <header class="site-header">
                        <div class="nav-container reveal-lux">
                            <!-- Logo premium -->
                            <div class="logo-wrapper">
                                <a href="${pageContext.request.contextPath}/home" aria-label="Retour à l'accueil">
                                    <img src="${pageContext.request.contextPath}/images/elegance-logo.png"
                                        alt="Élégance Boutique" class="luxury-logo"
                                        onerror="this.src='https://via.placeholder.com/180x44/d4af37/ffffff?text=Élégance'">
                                </a>
                            </div>

                            <!-- Barre de recherche uniquement sur home -->
                            <c:if
                                test="${pageContext.request.servletPath eq '/home.jsp' or fn:endsWith(pageContext.request.servletPath, '/home')}">
                                <div class="search-wrapper reveal-lux" style="animation-delay: 0.3s;">
                                    <span class="search-icon"><i class="fas fa-search"></i></span>
                                    <input type="search" id="searchInput" class="search-input"
                                        placeholder="Rechercher une pièce d'exception..." autocomplete="off"
                                        aria-label="Recherche">
                                </div>
                            </c:if>

                            <!-- Navigation premium responsive -->
                            <nav class="nav-links">
                                <c:choose>
                                    <c:when test="${currentUser != null}">
                                        <span class="welcome-msg">
                                            <i class="fas fa-user-circle"></i>
                                            <c:out value="${currentUser.username}" />
                                            <c:if test="${isAdmin}">
                                                <span class="badge-admin pulse-breath">Admin</span>
                                            </c:if>
                                        </span>

                                        <a href="${pageContext.request.contextPath}/home" class="nav-link">
                                            <i class="fas fa-home"></i> Accueil
                                        </a>

                                        <c:if test="${!isAdmin}">
                                            <a href="${pageContext.request.contextPath}/cart" class="nav-link">
                                                <i class="fas fa-shopping-bag" id="cart-icon"></i> Panier
                                            </a>
                                        </c:if>

                                        <c:if test="${isAdmin}">
                                            <a href="${pageContext.request.contextPath}/admin?action=orders"
                                                class="nav-link admin-link">
                                                <i class="fas fa-receipt"></i> Commandes
                                            </a>
                                            <a href="${pageContext.request.contextPath}/Dashboard"
                                                class="nav-link admin-link">
                                                <i class="fas fa-chart-line"></i> Tableau de bord
                                            </a>
                                            <a href="${pageContext.request.contextPath}/admin?action=users"
                                                class="nav-link admin-link">
                                                <i class="fas fa-users-cog"></i> Utilisateurs
                                            </a>
                                        </c:if>

                                        <a href="${pageContext.request.contextPath}/logout"
                                            class="nav-link logout-link">
                                            <i class="fas fa-sign-out-alt"></i> Quitter
                                        </a>
                                    </c:when>

                                    <c:otherwise>
                                        <a href="${pageContext.request.contextPath}/login" class="nav-link">
                                            <i class="fas fa-sign-in-alt"></i> Connexion
                                        </a>
                                        <a href="${pageContext.request.contextPath}/register.jsp"
                                            class="premium-btn secondary btn-small">
                                            S'inscrire
                                        </a>
                                    </c:otherwise>
                                </c:choose>
                            </nav>
                        </div>
                    </header>

                    <!-- Flash messages premium -->
                    <c:if test="${not empty flashError}">
                        <div class="flash-message error reveal-lux">
                            <i class="fas fa-exclamation-circle"></i>
                            <c:out value="${flashError}" />
                        </div>
                    </c:if>
                    <c:if test="${not empty flashSuccess}">
                        <div class="flash-message success reveal-lux">
                            <i class="fas fa-check-circle"></i>
                            <c:out value="${flashSuccess}" />
                        </div>
                    </c:if>
                    <c:if test="${not empty flashInfo}">
                        <div class="flash-message info reveal-lux">
                            <i class="fas fa-info-circle"></i>
                            <c:out value="${flashInfo}" />
                        </div>
                    </c:if>

                    <script>
                        // Variable globale pour le chemin de l'application (utilisée par elegance.js)
                        const CONTEXT_PATH = '${pageContext.request.contextPath}';
                    </script>

                    <style>
                        /* ── Variables globales ─────────────────────────────── */
                        :root {
                            --color-gold: #d4af37;
                            --color-text-light: #6b5a54;
                            --color-border: #e3d7c9;
                            --color-success: #3d9c5f;
                            --color-danger: #c62828;
                            --color-info: #2196f3;
                            --radius-pill: 9999px;
                            --shadow-md: 0 10px 30px rgba(0, 0, 0, 0.08);
                            --ease-luxe-out: cubic-bezier(0.25, 0.8, 0.25, 1);
                            --ease-dreamy: cubic-bezier(0.55, 0, 0.1, 1);
                        }

                        /* Animations micro-interactions */
                        @keyframes cart-pulse {
                            0% {
                                transform: scale(1);
                            }

                            50% {
                                transform: scale(1.4);
                            }

                            100% {
                                transform: scale(1);
                            }
                        }

                        .cart-pulse {
                            animation: cart-pulse 0.4s var(--ease-luxe-out);
                            color: var(--color-gold) !important;
                        }

                        /* Favoris */
                        .favorite-btn {
                            position: absolute;
                            top: 15px;
                            right: 15px;
                            background: rgba(255, 255, 255, 0.85);
                            backdrop-filter: blur(8px);
                            border: none;
                            width: 40px;
                            height: 40px;
                            border-radius: 50%;
                            display: flex;
                            align-items: center;
                            justify-content: center;
                            color: #6b5a54;
                            cursor: pointer;
                            transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
                            z-index: 10;
                            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
                        }

                        .favorite-btn:hover {
                            background: white;
                            transform: scale(1.15);
                        }

                        .favorite-btn i.favorite-active {
                            color: #e74c3c !important;
                        }

                        .favorite-btn i {
                            font-size: 1.1rem;
                            transition: color 0.3s ease;
                        }

                        /* ── Header premium Élégance ───────────────────────────── */
                        .site-header {
                            position: sticky;
                            top: 0;
                            z-index: 1000;
                            background: rgba(253, 250, 248, 0.94);
                            backdrop-filter: blur(20px);
                            -webkit-backdrop-filter: blur(20px);
                            border-bottom: 1px solid var(--color-border);
                            box-shadow: var(--shadow-md);
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

                        .luxury-logo {
                            height: 44px;
                            transition: transform 0.5s var(--ease-dreamy);

                        }

                        .luxury-logo:hover {
                            transform: scale(1.06);
                        }

                        /* Recherche */
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
                            color: var(--color-gold);
                            font-size: 1.1rem;
                        }

                        .search-input {
                            width: 100%;
                            padding: 0.9rem 1.2rem 0.9rem 3.2rem;
                            border: 1px solid var(--color-border);
                            border-radius: var(--radius-pill);
                            background: rgba(253, 250, 248, 0.6);
                            font-size: 0.96rem;
                            transition: all 0.35s var(--ease-luxe-out);
                        }

                        .search-input:focus {
                            outline: none;
                            border-color: var(--color-gold);
                            box-shadow: 0 0 0 3px rgba(212, 175, 55, 0.15);
                            background: white;
                        }

                        /* Navigation */
                        .nav-links {
                            display: flex;
                            align-items: center;
                            gap: 2.2rem;
                            flex-wrap: wrap;
                        }

                        .nav-link {
                            color: var(--color-text-light);
                            text-decoration: none;
                            font-weight: 500;
                            font-size: 0.98rem;
                            display: flex;
                            align-items: center;
                            gap: 0.5rem;
                            transition: all 0.35s var(--ease-luxe-out);
                            position: relative;
                        }

                        .nav-link:hover,
                        .nav-link:focus {
                            color: var(--color-gold);
                            transform: translateY(-2px);
                        }

                        .nav-link::after {
                            content: '';
                            position: absolute;
                            bottom: -8px;
                            left: 0;
                            width: 0;
                            height: 2px;
                            background: var(--color-gold);
                            transition: width 0.5s var(--ease-luxe-out);
                        }

                        .nav-link:hover::after {
                            width: 100%;
                        }

                        .admin-link {
                            color: var(--color-gold);
                            font-weight: 600;
                        }

                        /* Badge admin animé */
                        .badge-admin {
                            background: var(--color-gold);
                            color: white;
                            padding: 0.25rem 0.7rem;
                            border-radius: var(--radius-pill);
                            font-size: 0.76rem;
                            font-weight: 700;
                            margin-left: 0.6rem;
                            animation: pulse-breath 3s infinite ease-in-out;
                        }

                        @keyframes pulse-breath {

                            0%,
                            100% {
                                transform: scale(1);
                                opacity: 1;
                            }

                            50% {
                                transform: scale(1.05);
                                opacity: 0.8;
                            }
                        }

                        /* Bouton premium */
                        .premium-btn.secondary.btn-small {
                            padding: 0.65rem 1.4rem;
                            font-size: 0.92rem;
                            border: 1.5px solid var(--color-gold);
                            color: var(--color-gold);
                            border-radius: var(--radius-pill);
                            transition: all 0.35s var(--ease-luxe-out);
                        }

                        .premium-btn.secondary.btn-small:hover {
                            background: var(--color-gold);
                            color: white;
                            transform: translateY(-2px);
                        }

                        /* Logout */
                        .logout-link {
                            color: var(--color-danger);
                            font-weight: 600;
                        }

                        .logout-link:hover {
                            color: #b33d3d;
                        }

                        /* Flash messages */
                        .flash-message {
                            max-width: 720px;
                            margin: 1.2rem auto;
                            padding: 1.2rem 2rem;
                            border-radius: 12px;
                            text-align: center;
                            font-weight: 600;
                            box-shadow: var(--shadow-md);
                            backdrop-filter: blur(12px);
                            animation: luxuryReveal 1.2s var(--ease-luxe-out) forwards;
                        }

                        .flash-message.error {
                            background: rgba(201, 75, 75, 0.12);
                            color: var(--color-danger);
                        }

                        .flash-message.success {
                            background: rgba(61, 156, 95, 0.12);
                            color: var(--color-success);
                        }

                        @keyframes luxuryReveal {
                            from {
                                opacity: 0;
                                transform: translateY(-20px);
                            }

                            to {
                                opacity: 1;
                                transform: translateY(0);
                            }
                        }
                    </style>