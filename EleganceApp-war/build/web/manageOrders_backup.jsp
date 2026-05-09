<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.mycompany.eleganceapp.model.Order" %>
<%@ page import="com.mycompany.eleganceapp.model.OrderItem" %>
<%@ page import="com.mycompany.eleganceapp.model.User" %>
<%@ page import="java.util.List" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%
    User currentUser = (User) session.getAttribute("currentUser");
    if (currentUser == null || !"admin".equalsIgnoreCase(currentUser.getRole())) {
        response.sendRedirect(request.getContextPath() + "/home");
        return;
    }

    List<Order> orders = (List<Order>) request.getAttribute("orders");
%>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Élégance - Gestion des Commandes</title>
    <link rel="stylesheet" href="css/elegance.css">
    <style>
        .admin-container { background: white; padding: 40px; border-radius: 16px; box-shadow: 0 10px 32px rgba(212,175,55,0.10); margin-top: 20px; }
        table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        th, td { padding: 12px; border-bottom: 1px solid rgba(212,175,55,0.15); text-align: left; vertical-align: top; }
        th { font-family: 'Playfair Display', serif; color: #2f1e18; }
        .btn-view { padding: 6px 14px; border-radius: 12px; background: #d4af37; color: white; text-decoration: none; font-weight: 600; transition: all 0.3s ease; display:inline-block; margin-top:4px; }
        .btn-view:hover { transform: translateY(-2px); filter: brightness(1.1); }
        .order-items { margin-top: 10px; font-size: 0.95rem; }
        .order-items li { margin-bottom: 5px; }
        .order-total { font-weight: bold; color: #b38c3a; }
    </style>
</head>
<body>
<header>
    <a href="${pageContext.request.contextPath}/home">← Retour Accueil</a>
</header>

<main>
    <div class="admin-container">
        <h1 style="font-family: 'Playfair Display', serif; color: #d4af37; margin-bottom: 20px;">Gestion des Commandes</h1>

        <c:if test="${empty orders}">
            <p>Aucune commande pour le moment.</p>
        </c:if>

        <c:if test="${not empty orders}">
            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Utilisateur</th>
                        <th>Date</th>
                        <th>Détails</th>
                        <th>Total</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="order" items="${orders}">
                        <tr>
                            <td>${order.id}</td>
                            <td>${order.user.username}</td>
                            <td>${order.orderDate}</td>
                            <td>
                                <ul class="order-items">
                                    <c:forEach var="item" items="${order.items}">
                                        <li>${item.quantity} × ${item.article.name} (${item.price} CFA)</li>
                                    </c:forEach>
                                </ul>
                            </td>
                            <td class="order-total">${order.totalAmount} CFA</td>
                            <td>
                                <a href="${pageContext.request.contextPath}/admin?action=orders&mode=view&id=${order.id}" class="btn-view">Voir Détails</a>

                                <form action="${pageContext.request.contextPath}/admin" method="post" style="display:inline; margin-left:6px;" class="js-order-delete" data-order-id="${order.id}">
                                    <input type="hidden" name="action" value="order_delete">
                                    <input type="hidden" name="id" value="${order.id}">
                                    <button type="submit" class="btn-view" style="background:#c94b4b;">Supprimer</button>
                                </form>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>

            <c:if test="${not empty selectedOrder}">
                <div style="margin-top: 18px; padding-top: 12px; border-top: 1px solid rgba(212,175,55,0.15);">
                    <h2 style="font-family: 'Playfair Display', serif; color: #2f1e18; margin: 0 0 10px 0;">Détails commande #${selectedOrder.id}</h2>

                    <form action="${pageContext.request.contextPath}/admin" method="post" style="display:flex; gap:10px; align-items:center; flex-wrap:wrap;">
                        <input type="hidden" name="action" value="order_update">
                        <input type="hidden" name="id" value="${selectedOrder.id}">
                        <label style="font-weight:600;">Total (CFA)</label>
                        <input name="totalAmount" value="${selectedOrder.totalAmount}" style="padding:8px 10px; border-radius: 12px; border: 1px solid rgba(212,175,55,0.35);" />
                        <button type="submit" class="btn-view">Mettre à jour</button>
                        <a class="btn-view" href="${pageContext.request.contextPath}/home" style="background:#6e6b68;">Fermer</a>
                    </form>
                </div>
            </c:if>
        </c:if>
    </div>
</main>

<script>
document.addEventListener('DOMContentLoaded', () => {
    document.querySelectorAll('.js-order-delete').forEach((form) => {
        form.addEventListener('submit', (e) => {
            const id = form.getAttribute('data-order-id');
            if (!confirm('Supprimer la commande #' + id + ' ?')) {
                e.preventDefault();
            }
        });
    });
});
</script>
</body>
</html>
