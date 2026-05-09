<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <%@ page import="java.util.List" %>
                <%@ page import="com.mycompany.eleganceapp.model.Article" %>

                    <!DOCTYPE html>
                    <html lang="fr">

                    <head>
                        <meta charset="UTF-8">
                        <meta name="viewport" content="width=device-width, initial-scale=1.0">
                        <title>Tableau de bord - Élégance</title>

                        <link rel="preconnect" href="https://fonts.googleapis.com">
                        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
                        <link
                            href="https://fonts.googleapis.com/css2?family=Playfair+Display:ital,wght@0,300;0,400;0,500;0,600;0,700;1,400&family=Inter:wght@300;400;500;600;700&display=swap"
                            rel="stylesheet">

                        <style>
                            body {
                                background-color: #fdfaf8;
                                background-image:
                                    radial-gradient(at 0% 0%, hsla(253, 16%, 7%, 0) 0, transparent 50%),
                                    radial-gradient(at 50% 0%, hsla(225, 39%, 30%, 0) 0, transparent 50%),
                                    radial-gradient(at 100% 0%, hsla(339, 49%, 30%, 0) 0, transparent 50%);
                                /* Soft warm ambient background */
                            }

                            .dashboard-container {
                                max-width: 1280px;
                                margin: 0 auto;
                                padding: var(--space-12) var(--space-6);
                            }

                            .dashboard-header {
                                margin-bottom: var(--space-10);
                                text-align: center;
                            }

                            .dashboard-title {
                                font-family: var(--font-display);
                                font-size: 3rem;
                                background: linear-gradient(135deg, var(--color-text) 0%, #8a7a74 100%);
                                -webkit-background-clip: text;
                                -webkit-text-fill-color: transparent;
                                margin: 0;
                                font-weight: 700;
                                letter-spacing: -0.5px;
                            }

                            .dashboard-subtitle {
                                color: var(--color-text-light);
                                margin-top: 1rem;
                                font-size: 1.1rem;
                                font-weight: 300;
                            }

                            /* Stats Grid */
                            .stats-grid {
                                display: grid;
                                grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
                                gap: 2.5rem;
                                margin-bottom: 5rem;
                            }

                            .stat-card {
                                background: rgba(255, 255, 255, 0.8);
                                backdrop-filter: blur(20px);
                                border-radius: 24px;
                                padding: 2.5rem;
                                border: 1px solid rgba(255, 255, 255, 0.6);
                                box-shadow:
                                    0 10px 30px rgba(0, 0, 0, 0.04),
                                    0 1px 3px rgba(0, 0, 0, 0.02);
                                display: flex;
                                align-items: center;
                                gap: 2rem;
                                transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
                                position: relative;
                                overflow: hidden;
                            }

                            .stat-card::before {
                                content: '';
                                position: absolute;
                                top: 0;
                                left: 0;
                                width: 100%;
                                height: 4px;
                                background: linear-gradient(90deg, var(--color-gold), #f0e68c);
                                opacity: 0;
                                transition: opacity 0.3s ease;
                            }

                            .stat-card:hover {
                                transform: translateY(-8px);
                                box-shadow:
                                    0 20px 40px rgba(0, 0, 0, 0.08),
                                    0 1px 3px rgba(0, 0, 0, 0.02);
                                background: white;
                            }

                            .stat-card:hover::before {
                                opacity: 1;
                            }

                            .stat-icon {
                                width: 72px;
                                height: 72px;
                                background: linear-gradient(135deg, rgba(212, 175, 55, 0.1), rgba(212, 175, 55, 0.05));
                                color: var(--color-gold);
                                border-radius: 20px;
                                display: flex;
                                align-items: center;
                                justify-content: center;
                                font-size: 2rem;
                                border: 1px solid rgba(212, 175, 55, 0.1);
                            }

                            .stat-info .stat-value {
                                display: block;
                                font-size: 2.5rem;
                                font-weight: 700;
                                color: var(--text);
                                line-height: 1;
                                margin-bottom: 0.4rem;
                                font-family: var(--font-display);
                            }

                            .stat-info .stat-label {
                                font-size: 0.85rem;
                                color: var(--color-text-light);
                                text-transform: uppercase;
                                letter-spacing: 2px;
                                font-weight: 600;
                            }

                            /* Latest Articles Section */
                            .section-header {
                                display: flex;
                                align-items: center;
                                justify-content: space-between;
                                margin-bottom: 2.5rem;
                                border-bottom: 1px solid var(--color-border);
                                padding-bottom: 1rem;
                            }

                            .section-title {
                                font-family: var(--font-display);
                                font-size: 2.2rem;
                                color: var(--text);
                                margin: 0;
                            }

                            .articles-grid {
                                display: grid;
                                grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
                                gap: 2.5rem;
                            }

                            .article-card {
                                background: white;
                                border-radius: 20px;
                                overflow: hidden;
                                box-shadow: var(--shadow-md);
                                transition: all 0.4s var(--ease-luxe-out);
                                border: 1px solid transparent;
                                height: 100%;
                                display: flex;
                                flex-direction: column;
                            }

                            .article-card:hover {
                                transform: translateY(-10px);
                                box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
                                border-color: var(--color-gold);
                            }

                            .article-image-wrapper {
                                position: relative;
                                padding-top: 125%;
                                /* Aspect ratio portrait */
                                overflow: hidden;
                                background: #f5f5f5;
                            }

                            .article-image {
                                position: absolute;
                                top: 0;
                                left: 0;
                                width: 100%;
                                height: 100%;
                                object-fit: cover;
                                transition: transform 0.6s ease;
                            }

                            .article-card:hover .article-image {
                                transform: scale(1.05);
                            }

                            .article-info {
                                padding: 1.5rem;
                                flex-grow: 1;
                                display: flex;
                                flex-direction: column;
                                justify-content: space-between;
                            }

                            .article-title {
                                font-family: var(--font-display);
                                font-size: 1.2rem;
                                color: var(--color-text);
                                margin: 0 0 0.5rem 0;
                                line-height: 1.3;
                            }

                            .article-category {
                                font-size: 0.75rem;
                                color: var(--color-gold);
                                text-transform: uppercase;
                                letter-spacing: 1px;
                                margin-bottom: 1rem;
                                font-weight: 600;
                            }

                            .price-badge {
                                align-self: flex-start;
                                background: rgba(212, 175, 55, 0.1);
                                color: var(--color-gold-dark);
                                padding: 0.4rem 0.8rem;
                                border-radius: 50px;
                                font-weight: 700;
                                font-size: 0.95rem;
                            }

                            .empty-state {
                                grid-column: 1 / -1;
                                text-align: center;
                                padding: 4rem;
                                background: rgba(255, 255, 255, 0.5);
                                border-radius: var(--radius-lg);
                                border: 2px dashed var(--color-border);
                            }
                        </style>
                    </head>

                    <body>

                        <jsp:include page="header.jsp" />

                        <main class="dashboard-container">

                            <div class="dashboard-header reveal-lux">
                                <h1 class="dashboard-title">Vue d'ensemble</h1>
                                <p class="dashboard-subtitle">Performances et nouveautés de votre boutique Élégance.</p>
                            </div>

                            <!-- KPI Cards -->
                            <div class="stats-grid reveal-lux" style="animation-delay: 0.1s;">
                                <div class="stat-card">
                                    <div class="stat-icon"><i class="fas fa-gem"></i></div>
                                    <div class="stat-info">
                                        <span class="stat-value">${totalArticles}</span>
                                        <span class="stat-label">Pièces en boutique</span>
                                    </div>
                                </div>

                                <div class="stat-card">
                                    <div class="stat-icon"><i class="fas fa-users"></i></div>
                                    <div class="stat-info">
                                        <span class="stat-value">${totalUsers}</span>
                                        <span class="stat-label">Clients Membres</span>
                                    </div>
                                </div>
                            </div>

                            <!-- Latest Articles -->
                            <section class="reveal-lux" style="animation-delay: 0.2s;">
                                <div class="section-header">
                                    <h2 class="section-title">Derniers ajouts</h2>
  

                                </div>

                                <div class="articles-grid">
                                    <c:forEach var="article" items="${latestArticles}">
                                        <article class="article-card">
                                            <div class="article-image-wrapper">
                                                <img src="${not empty article.imageUrl ? article.imageUrl : 'https://via.placeholder.com/400x500/f5f5f5/d4af37?text=Élégance'}"
                                                    alt="${article.name}" class="article-image"
                                                    onerror="this.src='https://via.placeholder.com/400x500/f5f5f5/d4af37?text=Élégance'">
                                            </div>

                                            <div class="article-info">
                                                <div>
                                                    <div class="article-category">
                                                        <c:out
                                                            value="${article.category != null ? article.category.name : 'Collection'}" />
                                                    </div>
                                                    <h3 class="article-title">
                                                        <c:out value="${article.name}" />
                                                    </h3>
                                                </div>

                                                <div class="price-badge">
                                                    <fmt:formatNumber value="${article.price}" type="number"
                                                        groupingUsed="true" maxFractionDigits="0" /> CFA
                                                </div>
                                            </div>
                                        </article>
                                    </c:forEach>

                                    <c:if test="${empty latestArticles}">
                                        <div class="empty-state">
                                            <i class="fas fa-box-open"
                                                style="font-size: 3rem; color: var(--color-border); margin-bottom: 1rem;"></i>
                                            <p style="color: var(--color-text-light);">Aucun article ajouté récemment.
                                            </p>
                                        </div>
                                    </c:if>
                                </div>
                            </section>

                        </main>

                        <jsp:include page="footer.jsp" />

                    </body>

                    </html>