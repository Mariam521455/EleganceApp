<%@ page import="com.mycompany.eleganceapp.model.Article" %>
    <%@ page import="com.mycompany.eleganceapp.model.Category" %>
        <%@ page import="com.mycompany.eleganceapp.model.User" %>
            <%@ page import="java.util.List" %>
                <%@ page session="true" %>

                    <%
                        // Affichage uniquement: récupérer les attributs passés par le servlet
                        Article article = (Article) request.getAttribute("articleToEdit");
                        @SuppressWarnings("unchecked")
                        List<Category> categories = (List<Category>) request.getAttribute("categories");
                        if (article == null) {
                            response.sendRedirect("home");
                            return;
                        }
                        User currentUser = (User) session.getAttribute("currentUser");
                    %>

                        <!DOCTYPE html>
                        <html lang="fr">

                        <head>
                            <meta charset="UTF-8">
                            <meta name="viewport" content="width=device-width, initial-scale=1.0">
                            <title>Modifier un article - Élégance</title>
                            <link
                                href="https://fonts.googleapis.com/css2?family=Playfair+Display:ital,wght@0,400;0,700;1,400&family=Lato:wght@300;400;700&display=swap"
                                rel="stylesheet">
                            <link rel="stylesheet" href="css/elegance.css">
                            <style>
                                /* ===== HEADER ===== */
                                header {
                                    padding: 15px 20px 15px;
                                    text-align: center;
                                    background: rgba(255, 255, 255, 0.3);
                                    backdrop-filter: blur(14px);
                                    box-shadow: 0 4px 15px rgba(212, 175, 55, 0.1);
                                    border-bottom: 1px solid rgba(212, 175, 55, 0.2);
                                    position: sticky;
                                    top: 0;
                                    z-index: 100;
                                }

                                .logo-wrapper {
                                    display: flex;
                                    justify-content: center;
                                    margin-bottom: 10px;
                                }

                                .luxury-logo {
                                    width: 320px;
                                    height: 80px;
                                    object-fit: contain;
                                    display: block;
                                    filter: drop-shadow(0 6px 15px rgba(212, 175, 55, 0.45));
                                    transition: transform 0.3s ease;
                                }

                                .luxury-logo:hover {
                                    transform: scale(1.08);
                                }

                                .welcome-msg {
                                    font-size: 18px;
                                    color: #4a3c34;
                                    margin-bottom: 10px;
                                }

                                a.back-link {
                                    display: inline-block;
                                    margin-top: 5px;
                                    color: #d4af37;
                                    text-decoration: none;
                                    font-weight: 600;
                                }

                                a.back-link:hover {
                                    text-decoration: underline;
                                }

                                /* ===== MAIN FORM ===== */
                                main {
                                    padding: 20px;
                                    flex: 1;
                                    max-width: 600px;
                                    margin: 20px auto 50px auto;
                                    background: rgba(255, 255, 255, 0.25);
                                    backdrop-filter: blur(12px);
                                    border-radius: 25px;
                                    box-shadow: 0 15px 30px rgba(212, 175, 55, 0.08);
                                }

                                h2 {
                                    font-family: 'Playfair Display', serif;
                                    font-size: 28px;
                                    text-align: center;
                                    color: #4a3c34;
                                    margin-bottom: 25px;
                                }

                                form {
                                    display: flex;
                                    flex-direction: column;
                                    gap: 15px;
                                }

                                label {
                                    font-weight: 600;
                                    color: #4a3c34;
                                    margin-bottom: 5px;
                                }

                                input[type="text"],
                                input[type="number"],
                                textarea {
                                    padding: 12px 15px;
                                    border-radius: 15px;
                                    border: 1px solid rgba(212, 175, 55, 0.4);
                                    background: rgba(255, 255, 255, 0.6);
                                    font-family: 'Lato', sans-serif;
                                    font-size: 14px;
                                    outline: none;
                                    transition: all 0.3s ease;
                                }

                                input[type="text"]:focus,
                                input[type="number"]:focus,
                                textarea:focus {
                                    border-color: #d4af37;
                                    box-shadow: 0 0 12px rgba(212, 175, 55, 0.25);
                                }

                                textarea {
                                    resize: vertical;
                                    min-height: 120px;
                                }

                                button[type="submit"] {
                                    padding: 14px 28px;
                                    border-radius: 50px;
                                    border: none;
                                    background: linear-gradient(135deg, #fceceb, #d4af37);
                                    color: #fff;
                                    font-family: 'Playfair Display', serif;
                                    font-weight: 600;
                                    font-size: 16px;
                                    cursor: pointer;
                                    box-shadow: 0 10px 25px rgba(212, 175, 55, 0.3);
                                    transition: all 0.3s ease;
                                }

                                button[type="submit"]:hover {
                                    transform: translateY(-2px) scale(1.05);
                                    box-shadow: 0 15px 35px rgba(212, 175, 55, 0.4);
                                }

                                @media (max-width: 768px) {
                                    main {
                                        padding: 15px;
                                    }
                                }

                                @media (max-width: 480px) {
                                    .luxury-logo {
                                        max-width: 200px;
                                        max-height: 60px;
                                    }

                                    h2 {
                                        font-size: 22px;
                                    }
                                }
                            </style>
                        </head>

                        <body>
                            <header>
                                <div class="logo-wrapper">
                                    <img src="images/elegance-logo.png" alt="Élégance Logo" class="luxury-logo">
                                </div>
                                <div class="welcome-msg">Admin : <%= currentUser != null ? currentUser.getUsername() : "(inconnu)" %>
                                </div>
                                <a href="home" class="back-link">← Retour à l'accueil</a>
                            </header>

                            <main>
                                <h2>Modifier l'article : <%= article.getName() %>
                                </h2>
                                <form action="admin" method="post">
                                    <input type="hidden" name="id" value="<%= article.getId() %>">
                                    <input type="hidden" name="action" value="update">

                                    <label>Nom :</label>
                                    <input type="text" name="name" value="<%= article.getName() %>" required>

                                    <label>Description :</label>
                                    <textarea name="description" required><%= article.getDescription() %></textarea>

                                    <label>Prix :</label>
                                    <input type="number" step="0.01" name="price" value="<%= article.getPrice() %>"
                                        required>

                                    <label>URL image :</label>
                                    <input type="text" name="imageUrl" value="<%= article.getImageUrl() %>" required>

                                    <label>Catégorie :</label>
                                    <select name="categoryId" required
                                        style="width: 100%; padding: 12px 15px; border-radius: 15px; border: 1px solid rgba(212, 175, 55, 0.4); background: rgba(255, 255, 255, 0.6); font-family: 'Lato', sans-serif; font-size: 14px; outline: none; margin-top: 5px;">
                                        <% if (categories !=null) { for (Category c : categories) { boolean
                                            selected=article.getCategory() !=null &&
                                            article.getCategory().getId().equals(c.getId()); %>
                                            <option value="<%= c.getId() %>" <%=selected ? "selected" : "" %>><%=
                                                    c.getName() %>
                                            </option>
                                            <% } } %>
                                    </select>

                                    <div style="display: flex; align-items: center; gap: 10px; margin-top: 10px;">
                                        <label for="enabled" style="margin: 0;">Disponible :</label>
                                        <input type="checkbox" id="enabled" name="enabled"
                                            <%=Boolean.TRUE.equals(article.getEnabled()) ? "checked" : "" %>>
                                    </div>

                                    <button type="submit">Enregistrer les modifications</button>
                                </form>
                            </main>
                        </body>

                        </html>