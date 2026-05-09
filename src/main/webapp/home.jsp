<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.mycompany.eleganceapp.model.User" %>
<%@ page import="com.mycompany.eleganceapp.model.Article" %>
<%@ page import="com.mycompany.eleganceapp.model.Category" %>
<%@ page import="java.util.List" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%
    User currentUser = (User) session.getAttribute("currentUser");
    if (currentUser == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    boolean isAdmin = "admin".equalsIgnoreCase(currentUser.getRole());
    List<Article> articles = (List<Article>) request.getAttribute("articles");
    List<Category> categories = (List<Category>) request.getAttribute("categories");
    String error = (String) session.getAttribute("error");
    String success = (String) session.getAttribute("success");
    
    // Nettoyage des messages après utilisation
    session.removeAttribute("error");
    session.removeAttribute("success");
%>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Élégance - Accueil</title>
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@400;500;700&family=Lato:wght@300;400;500;700&display=swap" rel="stylesheet">
    
    <style>
        :root {
            --color-bg: #fdfaf8;
            --color-blush: #fce9e6;
            --color-rose: #f4d9d3;
            --color-gold: #c9a24e;
            --color-gold-dark: #b38c3a;
            --text-dark: #2f1e18;
            --text-medium: #5c4a44;
            --radius: 16px;
            --shadow-card: 0 12px 32px rgba(201, 162, 78, 0.14);
            --shadow-hover: 0 20px 48px rgba(201, 162, 78, 0.24);
            --transition: all 0.38s cubic-bezier(0.25, 0.8, 0.25, 1);
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Lato', sans-serif;
            background: linear-gradient(135deg, var(--color-bg) 0%, var(--color-blush) 100%);
            color: var(--text-dark);
            min-height: 100vh;
            line-height: 1.6;
        }

        main {
            padding: 2rem 1.5rem;
            max-width: 1440px;
            margin: 0 auto;
        }

        .admin-controls {
            text-align: center;
            margin: 1.5rem 0 2.5rem;
        }

        .btn-add-admin {
            display: inline-block;
            padding: 0.9rem 2.2rem;
            background: var(--color-gold);
            color: white;
            text-decoration: none;
            border-radius: 50px;
            font-weight: 600;
            letter-spacing: 0.5px;
            box-shadow: 0 6px 20px rgba(201,162,78,0.3);
            transition: var(--transition);
        }

        .btn-add-admin:hover {
            transform: translateY(-3px);
            box-shadow: 0 12px 32px rgba(201,162,78,0.45);
        }

        .category-filter {
            display: flex;
            flex-wrap: wrap;
            justify-content: center;
            gap: 1rem;
            margin: 1.5rem 0 3rem;
        }

        .category-filter button {
            padding: 0.7rem 1.8rem;
            border: 1px solid rgba(201,162,78,0.4);
            border-radius: 50px;
            background: white;
            color: var(--text-medium);
            font-weight: 500;
            cursor: pointer;
            transition: var(--transition);
        }

        .category-filter button:hover {
            background: rgba(201,162,78,0.08);
            border-color: var(--color-gold);
            transform: translateY(-2px);
        }

        .category-filter button.active {
            background: var(--color-gold);
            color: white;
            border-color: var(--color-gold);
            box-shadow: 0 6px 18px rgba(201,162,78,0.3);
        }

        .articles-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
            gap: 2rem;
        }

        .article-card {
            background: white;
            border-radius: var(--radius);
            overflow: hidden;
            box-shadow: var(--shadow-card);
            transition: var(--transition);
            display: flex;
            flex-direction: column;
        }

        .article-card:hover {
            transform: translateY(-12px);
            box-shadow: var(--shadow-hover);
        }

        .article-card img {
            width: 100%;
            height: 320px;
            object-fit: cover;
            transition: transform 0.55s ease;
        }

        .article-card:hover img {
            transform: scale(1.07);
        }

        .article-info {
            padding: 1.5rem;
            text-align: center;
            flex-grow: 1;
            display: flex;
            flex-direction: column;
        }

        .article-info .category-label {
            font-size: 0.75rem;
            font-weight: 600;
            letter-spacing: 1.2px;
            color: var(--color-gold);
            margin-bottom: 0.6rem;
            text-transform: uppercase;
        }

        .article-info h3 {
            font-family: 'Playfair Display', serif;
            font-size: 1.45rem;
            margin-bottom: 0.8rem;
            color: var(--text-dark);
            line-height: 1.25;
        }

        .article-info .price {
            font-size: 1.35rem;
            font-weight: 700;
            color: var(--color-gold-dark);
            margin-bottom: 1.4rem;
        }

        .action-buttons {
            display: flex;
            gap: 0.8rem;
            justify-content: center;
            margin-top: auto;
            flex-wrap: wrap;
        }

        .btn-details, .btn-luxury {
            padding: 0.75rem 1.6rem;
            border-radius: 50px;
            font-weight: 500;
            text-decoration: none;
            transition: var(--transition);
            font-size: 0.95rem;
        }

        .btn-details {
            background: transparent;
            border: 1.5px solid var(--color-gold);
            color: var(--color-gold);
        }

        .btn-details:hover {
            background: var(--color-gold);
            color: white;
        }

        .btn-luxury {
            background: var(--color-gold);
            color: white;
            border: none;
        }

        .btn-luxury:hover {
            background: var(--color-gold-dark);
            transform: translateY(-2px);
        }

        .admin-actions {
            margin-top: 1.2rem;
            display: flex;
            gap: 0.8rem;
            justify-content: center;
        }

        .btn-admin {
            padding: 0.5rem 1.1rem;
            border-radius: 8px;
            font-size: 0.85rem;
            text-decoration: none;
        }

        .btn-edit {
            background: #4a90e2;
            color: white;
        }

        .btn-delete {
            background: #e74c3c;
            color: white;
            border: none;
            cursor: pointer;
        }

        .no-articles {
            grid-column: 1 / -1;
            text-align: center;
            padding: 5rem 1rem;
            color: var(--text-medium);
            font-size: 1.4rem;
            font-family: 'Playfair Display', serif;
        }

        @media (max-width: 768px) {
            .articles-grid {
                grid-template-columns: repeat(auto-fill, minmax(240px, 1fr));
            }
            .article-card img {
                height: 280px;
            }
        }
    </style>
</head>
<body data-is-admin="<%= isAdmin %>">

    <%@ include file="header.jsp" %>

    <div id="toastContainer"></div>

    <main>
        <% if (isAdmin) { %>
            <div class="admin-controls">
                <a href="admin?action=add_form" class="btn-add-admin">✨ Ajouter un nouvel article</a>
            </div>
        <% } %>

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
                        <c:set var="imgUrl" value="${not empty article.imageUrl ? article.imageUrl : 'images/default.png'}"/>

                        <div class="article-card" data-category="${catName}" data-name="${fn:toLowerCase(article.name)}">
                            <img src="${imgUrl}" alt="${article.name}" loading="lazy">
                            <div class="article-info">
                                <div class="category-label">${catName}</div>
                                <h3>${article.name}</h3>
                                <div class="price">${article.price} €</div>

                                <div class="action-buttons">
                                    <a href="article?id=${article.id}" class="btn-details">Détails</a>
                                    <button onclick="addToCart(${article.id})" class="btn-luxury">Ajouter ✨</button>
                                </div>

                                <c:if test="${isAdmin}">
                                    <div class="admin-actions">
                                        <a href="admin?action=edit&id=${article.id}" class="btn-admin btn-edit">Modifier</a>
                                        <form action="admin" method="post" style="display:inline;" onsubmit="return confirm('Confirmer la suppression ?');">
                                            <input type="hidden" name="action" value="delete">
                                            <input type="hidden" name="id" value="${article.id}">
                                            <button type="submit" class="btn-admin btn-delete">Supprimer</button>
                                        </form>
                                    </div>
                                </c:if>
                            </div>
                        </div>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <p class="no-articles">Aucun article disponible pour le moment... ✨</p>
                </c:otherwise>
            </c:choose>
        </div>
    </main>

    <%@ include file="footer.jsp" %>

    <script src="https://cdnjs.cloudflare.com/ajax/libs/axios/1.7.7/axios.min.js"></script>
    <script>
        // Gestion des filtres catégories (client-side)
        document.querySelectorAll('.category-filter button').forEach(btn => {
            btn.addEventListener('click', function() {
                document.querySelectorAll('.category-filter button').forEach(b => b.classList.remove('active'));
                this.classList.add('active');
                
                const filter = this.dataset.category;
                document.querySelectorAll('.article-card').forEach(card => {
                    const cat = card.dataset.category;
                    card.style.display = (filter === 'all' || cat === filter) ? '' : 'none';
                });
            });
        });

        // Fonction d'ajout au panier (exemple)
        async function addToCart(articleId) {
            try {
                const formData = new FormData();
                formData.append('action', 'add');
                formData.append('id', articleId);

                await axios.post('cart', formData);
                showToast('Succès', 'Article ajouté au panier ! ✨', 'success');
            } catch (err) {
                showToast('Erreur', 'Impossible d\'ajouter au panier', 'error');
                console.error(err);
            }
        }

        // Toast simple (à améliorer selon tes besoins)
        function showToast(title, message, type = 'success') {
            const container = document.getElementById('toastContainer');
            const toast = document.createElement('div');
            toast.className = `toast ${type}`;
            toast.innerHTML = `
                <strong>${title}</strong><br>
                ${message}
            `;
            container.appendChild(toast);
            
            setTimeout(() => {
                toast.style.opacity = '0';
                setTimeout(() => toast.remove(), 400);
            }, 3200);
        }
    </script>

    <style>
        .toast-container {
            position: fixed;
            top: 20px;
            right: 20px;
            z-index: 1000;
        }
        .toast {
            background: rgba(0,0,0,0.85);
            color: white;
            padding: 1rem 1.4rem;
            border-radius: 10px;
            margin-bottom: 1rem;
            min-width: 280px;
            box-shadow: 0 8px 25px rgba(0,0,0,0.3);
            opacity: 1;
            transition: opacity 0.4s;
        }
        .toast.success { background: #27ae60; }
        .toast.error   { background: #e74c3c; }
    </style>
</body>
</html>