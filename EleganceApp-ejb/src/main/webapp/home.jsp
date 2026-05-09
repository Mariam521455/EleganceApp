<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.mycompany.eleganceapp.model.User" %>
<%@ page import="com.mycompany.eleganceapp.model.Article" %>
<%@ page import="com.mycompany.eleganceapp.model.Category" %>
<%@ page import="java.util.List" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%
    // Prefer request attributes set by servlets, fallback to session
    User currentUser = (User) request.getAttribute("currentUser");
    if (currentUser == null) {
        currentUser = (User) session.getAttribute("currentUser");
    }
    if (currentUser == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    Boolean isAdminAttr = (Boolean) request.getAttribute("isAdmin");
    boolean isAdmin = isAdminAttr != null ? isAdminAttr : "admin".equalsIgnoreCase(currentUser.getRole());
    List<Article> articles = (List<Article>) request.getAttribute("articles");
    List<Category> categories = (List<Category>) request.getAttribute("categories");
%>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="Élégance - Collection haut de gamme Mode, Beauté, Parfums et Accessoires">
    <title>Élégance • Accueil</title>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@400;500;600;700&family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css" integrity="sha512-SnH5WK+bZxgPHs44uWIX+LLJAJ9/2PkPKZ5QiAj6Ta86w+fsb2TkcmfRyVX3pBnMFcV7oQPJkl9QevSCWr3W6A==" crossorigin="anonymous" referrerpolicy="no-referrer" />

    <style>
        :root {
            --bg:           #fdfaf8;
            --blush:        #fce9e6;
            --rose-nude:    #f5e0db;
            --gold:         #d4af37;
            --gold-dark:    #b38c3a;
            --gold-light:   #e8d4a0;
            --text:         #2f1e18;
            --text-light:   #6b5a54;
            --text-lighter: #9a8882;
            --radius:       16px;
            --radius-pill:  9999px;
            --shadow-card:  0 10px 32px rgba(212,175,55,0.10);
            --shadow-hover: 0 22px 56px rgba(212,175,55,0.26);
            --transition:   all 0.38s cubic-bezier(0.25,0.8,0.25,1);
        }

        *, *::before, *::after { box-sizing: border-box; margin:0; padding:0; }

        body {
            font-family: 'Inter', system-ui, sans-serif;
            background: var(--bg);
            color: var(--text);
            min-height: 100vh;
            line-height: 1.6;
        }

        header {
            position: sticky;
            top: 0;
            z-index: 1000;
            background: rgba(253,250,248,0.94);
            backdrop-filter: blur(20px);
            border-bottom: 1px solid rgba(212,175,55,0.12);
            box-shadow: 0 4px 24px rgba(0,0,0,0.04);
        }

        .nav-top {
            max-width: 1520px;
            margin: 0 auto;
            padding: 1.2rem 2.5rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .logo-wrapper img {
            height: 42px;
            transition: transform 0.5s ease;
        }

        .logo-wrapper img:hover {
            transform: scale(1.05);
        }

        .nav-top-links {
            display: flex;
            gap: 2.6rem;
        }

        .nav-top-links a {
            color: var(--text-light);
            text-decoration: none;
            font-weight: 500;
            font-size: 0.98rem;
            transition: var(--transition);
        }

        .nav-top-links a:hover,
        .nav-top-links a:focus {
            color: var(--gold);
        }

        /* Promo Banner Premium */
        .promo-banner {
            margin: 2.5rem auto 3.5rem;
            max-width: 1320px;
            height: 320px;
            border-radius: var(--radius);
            background: linear-gradient(135deg, rgba(0,0,0,0.42), rgba(0,0,0,0.58)),
                        url('https://images.unsplash.com/photo-1615397349754-cfa2066a298e?auto=format&fit=crop&q=90&w=2560') center/cover;
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
            border-radius: var(--radius-pill);
            font-weight: 700;
            font-size: 1.45rem;
            box-shadow: 0 5px 20px rgba(0,0,0,0.3);
        }

        .promo-title {
            font-family: 'Playfair Display', serif;
            font-size: clamp(2.6rem, 7vw, 4rem);
            margin: 0.8rem 0 0.4rem;
            font-weight: 600;
            text-shadow: 0 4px 20px rgba(0,0,0,0.55);
        }

        .promo-subtitle {
            font-size: 1.22rem;
            opacity: 0.96;
        }

        main {
            padding: 0 1.8rem 8rem;
            max-width: 1520px;
            margin: 0 auto;
        }

        .admin-controls {
            text-align: center;
            margin: 2rem 0 3rem;
        }

        .btn-primary {
            background: var(--gold);
            color: white;
            padding: 1rem 2.6rem;
            border-radius: var(--radius-pill);
            font-weight: 600;
            font-size: 1rem;
            box-shadow: 0 8px 24px rgba(212,175,55,0.28);
            transition: var(--transition);
        }

        .btn-primary:hover {
            transform: translateY(-4px);
            box-shadow: 0 16px 40px rgba(212,175,55,0.4);
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
            border: 1px solid rgba(212,175,55,0.3);
            border-radius: var(--radius-pill);
            background: white;
            color: var(--text-light);
            font-weight: 500;
            cursor: pointer;
            transition: var(--transition);
        }

        .category-filter button:hover {
            background: rgba(212,175,55,0.1);
            border-color: var(--gold);
        }

        .category-filter button.active {
            background: var(--gold);
            color: white;
            border-color: var(--gold);
            box-shadow: 0 8px 24px rgba(212,175,55,0.32);
        }

        .articles-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 2.6rem;
        }

        .article-card {
            background: white;
            border-radius: var(--radius);
            overflow: hidden;
            box-shadow: var(--shadow-card);
            transition: var(--transition);
            opacity: 0;
            transform: translateY(30px);
            animation: fadeInUp 0.8s cubic-bezier(0.25,0.46,0.45,0.94) forwards;
        }

        @keyframes fadeInUp {
            to { opacity: 1; transform: translateY(0); }
        }

        .article-card:hover {
            transform: translateY(-14px);
            box-shadow: var(--shadow-hover);
        }

        .article-card img {
            width: 100%;
            aspect-ratio: 3/4;
            object-fit: cover;
            transition: transform 0.65s ease;
        }

        .article-card:hover img {
            transform: scale(1.09);
        }

        .article-info {
            padding: 1.6rem;
            text-align: center;
        }

        .category-label {
            font-size: 0.78rem;
            font-weight: 600;
            letter-spacing: 1.3px;
            color: var(--gold);
            text-transform: uppercase;
            margin-bottom: 0.8rem;
        }

        .article-info h3 {
            font-family: 'Playfair Display', serif;
            font-size: 1.55rem;
            margin-bottom: 0.8rem;
        }

        .price {
            font-size: 1.48rem;
            font-weight: 700;
            color: var(--gold-dark);
            margin: 1rem 0 1.5rem;
        }

        .card-actions {
            display: flex;
            gap: 1.1rem;
            justify-content: center;
            flex-wrap: wrap;
        }

        .btn-secondary,
        .btn-primary-card {
            padding: 0.88rem 2rem;
            border-radius: var(--radius-pill);
            font-weight: 550;
            font-size: 0.97rem;
            min-width: 150px;
            transition: var(--transition);
        }

        .btn-secondary {
            background: transparent;
            border: 1.8px solid var(--gold);
            color: var(--gold);
        }

        .btn-secondary:hover {
            background: var(--gold);
            color: white;
        }

        .btn-primary-card {
            background: var(--gold);
            color: white;
            border: none;
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
        }

        .btn-edit   { background: var(--gold-light); color: var(--text); }
        .btn-delete { background: #ffebee; color: #c62828; }

        .no-articles {
            grid-column: 1 / -1;
            text-align: center;
            padding: 10rem 1rem;
            color: var(--text-lighter);
            font-family: 'Playfair Display', serif;
            font-size: 2rem;
        }

        /* Bottom Nav Mobile */
        .bottom-nav {
            position: fixed;
            bottom: 0;
            left: 0; right: 0;
            height: 76px;
            background: rgba(253,250,248,0.97);
            backdrop-filter: blur(20px);
            border-top: 1px solid rgba(212,175,55,0.14);
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
            .bottom-nav { display: flex; }
            .nav-top-links { display: none; }
            main { padding-bottom: 8rem; }
        }

        @media (max-width: 480px) {
            .promo-banner { height: 260px; }
            .promo-title { font-size: 2.4rem; }
            .articles-grid { gap: 2rem; }
        }
    </style>
</head>
<body>
    <%@ include file="header.jsp" %>
<%-- Flash messages are now rendered centrally in header.jsp --%>

<header>
    <div class="nav-top">
        <div class="logo-wrapper">
            <img src="images/elegance-logo.png" alt="Élégance Boutique">
        </div>

        <div class="nav-top-links">
            <a href="home">Accueil</a>
            <c:if test="${!isAdmin}">
                <a href="cart">Panier</a>
            </c:if>
            <a href="articles">Articles</a>
            <c:if test="${isAdmin}">
                <a href="admin">Administration</a>
                <a href="admin?action=users">Utilisateurs</a>
            </c:if>
            <a href="logout">Quitter</a>
        </div>
    </div>
</header>

<div class="promo-banner">
    <div class="promo-content">
        <div class="promo-badge">-40%</div>
        <h2 class="promo-title">Collection Signature</h2>
        <p class="promo-subtitle">Pièces rares à prix exceptionnel – Offre limitée</p>
    </div>
</div>

<main>
    <c:if test="${isAdmin}">
        <div class="admin-controls">
            <a href="admin?action=add_form" class="btn-primary">+ Nouvel article</a>
        </div>
    </c:if>

    <div class="category-filter">
        <button class="active" data-category="all">Tous</button>
        <c:forEach var="cat" items="${categories}">
            <button data-category="${fn:toLowerCase(cat.name)}">${cat.name}</button>
        </c:forEach>
    </div>

    <div class="articles-grid" id="articlesGrid">
        <c:choose>
            <c:when test="${not empty articles}">
                <c:forEach var="article" items="${articles}">
                    <c:set var="catName" value="${article.category != null ? fn:toLowerCase(article.category.name) : 'autres'}"/>
                    <c:set var="imgUrl" value="${not empty article.imageUrl ? article.imageUrl : 'images/default-product.jpg'}"/>

                    <article class="article-card" data-category="${catName}">
                        <img src="${imgUrl}" alt="${article.name}" loading="lazy">
                        <div class="article-info">
                            <div class="category-label">${catName}</div>
                            <h3>${article.name}</h3>
                            <div class="price">${article.price} €</div>

                            <div class="card-actions">
                                <a href="article?id=${article.id}" class="btn-secondary"><i class="fas fa-eye"></i> Détails</a>
                                <c:if test="${!isAdmin}">
                                    <button onclick="addToCart(${article.id})" class="btn-primary-card">
                                        Ajouter au panier
                                    </button>
                                </c:if>
                            </div>

                            <c:if test="${isAdmin}">
                                <div class="admin-actions">
                                    <a href="admin?action=edit&id=${article.id}" class="btn-admin btn-edit">Modifier</a>
                                    <form action="admin" method="post" style="display:inline;" onsubmit="return confirm('Supprimer cet article ?');">
                                        <input type="hidden" name="action" value="delete">
                                        <input type="hidden" name="id" value="${article.id}">
                                        <button type="submit" class="btn-admin btn-delete">Supprimer</button>
                                    </form>
                                </div>
                            </c:if>
                        </div>
                    </article>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <p class="no-articles">Aucune pièce disponible pour le moment…</p>
            </c:otherwise>
        </c:choose>
    </div>
</main>

<nav class="bottom-nav" aria-label="Navigation mobile">
    <ul>
        <li><a href="home" class="active"><i class="fas fa-home"></i></a></li>
        <c:if test="${!isAdmin}">
            <li><a href="cart"><i class="fas fa-shopping-bag"></i></a></li>
        </c:if>
        <li><a href="articles"><i class="fas fa-gem"></i></a></li>
        <c:if test="${isAdmin}">
            <li><a href="admin"><i class="fas fa-user-shield"></i></a></li>
            <li><a href="admin?action=users"><i class="fas fa-users-cog"></i></a></li>
        </c:if>
        <li><a href="logout"><i class="fas fa-sign-out-alt"></i></a></li>
    </ul>
</nav>

<script src="https://cdnjs.cloudflare.com/ajax/libs/axios/1.7.7/axios.min.js"></script>
<script>
// ======================================================
// FILTRAGE CATÉGORIES - VERSION ROBUSTE (accents, espaces, casse)
// ======================================================
function normalizeCategory(str) {
    if (!str) return 'autres';
    return str
        .toLowerCase()
        .normalize('NFD').replace(/\p{Diacritic}/gu, '') // retire accents
        .replace(/\s+/g, '') // retire espaces
        .replace(/[^a-z0-9]/g, ''); // retire tout sauf lettres/chiffres
}

document.addEventListener('DOMContentLoaded', () => {
    const filterButtons = document.querySelectorAll('.category-filter button');
    const articleCards = document.querySelectorAll('.article-card');

    // Normalise les data-category des boutons et articles
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
        btn.addEventListener('click', () => {
            applyFilter(btn.dataset.category);
        });
    });

    // Initialisation
    applyFilter('all');

    // Fonction panier (à adapter selon ton implémentation réelle)
    window.addToCart = async function(id) {
        try {
            const formData = new FormData();
            formData.append('action', 'add');
            formData.append('id', id);
            await axios.post('cart', formData);
            alert('Article ajouté au panier ! ✨');
        } catch (err) {
            console.error(err);
            alert('Erreur lors de l\'ajout au panier');
        }
    };
});
</script>
</body>
</html>