<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.mycompany.eleganceapp.model.Order" %>
<%@ page import="com.mycompany.eleganceapp.model.OrderItem" %>
<%@ page import="com.mycompany.eleganceapp.model.User" %>
<%@ page import="java.util.List" %>
<%@ page import="java.time.LocalDateTime" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%
    User currentUser = (User) session.getAttribute("currentUser");
    if (currentUser == null || !"admin".equalsIgnoreCase(currentUser.getRole())) {
        response.sendRedirect(request.getContextPath() + "/home");
        return;
    }

    List<Order> orders = (List<Order>) request.getAttribute("orders");
    DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");
%>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Élégance - Gestion des Commandes</title>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@300;400;500;600;700&family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">

    <style>
        :root {
            --color-gold: #d4af37;
            --color-gold-dark: #b38c3a;
            --color-gold-light: #e8d4a0;
            --color-text: #2f1e18;
            --color-text-light: #6b5a54;
            --color-bg: #fdfaf8;
            --color-white: #ffffff;
            --color-border: #e3d7c9;
            --color-success: #3d9c5f;
            --color-danger: #c94b4b;
            --color-info: #2196f3;
        }

        body {
            font-family: 'Inter', sans-serif;
            background: linear-gradient(165deg, var(--color-bg) 0%, #f8f2ed 100%);
            color: var(--color-text);
            margin: 0;
            padding: 0;
            min-height: 100vh;
        }

        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 40px 20px;
        }

        .page-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 40px;
            padding-bottom: 20px;
            border-bottom: 1px solid var(--color-border);
        }

        .page-title {
            font-family: 'Playfair Display', serif;
            font-size: 2.5rem;
            font-weight: 700;
            color: var(--color-gold);
            margin: 0;
        }

        .back-link {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            color: var(--color-gold);
            text-decoration: none;
            font-weight: 600;
            transition: all 0.3s ease;
        }

        .back-link:hover {
            color: var(--color-gold-dark);
            transform: translateX(-5px);
        }

        .orders-container {
            background: var(--color-white);
            border-radius: 20px;
            padding: 30px;
            box-shadow: 0 20px 60px rgba(212,175,55,0.1);
            border: 1px solid var(--color-border);
        }

        .orders-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }

        .orders-table th {
            font-family: 'Playfair Display', serif;
            font-size: 1.1rem;
            font-weight: 600;
            color: var(--color-text);
            text-align: left;
            padding: 15px;
            border-bottom: 2px solid var(--color-gold);
            background: rgba(212,175,55,0.05);
        }

        .orders-table td {
            padding: 15px;
            border-bottom: 1px solid var(--color-border);
            vertical-align: top;
        }

        .orders-table tr:hover {
            background: rgba(212,175,55,0.02);
        }

        .order-id {
            font-weight: 700;
            color: var(--color-gold-dark);
        }

        .order-user {
            font-weight: 600;
        }

        .order-date {
            color: var(--color-text-light);
            font-size: 0.9rem;
        }

        .order-items {
            margin: 10px 0;
            font-size: 0.9rem;
            color: var(--color-text-light);
        }

        .order-items li {
            margin-bottom: 5px;
            padding-left: 10px;
            position: relative;
        }

        .order-items li:before {
            content: "•";
            color: var(--color-gold);
            position: absolute;
            left: 0;
        }

        .order-total {
            font-weight: 700;
            color: var(--color-gold-dark);
            font-size: 1.1rem;
        }

        .actions {
            display: flex;
            gap: 10px;
            align-items: center;
            flex-wrap: wrap;
        }

        .btn {
            padding: 8px 16px;
            border-radius: 20px;
            font-weight: 600;
            font-size: 0.85rem;
            cursor: pointer;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            transition: all 0.3s ease;
            border: none;
        }

        .btn-view {
            background: var(--color-gold);
            color: white;
        }

        .btn-view:hover {
            background: var(--order-gold-dark);
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(212,175,55,0.3);
        }

        .btn-delete {
            background: var(--color-danger);
            color: white;
        }

        .btn-delete:hover {
            background: #a03530;
            transform: translateY(-2px);
        }

        .btn-update {
            background: var(--color-success);
            color: white;
        }

        .btn-update:hover {
            background: #2e7d32;
            transform: translateY(-2px);
        }

        .btn-close {
            background: var(--color-text-light);
            color: white;
        }

        .btn-close:hover {
            background: var(--color-text);
            transform: translateY(-2px);
        }

        .no-orders {
            text-align: center;
            padding: 60px 20px;
            color: var(--color-text-light);
        }

        .no-orders-icon {
            font-size: 4rem;
            color: var(--color-gold);
            margin-bottom: 20px;
            opacity: 0.7;
        }

        .no-orders-title {
            font-family: 'Playfair Display', serif;
            font-size: 2rem;
            color: var(--color-text);
            margin-bottom: 10px;
        }

        .no-orders-text {
            font-size: 1.1rem;
            max-width: 400px;
            line-height: 1.6;
            margin: 0 auto;
        }

        .order-details {
            margin-top: 30px;
            padding: 25px;
            background: rgba(212,175,55,0.05);
            border-radius: 16px;
            border: 1px solid var(--color-border);
        }

        .order-details h2 {
            font-family: 'Playfair Display', serif;
            color: var(--color-text);
            margin: 0 0 20px 0;
        }

        .order-form {
            display: flex;
            gap: 15px;
            align-items: center;
            flex-wrap: wrap;
        }

        .order-form label {
            font-weight: 600;
            color: var(--color-text);
        }

        .order-form input {
            padding: 10px 15px;
            border-radius: 12px;
            border: 1px solid var(--color-border);
            font-size: 1rem;
            min-width: 150px;
        }

        @media (max-width: 768px) {
            .page-header {
                flex-direction: column;
                text-align: center;
                gap: 20px;
            }

            .orders-container {
                padding: 20px;
            }

            .orders-table {
                font-size: 0.9rem;
            }

            .orders-table th,
            .orders-table td {
                padding: 10px;
            }

            .actions {
                flex-direction: column;
                align-items: stretch;
            }

            .btn {
                justify-content: center;
            }
        }
    </style>
</head>
<body>

<%@ include file="header.jsp" %>

<div class="container">
    <div class="page-header">
        <h1 class="page-title">Gestion des Commandes</h1>
        <a href="${pageContext.request.contextPath}/home" class="back-link">
            <i class="fas fa-arrow-left"></i> Retour à l'accueil
        </a>
    </div>

    <div class="orders-container">
        <c:if test="${empty orders}">
            <div class="no-orders">
                <div class="no-orders-icon">
                    <i class="fas fa-shopping-bag"></i>
                </div>
                <h2 class="no-orders-title">Aucune commande</h2>
                <p class="no-orders-text">Aucune commande n'a été passée pour le moment.</p>
            </div>
        </c:if>

        <c:if test="${not empty orders}">
            <table class="orders-table">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Client</th>
                        <th>Date</th>
                        <th>Articles</th>
                        <th>Total</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <% 
                    if (orders != null) {
                        for (Order order : orders) {
                    %>
                        <tr>
                            <td class="order-id">#<%= order.getId() %></td>
                            <td class="order-user"><%= order.getUser().getUsername() %></td>
                            <td class="order-date">
                                <%= order.getOrderDate().format(dateFormatter) %>
                            </td>
                            <td>
                                <ul class="order-items">
                                    <% 
                                    if (order.getItems() != null) {
                                        for (OrderItem item : order.getItems()) {
                                    %>
                                        <li><%= item.getQuantity() %> × <%= item.getArticle().getName() %> (<%= item.getPrice() %> CFA)</li>
                                    <% 
                                        }
                                    }
                                    %>
                                </ul>
                            </td>
                           <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<td class="order-total">
    <fmt:formatNumber value="${order.totalAmount}" 
                      type="number" 
                      groupingUsed="true" 
                      maxFractionDigits="0"/> CFA
</td>

                            <td>
                                <div class="actions">
                                    <a href="${pageContext.request.contextPath}/admin?action=orders&mode=view&id=<%= order.getId() %>" class="btn btn-view">
                                        <i class="fas fa-eye"></i> Voir
                                    </a>

                                    <form action="${pageContext.request.contextPath}/admin" method="post" style="display:inline;" class="order-delete-form" data-order-id="<%= order.getId() %>">
                                        <input type="hidden" name="action" value="order_delete">
                                        <input type="hidden" name="id" value="<%= order.getId() %>">
                                        <button type="submit" class="btn btn-delete">
                                            <i class="fas fa-trash"></i> Supprimer
                                        </button>
                                    </form>
                                </div>
                            </td>
                        </tr>
                    <% 
                        }
                    }
                    %>
                </tbody>
            </table>

            <c:if test="${not empty selectedOrder}">
                <div class="order-details">
                    <h2>Détails de la commande #${selectedOrder.id}</h2>

                    <form action="${pageContext.request.contextPath}/admin" method="post" class="order-form">
                        <input type="hidden" name="action" value="order_update">
                        <input type="hidden" name="id" value="${selectedOrder.id}">
                        
                        <label for="totalAmount">Total (CFA) :</label>
                        <input type="number" id="totalAmount" name="totalAmount" value="${selectedOrder.totalAmount}" step="0.01" min="0">
                        
                        <button type="submit" class="btn btn-update">
                            <i class="fas fa-save"></i> Mettre à jour
                        </button>
                        
                        <a href="${pageContext.request.contextPath}/home" class="btn btn-close">
                            <i class="fas fa-times"></i> Fermer
                        </a>
                    </form>
                </div>
            </c:if>
        </c:if>
    </div>
</div>

<script>
document.addEventListener('DOMContentLoaded', () => {
    document.querySelectorAll('.order-delete-form').forEach((form) => {
        form.addEventListener('submit', (e) => {
            const id = form.getAttribute('data-order-id');
            if (!confirm('Êtes-vous sûr de vouloir supprimer la commande #' + id + ' ?')) {
                e.preventDefault();
            }
        });
    });
});
</script>

</body>
</html>
