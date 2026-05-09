<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ page import="com.mycompany.eleganceapp.model.User" %>
        <%@ page import="java.util.List" %>
            <% User currentUser=(User) session.getAttribute("currentUser"); if (currentUser==null ||
                !"admin".equalsIgnoreCase(currentUser.getRole())) { response.sendRedirect("home"); return; } List<User>
                userList = (List<User>) request.getAttribute("users");

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

                            <div id="toastContainer" class="toast-container"
                                data-success="<%= (success != null) ? success : "" %>"
                                data-error="<%= (error != null) ? error : "" %>"></div>

                            <main>
                                <div class="admin-container">
                                    <h1 class="font-display text-gold" style="margin-bottom: 30px;">Gestion des
                                        Utilisateurs
                                    </h1>

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
                                            <% if (userList !=null) { for (User u : userList) { %>
                                                <tr data-user-id="<%= u.getId() %>">
                                                    <td>
                                                        <%= u.getId() %>
                                                    </td>
                                                    <td>
                                                        <%= u.getUsername() %>
                                                    </td>
                                                    <td>
                                                        <% String roleColor="inherit" ; if
                                                            ("admin".equalsIgnoreCase(u.getRole())) {
                                                            roleColor="var(--color-gold)" ; } %>
                                                            <span class="badge-role" style="color:<%=roleColor%>">
                                                                <%= u.getRole() %>
                                                            </span>
                                                    </td>
                                                    <td>
                                                        <% if (!currentUser.getId().equals(u.getId())) { %>
                                                            <button
                                                                onclick="deleteUser('<%= u.getId() %>', '<%= u.getUsername() %>')"
                                                                class="btn-delete">Supprimer</button>
                                                            <% } else { %>
                                                                <span
                                                                    style="color: grey; font-style: italic;">(Vous)</span>
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