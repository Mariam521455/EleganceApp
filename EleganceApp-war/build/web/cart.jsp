<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ page import="com.mycompany.eleganceapp.model.Cart" %>
        <%@ page import="com.mycompany.eleganceapp.model.OrderItem" %>
            <%@ page import="com.mycompany.eleganceapp.model.User" %>
                <% User currentUser=(User) session.getAttribute("currentUser"); if (currentUser==null) {
                    response.sendRedirect("login.jsp"); return; } Cart cart=(Cart) session.getAttribute("cart"); %>

                    <!DOCTYPE html>
                    <html lang="fr">

                    <head>
                        <meta charset="UTF-8">
                        <meta name="viewport" content="width=device-width, initial-scale=1.0">
                        <title>Votre panier – Élégance</title>

                        <link
                            href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@400;500;600;700&family=Lato:wght@300;400;500&display=swap"
                            rel="stylesheet">
                        <link rel="stylesheet"
                            href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">

                        <style>
                            :root {
                                --color-bg-start: #fdf8f9;
                                --color-bg-end: #fceef2;
                                --color-gold: #d4af37;
                                --color-gold-dark: #b8972e;
                                --color-text: #3f2c22;
                                --color-text-light: #5c4438;
                                --glass: rgba(255, 255, 255, 0.4);
                                --glass-border: rgba(212, 175, 55, 0.2);
                            }

                            * {
                                box-sizing: border-box;
                                margin: 0;
                                padding: 0;
                            }

                            body {
                                font-family: 'Lato', sans-serif;
                                background: linear-gradient(165deg, var(--color-bg-start) 0%, var(--color-bg-end) 100%);
                                min-height: 100vh;
                                color: var(--color-text);
                                padding: 40px 20px;
                                line-height: 1.6;
                            }

                            .cart-container {
                                background: var(--glass);
                                backdrop-filter: blur(20px);
                                -webkit-backdrop-filter: blur(20px);
                                border: 1px solid var(--glass-border);
                                border-radius: 30px;
                                padding: 50px;
                                max-width: 950px;
                                margin: 0 auto;
                                box-shadow: 0 30px 80px -25px rgba(212, 175, 55, 0.2);
                            }

                            .page-header {
                                margin-bottom: 50px;
                                text-align: center;
                            }

                            h1 {
                                font-family: 'Playfair Display', serif;
                                font-size: 3rem;
                                font-weight: 600;
                                margin-bottom: 10px;
                            }

                            /* --- Luxury Stepper --- */
                            .checkout-stepper {
                                display: flex;
                                align-items: center;
                                justify-content: center;
                                gap: 20px;
                                margin-top: 40px;
                            }

                            .step {
                                display: flex;
                                flex-direction: column;
                                align-items: center;
                                gap: 10px;
                                opacity: 0.3;
                                transition: all 0.5s cubic-bezier(0.4, 0, 0.2, 1);
                            }

                            .step.active {
                                opacity: 1;
                                transform: scale(1.1);
                            }

                            .step.completed {
                                opacity: 0.8;
                            }

                            .step.completed .step-num {
                                background: var(--color-gold);
                                color: white;
                                border-color: var(--color-gold);
                            }

                            .step-num {
                                width: 36px;
                                height: 36px;
                                border-radius: 50%;
                                background: #fff;
                                border: 2px solid var(--color-gold);
                                display: flex;
                                align-items: center;
                                justify-content: center;
                                font-weight: 700;
                                font-size: 0.95rem;
                                box-shadow: 0 4px 10px rgba(212, 175, 55, 0.1);
                            }

                            .step-label {
                                font-size: 0.75rem;
                                text-transform: uppercase;
                                letter-spacing: 2px;
                                font-weight: 700;
                                color: var(--color-text);
                            }

                            .step-line {
                                width: 60px;
                                height: 1px;
                                background: var(--color-gold);
                                opacity: 0.2;
                                margin-bottom: 28px;
                            }

                            /* --- Cart Items --- */
                            .cart-items-list {
                                margin-bottom: 40px;
                            }

                            .cart-item {
                                display: grid;
                                grid-template-columns: 120px 2fr 120px 120px 40px;
                                gap: 30px;
                                align-items: center;
                                padding: 25px 0;
                                border-bottom: 1px solid rgba(212, 175, 55, 0.1);
                            }

                            .cart-item:last-child {
                                border-bottom: none;
                            }

                            .cart-item-img {
                                width: 100%;
                                height: 120px;
                                object-fit: cover;
                                border-radius: 15px;
                                box-shadow: 0 8px 25px rgba(0, 0, 0, 0.06);
                            }

                            .cart-item-name {
                                font-family: 'Playfair Display', serif;
                                font-size: 1.4rem;
                                font-weight: 600;
                                margin-bottom: 4px;
                            }

                            .unit-price {
                                color: var(--color-text-light);
                                font-size: 0.95rem;
                                font-style: italic;
                            }

                            /* --- Forms & Buttons --- */
                            .qty-form {
                                display: flex;
                                align-items: center;
                                gap: 12px;
                            }

                            .qty-form input {
                                width: 60px;
                                padding: 10px;
                                border: 1px solid rgba(212, 175, 55, 0.2);
                                border-radius: 12px;
                                text-align: center;
                                background: rgba(255, 255, 255, 0.5);
                            }

                            .qty-form button {
                                width: 34px;
                                height: 34px;
                                border-radius: 50%;
                                border: none;
                                background: var(--color-gold);
                                color: #fff;
                                cursor: pointer;
                                transition: 0.3s;
                            }

                            .qty-form button:hover {
                                background: var(--color-gold-dark);
                                transform: rotate(45deg);
                            }

                            .line-total {
                                font-weight: 700;
                                font-size: 1.2rem;
                                color: var(--color-text);
                                text-align: right;
                            }

                            .remove-btn {
                                background: none;
                                border: none;
                                color: #d1b8b0;
                                font-size: 1.5rem;
                                cursor: pointer;
                                transition: 0.3s;
                            }

                            .remove-btn:hover {
                                color: #b08d82;
                                transform: scale(1.2);
                            }

                            .cart-summary {
                                display: flex;
                                justify-content: space-between;
                                align-items: center;
                                padding-top: 40px;
                                border-top: 1px solid rgba(212, 175, 55, 0.2);
                            }

                            .cart-total {
                                font-size: 1.8rem;
                                font-family: 'Playfair Display', serif;
                            }

                            .cart-total span {
                                color: var(--color-gold);
                                font-weight: 700;
                                margin-left: 10px;
                            }

                            .premium-btn {
                                padding: 16px 45px;
                                background: linear-gradient(135deg, #f9f1e9 0%, var(--color-gold) 100%);
                                color: #1a110a;
                                text-decoration: none;
                                border-radius: 50px;
                                border: none;
                                font-family: 'Playfair Display', serif;
                                font-size: 1.1rem;
                                font-weight: 700;
                                box-shadow: 0 12px 30px rgba(212, 175, 55, 0.25);
                                cursor: pointer;
                                transition: all 0.4s;
                            }

                            .premium-btn:hover {
                                transform: translateY(-4px);
                                box-shadow: 0 20px 50px rgba(212, 175, 55, 0.35);
                            }

                            /* --- Sections --- */
                            .checkout-section {
                                display: none;
                                animation: slideIn 0.6s cubic-bezier(0.23, 1, 0.32, 1) forwards;
                            }

                            .checkout-section.active {
                                display: block;
                            }

                            @keyframes slideIn {
                                from {
                                    opacity: 0;
                                    transform: translateY(20px);
                                }

                                to {
                                    opacity: 1;
                                    transform: translateY(0);
                                }
                            }

                            .luxury-form {
                                max-width: 550px;
                                margin: 0 auto;
                                padding: 20px 0;
                                text-align: center;
                            }

                            .luxury-form h2 {
                                font-family: 'Playfair Display', serif;
                                font-size: 2rem;
                                margin-bottom: 12px;
                            }

                            .form-hint {
                                color: var(--color-text-light);
                                margin-bottom: 40px;
                                font-style: italic;
                            }

                            .form-group-lux {
                                margin-bottom: 25px;
                                text-align: left;
                            }

                            .form-group-lux label {
                                display: block;
                                margin-bottom: 10px;
                                font-weight: 700;
                                font-size: 0.85rem;
                                text-transform: uppercase;
                                letter-spacing: 1px;
                                color: var(--color-gold-dark);
                            }

                            .form-group-lux input {
                                width: 100%;
                                padding: 15px 20px;
                                border-radius: 15px;
                                border: 1px solid rgba(212, 175, 55, 0.2);
                                background: rgba(255, 255, 255, 0.7);
                                font-family: inherit;
                                font-size: 1rem;
                                transition: 0.3s;
                            }

                            .form-group-lux input:focus {
                                outline: none;
                                border-color: var(--color-gold);
                                background: #fff;
                                box-shadow: 0 0 0 4px rgba(212, 175, 55, 0.1);
                            }

                            .payment-options {
                                display: flex;
                                gap: 20px;
                                margin-bottom: 35px;
                            }

                            .pay-option {
                                flex: 1;
                                padding: 25px;
                                border-radius: 20px;
                                border: 2px solid rgba(212, 175, 55, 0.1);
                                cursor: pointer;
                                transition: 0.4s;
                                background: rgba(255, 255, 255, 0.4);
                            }

                            .pay-option.selected {
                                border-color: var(--color-gold);
                                background: rgba(212, 175, 55, 0.08);
                                transform: translateY(-5px);
                            }

                            .pay-option i {
                                font-size: 2rem;
                                color: var(--color-gold);
                                margin-bottom: 12px;
                                display: block;
                            }

                            .pay-option span {
                                font-weight: 700;
                                font-size: 0.9rem;
                            }

                            .back-link {
                                color: var(--color-text-light);
                                text-decoration: none;
                                font-size: 0.9rem;
                                font-weight: 600;
                                transition: 0.3s;
                                display: inline-block;
                            }

                            .back-link:hover {
                                color: var(--color-gold);
                                transform: translateX(-5px);
                            }

                            @media (max-width: 768px) {
                                .cart-container {
                                    padding: 30px 20px;
                                }

                                .cart-item {
                                    grid-template-columns: 80px 1fr 1fr;
                                    gap: 15px;
                                }

                                .cart-item-img {
                                    height: 80px;
                                }

                                .line-total {
                                    grid-column: 3;
                                }

                                .remove-btn {
                                    grid-column: 3;
                                    justify-self: end;
                                }

                                .cart-summary {
                                    flex-direction: column;
                                    gap: 30px;
                                    text-align: center;
                                }
                            }
                        </style>

                    <body>

                        <div id="toastContainer"></div>
                        <div class="cart-container">

                            <div class="page-header">
                                <a href="${pageContext.request.contextPath}/home" class="back-link">← Continuer vos
                                    achats</a>
                                <h1>Votre panier</h1>

                                <!-- Checkout Stepper -->
                                <div class="checkout-stepper">
                                    <div class="step active" id="step1-indicator">
                                        <span class="step-num">1</span>
                                        <span class="step-label">Récapitulatif</span>
                                    </div>
                                    <div class="step-line"></div>
                                    <div class="step" id="step2-indicator">
                                        <span class="step-num">2</span>
                                        <span class="step-label">Livraison</span>
                                    </div>
                                    <div class="step-line"></div>
                                    <div class="step" id="step3-indicator">
                                        <span class="step-num">3</span>
                                        <span class="step-label">Paiement</span>
                                    </div>
                                </div>
                            </div>

                            <% if (cart==null || cart.isEmpty()) { %>
                                <div class="empty-state">
                                    <div class="empty-title">Votre panier est vide</div>
                                    <p class="empty-text">Découvrez nos collections pour le remplir d’élégance et de
                                        raffinement.</p>
                                    <a href="${pageContext.request.contextPath}/home" class="premium-btn">Découvrir les
                                        articles</a>
                                </div>
                                <% } else { %>

                                    <!-- STEP 1: RÉCAPITULATIF -->
                                    <div id="checkout-step-1" class="checkout-section active">
                                        <div class="cart-items-list">
                                            <% for (OrderItem item : cart.getItems()) { String
                                                imageUrl=item.getArticle().getImageUrl() !=null &&
                                                !item.getArticle().getImageUrl().isEmpty() ?
                                                item.getArticle().getImageUrl() : "images/default.png" ; %>
                                                <div class="cart-item">
                                                    <img src="<%= imageUrl %>" alt="<%= item.getArticle().getName() %>"
                                                        class="cart-item-img">

                                                    <div>
                                                        <div class="cart-item-name">
                                                            <%= item.getArticle().getName() %>
                                                        </div>
                                                        <div class="unit-price">
                                                            <%= String.format("%.2f", item.getPrice()) %> €
                                                        </div>
                                                    </div>

                                                    <form action="cart" method="post" class="qty-form">
                                                        <input type="hidden" name="action" value="update">
                                                        <input type="hidden" name="id"
                                                            value="<%= item.getArticle().getId() %>">
                                                        <input type="number" name="quantity" min="1"
                                                            value="<%= item.getQuantity() %>">
                                                        <button type="submit" title="Mettre à jour">↻</button>
                                                    </form>

                                                    <div class="line-total">
                                                        <%= String.format("%.2f", item.getPrice() * item.getQuantity())
                                                            %> €
                                                    </div>

                                                    <form action="cart" method="post">
                                                        <input type="hidden" name="action" value="remove">
                                                        <input type="hidden" name="id"
                                                            value="<%= item.getArticle().getId() %>">
                                                        <button type="submit" class="remove-btn">✕</button>
                                                    </form>
                                                </div>
                                                <% } %>
                                        </div>

                                        <div class="cart-summary">
                                            <div class="cart-total">
                                                Total : <span>
                                                    <%= String.format("%.2f", cart.getTotal()) %> €
                                                </span>
                                            </div>

                                            <button type="button" class="premium-btn" onclick="goToStep(2)">
                                                Continuer vers la livraison
                                            </button>
                                        </div>
                                    </div>

                                    <!-- STEP 2: LIVRAISON -->
                                    <div id="checkout-step-2" class="checkout-section">
                                        <div class="luxury-form">
                                            <h2>Adresse de livraison</h2>
                                            <p class="form-hint">Indiquez où nous devons livrer vos pièces d'exception.
                                            </p>

                                            <div class="form-group-lux">
                                                <label>Nom complet</label>
                                                <input type="text"
                                                    value="<%= currentUser != null ? currentUser.getUsername() : "" %>">
                                            </div>

                                            <div class="form-group-lux">
                                                <label>Adresse détaillée</label>
                                                <input type="text" placeholder="Ex: 42 Avenue des Champs-Élysées">
                                            </div>

                                            <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px;">
                                                <div class="form-group-lux">
                                                    <label>Ville</label>
                                                    <input type="text" placeholder="Paris">
                                                </div>
                                                <div class="form-group-lux">
                                                    <label>Code Postal</label>
                                                    <input type="text" placeholder="75008">
                                                </div>
                                            </div>

                                            <div class="cart-summary" style="margin-top: 40px;">
                                                <a href="javascript:void(0)" class="back-link" onclick="goToStep(1)">←
                                                    Retour au récapitulatif</a>
                                                <button type="button" class="premium-btn" onclick="goToStep(3)">
                                                    Passer au paiement sécurisé
                                                </button>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- STEP 3: PAIEMENT -->
                                    <div id="checkout-step-3" class="checkout-section">
                                        <div class="luxury-form">
                                            <h2>Paiement sécurisé</h2>
                                            <p class="form-hint">Finalisez votre acquisition en toute sérénité.</p>

                                            <div class="payment-options">
                                                <div class="pay-option selected">
                                                    <i class="fas fa-credit-card"></i>
                                                    <span>Carte Bancaire</span>
                                                </div>
                                                <div class="pay-option">
                                                    <i class="fab fa-paypal"></i>
                                                    <span>PayPal</span>
                                                </div>
                                            </div>

                                            <div class="form-group-lux">
                                                <label>Informations de Carte</label>
                                                <input type="text" placeholder="●●●●  ●●●●  ●●●●  ●●●●">
                                            </div>

                                            <div class="cart-summary" style="margin-top: 40px;">
                                                <a href="javascript:void(0)" class="back-link" onclick="goToStep(2)">←
                                                    Retour à la livraison</a>
                                                <form action="${pageContext.request.contextPath}/order" method="post"
                                                    style="display:inline;">
                                                    <button type="submit" class="premium-btn">
                                                        Confirmer et Payer (<%= String.format("%.2f", cart.getTotal())
                                                            %> €)
                                                    </button>
                                                </form>
                                            </div>
                                        </div>
                                    </div>

                                    <% } %>

                        </div>

                        <script src="${pageContext.request.contextPath}/js/elegance.js"></script>
                    </body>

                    </html>