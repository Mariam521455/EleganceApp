<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
            <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
                <%@ page import="java.util.List" %>
                    <%@ page import="com.mycompany.eleganceapp.model.Article" %>
                        <%@ page import="com.mycompany.eleganceapp.model.Category" %>
                            <%@ page session="true" %>

                                <c:set var="articles"
                                    value="${requestScope.allArticles != null ? requestScope.allArticles : emptyList}" />
                                <c:set var="categories"
                                    value="${requestScope.categories != null ? requestScope.categories : emptyList}" />

                                <!DOCTYPE html>
                                <html lang="fr">

                                <head>
                                    <meta charset="UTF-8">
                                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                                    <title>Administration - Élégance</title>

                                    <link rel="preconnect" href="https://fonts.googleapis.com">
                                    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
                                    <link
                                        href="https://fonts.googleapis.com/css2?family=Playfair+Display:ital,wght@0,300;0,400;0,500;0,600;0,700;1,400&family=Inter:wght@300;400;500;600;700&display=swap"
                                        rel="stylesheet">
                                    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

                                    <style>
                                        .admin-container {
                                            max-width: 1280px;
                                            margin: 0 auto;
                                            padding: var(--space-12) var(--space-6);
                                        }

                                        .admin-header {
                                            display: flex;
                                            justify-content: space-between;
                                            align-items: center;
                                            margin-bottom: var(--space-10);
                                            flex-wrap: wrap;
                                            gap: var(--space-6);
                                        }

                                        .admin-title {
                                            font-family: var(--font-display);
                                            font-size: 2.8rem;
                                            color: var(--text);
                                            margin: 0;
                                            font-weight: 700;
                                        }

                                        /* Stats Cards */
                                        .stats-grid {
                                            display: grid;
                                            grid-template-columns: repeat(auto-fit, minmax(240px, 1fr));
                                            gap: 2rem;
                                            margin-bottom: 4rem;
                                        }

                                        .stat-card {
                                            background: white;
                                            border-radius: var(--radius-lg);
                                            padding: 2rem;
                                            border: 1px solid var(--color-border);
                                            box-shadow: var(--shadow-md);
                                            display: flex;
                                            align-items: center;
                                            gap: 1.5rem;
                                            transition: var(--transition);
                                        }

                                        .stat-card:hover {
                                            transform: translateY(-5px);
                                            box-shadow: var(--shadow-hover);
                                            border-color: var(--color-gold);
                                        }

                                        .stat-icon {
                                            width: 60px;
                                            height: 60px;
                                            background: rgba(212, 175, 55, 0.1);
                                            color: var(--color-gold);
                                            border-radius: 15px;
                                            display: flex;
                                            align-items: center;
                                            justify-content: center;
                                            font-size: 1.8rem;
                                        }

                                        .stat-info .stat-value {
                                            display: block;
                                            font-size: 1.8rem;
                                            font-weight: 700;
                                            color: var(--text);
                                            line-height: 1;
                                            margin-bottom: 0.3rem;
                                        }

                                        .stat-info .stat-label {
                                            font-size: 0.9rem;
                                            color: var(--color-text-light);
                                            text-transform: uppercase;
                                            letter-spacing: 1px;
                                            font-weight: 600;
                                        }

                                        /* Dynamic Chart Section */
                                        .charts-section {
                                            display: grid;
                                            grid-template-columns: 1fr;
                                            gap: 2rem;
                                            margin-bottom: 4rem;
                                        }

                                        .chart-container {
                                            background: white;
                                            border-radius: var(--radius-lg);
                                            padding: 2.5rem;
                                            border: 1px solid var(--color-border);
                                            box-shadow: var(--shadow-md);
                                            min-height: 400px;
                                        }

                                        .chart-title {
                                            font-family: var(--font-display);
                                            font-size: 1.5rem;
                                            margin-bottom: 2rem;
                                            color: var(--text);
                                            text-align: center;
                                        }

                                        .articles-grid {
                                            display: grid;
                                            grid-template-columns: repeat(auto-fill, minmax(340px, 1fr));
                                            gap: var(--space-8);
                                        }

                                        .article-card {
                                            background: rgba(255, 255, 255, 0.35);
                                            backdrop-filter: blur(16px);
                                            border-radius: var(--radius-lg);
                                            overflow: hidden;
                                            border: 1px solid var(--color-border);
                                            box-shadow: var(--shadow-md);
                                            transition: var(--transition);
                                        }

                                        .article-card:hover {
                                            transform: translateY(-12px);
                                            box-shadow: var(--shadow-hover);
                                        }

                                        .article-info {
                                            padding: var(--space-6);
                                            text-align: center;
                                        }

                                        .article-title {
                                            font-family: var(--font-display);
                                            font-size: 1.45rem;
                                            color: var(--color-text);
                                            margin-bottom: var(--space-3);
                                        }

                                        .article-desc {
                                            color: var(--color-text-light);
                                            font-size: 0.98rem;
                                            margin-bottom: var(--space-4);
                                            line-height: 1.5;
                                        }

                                        .price {
                                            font-size: 1.35rem;
                                            font-weight: 700;
                                            color: var(--color-gold-dark);
                                            margin-bottom: var(--space-4);
                                        }

                                        .category-label {
                                            font-size: 0.9rem;
                                            color: var(--color-gold);
                                            text-transform: uppercase;
                                            letter-spacing: 0.8px;
                                            margin-bottom: var(--space-4);
                                        }

                                        .admin-actions {
                                            display: flex;
                                            gap: var(--space-4);
                                            justify-content: center;
                                            flex-wrap: wrap;
                                            margin-top: var(--space-5);
                                        }

                                        .premium-btn.edit {
                                            background: linear-gradient(135deg, var(--color-gold-light) 0%, var(--color-gold) 100%);
                                            color: var(--color-text);
                                        }

                                        .premium-btn.danger {
                                            background: linear-gradient(135deg, #ffebee 0%, var(--color-danger) 100%);
                                        }

                                        @media (max-width: 768px) {
                                            .admin-header {
                                                flex-direction: column;
                                                text-align: center;
                                            }
                                        }
                                    </style>
                                </head>

                                <body>

                                    <%@ include file="header.jsp" %>

                                        <main class="admin-container">
                                            <div class="admin-header">
                                                <h1 class="admin-title">Gestion des Articles</h1>
                                                <a href="${pageContext.request.contextPath}/admin?action=add_form"
                                                    class="premium-btn btn-pop-luxe">
                                                    ✨ Ajouter un article
                                                </a>
                                            </div>

                                            <div class="stats-grid reveal-lux">
                                                <div class="stat-card">
                                                    <div class="stat-icon"><i class="fas fa-gem"></i></div>
                                                    <div class="stat-info">
                                                        <span class="stat-value">${articleCount}</span>
                                                        <span class="stat-label">Articles</span>
                                                    </div>
                                                </div>
                                                <div class="stat-card">
                                                    <div class="stat-icon"><i class="fas fa-users"></i></div>
                                                    <div class="stat-info">
                                                        <span class="stat-value">${userCount}</span>
                                                        <span class="stat-label">Clients</span>
                                                    </div>
                                                </div>
                                                <div class="stat-card">
                                                    <div class="stat-icon"><i class="fas fa-shopping-cart"></i></div>
                                                    <div class="stat-info">
                                                        <span class="stat-value">${orderCount}</span>
                                                        <span class="stat-label">Commandes</span>
                                                    </div>
                                                </div>
                                                <div class="stat-card">
                                                    <div class="stat-icon"><i class="fas fa-coins"></i></div>
                                                    <div class="stat-info">
                                                        <span class="stat-value">
                                                            <fmt:formatNumber value="${totalSales}"
                                                                maxFractionDigits="0" />
                                                        </span>
                                                        <span class="stat-label">CFA Total</span>
                                                    </div>
                                                </div>
                                            </div>

                                            <!-- Section Graphiques Dynamiques -->
                                            <div class="charts-section reveal-lux">
                                                <div class="chart-container">
                                                    <h2 class="chart-title">Répartition Exclusive par Catégorie</h2>
                                                    <div style="max-width: 500px; margin: 0 auto; min-height: 300px;">
                                                        <canvas id="categoryChart"></canvas>
                                                    </div>
                                                </div>
                                            </div>

                                            <h2 class="admin-title" style="font-size: 2rem; margin-bottom: 2rem;">
                                                Inventaire</h2>

                                            <div class="articles-grid">
                                                <c:choose>
                                                    <c:when test="${not empty articles}">
                                                        <c:forEach var="article" items="${articles}">
                                                            <article class="article-card reveal-lux hover-bloom">
                                                                <div class="article-info">
                                                                    <h3 class="article-title">
                                                                        <c:out value="${article.name}" />
                                                                    </h3>

                                                                    <p class="article-desc">
                                                                        <c:out value="${article.description}" />
                                                                    </p>

                                                                    <div class="price">
                                                                        <fmt:formatNumber value="${article.price}"
                                                                            type="number" groupingUsed="true"
                                                                            maxFractionDigits="0" /> CFA
                                                                    </div>

                                                                    <div class="category-label">
                                                                        <c:out
                                                                            value="${article.category != null ? article.category.name : 'Non définie'}" />
                                                                    </div>

                                                                    <div class="admin-actions">
                                                                        <form
                                                                            action="${pageContext.request.contextPath}/admin"
                                                                            method="get">
                                                                            <input type="hidden" name="action"
                                                                                value="edit">
                                                                            <input type="hidden" name="id"
                                                                                value="${article.id}">
                                                                            <button type="submit"
                                                                                class="premium-btn edit">
                                                                                <i class="fas fa-pen"></i> Modifier
                                                                            </button>
                                                                        </form>

                                                                        <form
                                                                            action="${pageContext.request.contextPath}/admin"
                                                                            method="post"
                                                                            onsubmit="return confirm('Vraiment supprimer ${fn:escapeXml(article.name)} ?');">
                                                                            <input type="hidden" name="action"
                                                                                value="delete">
                                                                            <input type="hidden" name="id"
                                                                                value="${article.id}">
                                                                            <button type="submit"
                                                                                class="premium-btn danger">
                                                                                <i class="fas fa-trash"></i> Supprimer
                                                                            </button>
                                                                        </form>
                                                                    </div>
                                                                </div>
                                                            </article>
                                                        </c:forEach>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <div class="no-articles">
                                                            <div class="no-articles-icon">
                                                                <i class="fas fa-gem"></i>
                                                            </div>
                                                            <h2 class="no-articles-title">Aucun article à gérer</h2>
                                                            <p class="no-articles-text">Tous les articles ont été
                                                                supprimés. Commencez par ajouter un nouvel article pour
                                                                repeuplir votre collection.</p>
                                                            <a href="${pageContext.request.contextPath}/admin?action=add_form"
                                                                class="premium-btn btn-pop-luxe">
                                                                <i class="fas fa-plus"></i> Ajouter un article
                                                            </a>
                                                        </div>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                        </main>

                                        <%@ include file="footer.jsp" %>

                                            <script>
                                                document.addEventListener('DOMContentLoaded', () => {
                                                    const ctx = document.getElementById('categoryChart').getContext('2d');

                                                    // Data passed from servlet
                                                    const categoryData = {
                < c: forEach var="entry" items = "${categoryCounts}" varStatus = "loop" >
                                                        '<c:out value="${entry.key}"/>': <c:out value="${entry.value}"/><c:if test="${!loop.last}">,</c:if>
                </c: forEach >
            };

                                                if (Object.keys(categoryData).length === 0) {
                                                    document.querySelector('.chart-container').style.display = 'none';
                                                    return;
                                                }

                                                new Chart(ctx, {
                                                    type: 'doughnut',
                                                    data: {
                                                        labels: Object.keys(categoryData),
                                                        datasets: [{
                                                            data: Object.values(categoryData),
                                                            backgroundColor: [
                                                                '#d4af37', // Gold
                                                                '#3f2c22', // Coffee
                                                                '#b8972e', // Dark Gold
                                                                '#e3d7c9', // Beige
                                                                '#5c4438'  // Brown
                                                            ],
                                                            borderWidth: 0,
                                                            hoverOffset: 20
                                                        }]
                                                    },
                                                    options: {
                                                        responsive: true,
                                                        maintainAspectRatio: false,
                                                        plugins: {
                                                            legend: {
                                                                position: 'bottom',
                                                                labels: {
                                                                    font: {
                                                                        family: "'Inter', sans-serif",
                                                                        size: 13
                                                                    },
                                                                    padding: 20,
                                                                    usePointStyle: true
                                                                }
                                                            },
                                                            tooltip: {
                                                                backgroundColor: 'rgba(255, 255, 255, 0.9)',
                                                                titleColor: '#3f2c22',
                                                                bodyColor: '#3f2c22',
                                                                borderColor: '#d4af37',
                                                                borderWidth: 1,
                                                                padding: 12,
                                                                displayColors: false
                                                            }
                                                        },
                                                        cutout: '70%'
                                                    }
                                                });
        });
                                            </script>
                                </body>

                                </html>