<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ page import="java.util.List" %>
        <%@ page import="com.mycompany.eleganceapp.model.Category" %>
            <%@ page session="true" %>

                    <% List<Category> categories = (List<Category>) request.getAttribute("categories");
                       if (categories == null) categories = java.util.List.of(); // éviter null
                    %>

                            <!DOCTYPE html>
                            <html lang="fr">

                            <head>
                                <meta charset="UTF-8">
                                <title>Ajouter un article - Élégance</title>
                                <link
                                    href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@400;700&family=Lato:wght@300;400;700&display=swap"
                                    rel="stylesheet">

                                <style>
                                    body {
                                        font-family: 'Lato', sans-serif;
                                        background: linear-gradient(to bottom, #fffafc, #fceceb);
                                        display: flex;
                                        justify-content: center;
                                        align-items: center;
                                        min-height: 100vh;
                                        margin: 0;
                                    }

                                    .form-container {
                                        background: rgba(255, 255, 255, 0.35);
                                        backdrop-filter: blur(15px);
                                        padding: 40px;
                                        border-radius: 25px;
                                        width: 100%;
                                        max-width: 500px;
                                        box-shadow: 0 20px 50px rgba(212, 175, 55, 0.25);
                                    }

                                    h1 {
                                        font-family: 'Playfair Display', serif;
                                        text-align: center;
                                        margin-bottom: 30px;
                                        color: #4a3c34;
                                    }

                                    label {
                                        display: block;
                                        margin-top: 15px;
                                        font-weight: 600;
                                        color: #4a3c34;
                                    }

                                    input,
                                    textarea,
                                    select {
                                        width: 100%;
                                        padding: 10px 15px;
                                        margin-top: 5px;
                                        border-radius: 15px;
                                        border: 1px solid rgba(212, 175, 55, 0.4);
                                        font-family: 'Lato', sans-serif;
                                    }

                                    button {
                                        margin-top: 30px;
                                        width: 100%;
                                        padding: 12px;
                                        border-radius: 50px;
                                        border: none;
                                        background: linear-gradient(135deg, #fceceb, #d4af37);
                                        color: #fff;
                                        font-family: 'Playfair Display', serif;
                                        font-size: 16px;
                                        cursor: pointer;
                                        box-shadow: 0 10px 30px rgba(212, 175, 55, 0.4);
                                        transition: all 0.3s ease;
                                    }

                                    button:hover {
                                        transform: translateY(-2px);
                                        box-shadow: 0 15px 40px rgba(212, 175, 55, 0.5);
                                    }
                                </style>
                            </head>

                            <body>
                                <%@ include file="header.jsp" %>

                                <div class="form-container">
                                    <div style="text-align: left; margin-bottom: 15px;">
                                        <a href="home"
                                            style="color: #d4af37; text-decoration: none; font-weight: 600;">← Retour à
                                            l'accueil</a>
                                    </div>
                                    <h1>Ajouter un article</h1>

                                    <form action="admin" method="post">
                                        <input type="hidden" name="action" value="add">

                                        <label>Nom</label>
                                        <input type="text" name="name" required>

                                        <label>Description</label>
                                        <textarea name="description" rows="3" required></textarea>

                                        <label>Prix (€)</label>
                                        <input type="number" step="0.01" name="price" required>

                                        <label>Image (URL)</label>
                                        <input type="text" name="imageUrl">

                                        <label>Catégorie</label>
                                        <select name="categoryId" required>
                                            <option value="">-- Choisir une catégorie --</option>
                                            <% if (!categories.isEmpty()) { for (Category c : categories) { %>
                                                <option value="<%= c.getId() %>">
                                                    <%= c.getName() %>
                                                </option>
                                                <% } } else { %>
                                                    <option value="">Aucune catégorie disponible</option>
                                                    <% } %>
                                        </select>

                                        <div style="display: flex; align-items: center; gap: 10px; margin-top: 15px;">
                                            <input type="checkbox" id="enabled" name="enabled" checked
                                                style="width: auto; margin-top: 0;">
                                            <label for="enabled" style="margin-top: 0;">Disponible immédiatement</label>
                                        </div>

                                        <button type="submit">Ajouter l’article</button>
                                    </form>
                                </div>

                            </body>

                            </html>