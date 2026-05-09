<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    <%@ page import="com.mycompany.eleganceapp.model.Article" %>
        <%@ page import="com.mycompany.eleganceapp.model.Category" %>
            <%@ page import="java.util.List" %>
                <%@ page session="true" %>

                    <% List<Article> articles = (List<Article>) request.getAttribute("allArticles");
                       List<Category> categories = (List<Category>) request.getAttribute("categories");
                       if (articles == null) articles = java.util.List.of();
                       if (categories == null) categories = java.util.List.of();
                    %>

                                        <!DOCTYPE html>
                                        <html lang="fr">

                                        <head>
                                            <meta charset="UTF-8">
                                            <meta name="viewport" content="width=device-width, initial-scale=1.0">
                                            <title>Administration - Élégance</title>
                                            <link
                                                href="https://fonts.googleapis.com/css2?family=Playfair+Display:ital,wght@0,400;0,700;1,400&family=Lato:wght@300;400;700&display=swap"
                                                rel="stylesheet">
                                            <link rel="stylesheet" href="css/elegance.css">
                                        </head>

                                        <body>
                                            <%@ include file="header.jsp" %>

<%-- Flash messages are now rendered centrally in header.jsp --%>


                                                <main>
                                                    <div class="admin-container" style="max-width:1200px;margin:0 auto;padding:2.5rem 1.5rem;">
                                                        <h1 class="font-display text-gold" style="margin-bottom:2.2rem;">Gestion des Articles</h1>
                                                        <a href="admin?action=add_form" class="btn-primary btn-pop-luxe" style="margin-bottom:2.2rem;display:inline-block;">✨ Ajouter un article</a>

                                                        <div class="articles-grid">
                                                            <% for(Article a : articles) { %>
                                                                <div class="article-card reveal-lux hover-bloom">
                                                                    <div class="article-info">
                                                                        <h3 style="font-family:'Playfair Display',serif;font-size:1.3rem;margin-bottom:0.7rem;">
                                                                            <%= a.getName() %>
                                                                        </h3>
                                                                        <p style="color:#6d5c56;font-size:1rem;margin-bottom:0.7rem;">
                                                                            <%= a.getDescription() %>
                                                                        </p>
                                                                        <div class="price" style="font-size:1.15rem;font-weight:600;color:var(--color-gold-dark);margin-bottom:0.7rem;">
                                                                            <%= a.getPrice() %> €
                                                                        </div>
                                                                        <div class="category-label" style="font-size:0.92rem;color:var(--color-gold);margin-bottom:0.7rem;">
                                                                            <%= a.getCategory() !=null ? a.getCategory().getName() : "Non définie" %>
                                                                        </div>
                                                                        <div class="admin-actions" style="margin-top:1.1rem;display:flex;gap:0.7rem;justify-content:center;">
                                                                            <form action="admin" method="get" style="display:inline;">
                                                                                <input type="hidden" name="action" value="edit">
                                                                                <input type="hidden" name="id" value="<%= a.getId() %>">
                                                                                <button type="submit" class="btn-admin btn-edit"><i class="fas fa-pen"></i> Modifier</button>
                                                                            </form>
                                                                            <form action="admin" method="post" style="display:inline;">
                                                                                <input type="hidden" name="action" value="delete">
                                                                                <input type="hidden" name="id" value="<%= a.getId() %>">
                                                                                <button type="submit" class="btn-admin btn-delete" onclick="return confirm('Supprimer cet article ?')"><i class="fas fa-trash"></i> Supprimer</button>
                                                                            </form>
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                            <% } %>
                                                        </div>
                                                    </div>
                                                </main>
                                                <%@ include file="footer.jsp" %>
                                        </body>

                                        </html>