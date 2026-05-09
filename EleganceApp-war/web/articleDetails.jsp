<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ page import="com.mycompany.eleganceapp.model.Article" %>
        <%@ page import="com.mycompany.eleganceapp.model.User" %>
            <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
                <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

                    <% Article article=(Article) request.getAttribute("article"); String status=(String)
                        request.getAttribute("status"); User currentUser=(User) session.getAttribute("currentUser"); if
                        (article==null) { response.sendRedirect(request.getContextPath() + "/home" ); return; } boolean
                        isAdmin=currentUser !=null && "admin" .equalsIgnoreCase(currentUser.getRole()); boolean
                        isAvailable="Disponible" .equals(status); String imageUrl=(article.getImageUrl() !=null &&
                        !article.getImageUrl().isEmpty()) ? article.getImageUrl() : request.getContextPath()
                        + "/images/default.png" ; %>

                        <!DOCTYPE html>
                        <html lang="fr">

                        <head>
                            <meta charset="UTF-8">
                            <title>Élégance - <%= article.getName() %>
                            </title>
                            <link rel="stylesheet"
                                href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
                            <link
                                href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@400;700&family=Lato:wght@300;400;700&display=swap"
                                rel="stylesheet">

                            <style>
                                body {
                                    font-family: 'Lato', sans-serif;
                                    margin: 0;
                                    padding: 0;
                                    background-color: #fdf5f5;
                                    color: #4a4a4a;
                                }

                                h1,
                                h4 {
                                    font-family: 'Playfair Display', serif;
                                    margin: 0 0 10px 0;
                                }

                                a {
                                    text-decoration: none;
                                    color: inherit;
                                }

                                button {
                                    cursor: pointer;
                                    border: none;
                                    outline: none;
                                }

                                .detail-main {
                                    max-width: 1200px;
                                    margin: 40px auto;
                                    padding: 0 20px;
                                }

                                .boutique-grid {
                                    display: grid;
                                    grid-template-columns: 1fr 1fr;
                                    gap: 40px;
                                    align-items: start;
                                }

                                .img-wrapper img {
                                    width: 100%;
                                    max-width: 500px;
                                    border-radius: 20px;
                                    object-fit: cover;
                                    box-shadow: 0 15px 40px rgba(0, 0, 0, 0.1);
                                }

                                .info-wrapper {
                                    display: flex;
                                    flex-direction: column;
                                    gap: 15px;
                                }

                                .article-cat {
                                    font-size: 0.9rem;
                                    font-weight: bold;
                                    letter-spacing: 1px;
                                    color: #d4af37;
                                }

                                .article-price {
                                    font-size: 2rem;
                                    font-weight: 700;
                                    color: #333;
                                    margin: 10px 0;
                                }

                                .article-desc {
                                    line-height: 1.8;
                                    font-size: 1.1rem;
                                    color: #555;
                                }

                                .btn-luxury {
                                    background-color: #d4af37;
                                    color: white;
                                    font-weight: 600;
                                    padding: 15px 35px;
                                    border-radius: 12px;
                                    transition: all 0.3s ease;
                                    font-size: 1rem;
                                }

                                .btn-luxury:hover:not([disabled]) {
                                    background-color: #b8972e;
                                    transform: translateY(-2px);
                                    box-shadow: 0 8px 15px rgba(212, 175, 55, 0.3);
                                }

                                .btn-luxury:disabled {
                                    opacity: 0.6;
                                    cursor: not-allowed;
                                }

                                .admin-panel {
                                    margin-top: 30px;
                                    padding: 20px;
                                    background-color: #fff8e1;
                                    border-radius: 15px;
                                    border: 1px solid #ffe082;
                                }

                                .btn-admin {
                                    padding: 10px 20px;
                                    border-radius: 8px;
                                    font-weight: 600;
                                    display: inline-block;
                                    margin-right: 10px;
                                }

                                .btn-edit {
                                    background-color: #b08a7a;
                                    color: white;
                                }

                                .btn-delete {
                                    background-color: #f44336;
                                    color: white;
                                }

                                /* Similar Articles Section */
                                .similar-articles {
                                    margin-top: 80px;
                                    border-top: 1px solid rgba(212, 175, 55, 0.2);
                                    padding-top: 60px;
                                }

                                .similar-title {
                                    font-family: 'Playfair Display', serif;
                                    font-size: 2.2rem;
                                    text-align: center;
                                    margin-bottom: 40px;
                                    color: #3f2c22;
                                }

                                .similar-grid {
                                    display: grid;
                                    grid-template-columns: repeat(auto-fit, minmax(240px, 1fr));
                                    gap: 30px;
                                }

                                .similar-card {
                                    background: white;
                                    border-radius: 15px;
                                    overflow: hidden;
                                    box-shadow: 0 10px 25px rgba(0, 0, 0, 0.05);
                                    transition: all 0.3s ease;
                                    display: block;
                                }

                                .similar-card:hover {
                                    transform: translateY(-10px);
                                    box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
                                }

                                .similar-card img {
                                    width: 100%;
                                    height: 250px;
                                    object-fit: cover;
                                }

                                .similar-info {
                                    padding: 20px;
                                    text-align: center;
                                }

                                .similar-info h3 {
                                    font-family: 'Playfair Display', serif;
                                    font-size: 1.25rem;
                                    margin-bottom: 8px;
                                    color: #3f2c22;
                                }

                                .similar-info span {
                                    color: #d4af37;
                                    font-weight: 700;
                                    font-size: 1.1rem;
                                }

                                @media (max-width: 900px) {
                                    .boutique-grid {
                                        grid-template-columns: 1fr;
                                        text-align: center;
                                    }

                                    .img-wrapper img {
                                        margin: 0 auto;
                                    }

                                    .similar-grid {
                                        grid-template-columns: 1fr 1fr;
                                    }
                                }

                                .favorite-btn i.favorite-active {
                                    color: #e74c3c !important;
                                }
                            </style>
                        </head>

                        <body>
                            <%@ include file="header.jsp" %>

                                <main class="detail-main">
                                    <nav class="breadcrumb-nav reveal-lux"
                                        style="margin-bottom: 40px; font-size: 0.9rem;">
                                        <a href="${pageContext.request.contextPath}/home"><i class="fas fa-home"></i>
                                            Accueil</a>
                                        <i class="fas fa-chevron-right"
                                            style="margin: 0 10px; font-size: 0.7rem; color: #d4af37;"></i>
                                        <span>
                                            <%= article.getCategory() !=null ? article.getCategory().getName()
                                                : "Collection" %>
                                        </span>
                                        <i class="fas fa-chevron-right"
                                            style="margin: 0 10px; font-size: 0.7rem; color: #d4af37;"></i>
                                        <span class="active" style="color: #d4af37; font-weight: 700;">
                                            <%= article.getName() %>
                                        </span>
                                    </nav>

                                    <div class="boutique-grid">
                                        <div class="img-wrapper" style="position: relative;">
                                            <c:set var="isFav" value="false" />
                                            <c:if test="${not empty userFavorites}">
                                                <c:forEach var="fav" items="${userFavorites}">
                                                    <c:if test="${fav.id == article.id}">
                                                        <c:set var="isFav" value="true" />
                                                    </c:if>
                                                </c:forEach>
                                            </c:if>

                                            <button class="favorite-btn" data-article-id="${article.id}"
                                                onclick="toggleFavorite(this)"
                                                style="position: absolute; top: 20px; right: 20px; z-index: 10; background: rgba(255,255,255,0.9); border-radius: 50%; width: 45px; height: 45px; display: flex; align-items: center; justify-content: center; box-shadow: 0 4px 10px rgba(0,0,0,0.1);"
                                                aria-label="Ajouter aux favoris">
                                                <i class="${isFav ? 'fas favorite-active' : 'far'} fa-heart"
                                                    style="${isFav ? 'color: #e74c3c;' : ''}; font-size: 1.2rem;"></i>
                                            </button>

                                            <img src="<%= imageUrl %>" alt="<%= article.getName() %>">
                                        </div>

                                        <div class="info-wrapper">
                                            <div class="article-cat">
                                                <%= article.getCategory() !=null ?
                                                    article.getCategory().getName().toUpperCase()
                                                    : "COLLECTION EXCLUSIVE" %>
                                            </div>

                                            <div style="display: flex; align-items: center; gap: 20px;">
                                                <h1>
                                                    <%= article.getName() %>
                                                </h1>

                                            </div>

                                            <div class="article-price">
                                                <fmt:formatNumber value="<%= article.getPrice() %>"
                                                    maxFractionDigits="0" /> CFA
                                            </div>
                                            <p class="article-desc">
                                                <%= article.getDescription() !=null ? article.getDescription()
                                                    : "Cette pièce d'exception incarne l'élégance pure de notre Maison."
                                                    %>
                                            </p>

                                            <div class="actions">
                                                <% if (currentUser !=null) { %>
                                                    <% if (isAvailable) { %>
                                                        <button onclick="addToCart(<%= article.getId() %>)"
                                                            class="btn-luxury">✨ Ajouter au panier</button>
                                                        <% } else { %>
                                                            <button disabled class="btn-luxury">Indisponible</button>
                                                            <% } %>
                                                                <% } else { %>
                                                                    <a href="${pageContext.request.contextPath}/login"
                                                                        class="btn-luxury">Se connecter pour
                                                                        commander</a>
                                                                    <% } %>
                                            </div>

                                            <% if (isAdmin) { %>
                                                <div class="admin-panel">
                                                    <h4 style="margin-bottom: 15px;">Interface Administration</h4>
                                                    <a href="${pageContext.request.contextPath}/admin?action=edit&id=<%= article.getId() %>"
                                                        class="btn-admin btn-edit">Modifier</a>
                                                    <form action="${pageContext.request.contextPath}/admin"
                                                        method="post" style="display:inline"
                                                        onsubmit="return confirm('Supprimer cet article ?');">
                                                        <input type="hidden" name="action" value="delete">
                                                        <input type="hidden" name="id" value="<%= article.getId() %>">
                                                        <button type="submit"
                                                            class="btn-admin btn-delete">Supprimer</button>
                                                    </form>
                                                </div>
                                                <% } %>
                                        </div>
                                    </div>

                                    <c:if test="${not empty similarArticles}">
                                        <section class="similar-articles reveal-lux">
                                            <h2 class="similar-title">Vous aimerez aussi</h2>
                                            <div class="similar-grid">
                                                <c:forEach var="similar" items="${similarArticles}">
                                                    <article class="article-card" style="position: relative;">

                                                        <c:set var="isFavSimilar" value="false" />
                                                        <c:if test="${not empty userFavorites}">
                                                            <c:forEach var="fav" items="${userFavorites}">
                                                                <c:if test="${fav.id == similar.id}">
                                                                    <c:set var="isFavSimilar" value="true" />
                                                                </c:if>
                                                            </c:forEach>
                                                        </c:if>

                                                        <button class="favorite-btn"
                                                            onclick="toggleFavorite(${similar.id}, this)"
                                                            aria-label="Favoris">
                                                            <i
                                                                class="${isFavSimilar ? 'fas favorite-active' : 'far'} fa-heart"></i>
                                                        </button>

                                                        <a href="article?id=${similar.id}" style="display: block;">
                                                            <img src="${not empty similar.imageUrl ? similar.imageUrl : 'images/default.png'}"
                                                                alt="${similar.name}">
                                                        </a>
                                                        <div class="similar-info">
                                                            <h3>${similar.name}</h3>
                                                            <span>
                                                                <fmt:formatNumber value="${similar.price}"
                                                                    maxFractionDigits="0" /> CFA
                                                            </span>
                                                        </div>
                                                    </article>
                                                </c:forEach>
                                            </div>
                                        </section>
                                    </c:if>
                                </main>

                                <% include file="footer.jsp" %>
                        </body>

                        </html>