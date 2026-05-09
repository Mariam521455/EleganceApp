<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.mycompany.eleganceapp.model.User" %>
<%@ page import="java.util.List" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
    User currentUser = (User) request.getAttribute("currentUser");
    if (currentUser == null) {
        currentUser = (User) session.getAttribute("currentUser");
    }
    if (currentUser == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
    if (!"admin".equalsIgnoreCase(currentUser.getRole())) {
        response.sendRedirect(request.getContextPath() + "/home");
        return;
    }
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Statistiques des Favoris • Admin Élégance</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@400;500;600;700&family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
    
    <style>
        :root {
            --bg-start: #fdf8f9;
            --bg-end: #fceef2;
            --gold: #d4af37;
            --gold-dark: #b8972e;
            --text: #3f2c22;
            --text-light: #5c4438;
            --success: #28a745;
            --danger: #dc3545;
            --info: #17a2b8;
            --radius: 16px;
            --shadow: 0 10px 32px rgba(212,175,55,0.10);
            --shadow-hover: 0 22px 56px rgba(212,175,55,0.26);
        }

        body {
            font-family: 'Inter', system-ui, sans-serif;
            background: linear-gradient(165deg, var(--bg-start) 0%, var(--bg-end) 50%, #f9e8ed 100%);
            color: var(--text);
            min-height: 100vh;
            line-height: 1.6;
            margin: 0;
            padding: 0;
        }

        .admin-header {
            background: white;
            padding: 1.5rem 2rem;
            box-shadow: var(--shadow);
            margin-bottom: 2rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .admin-title {
            font-family: 'Playfair Display', serif;
            font-size: 2rem;
            font-weight: 600;
            color: var(--gold);
            margin: 0;
        }

        .admin-nav {
            display: flex;
            gap: 1rem;
        }

        .admin-nav a {
            padding: 0.75rem 1.5rem;
            background: var(--gold);
            color: white;
            text-decoration: none;
            border-radius: 25px;
            font-weight: 500;
            transition: all 0.3s ease;
        }

        .admin-nav a:hover {
            background: var(--gold-dark);
            transform: translateY(-2px);
        }

        .admin-nav a.active {
            background: var(--text);
        }

        .container {
            max-width: 1400px;
            margin: 0 auto;
            padding: 0 2rem;
        }

        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 1.5rem;
            margin-bottom: 3rem;
        }

        .stat-card {
            background: white;
            padding: 2rem;
            border-radius: var(--radius);
            box-shadow: var(--shadow);
            text-align: center;
            transition: all 0.3s ease;
        }

        .stat-card:hover {
            transform: translateY(-5px);
            box-shadow: var(--shadow-hover);
        }

        .stat-icon {
            font-size: 3rem;
            color: var(--gold);
            margin-bottom: 1rem;
        }

        .stat-number {
            font-size: 2.5rem;
            font-weight: 700;
            color: var(--text);
            margin-bottom: 0.5rem;
        }

        .stat-label {
            color: var(--text-light);
            font-size: 1rem;
            font-weight: 500;
        }

        .favorites-table {
            background: white;
            border-radius: var(--radius);
            box-shadow: var(--shadow);
            overflow: hidden;
        }

        .table-header {
            background: var(--gold);
            color: white;
            padding: 1.5rem 2rem;
            font-family: 'Playfair Display', serif;
            font-size: 1.5rem;
            font-weight: 600;
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        th, td {
            padding: 1rem 2rem;
            text-align: left;
            border-bottom: 1px solid #f0f0f0;
        }

        th {
            background: #f8f9fa;
            font-weight: 600;
            color: var(--text);
            font-family: 'Inter', sans-serif;
        }

        tr:hover {
            background: #f8f9fa;
        }

        .article-name {
            font-weight: 600;
            color: var(--text);
        }

        .favorite-count {
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            background: var(--gold);
            color: white;
            padding: 0.5rem 1rem;
            border-radius: 20px;
            font-weight: 600;
        }

        .favorite-count i {
            color: white;
        }

        .no-data {
            text-align: center;
            padding: 3rem;
            color: var(--text-light);
            font-size: 1.1rem;
        }

        .no-data i {
            font-size: 3rem;
            color: var(--gold);
            margin-bottom: 1rem;
            display: block;
        }

        .top-articles {
            background: white;
            border-radius: var(--radius);
            box-shadow: var(--shadow);
            overflow: hidden;
            margin-top: 2rem;
        }

        .top-articles-header {
            background: var(--info);
            color: white;
            padding: 1.5rem 2rem;
            font-family: 'Playfair Display', serif;
            font-size: 1.5rem;
            font-weight: 600;
        }

        .top-article-item {
            display: flex;
            align-items: center;
            padding: 1.5rem 2rem;
            border-bottom: 1px solid #f0f0f0;
            transition: background 0.3s ease;
        }

        .top-article-item:hover {
            background: #f8f9fa;
        }

        .top-article-rank {
            font-size: 2rem;
            font-weight: 700;
            color: var(--gold);
            margin-right: 1.5rem;
            min-width: 40px;
            text-align: center;
        }

        .top-article-info {
            flex: 1;
        }

        .top-article-name {
            font-weight: 600;
            color: var(--text);
            margin-bottom: 0.25rem;
        }

        .top-article-count {
            color: var(--text-light);
            font-size: 0.9rem;
        }

        .top-article-badge {
            background: var(--info);
            color: white;
            padding: 0.5rem 1rem;
            border-radius: 15px;
            font-weight: 600;
            font-size: 0.9rem;
        }

        @media (max-width: 768px) {
            .admin-header {
                flex-direction: column;
                gap: 1rem;
                text-align: center;
            }

            .admin-nav {
                flex-wrap: wrap;
                justify-content: center;
            }

            .container {
                padding: 0 1rem;
            }

            th, td {
                padding: 0.75rem 1rem;
            }

            .favorite-count {
                padding: 0.25rem 0.75rem;
                font-size: 0.9rem;
            }
        }
    </style>
</head>
<body>
    <%@ include file="header.jsp" %>

    <div class="admin-header">
        <h1 class="admin-title">
            <i class="fas fa-heart"></i> Statistiques des Favoris
        </h1>
        <nav class="admin-nav">
            <a href="${pageContext.request.contextPath}/admin?action=dashboard">
                <i class="fas fa-tachometer-alt"></i> Dashboard
            </a>
            <a href="${pageContext.request.contextPath}/admin?action=orders">
                <i class="fas fa-shopping-cart"></i> Commandes
            </a>
            <a href="${pageContext.request.contextPath}/admin?action=users">
                <i class="fas fa-users"></i> Utilisateurs
            </a>
            <a href="${pageContext.request.contextPath}/admin?action=articles">
                <i class="fas fa-box"></i> Articles
            </a>
            <a href="${pageContext.request.contextPath}/home" class="active">
                <i class="fas fa-heart"></i> Favoris
            </a>
        </nav>
    </div>

    <div class="container">
        <!-- Statistiques générales -->
        <div class="stats-grid">
            <div class="stat-card">
                <div class="stat-icon">
                    <i class="fas fa-heart"></i>
                </div>
                <div class="stat-number">${totalFavorites}</div>
                <div class="stat-label">Total des Favoris</div>
            </div>
            
            <div class="stat-card">
                <div class="stat-icon">
                    <i class="fas fa-box"></i>
                </div>
                <div class="stat-number">${totalArticlesWithFavorites}</div>
                <div class="stat-label">Articles en Favoris</div>
            </div>
            
            <div class="stat-card">
                <div class="stat-icon">
                    <i class="fas fa-chart-line"></i>
                </div>
                <div class="stat-number">${averageFavorites}</div>
                <div class="stat-label">Moyenne par Article</div>
            </div>
            
            <div class="stat-card">
                <div class="stat-icon">
                    <i class="fas fa-trophy"></i>
                </div>
                <div class="stat-number">${topArticleCount}</div>
                <div class="stat-label">Article le Plus Populaire</div>
            </div>
        </div>

        <!-- Tableau des favoris par article -->
        <div class="favorites-table">
            <div class="table-header">
                <i class="fas fa-list"></i> Articles par Nombre de Favoris
            </div>
            
            <c:choose>
                <c:when test="${not empty favoriteStats}">
                    <table>
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Nom de l'article</th>
                                <th>Nombre de favoris</th>
                                <th>Popularité</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="stat" items="${favoriteStats}" varStatus="status">
                                <c:set var="articleId" value="${stat[0]}" />
                                <c:set var="articleName" value="${stat[1]}" />
                                <c:set var="favoriteCount" value="${stat[2]}" />
                                
                                <tr>
                                    <td>${articleId}</td>
                                    <td class="article-name">${articleName}</td>
                                    <td>
                                        <span class="favorite-count">
                                            <i class="fas fa-heart"></i>
                                            ${favoriteCount}
                                        </span>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${favoriteCount == 0}">
                                                <span style="color: #6c757d;">Non populaire</span>
                                            </c:when>
                                            <c:when test="${favoriteCount <= 2}">
                                                <span style="color: #fd7e14;">Peu populaire</span>
                                            </c:when>
                                            <c:when test="${favoriteCount <= 5}">
                                                <span style="color: #20c997;">Populaire</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span style="color: #dc3545;">Très populaire</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </c:when>
                <c:otherwise>
                    <div class="no-data">
                        <i class="fas fa-heart-broken"></i>
                        <p>Aucun article n'a encore été ajouté aux favoris.</p>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

        <!-- Top 10 des articles les plus favoris -->
        <c:if test="${not empty mostFavorited}">
            <div class="top-articles">
                <div class="top-articles-header">
                    <i class="fas fa-trophy"></i> Top 10 des Articles les Plus Populaires
                </div>
                
                <c:forEach var="article" items="${mostFavorited}" varStatus="status">
                    <c:set var="articleData" value="${article[0]}" />
                    <c:set var="favoriteCount" value="${article[1]}" />
                    
                    <div class="top-article-item">
                        <div class="top-article-rank">#${status.count}</div>
                        <div class="top-article-info">
                            <div class="top-article-name">${articleData.name}</div>
                            <div class="top-article-count">
                                <fmt:formatNumber value="${articleData.price}" 
                                                 type="number" 
                                                 groupingUsed="true" 
                                                 maxFractionDigits="0"/> CFA
                            </div>
                        </div>
                        <div class="top-article-badge">
                            <i class="fas fa-heart"></i> ${favoriteCount} favoris
                        </div>
                    </div>
                </c:forEach>
            </div>
        </c:if>
    </div>

    <script>
        // Animation des nombres
        function animateValue(element, start, end, duration) {
            const range = end - start;
            const increment = range / (duration / 16);
            let current = start;
            
            const timer = setInterval(() => {
                current += increment;
                if ((increment > 0 && current >= end) || (increment < 0 && current <= end)) {
                    element.textContent = end;
                    clearInterval(timer);
                } else {
                    element.textContent = Math.round(current);
                }
            }, 16);
        }

        // Animer les statistiques au chargement
        document.addEventListener('DOMContentLoaded', () => {
            const statNumbers = document.querySelectorAll('.stat-number');
            statNumbers.forEach(element => {
                const finalValue = parseInt(element.textContent);
                if (!isNaN(finalValue)) {
                    animateValue(element, 0, finalValue, 1000);
                }
            });
        });
    </script>
</body>
</html>
