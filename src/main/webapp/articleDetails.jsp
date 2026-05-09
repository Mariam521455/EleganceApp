<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ page import="com.mycompany.eleganceapp.model.Article" %>
        <%@ page import="com.mycompany.eleganceapp.model.User" %>
            <% Article article=(Article) request.getAttribute("article"); String status=(String)
                request.getAttribute("status"); User currentUser=(User) session.getAttribute("currentUser"); if
                (article==null) { response.sendRedirect("home.jsp"); return; } boolean isAdmin=currentUser !=null
                && "admin" .equalsIgnoreCase(currentUser.getRole()); String imageUrl=(article.getImageUrl() !=null &&
                !article.getImageUrl().isEmpty()) ? article.getImageUrl() : "images/default.png" ; boolean
                isAvailable="Disponible" .equals(status); %>
                <!DOCTYPE html>
                <html lang="fr">

                <head>
                    <meta charset="UTF-8">
                    <title>Élégance - <%= article.getName() %>
                    </title>
                    <link rel="stylesheet" href="css/elegance.css">
                    <link
                        href="https://fonts.googleapis.com/css2?family=Playfair+Display:ital,wght@0,400;0,700;1,400&family=Lato:wght@300;400;700&display=swap"
                        rel="stylesheet">
                </head>

                <body>
                    <%@ include file="header.jsp" %>
                        <main class="detail-main">
                            <div class="boutique-grid">
                                <div class="img-wrapper">
                                    <img src="<%= imageUrl %>" alt="<%= article.getName() %>"
                                        style="width: 100%; border-radius: 20px;">
                                </div>
                                <div class="info-wrapper">
                                    <div class="article-cat text-gold"
                                        style="font-weight: 700; letter-spacing: 3px; margin-bottom: 15px;">
                                        <%= (article.getCategory() !=null) ?
                                            article.getCategory().getName().toUpperCase() : "COLLECTION EXCLUSIVE" %>
                                    </div>
                                    <h1 class="article-title font-display"
                                        style="font-size: 3rem; margin-bottom: 25px;">
                                        <%= article.getName() %>
                                    </h1>
                                    <div class="article-price font-display"
                                        style="font-size: 2.5rem; color: var(--color-gold); margin-bottom: 30px;">
                                        <%= article.getPrice() %> €
                                    </div>
                                    <p class="article-desc"
                                        style="font-size: 1.1rem; color: #666; margin-bottom: 40px;">
                                        <%= (article.getDescription() !=null && !article.getDescription().isEmpty()) ?
                                            article.getDescription()
                                            : "Cette pièce d'exception incarne l'élégance pure de notre Maison." %>
                                    </p>
                                    <div class="actions">
                                        <% if (currentUser !=null) { %>
                                            <% if (isAvailable) { %>
                                                <form action="cart" method="post">
                                                    <input type="hidden" name="action" value="add">
                                                    <input type="hidden" name="id" value="<%= article.getId() %>">
                                                    <button type="submit" class="btn-luxury">✨ Ajouter au
                                                        Panier</button>
                                                </form>
                                                <% } else { %>
                                                    <button class="btn-luxury"
                                                        style="background: #ccc; cursor: not-allowed;"
                                                        disabled>Indisponible</button>
                                                    <% } %>
                                                        <% } else { %>
                                                            <a href="login.jsp" class="btn-luxury">Se connecter pour
                                                                commander</a>
                                                            <% } %>
                                    </div>
                                    <% if (isAdmin) { %>
                                        <div class="admin-panel"
                                            style="margin-top: 50px; padding-top: 30px; border-top: 1px solid rgba(212,175,55,0.1);">
                                            <h4 class="font-display" style="margin-bottom: 20px;">Administration</h4>
                                            <a href="admin?action=edit&id=<%= article.getId() %>"
                                                class="btn-admin btn-edit">Modifier</a>
                                            <form action="admin" method="post" style="display:inline;"
                                                onsubmit="return confirm('Supprimer ?')">
                                                <input type="hidden" name="action" value="delete">
                                                <input type="hidden" name="id" value="<%= article.getId() %>">
                                                <button type="submit" class="btn-admin btn-delete">Supprimer</button>
                                            </form>
                                        </div>
                                        <% } %>
                                </div>
                            </div>
                        </main>
                        <%@ include file="footer.jsp" %>
                </body>

                </html>