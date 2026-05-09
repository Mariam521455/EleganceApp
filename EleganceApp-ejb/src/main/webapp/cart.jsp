<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="com.mycompany.eleganceapp.model.Cart" %>
<%@ page import="com.mycompany.eleganceapp.model.OrderItem" %>
<%@ page import="com.mycompany.eleganceapp.model.User" %>
<%@ page import="java.util.List" %>
<%
    // Prefer request attributes set by servlets, fallback to session
    User currentUser = (User) request.getAttribute("currentUser");
    if (currentUser == null) currentUser = (User) session.getAttribute("currentUser");
    if (currentUser == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    Cart cart = (Cart) session.getAttribute("cart");
    boolean isAdmin = false;
    Boolean isAdminAttr = (Boolean) request.getAttribute("isAdmin");
    if (isAdminAttr != null) isAdmin = isAdminAttr; else isAdmin = "admin".equalsIgnoreCase(currentUser.getRole());
%>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Élégance • Votre Panier</title>
    
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@400;500;600;700&family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">

    <style>
        <%@ include file="css/elegance.css" %>
        
        /* ── Harmonisation Panier avec système Élégance ────────────────── */
        :root {
            --gradient-cart: linear-gradient(135deg, var(--color-blush) 0%, var(--color-rose-nude) 100%);
        }

        main { 
            padding: var(--space-12) var(--space-6) var(--space-16);
            max-width: 1440px; 
            margin: 0 auto;
            background: var(--gradient-cart);
            min-height: 100vh;
        }

        /* Titre panier premium */
        .cart-title {
            font-family: var(--font-display);
            font-size: clamp(2.8rem, 8vw, 4.2rem);
            text-align: center;
            background: linear-gradient(135deg, var(--color-gold), var(--color-gold-dark));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            margin-bottom: var(--space-12);
            animation: luxuryReveal 1.8s var(--ease-luxe-out) forwards;
        }

        /* Grille panier avec animations cascade */
        .cart-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(380px, 1fr));
            gap: var(--space-8);
            margin-bottom: var(--space-12);
        }

        .cart-item-card {
            background: var(--color-surface);
            border-radius: var(--radius-lg);
            padding: var(--space-4);
            box-shadow: var(--shadow-md);
            transition: var(--transition-smooth);
            position: relative;
            overflow: hidden;
            animation: luxuryReveal var(--duration-elegant) var(--ease-luxe-out) forwards;
            max-width: 340px;
            min-width: 260px;
        }

        .cart-item-card:nth-child(1) { animation-delay: 0.2s; }
        .cart-item-card:nth-child(2) { animation-delay: 0.3s; }
        .cart-item-card:nth-child(3) { animation-delay: 0.4s; }

        .cart-item-card:hover {
            transform: translateY(-8px);
            box-shadow: var(--shadow-hover);
        }

        /* Image produit avec zoom subtil */
        .cart-item-img {
            width: 100%;
            height: 220px;
            object-fit: cover;
            border-radius: var(--radius-md);
            transition: transform 0.7s var(--ease-dreamy);
        }

        .cart-item-card:hover .cart-item-img {
            transform: scale(1.05);
        }

        /* Détails produit harmonisés */
        .cart-item-details h4 {
            font-family: var(--font-display);
            font-size: 1.4rem;
            margin: var(--space-2) 0;
        }

        .cart-item-price {
            font-size: 1.3rem;
            font-weight: 700;
            color: var(--color-gold-dark);
        }

        /* Spinner quantité premium */
        .cart-qty-spinner {
            display: flex;
            align-items: center;
            gap: var(--space-2);
            background: var(--color-surface-2);
            padding: var(--space-3) var(--space-4);
            border-radius: var(--radius-pill);
            border: 1px solid var(--color-border);
        }

        .qty-btn {
            width: 32px;
            height: 32px;
            border: none;
            background: var(--color-gold-light);
            color: var(--color-gold-dark);
            border-radius: 50%;
            font-weight: 600;
            cursor: pointer;
            transition: var(--transition-normal);
        }

        .qty-btn:hover {
            background: var(--color-gold);
            color: white;
            transform: scale(1.1);
        }

        /* Bouton suppression animé */
        .remove-btn {
            position: absolute;
            top: var(--space-4);
            right: var(--space-4);
            width: 36px;
            height: 36px;
            border-radius: 50%;
            background: rgba(201, 75, 75, 0.15);
            border: none;
            color: var(--color-danger);
            font-size: 1.1rem;
            cursor: pointer;
            transition: var(--transition-smooth);
            opacity: 0;
        }

        .cart-item-card:hover .remove-btn {
            opacity: 1;
            animation: breatheLux 2s infinite;
        }

        /* Summary total ultra-premium */
        .cart-summary {
            background: var(--color-surface);
            backdrop-filter: blur(20px);
            border: 1px solid var(--color-border);
            border-radius: var(--radius-lg);
            padding: var(--space-10);
            box-shadow: var(--shadow-lg);
            animation: elegantPop 1.5s var(--ease-soft-bounce) both;
        }

        .cart-total {
            font-family: var(--font-display);
            font-size: clamp(2.8rem, 10vw, 4.5rem);
            background: linear-gradient(135deg, var(--color-gold), var(--color-gold-dark));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            text-align: right;
            font-weight: 700;
        }

        /* Panier vide - Illustration dreamy */
        .empty-cart {
            text-align: center;
            padding: var(--space-16) var(--space-8);
            animation: luxuryReveal var(--duration-dreamy) forwards;
        }

        .empty-icon {
            font-size: 8rem;
            background: linear-gradient(135deg, var(--color-gold-light), var(--color-gold));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            margin-bottom: var(--space-8);
            animation: pulse-breath 4s infinite ease-in-out;
        }

        /* Toasts harmonisés Élégance */
        .toast {
            background: rgba(255,255,255,0.95);
            backdrop-filter: blur(24px);
            border: 1px solid var(--color-gold-light);
            box-shadow: var(--shadow-hover);
            animation: slideInGold 0.6s var(--ease-luxe-out) forwards;
        }

        @keyframes slideInGold {
            from { transform: translateX(100%) scale(0.95); opacity: 0; }
            to { transform: translateX(0) scale(1); opacity: 1; }
        }

        /* Responsive luxury */
        @media (max-width: 768px) {
            .cart-grid { grid-template-columns: 1fr; gap: var(--space-6); }
            main { padding: var(--space-8) var(--space-4) var(--space-16); }
        }
    </style>
</head>
<body>
    <%@ include file="header.jsp" %>
<%-- Flash messages are now rendered centrally in header.jsp --%>

    <main class="detail-main">
        <h1 class="cart-title reveal-lux golden-shine">Votre Collection</h1>

        <div id="cartContent">
            <% if (cart == null || cart.isEmpty()) { %>
                <div class="empty-cart reveal-lux">
                    <div class="empty-icon">🛍️</div>
                    <h2 class="h2 font-display text-gold-dark">Votre panier est encore vide</h2>
                    <p class="text-body text-secondary mb-4">Découvrez nos pièces d'exception pour sublimer votre style.</p>
                    <a href="home" class="btn btn-primary btn-pop-luxe btn-large pulse-breath">Commencer mes achats ✨</a>
                </div>
            <% } else { %>
                <div class="cart-grid">
                    <% for (OrderItem item : cart.getItems()) { 
                        String itemUrl = (item.getArticle().getImageUrl() != null && !item.getArticle().getImageUrl().isEmpty()) 
                            ? item.getArticle().getImageUrl() : "images/default.png"; 
                    %>
                        <div class="cart-item-card reveal-lux hover-bloom" id="item-<%= item.getArticle().getId() %>">
                            <img src="<%= itemUrl %>" alt="<%= item.getArticle().getName() %>" class="cart-item-img">
                            <button class="remove-btn" onclick="removeItem('<%= item.getArticle().getId() %>')" title="Retirer">✕</button>
                            
                            <div class="cart-item-details p-4">
                                <div class="text-tiny text-gold uppercase fw-600 mb-2">Article</div>
                                <h4 class="h4 mb-3"><%= item.getArticle().getName() %></h4>
                                <div class="cart-item-price text-gold-dark fw-700 fs-1-3"><%= item.getPrice() %> €</div>
                            </div>
                            
                            <div class="d-flex align-center gap-4 p-4">
                                <div class="cart-qty-spinner">
                                    <button class="qty-btn" onclick="updateQty('<%= item.getArticle().getId() %>', -1)">−</button>
                                    <span id="qty-<%= item.getArticle().getId() %>" class="fw-700 w-25 text-center"><%= item.getQuantity() %></span>
                                    <button class="qty-btn" onclick="updateQty('<%= item.getArticle().getId() %>', 1)">+</button>
                                </div>
                                <div class="text-right min-w-100px">
                                    <div class="text-tiny text-tertiary mb-1">Sous-total</div>
                                    <div id="subtotal-<%= item.getArticle().getId() %>" class="item-subtotal fw-700" 
                                         data-price="<%= item.getPrice() %>">
                                        <%= String.format("%.2f", item.getPrice() * item.getQuantity()) %> €
                                    </div>
                                </div>
                            </div>
                        </div>
                    <% } %>
                </div>

                <div class="cart-summary">
                    <div class="d-flex justify-between align-center">
                        <div>
                            <p class="text-secondary mb-2">Livraison Standard Offerte ✨</p>
                            <h3 class="h3 font-display">Total de votre sélection</h3>
                        </div>
                        <div id="cartTotal" class="cart-total"><%= String.format("%.2f", cart.getTotal()) %> €</div>
                    </div>
                    <div class="mt-8 d-flex justify-end gap-4">
                        <a href="home" class="btn btn-outline text-secondary">← Continuer les achats</a>
                        <form action="order" method="post">
                            <button type="submit" class="btn btn-primary btn-large btn-pop-luxe pulse-breath">Valider la Commande ✨</button>
                        </form>
                    </div>
                </div>
            <% } %>
        </div>
    </main>

    <%@ include file="footer.jsp" %>

    <script src="https://cdnjs.cloudflare.com/ajax/libs/axios/1.7.7/axios.min.js"></script>
    <script>
        // ======================================================
        // TA LOGIQUE 100% INTACTE (updateQty, removeItem, etc.)
        // ======================================================
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
                qtySpan.innerText = newQty;
                const price = parseFloat(subtotalSpan.dataset.price);
                const newSubtotal = price * newQty;
                subtotalSpan.innerText = newSubtotal.toFixed(2) + ' €';
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
            card.style.animation = 'fadeUp reverse 0.5s ease forwards';
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
                        location.reload();
                    }
                }, 500);
                showToast("Panier", "Article retiré ✨", "success");
            } catch (e) {
                card.style.animation = '';
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

        // Toast système Élégance (si pas dans elegance.js)
        function showToast(title, message, type = 'success') {
            const container = document.getElementById('toastContainer');
            const toast = document.createElement('div');
            toast.className = `toast ${type}`;
            toast.innerHTML = `<strong>${title}</strong><br>${message}`;
            container.appendChild(toast);
            setTimeout(() => toast.remove(), 4000);
        }
    </script>
</body>
</html>