<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.mycompany.eleganceapp.model.User" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%
    User currentUser = (User) request.getAttribute("currentUser");
    if (currentUser == null) {
        currentUser = (User) session.getAttribute("currentUser");
    }
    if (currentUser == null || !"admin".equalsIgnoreCase(currentUser.getRole())) {
        response.sendRedirect("home");
        return;
    }
%>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Gestion des utilisateurs - Élégance</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
    <style>
        body { font-family: 'Inter', sans-serif; background: #fff5f7; color: #2f1e18; margin: 0; padding: 2rem; }
        h1 { text-align: center; color: #d4af37; margin-bottom: 2rem; }
        table { width: 100%; border-collapse: collapse; background: #fff; border-radius: 12px; overflow: hidden; box-shadow: 0 10px 32px rgba(212,175,55,0.1); }
        th, td { padding: 1rem; text-align: left; border-bottom: 1px solid #f0e6e6; }
        th { background: #ffd9e0; color: #2f1e18; }
        tr:hover { background: #ffebee; }
        .btn { padding: 0.5rem 1rem; border-radius: 9999px; border: none; cursor: pointer; font-weight: 600; transition: all 0.3s; }
        .btn-edit { background: #d4af37; color: #fff; }
        .btn-edit:hover { background: #b38c3a; }
        .btn-delete { background: #ffebee; color: #c62828; }
        .btn-delete:hover { background: #ffcdd2; }
        .flash { margin-bottom: 1.5rem; padding: 1rem; border-radius: 12px; font-weight: 600; text-align: center; }
        .flash-success { background: rgba(61,156,95,0.12); color: #3d9c5f; }
        .flash-error { background: rgba(201,75,75,0.12); color: #c94b4b; }
        .top-actions { text-align: right; margin-bottom: 1rem; }
        .top-actions a { text-decoration: none; color: #fff; background: #d4af37; padding: 0.6rem 1.2rem; border-radius: 9999px; font-weight: 600; transition: all 0.3s; }
        .top-actions a:hover { background: #b38c3a; }
    </style>
</head>
<body>

    <h1>Gestion des utilisateurs</h1>

    <!-- Flash messages -->
    <c:if test="${not empty flashSuccess}">
        <div class="flash flash-success"><c:out value="${flashSuccess}"/></div>
    </c:if>
    <c:if test="${not empty flashError}">
        <div class="flash flash-error"><c:out value="${flashError}"/></div>
    </c:if>

    <div class="top-actions">
        <a href="${pageContext.request.contextPath}/home">← Retour Accueil</a>
    </div>

    <table>
        <thead>
            <tr>
                <th>ID</th>
                <th>Nom d'utilisateur</th>
                <th>Rôle</th>
                <th>Actions</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="user" items="${users}">
                <tr>
                    <td><c:out value="${user.id}"/></td>
                    <td><c:out value="${user.username}"/></td>
                    <td><c:out value="${user.role}"/></td>
                    <td>
                        <form action="${pageContext.request.contextPath}/manageUsers" method="post" style="display:inline; margin-right:8px;">
                            <input type="hidden" name="action" value="updateRole">
                            <input type="hidden" name="id" value="${user.id}">
                            <select name="role" style="padding:0.5rem 0.8rem; border-radius:9999px; border:1px solid #f0e6e6; margin-right:6px;">
                                <option value="user" ${user.role == 'user' ? 'selected' : ''}>user</option>
                                <option value="admin" ${user.role == 'admin' ? 'selected' : ''}>admin</option>
                            </select>
                            <button type="submit" class="btn btn-edit">
                                <i class="fas fa-edit"></i> Enregistrer
                            </button>
                        </form>

                        <!-- Supprimer -->
                        <form action="${pageContext.request.contextPath}/manageUsers" method="post" style="display:inline;" 
                              onsubmit="return confirm('Vraiment supprimer ${user.username} ?');">
                            <input type="hidden" name="action" value="delete">
                            <input type="hidden" name="id" value="${user.id}">
                            <button type="submit" class="btn btn-delete">
                                <i class="fas fa-trash-alt"></i> Supprimer
                            </button>
                        </form>
                    </td>
                </tr>
            </c:forEach>
            <c:if test="${empty users}">
                <tr>
                    <td colspan="4" style="text-align:center; padding:2rem;">Aucun utilisateur trouvé.</td>
                </tr>
            </c:if>
        </tbody>
    </table>

</body>
</html>
