<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
            <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

                <!DOCTYPE html>
                <html lang="fr">

                <head>
                    <meta charset="UTF-8">
                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                    <title>Mes Coups de Cœur • Élégance</title>
                    <link rel="preconnect" href="https://fonts.googleapis.com">
                    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
                    <link
                        href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@400;700&family=Inter:wght@300;400;600&display=swap"
                        rel="stylesheet">
                    <link rel="stylesheet"
                        href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
                    <style>
                        :root {
                            --bg: #fdf8f9;
                            --gold: #d4af37;
                            --text: #3f2c22;
                        }

                        body {
                            font-family: 'Inter', sans-serif;
                            background-color: var(--bg);
                            color: var(--text);
                            margin: 0;
                            padding: 0;
                        }

                        .header-section {
                            text-align: center;
                            padding: 80px 20px 40px;
                            background: linear-gradient(to bottom, #f9e8ed, var(--bg));
                        }

                        .header-section h1 {
                            font-family: 'Playfair Display', serif;
                            font-size: 3rem;
                            margin-bottom: 10px;
                        }

                        .header-section p {
                            font-size: 1.1rem;
                            opacity: 0.8;
                            letter-spacing: 1px;
                        }

                        .favorites-container {
                            max-width: 1400px;
                            margin: 0 auto;
                            padding: 40px 20px 100px;
                        }

                        .articles-grid {
                            display: grid;
                            grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
                            gap: 30px;
                        }

                        .article-card {
                            background: white;
                            border-radius: 12px;
                            overflow: hidden;
                            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.05);
                            transition: all 0.3s ease;
                            position: relative;
                        }

                        .article-card:hover {
                            transform: translateY(-10px);
                            box-shadow: 0 20px 40px rgba(212, 175, 55, 0.15);
                        }

                        .article-card img {
                            width: 100%;
                            aspect-ratio: 1;
                            object-fit: cover;
                        }

                        .article-info {
                            padding: 20px;
                            text-align: center;
                        }

                        .article-info h3 {
                            font-family: 'Playfair Display', serif;
                            font-size: 1.2rem;
                            margin: 10px 0;
                        }

                        .price {
                            color: var(--gold);
                            font-weight: 700;
                            font-size: 1.1rem;
                            margin-bottom: 20px;
                        }

                        .card-actions {
                            display: flex;
                            gap: 10px;
                            justify-content: center;
                        }

                        .btn-view {
                            padding: 8px 20px;
                            border: 1px solid var(--gold);
                            color: var(--gold);
                            text-decoration: none;
                            border-radius: 20px;
                            font-size: 0.9rem;
                            transition: all 0.3s;
                        }

                        .btn-view:hover {
                            background: var(--gold);
                            color: white;
                        }

                        .empty-state {
                            text-align: center;
                            padding: 100px 20px;
                        }

                        .empty-state i {
                            font-size: 4rem;
                            color: #eee;
                            margin-bottom: 20px;
                        }
                    </style>
                </head>

                <body>
                    <%@ include file="header.jsp" %>
                        <div class="header-section">
                            <h1 class="reveal-lux">Mes Coups de Cœur</h1>
                            <p class="reveal-lux">VOTRE SÉLECTION PERSONNELLE D'EXCEPTION</p>
                        </div>
                        <div class="favorites-container">
                            <c:choose>
                                <c:when test="${not empty favorites}">
                                    <div class="articles-grid">
                                        <c:forEach var="article" items="${favorites}">
                                            <article class="article-card reveal-lux">
                                                <button class="favorite-btn"
                                                    onclick="toggleFavorite(${article.id}, this)"
                                                    aria-label="Retirer des favoris">
                                                    <i class="fas favorite-active fa-heart"></i>
                                                </button>
                                                <img src="${not empty article.imageUrl ? article.imageUrl : 'images/default-product.jpg'}"
                                                    alt="${article.name}">
                                                <div class="article-info">
                                                    <h3>${article.name}</h3>
                                                    <div class="price">
                                                        <fmt:formatNumber value="${article.price}" type="number"
                                                            maxFractionDigits="0" /> CFA
                                                    </div>
                                                    <div class="card-actions">
                                                        <a href="article?id=${article.id}" class="btn-view">Voir
                                                            l'article</a>
                                                    </div>
                                                </div>
                                            </article>
                                        </c:forEach>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="empty-state reveal-lux">
                                        <i class="far fa-heart"></i>
                                        <h2>Votre liste est vide</h2>
                                        <p>Parcourez notre collection et enregistrez vos pièces favorites ici.</p>
                                        <a href="home" class="btn-primary"
                                            style="margin-top: 20px; display: inline-block;">Découvrir la collection</a>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                        <%@ include file="footer.jsp" %>
                </body>

                </html>