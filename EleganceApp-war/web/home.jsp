<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ page import="com.mycompany.eleganceapp.model.User" %>
        <%@ page import="com.mycompany.eleganceapp.model.Article" %>
            <%@ page import="com.mycompany.eleganceapp.model.Category" %>
                <%@ page import="java.util.List" %>
                    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
                        <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
                            <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
                                <% User currentUser=(User) request.getAttribute("currentUser"); if (currentUser==null) {
                                    currentUser=(User) session.getAttribute("currentUser"); } if (currentUser==null) {
                                    response.sendRedirect(request.getContextPath() + "/login" ); return; } boolean
                                    isAdmin="admin" .equalsIgnoreCase(currentUser.getRole()); Boolean
                                    isAdminAttr=(Boolean) request.getAttribute("isAdmin"); if (isAdminAttr !=null) {
                                    isAdmin=isAdminAttr; } %>
                                    <!DOCTYPE html>
                                    <html lang="fr">

                                    <head>
                                        <meta charset="UTF-8">
                                        <meta name="viewport" content="width=device-width, initial-scale=1.0">
                                        <meta name="description"
                                            content="Élégance - Collection haut de gamme Mode, Beauté, Parfums et Accessoires">
                                        <title>Élégance • Accueil</title>
                                        <link rel="preconnect" href="https://fonts.googleapis.com">
                                        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
                                        <link
                                            href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@400;500;600;700&family=Inter:wght@300;400;500;600;700&display=swap"
                                            rel="stylesheet">
                                        <link rel="stylesheet"
                                            href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">

                                        <style>
                                            :root {
                                                --bg-start: #fdf8f9;
                                                --bg-end: #fceef2;
                                                --gold: #d4af37;
                                                --gold-dark: #b8972e;
                                                --text: #3f2c22;
                                                --text-light: #5c4438;
                                                --radius: 16px;
                                                --shadow-card: 0 10px 32px rgba(212, 175, 55, 0.10);
                                                --shadow-hover: 0 22px 56px rgba(212, 175, 55, 0.26);
                                                --transition: all 0.38s cubic-bezier(0.25, 0.8, 0.25, 1);
                                            }

                                            body {
                                                font-family: 'Inter', system-ui, sans-serif;
                                                background: linear-gradient(165deg,
                                                        var(--bg-start) 0%,
                                                        var(--bg-end) 50%,
                                                        #f9e8ed 100%);
                                                color: var(--text);
                                                min-height: 100vh;
                                                line-height: 1.6;
                                                position: relative;
                                            }

                                            body::before {
                                                content: '';
                                                position: fixed;
                                                inset: 0;
                                                background: radial-gradient(circle at 30% 20%,
                                                        rgba(212, 175, 55, 0.04) 0%,
                                                        transparent 40%);
                                                pointer-events: none;
                                                z-index: -1;
                                            }

                                            main {
                                                padding: 0 1.8rem 8rem;
                                                max-width: 1520px;
                                                margin: 0 auto;
                                            }

                                            .promo-banner {
                                                margin: 2.5rem auto 3.5rem;
                                                max-width: 1320px;
                                                height: 320px;
                                                border-radius: var(--radius);
                                                background: linear-gradient(135deg, rgba(0, 0, 0, 0.42), rgba(0, 0, 0, 0.58)),
                                                    url('https://i.pinimg.com/1200x/9f/b1/18/9fb118d3d637cf3ac9bba3343ac52e69.jpg') center/cover;
                                                position: relative;
                                                overflow: hidden;
                                                display: flex;
                                                align-items: center;
                                                justify-content: center;
                                                color: white;
                                                text-align: center;
                                            }

                                            .promo-badge {
                                                background: var(--gold);
                                                color: white;
                                                padding: 0.6rem 1.8rem;
                                                border-radius: 9999px;
                                                font-weight: 700;
                                                font-size: 1.45rem;
                                                box-shadow: 0 5px 20px rgba(0, 0, 0, 0.3);
                                            }

                                            .promo-title {
                                                font-family: 'Playfair Display', serif;
                                                font-size: clamp(2.6rem, 7vw, 4rem);
                                                margin: 0.8rem 0 0.4rem;
                                                font-weight: 600;
                                                text-shadow: 0 4px 20px rgba(0, 0, 0, 0.55);
                                            }

                                            .promo-subtitle {
                                                font-size: 1.22rem;
                                                opacity: 0.96;
                                            }

                                            .admin-controls {
                                                text-align: center;
                                                margin: 2rem 0 3rem;
                                            }

                                            .btn-primary {
                                                background: var(--gold);
                                                color: white;
                                                padding: 1rem 2.6rem;
                                                border-radius: 9999px;
                                                font-weight: 600;
                                                font-size: 1rem;
                                                box-shadow: 0 8px 24px rgba(212, 175, 55, 0.28);
                                                transition: var(--transition);
                                                text-decoration: none;
                                                display: inline-block;
                                            }

                                            .btn-primary:hover {
                                                transform: translateY(-4px);
                                                box-shadow: 0 16px 40px rgba(212, 175, 55, 0.4);
                                            }

                                            .category-filter {
                                                display: flex;
                                                flex-wrap: wrap;
                                                justify-content: center;
                                                gap: 1.3rem;
                                                margin: 2.2rem 0 4rem;
                                            }

                                            .category-filter button {
                                                padding: 0.85rem 2.2rem;
                                                border: 1px solid rgba(212, 175, 55, 0.3);
                                                border-radius: 9999px;
                                                background: white;
                                                color: var(--text-light);
                                                font-weight: 500;
                                                cursor: pointer;
                                                transition: var(--transition);
                                            }

                                            .category-filter button:hover {
                                                background: rgba(212, 175, 55, 0.1);
                                                border-color: var(--gold);
                                            }

                                            .category-filter button.active {
                                                background: var(--gold);
                                                color: white;
                                                border-color: var(--gold);
                                                box-shadow: 0 8px 24px rgba(212, 175, 55, 0.32);
                                            }

                                            .articles-grid {
                                                display: grid;
                                                grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
                                                gap: 2rem;
                                            }

                                            .article-card {
                                                background: white;
                                                border-radius: 12px;
                                                overflow: hidden;
                                                box-shadow: 0 6px 20px rgba(212, 175, 55, 0.08);
                                                transition: all 0.3s ease;
                                                opacity: 0;
                                                position: relative;
                                                transform: translateY(20px);
                                                animation: fadeInUp 0.6s cubic-bezier(0.25, 0.46, 0.45, 0.94) forwards;
                                            }

                                            @keyframes fadeInUp {
                                                to {
                                                    opacity: 1;
                                                    transform: translateY(0);
                                                }
                                            }

                                            .article-card:hover {
                                                transform: translateY(-8px);
                                                box-shadow: 0 12px 32px rgba(212, 175, 55, 0.18);
                                            }


                                            .article-card img {
                                                width: 100%;
                                                aspect-ratio: 1/1.1;
                                                object-fit: cover;
                                                transition: transform 0.5s ease;
                                            }

                                            .article-card:hover img {
                                                transform: scale(1.05);
                                            }

                                            .article-info {
                                                padding: 0.8rem;
                                                text-align: center;
                                                display: flex;
                                                flex-direction: column;
                                                justify-content: space-between;
                                                min-height: 140px;
                                            }

                                            .category-label {
                                                font-size: 0.68rem;
                                                font-weight: 600;
                                                letter-spacing: 1.1px;
                                                color: var(--gold);
                                                text-transform: uppercase;
                                                margin-bottom: 0.3rem;
                                            }

                                            .article-info h3 {
                                                font-family: 'Playfair Display', serif;
                                                font-size: 1.1rem;
                                                margin-bottom: 0.5rem;
                                                font-weight: 600;
                                                line-height: 1.1;
                                                flex: 1;
                                                display: flex;
                                                align-items: center;
                                                justify-content: center;
                                            }

                                            .price {
                                                font-size: 1.1rem;
                                                font-weight: 700;
                                                color: var(--gold-dark);
                                                margin: 0.6rem 0 1rem;
                                            }

                                            .card-actions {
                                                display: flex;
                                                gap: 0.8rem;
                                                justify-content: center;
                                                align-items: center;
                                                margin-top: auto;
                                            }

                                            .btn-secondary,
                                            .btn-primary-card {
                                                padding: 0.8rem 1.5rem;
                                                border-radius: 20px;
                                                font-weight: 600;
                                                font-size: 0.9rem;
                                                min-width: 110px;
                                                transition: all 0.3s ease;
                                                cursor: pointer;
                                                border: none;
                                                white-space: nowrap;
                                            }

                                            .btn-secondary {
                                                background: transparent;
                                                border: 1.8px solid var(--gold);
                                                color: var(--gold);
                                                text-decoration: none;
                                                display: inline-block;
                                            }

                                            .btn-secondary:hover {
                                                background: var(--gold);
                                                color: white;
                                            }

                                            .btn-primary-card {
                                                background: var(--gold);
                                                color: white;
                                            }

                                            .btn-primary-card:hover {
                                                background: var(--gold-dark);
                                                transform: translateY(-3px);
                                            }

                                            .admin-actions {
                                                margin-top: 1.5rem;
                                                display: flex;
                                                gap: 1.1rem;
                                                justify-content: center;
                                                flex-wrap: wrap;
                                            }

                                            .btn-admin {
                                                padding: 0.65rem 1.4rem;
                                                border-radius: 12px;
                                                font-size: 0.9rem;
                                                min-width: 110px;
                                                text-decoration: none;
                                                display: inline-block;
                                            }

                                            .btn-edit {
                                                background: var(--gold-light);
                                                color: var(--text);
                                            }

                                            .btn-delete {
                                                background: #ffebee;
                                                color: #c62828;
                                            }

                                            .no-articles {
                                                grid-column: 1 / -1;
                                                text-align: center;
                                                padding: 80px 20px;
                                                color: var(--color-text-lighter);
                                                font-family: 'Playfair Display', serif;
                                                font-size: 2rem;
                                                display: flex;
                                                flex-direction: column;
                                                align-items: center;
                                                justify-content: center;
                                                min-height: 400px;
                                            }

                                            .no-articles-icon {
                                                font-size: 4rem;
                                                color: var(--color-gold);
                                                margin-bottom: 2rem;
                                                opacity: 0.7;
                                            }

                                            .no-articles-title {
                                                font-size: 2.5rem;
                                                margin: 0 0 1rem 0;
                                                font-weight: 700;
                                                color: var(--color-text);
                                            }

                                            .no-articles-text {
                                                font-size: 1.1rem;
                                                margin: 0 0 2rem 0;
                                                max-width: 400px;
                                                line-height: 1.6;
                                                color: var(--color-text-light);
                                            }

                                            .no-articles .btn-primary {
                                                margin-top: 1rem;
                                            }

                                            .bottom-nav {
                                                position: fixed;
                                                bottom: 0;
                                                left: 0;
                                                right: 0;
                                                height: 76px;
                                                background: rgba(253, 250, 248, 0.97);
                                                backdrop-filter: blur(20px);
                                                border-top: 1px solid rgba(212, 175, 55, 0.14);
                                                display: none;
                                                z-index: 999;
                                            }

                                            .bottom-nav ul {
                                                display: flex;
                                                height: 100%;
                                                list-style: none;
                                            }

                                            .bottom-nav li {
                                                flex: 1;
                                                display: flex;
                                                align-items: center;
                                                justify-content: center;
                                            }

                                            .bottom-nav a {
                                                color: var(--text-light);
                                                font-size: 1.8rem;
                                                transition: var(--transition);
                                            }

                                            .bottom-nav a:hover,
                                            .bottom-nav a.active {
                                                color: var(--gold);
                                                transform: scale(1.15);
                                            }

                                            @media (max-width: 992px) {
                                                .bottom-nav {
                                                    display: flex;
                                                }

                                                main {
                                                    padding-bottom: 8rem;
                                                }
                                            }

                                            @media (max-width: 480px) {
                                                .promo-banner {
                                                    height: 260px;
                                                }

                                                .promo-title {
                                                    font-size: 2.4rem;
                                                }

                                                .articles-grid {
                                                    gap: 2.2rem;
                                                }
                                            }
                                        </style>
                                    </head>

                                    <body>
                                        <%@ include file="header.jsp" %>

                                            <!-- Bannière promo cachée pour les admins -->
                                            <c:if test="${!isAdmin}">
                                                <div class="promo-banner">
                                                    <div class="promo-content">
                                                        <div class="promo-badge">-40%</div>
                                                        <h2 class="promo-title">Collection Signature</h2>
                                                        <p class="promo-subtitle">Pièces rares à prix exceptionnel –
                                                            Offre limitée</p>
                                                    </div>
                                                </div>
                                            </c:if>

                                            <main>
                                                <c:if test="${isAdmin}">
                                                    <div class="admin-controls">
                                                        <a href="${pageContext.request.contextPath}/admin?action=add_form"
                                                            class="btn-primary">
                                                            + Nouvel article
                                                        </a>
                                                    </div>
                                                </c:if>

                                                <div class="category-filter">
                                                    <button class="active" data-category="all">Tous</button>
                                                    <c:forEach var="cat" items="${categories}">
                                                        <button data-category="${fn:toLowerCase(cat.name)}">
                                                            <c:out value="${cat.name}" />
                                                        </button>
                                                    </c:forEach>
                                                </div>

                                                <div class="articles-grid" id="articlesGrid">
                                                    <c:choose>
                                                        <c:when test="${not empty articles}">
                                                            <c:forEach var="article" items="${articles}">
                                                                <c:set var="catName"
                                                                    value="${article.category != null ? fn:toLowerCase(article.category.name) : 'autres'}" />
                                                                <c:set var="safeName"
                                                                    value="${fn:escapeXml(article.name)}" />
                                                                <c:set var="imgUrl"
                                                                    value="${not empty article.imageUrl ? fn:escapeXml(article.imageUrl) : pageContext.request.contextPath.concat('/images/default-product.jpg')}" />

                                                                <article class="article-card"
                                                                    data-category="${catName}">
                                                                    <c:set var="isFav" value="false" />
                                                                    <c:if test="${not empty userFavorites}">
                                                                        <c:forEach var="fav" items="${userFavorites}">
                                                                            <c:if test="${fav.id == article.id}">
                                                                                <c:set var="isFav" value="true" />
                                                                            </c:if>
                                                                        </c:forEach>
                                                                    </c:if>

                                                                    <button class="favorite-btn"
                                                                        data-article-id="${article.id}"
                                                                        onclick="toggleFavorite(this)"
                                                                        aria-label="Favoris">
                                                                        <i
                                                                            class="${isFav ? 'fas favorite-active' : 'far'} fa-heart"></i>
                                                                    </button>

                                                                    <img src="${imgUrl}" alt="${safeName}"
                                                                        loading="lazy"
                                                                        onerror="this.src='${pageContext.request.contextPath}/images/default-product.jpg'">
                                                                    <div class="article-info">
                                                                        <div class="category-label">
                                                                            <c:out value="${catName}" />
                                                                        </div>
                                                                        <h3>
                                                                            <c:out value="${safeName}" />
                                                                        </h3>
                                                                        <div class="price">
                                                                            <fmt:formatNumber value="${article.price}"
                                                                                type="number" groupingUsed="true"
                                                                                maxFractionDigits="0" /> CFA
                                                                        </div>
                                                                        <div class="card-actions">
                                                                            <a href="${pageContext.request.contextPath}/article?id=${article.id}"
                                                                                class="btn-secondary">
                                                                                <i class="fas fa-eye"></i> Détails
                                                                            </a>

                                                                            <c:if test="${!isAdmin}">
                                                                                <button
                                                                                    onclick="addToCart(${article.id})"
                                                                                    class="btn-primary-card">
                                                                                    <i class="fas fa-shopping-bag"></i>
                                                                                </button>
                                                                            </c:if>
                                                                        </div>

                                                                        <c:if test="${isAdmin}">
                                                                            <div class="admin-actions">
                                                                                <a href="${pageContext.request.contextPath}/admin?action=edit&id=${article.id}"
                                                                                    class="btn-admin btn-edit">Modifier</a>
                                                                                <form
                                                                                    action="${pageContext.request.contextPath}/admin"
                                                                                    method="post"
                                                                                    style="display:inline;"
                                                                                    onsubmit="return confirm('Vraiment supprimer ${fn:escapeXml(article.name)} ?');">
                                                                                    <input type="hidden" name="action"
                                                                                        value="delete">
                                                                                    <input type="hidden" name="id"
                                                                                        value="${article.id}">
                                                                                    <button type="submit"
                                                                                        class="btn-admin btn-delete">Supprimer</button>
                                                                                </form>
                                                                            </div>
                                                                        </c:if>
                                                                    </div>
                                                                </article>
                                                            </c:forEach>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <div class="no-articles">
                                                                <div class="no-articles-icon">
                                                                    <i class="fas fa-gem"></i>
                                                                </div>
                                                                <h2 class="no-articles-title">Aucun article disponible
                                                                </h2>
                                                                <p class="no-articles-text">Notre collection est en
                                                                    cours de préparation. Revenez bientôt pour découvrir
                                                                    nos nouvelles pièces exclusives.</p>
                                                                <a href="${pageContext.request.contextPath}/home"
                                                                    class="btn-primary">
                                                                    <i class="fas fa-home"></i> Retour à l'accueil
                                                                </a>
                                                            </div>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>
                                            </main>

                                            <nav class="bottom-nav" aria-label="Navigation mobile">
                                                <ul>
                                                    <li><a href="${pageContext.request.contextPath}/home"
                                                            class="active"><i class="fas fa-home"></i></a></li>
                                                    <c:if test="${!isAdmin}">
                                                        <li><a href="${pageContext.request.contextPath}/cart"><i
                                                                    class="fas fa-shopping-bag"></i></a></li>
                                                    </c:if>
                                                    <li><a href="${pageContext.request.contextPath}/articles"><i
                                                                class="fas fa-gem"></i></a></li>
                                                    <c:if test="${isAdmin}">
                                                        <li><a
                                                                href="${pageContext.request.contextPath}/admin?action=orders"><i
                                                                    class="fas fa-receipt"></i></a></li>
                                                        <li><a
                                                                href="${pageContext.request.contextPath}/admin?action=users"><i
                                                                    class="fas fa-users-cog"></i></a></li>
                                                    </c:if>
                                                    <li><a href="${pageContext.request.contextPath}/logout"><i
                                                                class="fas fa-sign-out-alt"></i></a></li>
                                                </ul>
                                            </nav>

                                            <script>
                                                function normalizeCategory(str) {
                                                    if (!str) return 'autres';
                                                    return str.toLowerCase().normalize('NFD').replace(/[\u0300-\u036f]/g, '').replace(/\s+/g, '').replace(/[^a-z0-9]/g, '');
                                                }

                                                document.addEventListener('DOMContentLoaded', () => {
                                                    const filterButtons = document.querySelectorAll('.category-filter button');
                                                    const articleCards = document.querySelectorAll('.article-card');

                                                    filterButtons.forEach(btn => {
                                                        btn.dataset.category = normalizeCategory(btn.dataset.category);
                                                    });

                                                    articleCards.forEach(card => {
                                                        card.dataset.category = normalizeCategory(card.dataset.category);
                                                    });

                                                    function applyFilter(category) {
                                                        filterButtons.forEach(btn => {
                                                            btn.classList.toggle('active', btn.dataset.category === category);
                                                        });
                                                        articleCards.forEach(card => {
                                                            const cardCat = card.dataset.category || 'autres';
                                                            card.style.display = (category === 'all' || cardCat === category) ? '' : 'none';
                                                        });
                                                    }

                                                    filterButtons.forEach(btn => {
                                                        btn.addEventListener('click', () => applyFilter(btn.dataset.category));
                                                    });

                                                    applyFilter('all');
                                                });
                                            </script>
                                            <%@ include file="footer.jsp" %>
                                    </body>

                                    </html>