<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.mycompany.eleganceapp.model.User" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ page import="java.util.List" %>
            <% List<User> userList = (List<User>) request.getAttribute("users");

                    String error = (String) session.getAttribute("error");
                    String success = (String) session.getAttribute("success");
                    session.removeAttribute("error");
                    session.removeAttribute("success");
                    %>
                    <!DOCTYPE html>
                    <html lang="fr">

                    <head>
                        <meta charset="UTF-8">
                        <title>Élégance - Gestion Utilisateurs</title>
                        <link rel="stylesheet" href="css/elegance.css">
                    </head>

                    <body>
                        <%@ include file="header.jsp" %>

<%-- Flash messages are now rendered centrally in header.jsp --%>

                            <main>
                                <div class="admin-container" style="max-width:1200px;margin:0 auto;padding:2.5rem 1.5rem;">
                                    <h1 class="font-display text-gold" style="margin-bottom:2.2rem;">Gestion des Utilisateurs</h1>
                                    <table style="width:100%;border-radius:16px;box-shadow:0 10px 32px rgba(212,175,55,0.10);overflow:hidden;background:white;">
                                        <thead style="background:var(--color-blush);">
                                            <tr style="font-size:1.1rem;color:var(--color-gold-dark);">
                                                <th style="padding:1rem 0.5rem;">ID</th>
                                                <th style="padding:1rem 0.5rem;">Nom d'utilisateur</th>
                                                <th style="padding:1rem 0.5rem;">Rôle</th>
                                                <th style="padding:1rem 0.5rem;">Actions</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <% if (userList !=null) { for (User u : userList) { %>
                                                <tr data-user-id="<%= u.getId() %>" class="reveal-lux" style="transition:box-shadow 0.8s;">
                                                    <td style="padding:0.9rem 0.5rem;text-align:center;">
                                                        <%= u.getId() %>
                                                    </td>
                                                    <td style="padding:0.9rem 0.5rem;text-align:center;">
                                                        <%= u.getUsername() %>
                                                    </td>
                                                    <td style="padding:0.9rem 0.5rem;text-align:center;">
                                                        <% String roleColor="inherit" ; if ("admin".equalsIgnoreCase(u.getRole())) { roleColor="var(--color-gold)" ; } %>
                                                        <span class="badge-role" style="color:<%=roleColor%>;font-weight:600;"> <%= u.getRole() %> </span>
                                                    </td>
                                                    <td style="padding:0.9rem 0.5rem;text-align:center;">
                                                        <% if (!currentUser.getId().equals(u.getId())) { %>
                                                            <button type="button" onclick="window.location.href='admin?action=edit_user&id=<%= u.getId() %>'" class="btn-admin btn-edit hover-bloom" style="margin-right:0.5rem;"><i class="fas fa-pen"></i> Modifier</button>
                                                            <button type="button" onclick="deleteUser(<%= u.getId() %>, '<%= u.getUsername().replace("'","\\'") %>')" class="btn-admin btn-delete hover-bloom"><i class="fas fa-trash"></i> Supprimer</button>
                                                        <% } else { %>
                                                            <span style="color: grey; font-style: italic;">(Vous)</span>
                                                        <% } %>
                                                    </td>
                                                </tr>
                                            <% } } %>
                                        </tbody>
                                    </table>
                                </div>
                            </main>

                            <%@ include file="footer.jsp" %>

                                <script src="https://cdnjs.cloudflare.com/ajax/libs/axios/1.5.2/axios.min.js"></script>
                                <script src="js/elegance.js"></script>
                                <script>
                                    async function deleteUser(id, username) {
                                        if (!confirm(`Voulez-vous vraiment supprimer l'utilisateur ${username} ?`)) return;

                                        const row = document.querySelector(`tr[data-user-id="${id}"]`);

                                        try {
                                            const params = new URLSearchParams();
                                            params.append('action', 'delete');
                                            params.append('id', id);

                                            await axios.post('manageUsers', params, {
                                                headers: { 'X-Requested-With': 'XMLHttpRequest' }
                                            });

                                            if (row) {
                                                row.style.opacity = '0';
                                                row.style.transform = 'scale(0.9)';
                                                row.style.transition = 'all 0.5s ease';
                                                setTimeout(() => row.remove(), 500);
                                            }

                                            showToast("Succès", `L'utilisateur ${username} a été supprimé.`, "success");
                                        } catch (e) {
                                            console.error("Erreur suppression utilisateur", e);
                                            showToast("Erreur", "Impossible de supprimer l'utilisateur.", "error");
                                        }
                                    }
                                </script>
                    </body>

                    </html>