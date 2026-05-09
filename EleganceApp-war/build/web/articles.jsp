<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.mycompany.eleganceapp.model.Article" %>
<%@ page import="com.mycompany.eleganceapp.model.User" %>

<%
    Article article = (Article) request.getAttribute("article");
    String status = (String) request.getAttribute("status");
    User currentUser = (User) session.getAttribute("currentUser");

    if (article == null) {
        response.sendRedirect(request.getContextPath() + "/home");
        return;
    }

    boolean isAdmin = currentUser != null && "admin".equalsIgnoreCase(currentUser.getRole());
    boolean isAvailable = "Disponible".equals(status);

    String imageUrl = (article.getImageUrl() != null && !article.getImageUrl().isEmpty())
            ? article.getImageUrl()
            : request.getContextPath() + "/images/default.png";

    request.setAttribute("imageUrl", imageUrl);
%>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Élégance - <%= article.getName() %></title>

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@400;700&family=Lato:wght@300;400;700&display=swap" rel="stylesheet">

    <style>
        /* ==== Reset & Base ==== */
        body {
            font-family: 'Lato', sans-serif;
            margin: 0;
            padding: 0;
            background-color: #fdf5f5;
            color: #4a4a4a;
        }

        h1, h4 {
            font-family: 'Playfair Display', serif;
            margin: 0 0 10px 0;
        }

        a {
            text-decoration: none;
            color: inherit;
        }

        button {
            cursor: pointer;
            border: none;
            outline: none;
        }

        /* ==== Main Grid ==== */
        .detail-main {
            max-width: 1200px;
            margin: 40px auto;
            padding: 0 20px;
        }

        .boutique-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 60px;
            align-items: start;
        }

        .img-wrapper {
            display: flex;
            justify-content: center;
            align-items: center;
            background: linear-gradient(135deg, #fdfaf8 0%, #f8f2ed 100%);
            border-radius: 30px;
            padding: 40px;
            box-shadow: 0 20px 60px rgba(212,175,55,0.15);
            border: 1px solid rgba(212,175,55,0.2);
        }

        .img-wrapper img {
            width: 100%;
            max-width: 400px;
            border-radius: 20px;
            object-fit: cover;
            box-shadow: 0 15px 40px rgba(0,0,0,0.1);
            transition: transform 0.3s ease;
        }

        .img-wrapper img:hover {
            transform: scale(1.02);
        }

        .info-wrapper {
            display: flex;
            flex-direction: column;
            gap: 25px;
            background: rgba(255,255,255,0.9);
            backdrop-filter: blur(20px);
            border-radius: 25px;
            padding: 40px;
            box-shadow: 0 20px 60px rgba(212,175,55,0.1);
            border: 1px solid rgba(212,175,55,0.15);
        }

        .article-cat {
            font-size: 0.9rem;
            font-weight: 700;
            letter-spacing: 2px;
            text-transform: uppercase;
            color: #d4af37;
            padding: 8px 16px;
            background: rgba(212,175,55,0.1);
            border-radius: 20px;
            display: inline-block;
        }

        .article-price {
            font-size: 2rem;
            font-weight: 700;
            color: #2f1e18;
            margin: 15px 0;
            font-family: 'Playfair Display', serif;
        }

        .article-desc {
            line-height: 1.7;
            font-size: 1.1rem;
            color: #4a4a4a;
            font-family: 'Lato', sans-serif;
        }

        /* ==== Buttons ==== */
        .btn-luxury {
            background: linear-gradient(135deg, #d4af37 0%, #b38c3a 100%);
            color: white;
            font-weight: 600;
            padding: 15px 35px;
            border-radius: 25px;
            transition: all 0.3s ease;
            box-shadow: 0 10px 30px rgba(212,175,55,0.3);
            font-size: 1rem;
            letter-spacing: 0.5px;
        }

        .btn-luxury:hover:not([disabled]) {
            background: linear-gradient(135deg, #e8d4a0 0%, #d4af37 100%);
            transform: translateY(-3px);
            box-shadow: 0 15px 40px rgba(212,175,55,0.4);
        }

        .btn-luxury:disabled {
            opacity: 0.6;
            cursor: not-allowed;
            background: #ccc;
        }

        .actions {
            margin-top: 30px;
        }

        /* ==== Admin Panel ==== */
        .admin-panel {
            margin-top: 40px;
            padding: 25px;
            background: linear-gradient(135deg, rgba(212,175,55,0.1) 0%, rgba(179,140,58,0.05) 100%);
            border-radius: 20px;
            border: 1px solid rgba(212,175,55,0.2);
            backdrop-filter: blur(10px);
        }

        .admin-panel h4 {
            font-family: 'Playfair Display', serif;
            font-size: 1.3rem;
            color: #d4af37;
            margin: 0 0 20px 0;
            font-weight: 700;
        }

        .btn-admin {
            padding: 12px 30px;
            border-radius: 20px;
            font-weight: 600;
            text-decoration: none;
            display: inline-block;
            transition: all 0.3s ease;
            font-size: 0.95rem;
            letter-spacing: 0.3px;
        }

        .btn-edit {
            background-color: #d4af37;
            color: white;
        }

        .btn-edit:hover {
            background-color: #b38c3a;
        }

        .btn-delete {
            background-color: #f44336;
            color: white;
        }

        .btn-delete:hover {
            background-color: #e57373;
        }

        /* ==== Responsive ==== */
        @media (max-width: 900px) {
            .boutique-grid {
                grid-template-columns: 1fr;
            }

            .img-wrapper img {
                max-height: 400px;
            }
        }
    </style>
</head>

<body>
<%@ include file="header.jsp" %>

<main class="detail-main">
    <div class="boutique-grid">

        <div class="img-wrapper">
            <img src="${imageUrl}" alt="<%= article.getName() %>">
        </div>

        <div class="info-wrapper">

            <div class="article-cat">
                <%= article.getCategory() != null ? article.getCategory().getName().toUpperCase() : "COLLECTION EXCLUSIVE" %>
            </div>

            <h1><%= article.getName() %></h1>

            <div class="article-price">
                <%= article.getPrice() %> CFA
            </div>

            <p class="article-desc">
                <%= article.getDescription() != null ? article.getDescription() : "Cette pièce d'exception incarne l'élégance pure de notre Maison." %>
            </p>

            <div class="actions">
                <% if (currentUser != null && !isAdmin) { %>
                    <% if (isAvailable) { %>
                        <form action="${pageContext.request.contextPath}/cart" method="post">
                            <input type="hidden" name="action" value="add">
                            <input type="hidden" name="id" value="<%= article.getId() %>">
                            <button type="submit" class="btn-luxury">
                                ✨ Ajouter au panier
                            </button>
                        </form>
                    <% } else { %>
                        <button disabled class="btn-luxury">Indisponible</button>
                    <% } %>
                <% } else if (currentUser == null) { %>
                    <a href="${pageContext.request.contextPath}/login" class="btn-luxury">
                        Se connecter pour commander
                    </a>
                <% } %>
            </div>

            <% if (isAdmin) { %>
                <div class="admin-panel">
                    <h4>Administration</h4>

                    <a href="${pageContext.request.contextPath}/admin?action=edit&id=<%= article.getId() %>"
                       class="btn-admin btn-edit">Modifier</a>
                </div>
            <% } %>

        </div>
    </div>
</main>

</body>
</html>
