<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ page import="com.mycompany.eleganceapp.model.Cart" %>
        <%@ page import="com.mycompany.eleganceapp.model.OrderItem" %>
            <%@ page import="com.mycompany.eleganceapp.model.User" %>
                <%@ page import="java.util.List" %>
                    <% User currentUser=(User) session.getAttribute("currentUser"); if (currentUser==null) {
                        response.sendRedirect("login.jsp"); return; } Cart cart=(Cart) session.getAttribute("cart");
                        String successMsg=(String) session.getAttribute("success"); String errorMsg=(String)
                        session.getAttribute("error"); session.removeAttribute("success");
                        session.removeAttribute("error"); %>
                        <!DOCTYPE html>
                        <html lang="fr">

                        <head>
                            <meta charset="UTF-8">
                            <title>Élégance - Votre Panier</title>
                            <link rel="stylesheet" href="css/elegance.css">
                        </head>

                        <body>
                            <%@ include file="header.jsp" %>

                                <div id="toastContainer" class="toast-container"
                                    data-success="<%= successMsg != null ? successMsg : "" %>"
                                    data-error="<%= errorMsg != null ? errorMsg : "" %>">
                                </div>

                                <main class="detail-main">
                                    <h1 class="font-display text-gold" style="margin-bottom: 40px; text-align: center;">
                                        Votre Collection</h1>

                                    <div id="cartContent">
                                        <% if (cart==null || cart.isEmpty()) { %>
                                            <div
                                                style="text-align: center; padding: 80px 20px; animation: fadeInUp 0.8s ease;">
                                                <div style="font-size: 5rem; margin-bottom: 20px; opacity: 0.2;">🛍️
                                                </div>
                                                <h2 class="font-display" style="margin-bottom: 15px;">Votre panier est
                                                    encore vide</h2>
                                                <p style="color: #666; margin-bottom: 40px;">Découvrez nos pièces
                                                    d'exception pour sublimer votre style.</p>
                                                <a href="home" class="btn-luxury">Commencer mes achats ✨</a>
                                            </div>
                                            <% } else { %>
                                                <div class="cart-grid">
                                                    <% for (OrderItem item : cart.getItems()) { String
                                                        itemUrl=(item.getArticle().getImageUrl() !=null &&
                                                        !item.getArticle().getImageUrl().isEmpty()) ?
                                                        item.getArticle().getImageUrl() : "images/default.png" ; %>
                                                        <div class="cart-item-card"
                                                            id="item-<%= item.getArticle().getId() %>">
                                                            <img src="<%= itemUrl %>" alt="Produit"
                                                                class="cart-item-img">

                                                            <div class="cart-item-details">
                                                                <div
                                                                    style="color: var(--color-gold); font-size: 0.8rem; letter-spacing: 1px; font-weight: 700;">
                                                                    ARTICLE</div>
                                                                <h4>
                                                                    <%= item.getArticle().getName() %>
                                                                </h4>
                                                                <div class="cart-item-price">
                                                                    <%= item.getPrice() %> €
                                                                </div>
                                                            </div>

                                                            <div style="display: flex; align-items: center; gap: 30px;">
                                                                <div class="cart-qty-spinner">
                                                                    <button class="qty-btn"
                                                                        onclick="updateQty('<%= item.getArticle().getId() %>', -1)">−</button>
                                                                    <span id="qty-<%= item.getArticle().getId() %>"
                                                                        style="font-weight: 700; width: 25px; text-align: center;">
                                                                        <%= item.getQuantity() %>
                                                                    </span>
                                                                    <button class="qty-btn"
                                                                        onclick="updateQty('<%= item.getArticle().getId() %>', 1)">+</button>
                                                                </div>

                                                                <div style="text-align: right; min-width: 100px;">
                                                                    <div
                                                                        style="font-size: 0.75rem; color: #999; margin-bottom: 5px;">
                                                                        SOUS-TOTAL</div>
                                                                    <div id="subtotal-<%= item.getArticle().getId() %>"
                                                                        class="item-subtotal"
                                                                        data-price="<%= item.getPrice() %>"
                                                                        style="font-weight: 700;">
                                                                        <%= String.format("%.2f", item.getPrice() *
                                                                            item.getQuantity()) %> €
                                                                    </div>
                                                                </div>

                                                                <button
                                                                    onclick="removeItem('<%= item.getArticle().getId() %>')"
                                                                    style="background: none; border: none; font-size: 1.2rem; cursor: pointer; opacity: 0.3;">✕</button>
                                                            </div>
                                                        </div>
                                                        <% } %>
                                                </div>

                                                <div class="cart-summary"
                                                    style="margin-top: 50px; background: white; padding: 40px; border-radius: 20px; box-shadow: var(--shadow-card);">
                                                    <div
                                                        style="display: flex; justify-content: space-between; align-items: center;">
                                                        <div>
                                                            <p style="color: #666; margin-bottom: 5px;">Livraison
                                                                Standard
                                                                Offerte ✨</p>
                                                            <h3 class="font-display">Total de votre sélection</h3>
                                                        </div>
                                                        <div id="cartTotal" class="font-display"
                                                            style="font-size: 2.5rem; color: var(--color-gold);">
                                                            <%= String.format("%.2f", cart.getTotal()) %> €
                                                        </div>
                                                    </div>
                                                    <div
                                                        style="margin-top: 30px; display: flex; justify-content: flex-end; gap: 20px;">
                                                        <a href="home"
                                                            style="padding: 15px 30px; color: #999; text-decoration: none; display: flex; align-items: center;">←
                                                            Continuer</a>
                                                        <form action="order" method="post">
                                                            <button type="submit" class="btn-luxury">Valider la
                                                                Commande</button>
                                                        </form>
                                                    </div>
                                                </div>
                                                <% } %>
                                    </div>
                                </main>

                                <%@ include file="footer.jsp" %>

                                    <script
                                        src="https://cdnjs.cloudflare.com/ajax/libs/axios/1.5.2/axios.min.js"></script>
                                    <script src="js/elegance.js"></script>
                                    <script>
                                        async function updateQty(id, delta) {
                                            const qtySpan = document.getElementById(`qty-${id}`);
                                            const subtotalSpan = document.getElementById(`subtotal-${id}`);
                                            const cartTotal = document.getElementById('cartTotal');

                                            let oldQty = parseInt(qtySpan.innerText);
                                            let newQty = oldQty + delta;
                                            if (newQty < 1) return;

                                            try {
                                                const params = new URLSearchParams();
                                                params.append('action', 'update');
                                                params.append('id', id);
                                                params.append('quantity', newQty);

                                                await axios.post('cart', params, {
                                                    headers: { 'X-Requested-With': 'XMLHttpRequest' }
                                                });

                                                // Update UI locally
                                                qtySpan.innerText = newQty;
                                                const price = parseFloat(subtotalSpan.dataset.price);
                                                const newSubtotal = price * newQty;
                                                subtotalSpan.innerText = newSubtotal.toFixed(2) + ' €';

                                                // Recalculate total
                                                recalculateTotal();
                                                showToast("Panier", "Quantité mise à jour ✨", "success");
                                            } catch (e) {
                                                console.error("Erreur mise à jour panier", e);
                                                showToast("Erreur", "Impossible de mettre à jour la quantité.", "error");
                                            }
                                        }

                                        async function removeItem(id) {
                                            if (!confirm('Retirer cet article de votre sélection ?')) return;

                                            const card = document.getElementById(`item-${id}`);
                                            card.classList.add('removing');

                                            try {
                                                const params = new URLSearchParams();
                                                params.append('action', 'remove');
                                                params.append('id', id);
                                                await axios.post('cart', params, {
                                                    headers: { 'X-Requested-With': 'XMLHttpRequest' }
                                                });

                                                setTimeout(() => {
                                                    card.remove();
                                                    recalculateTotal();
                                                    if (document.querySelectorAll('.cart-item-card').length === 0) {
                                                        location.reload(); // Show empty cart message
                                                    }
                                                }, 500);

                                                showToast("Panier", "Article retiré ✨", "success");
                                            } catch (e) {
                                                card.classList.remove('removing');
                                                console.error("Erreur suppression panier", e);
                                                showToast("Erreur", "Impossible de retirer l'article.", "error");
                                            }
                                        }

                                        function recalculateTotal() {
                                            const subtotals = document.querySelectorAll('.item-subtotal');
                                            let total = 0;
                                            subtotals.forEach(s => {
                                                total += parseFloat(s.innerText.replace(' €', '').replace(',', '.'));
                                            });
                                            document.getElementById('cartTotal').innerText = total.toFixed(2) + ' €';
                                        }
                                    </script>
                        </body>

                        </html>