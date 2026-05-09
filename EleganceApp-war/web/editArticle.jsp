<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.mycompany.eleganceapp.model.User" %>
<%@ page import="com.mycompany.eleganceapp.model.Article" %>
<%@ page import="com.mycompany.eleganceapp.model.Category" %>
<%@ page import="java.util.List" %>
<%@ page session="true" %>

<% 
    User user = (User) session.getAttribute("currentUser"); 
    if (user == null || !"admin".equalsIgnoreCase(user.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    
    Article article = (Article) request.getAttribute("articleToEdit");
    List<Category> categories = (List<Category>) request.getAttribute("categories");
    
    if (article == null) {
        response.sendRedirect(request.getContextPath() + "/home");
        return;
    }
%>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Modifier un article – Élégance</title>
    
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@400;500;700&family=Lato:wght@300;400;600&display=swap" rel="stylesheet">

    <style>
        * {
            box-sizing: border-box;
        }
        body {
            font-family: 'Lato', sans-serif;
            background: linear-gradient(to bottom, #fffafc, #fceceb);
            min-height: 100vh;
            margin: 0;
            padding: 20px 15px;
            display: flex;
            justify-content: center;
            align-items: flex-start;
        }
        .form-container {
            background: rgba(255, 255, 255, 0.33);
            backdrop-filter: blur(16px);
            -webkit-backdrop-filter: blur(16px);
            padding: 40px;
            border-radius: 24px;
            width: 100%;
            max-width: 640px;
            box-shadow: 0 22px 55px rgba(212, 175, 55, 0.22);
            border: 1px solid rgba(212, 175, 55, 0.18);
        }
        .back-link {
            display: inline-block;
            margin-bottom: 20px;
            color: #d4af37;
            text-decoration: none;
            font-weight: 600;
            font-size: 0.98rem;
            transition: color 0.25s;
        }
        .back-link:hover {
            color: #b8972e;
            text-decoration: underline;
        }
        h1 {
            font-family: 'Playfair Display', serif;
            text-align: center;
            margin: 0 0 38px 0;
            color: #4a3c34;
            font-weight: 700;
            font-size: 2.1rem;
            letter-spacing: 0.4px;
        }
        label {
            display: block;
            margin: 18px 0 7px 0;
            font-weight: 600;
            color: #4a3c34;
            font-size: 0.98rem;
        }
        input, textarea, select {
            width: 100%;
            padding: 12px 16px;
            border-radius: 14px;
            border: 1px solid rgba(212, 175, 55, 0.38);
            background: rgba(255,255,255,0.65);
            font-family: 'Lato', sans-serif;
            font-size: 1rem;
            color: #3a2f27;
            transition: all 0.25s ease;
        }
        input:focus, textarea:focus, select:focus {
            outline: none;
            border-color: #d4af37;
            box-shadow: 0 0 0 3px rgba(212, 175, 55, 0.14);
            background: white;
        }
        textarea {
            min-height: 110px;
            resize: vertical;
        }
        .field-row {
            display: flex;
            gap: 24px;
            margin-top: 10px;
        }
        .field-row > div {
            flex: 1;
        }
        .checkbox-group {
            display: flex;
            align-items: center;
            gap: 12px;
            margin-top: 22px;
            margin-bottom: 10px;
        }
        .checkbox-group input[type="checkbox"] {
            width: 18px;
            height: 18px;
            accent-color: #d4af37;
        }
        .checkbox-group span {
            font-weight: 500;
            color: #4a3c34;
        }
        button[type="submit"] {
            margin-top: 38px;
            width: 100%;
            padding: 14px;
            border: none;
            border-radius: 50px;
            background: linear-gradient(135deg, #fceceb, #d4af37);
            color: white;
            font-family: 'Playfair Display', serif;
            font-size: 1.15rem;
            font-weight: 600;
            cursor: pointer;
            box-shadow: 0 10px 35px rgba(212, 175, 55, 0.38);
            transition: all 0.3s ease;
        }
        button[type="submit"]:hover {
            transform: translateY(-3px);
            box-shadow: 0 18px 50px rgba(212, 175, 55, 0.52);
        }

        @media (max-width: 520px) {
            .field-row {
                flex-direction: column;
                gap: 0;
            }
            .form-container {
                padding: 32px 24px;
            }
        }
    </style>
</head>
<body>

    <div class="form-container">
        
        <a href="${pageContext.request.contextPath}/home" class="back-link">← Retour à l'accueil</a>
        
        <h1>Modifier un article</h1>

        <form action="admin" method="post">
            <input type="hidden" name="id" value="<%= article.getId() %>">
            <input type="hidden" name="action" value="update">

            <label>Nom de l’article</label>
            <input type="text" name="name" value="<%= article.getName() %>" required>

            <label>Description</label>
            <textarea name="description" rows="4" required><%= article.getDescription() %></textarea>

            <div class="field-row">
                <div>
                    <label>Prix (€)</label>
                    <input type="number" step="0.01" name="price" value="<%= article.getPrice() %>" required>
                </div>
                <div>
                    <label>Image (URL)</label>
                    <input type="text" name="imageUrl" value="<%= article.getImageUrl() != null ? article.getImageUrl() : "" %>">
                </div>
            </div>

            <label>Catégorie</label>
            <select name="categoryId" required>
                <option value="">-- Choisir une catégorie --</option>
                <% if (categories != null) {
                    for (Category c : categories) {
                        boolean selected = article.getCategory() != null 
                                        && article.getCategory().getId().equals(c.getId());
                %>
                    <option value="<%= c.getId() %>" <%= selected ? "selected" : "" %>>
                        <%= c.getName() %>
                    </option>
                <% }} %>
            </select>

            <div class="checkbox-group">
                <input type="checkbox" name="enabled" 
                       id="enabled" 
                       <%= Boolean.TRUE.equals(article.getEnabled()) ? "checked" : "" %>>
                <span> Disponible immédiatement</span>
            </div>

            <button type="submit">Enregistrer les modifications</button>
        </form>
    </div>

</body>
</html>