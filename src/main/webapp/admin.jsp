<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ page import="com.mycompany.eleganceapp.model.Article" %>
        <%@ page import="com.mycompany.eleganceapp.model.Category" %>
            <%@ page import="com.mycompany.eleganceapp.model.User" %>
                <%@ page import="java.util.List" %>
                    <%@ page session="true" %>

                        <% User user=(User) session.getAttribute("currentUser"); if(user==null ||
                            !"admin".equalsIgnoreCase(user.getRole())){ response.sendRedirect("login.jsp"); return; }
                            List<Article> articles = (List<Article>) request.getAttribute("allArticles");
                                List<Category> categories = (List<Category>) request.getAttribute("categories");
                                        if(articles == null) articles = List.of();
                                        if(categories == null) categories = List.of();
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
                                            <link rel="stylesheet" href="css/elegance.css">
                                        </head>

                                        <body>
                                            <%@ include file="header.jsp" %>

                                                <main>
                                                    <h2 class="font-display">Gérer les articles</h2>
                                                    <a href="admin?action=add_form" class="btn-luxury"
                                                        style="margin-bottom: 30px;">✨ Ajouter un article</a>

                                                    <div class="articles-container">
                                                        <% for(Article a : articles) { %>
                                                            <div class="article-card">
                                                                <h3>
                                                                    <%= a.getName() %>
                                                                </h3>
                                                                <p>
                                                                    <%= a.getDescription() %>
                                                                </p>
                                                                <p>Prix : <%= a.getPrice() %> €</p>
                                                                <p>Catégorie : <%= a.getCategory() !=null ?
                                                                        a.getCategory().getName() : "Non définie" %>
                                                                </p>

                                                                <form action="admin" method="get"
                                                                    style="display:inline;">
                                                                    <input type="hidden" name="action" value="edit">
                                                                    <input type="hidden" name="id"
                                                                        value="<%= a.getId() %>">
                                                                    <button type="submit"
                                                                        class="btn btn-edit">Modifier</button>
                                                                </form>

                                                                <form action="admin" method="post"
                                                                    style="display:inline;">
                                                                    <input type="hidden" name="action" value="delete">
                                                                    <input type="hidden" name="id"
                                                                        value="<%= a.getId() %>">
                                                                    <button type="submit" class="btn btn-delete"
                                                                        onclick="return confirm('Supprimer cet article ?')">Supprimer</button>
                                                                </form>
                                                            </div>
                                                            <% } %>
                                                    </div>
                                                </main>
                                                <%@ include file="footer.jsp" %>
                                        </body>

                                        </html>