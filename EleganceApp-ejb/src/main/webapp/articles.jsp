<%@page import="com.mycompany.eleganceapp.model.User"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.mycompany.eleganceapp.model.Article" %>

<%
    // Vérifier session
    User currentUser = (User) session.getAttribute("currentUser");
    if(currentUser == null){
        response.sendRedirect("login.jsp");
        return;
    }

    // Récupération des articles passés par le servlet
    List<Article> articles = (List<Article>) request.getAttribute("allArticles");
%>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Élégance - Articles</title>
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:ital,wght@0,400;0,700;1,400&family=Lato:wght@300;400;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="css/elegance.css">

    <style>
        /* === Design harmonisé === */
        body {
            font-family: 'Lato', sans-serif;
            background: linear-gradient(to bottom, #fffafc, #fceceb);
            min-height: 100vh;
            margin: 0;
        }

        header {
            padding: 25px 20px 10px;
            text-align: center;
            position: sticky;
            top: 0;
            background: rgba(255,255,255,0.3);
            backdrop-filter: blur(14px);
            z-index: 100;
            box-shadow: 0 4px 15px rgba(212,175,55,0.1);
            border-bottom: 1px solid rgba(212,175,55,0.2);
        }

        .logo {
            font-family: 'Playfair Display', serif;
            font-size: 36px;
            color: #d4af37;
            font-weight: 700;
            letter-spacing: 2px;
            margin-bottom: 15px;
        }

        .category-filter {
            display: flex;
            justify-content: center;
            gap: 12px;
            flex-wrap: wrap;
        }

        .category-filter button {
            padding: 8px 22px;
            border: 1px solid #d4af37;
            background: rgba(212,175,55,0.1);
            border-radius: 25px;
            cursor: pointer;
            font-family: 'Lato', sans-serif;
            font-weight: 500;
            color: #4a3c34;
            transition: all 0.3s ease;
        }

        .category-filter button:hover {
            background: #d4af37;
            color: #fff;
            box-shadow: 0 8px 20px rgba(212,175,55,0.3);
            transform: translateY(-2px);
        }

        .articles-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(240px,1fr));
            gap: 25px;
            padding: 50px 20px;
            max-width: 1200px;
            margin: 0 auto;
        }

        .article-card {
            background: rgba(255,255,255,0.25);
            backdrop-filter: blur(10px);
            border-radius: 25px;
            overflow: hidden;
            box-shadow: 0 15px 30px rgba(212,175,55,0.08);
            transition: transform 0.3s, box-shadow 0.3s;
            cursor: pointer;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
        }

        .article-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 25px 50px rgba(212,175,55,0.2);
        }

        .article-card img {
            width: 100%;
            height: 260px;
            object-fit: cover;
            border-bottom: 1px solid rgba(212,175,55,0.1);
        }

        .article-info {
            padding: 18px 20px;
            text-align: center;
        }

        .article-info h3 {
            font-family: 'Playfair Display', serif;
            color: #4a3c34;
            font-size: 20px;
            margin-bottom: 8px;
        }

        .article-info p {
            color: #6d5c56;
            font-size: 16px;
            margin-bottom: 12px;
        }

        .article-info .btn-details {
            background: linear-gradient(135deg, #fceceb, #d4af37);
            color: #fff;
            border:none;
            padding: 10px 25px;
            border-radius: 50px;
            font-family: 'Playfair Display', serif;
            cursor: pointer;
            transition: all 0.3s ease;
            box-shadow: 0 8px 20px rgba(212,175,55,0.3);
        }

        .article-info .btn-details:hover {
            transform: scale(1.05) translateY(-2px);
            box-shadow: 0 15px 35px rgba(212,175,55,0.4);
        }

        footer {
            text-align: center;
            padding: 25px 20px;
            font-size: 14px;
            color: #6d5c56;
            margin-top: 50px;
        }

        @media (max-width: 768px){
            .articles-grid { grid-template-columns: repeat(auto-fill, minmax(180px,1fr)); gap: 15px; padding: 30px 15px; }
            .article-card img { height: 200px; }
            .article-info h3 { font-size: 18px; }
            .article-info p { font-size: 14px; }
        }
    </style>
</head>
<body>
    <%@ include file="header.jsp" %>
    <header>
        <div class="logo">Élégance</div>
        <div class="category-filter">
            <button onclick="filterCategory('all')">Tous</button>
            <button onclick="filterCategory('beaute')">Beauté</button>
            <button onclick="filterCategory('mode')">Mode</button>
            <button onclick="filterCategory('accessoires')">Accessoires</button>
            <button onclick="filterCategory('parfum')">Parfums</button>
        </div>
    </header>

    <main class="articles-grid" id="articlesGrid">
        <%
            if(articles != null && !articles.isEmpty()){
                for(Article a : articles){
                    String name = a.getName() != null ? a.getName() : "Nom non disponible";
                    String price = a.getPrice() != null ? String.valueOf(a.getPrice()) : "-";
                    String imageUrl = a.getImageUrl() != null ? a.getImageUrl() : "images/default.png";
                    String categoryName = (a.getCategory() != null && a.getCategory().getName() != null)
                                          ? a.getCategory().getName()
                                          : "autres";
        %>
            <div class="article-card" data-category="<%= categoryName %>">
                <img src="<%= imageUrl %>" alt="<%= name %>">
                <div class="article-info">
                    <h3><%= name %></h3>
                    <p><%= price %> €</p>
                    <form action="article" method="get">
                        <input type="hidden" name="id" value="<%= a.getId() %>">
                        <button type="submit" class="btn-details"><i class="fas fa-eye"></i> Voir détails</button>
                    </form>
                </div>
            </div>
        <%
                }
            } else {
        %>
            <p style="text-align:center; width:100%; grid-column: 1/-1;">Aucun article disponible.</p>
        <%
            }
        %>
    </main>

    <footer>
        &copy; 2026 Élégance — Tous droits réservés
    </footer>

    <script>
        // Filtrage simple par catégorie
        function filterCategory(cat){
            const cards = document.querySelectorAll('.article-card');
            cards.forEach(card=>{
                if(cat === 'all' || card.dataset.category === cat){
                    card.style.display = 'flex';
                } else {
                    card.style.display = 'none';
                }
            <%
                User currentUser = (User) request.getAttribute("currentUser");
                if (currentUser == null) {
                    currentUser = (User) session.getAttribute("currentUser");
                }
                boolean isAdmin = currentUser != null && currentUser.isAdmin();
                List<Article> articles = (List<Article>) request.getAttribute("articles");
                List<Category> categories = (List<Category>) request.getAttribute("categories");
                String q = request.getParameter("q");
                String categoryId = request.getParameter("categoryId");
                String message = (String) request.getAttribute("message");
                if (articles == null) articles = new ArrayList<>();
            %>


