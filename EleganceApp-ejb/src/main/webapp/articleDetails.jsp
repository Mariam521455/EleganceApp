
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.mycompany.eleganceapp.model.Article" %>
<%@ page import="com.mycompany.eleganceapp.model.User" %>
<%
    Article article = (Article) request.getAttribute("article");
    String status = (String) request.getAttribute("status");
    User currentUser = (User) request.getAttribute("currentUser");
    if (currentUser == null) {
        currentUser = (User) session.getAttribute("currentUser");
    }
    boolean isAdmin = currentUser != null && currentUser.isAdmin();
    boolean isAvailable = "Disponible".equals(status);
    String imageUrl = (article != null && article.getImageUrl() != null && !article.getImageUrl().isEmpty())
            ? article.getImageUrl()
            : "images/default.png";
%>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Élégance • Détails</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@400;500;600;700&family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Inter', system-ui, sans-serif; background: #fdfaf8; color: #2f1e18; }
        main { max-width: 900px; margin: 0 auto; padding: 3rem; }
        img { max-width: 320px; border-radius: 16px; box-shadow: 0 8px 32px #d4af3722; }
        .error-msg { background:#ffeaea;color:#c62828;padding:1.5rem;border-radius:12px;text-align:center;margin:2rem auto;max-width:600px;box-shadow:0 2px 12px #c6282822; }
        .article-title { font-family: 'Playfair Display', serif; font-size:2.5rem; margin:1.5rem 0 1rem; }
        .article-price { color:#b38c3a; font-size:2rem; font-weight:700; margin:1rem 0; }
        .admin-panel { margin-top:2.5rem; border-top:1px solid #eee; padding-top:1.5rem; }
        .btn { padding:0.7rem 2rem; border-radius:12px; background:#d4af37; color:white; border:none; font-weight:600; margin:0.5rem 0; cursor:pointer; }
        .btn-danger { background:#ef5350; }
        .btn-outline { background:transparent; color:#b38c3a; border:1px solid #b38c3a; }
    </style>
</head>
<body>

<%@ include file="header.jsp" %>


<main>
<% if (article == null) { %>
    <div class="error-msg">
        <i class="fas fa-exclamation-triangle"></i>
        Article introuvable ou lien invalide.<br>
        <a href="home" class="btn btn-outline">Retour à l’accueil</a>
    </div>
<% } else { %>
    <div style="display:grid;grid-template-columns:1fr 2fr;gap:3rem;align-items:start;max-width:900px;margin:0 auto;">
        <div>
            <img src="<%= imageUrl %>" alt="<%= article.getName() %>" style="max-width:100%;border-radius:16px;box-shadow:0 8px 32px #d4af3722;">
        </div>
        <div>
            <div style="font-size:1rem;font-weight:700;letter-spacing:2px;color:#d4af37;text-transform:uppercase;margin-bottom:1rem;">
                <%= (article.getCategory() != null) ? article.getCategory().getName() : "Collection" %>
            </div>
            <h1 class="article-title" style="margin-top:0;"><%= article.getName() %></h1>
            <div class="article-price" style="margin-bottom:1.5rem;"><%= article.getPrice() %> €</div>
            <div style="font-size:1.15rem;color:#6b5a54;line-height:1.7;margin-bottom:2.5rem;">
                <%= (article.getDescription() != null && !article.getDescription().isEmpty()) ? article.getDescription() : "Cette pièce d'exception incarne l'élégance pure de notre Maison." %>
            </div>
            <% if (currentUser != null && isAvailable) { %>
                <form action="cart" method="post" style="margin-bottom:1.5rem;">
                    <input type="hidden" name="action" value="add">
                    <input type="hidden" name="id" value="<%= article.getId() %>">
                    <button type="submit" class="btn"><i class="fas fa-shopping-bag"></i> Ajouter au panier</button>
                </form>
            <% } %>
            <% if (isAdmin) { %>
                <div class="admin-panel">
                    <h3>Administration</h3>
                    <a href="admin?action=edit&id=<%= article.getId() %>" class="btn"><i class="fas fa-pen"></i> Modifier</a>
                    <form action="admin" method="post" style="display:inline;">
                        <input type="hidden" name="action" value="delete">
                        <input type="hidden" name="id" value="<%= article.getId() %>">
                        <button type="submit" class="btn btn-danger" onclick="return confirm('Supprimer cet article ?');"><i class="fas fa-trash"></i> Supprimer</button>
                    </form>
                </div>
            <% } %>
        </div>
    </div>
<% } %>
</main>

<%@ include file="footer.jsp" %>

</body>
</html>