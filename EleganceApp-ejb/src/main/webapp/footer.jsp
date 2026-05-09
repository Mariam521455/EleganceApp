<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<footer class="site-footer reveal-lux">
    <div class="footer-container">
        <!-- Zone principale : logo + slogan + liens utiles -->
        <div class="footer-main">
            <div class="footer-brand">
                <img src="images/elegance-logo.png" alt="Élégance Boutique" class="footer-logo">
                <p class="footer-slogan">
                    L'élégance n'est pas une tendance.<br>
                    C'est une façon d'être.
                </p>
            </div>

            <div class="footer-links-group">
                <div class="footer-column">
                    <h4 class="footer-title">Découverte</h4>
                   
                </div>

                <div class="footer-column">
                    <h4 class="footer-title">Compte</h4>
                    <ul>
                        <li><a href="cart">Panier</a></li>
                        <li><a href="profile.jsp">Mon compte</a></li>
                        <li><a href="orders.jsp">Mes commandes</a></li>
                    </ul>
                </div>
            </div>
        </div>

        <!-- Bas du footer : copyright + mentions légales -->
        <div class="footer-bottom">
            <p class="copyright">
                © <%= java.time.Year.now().toString() %> Élégance Paris — Tous droits réservés
            </p>
            <div class="footer-legal">
                <a href="#">Conditions générales</a>
                <span class="separator">•</span>
                <a href="#">Politique de confidentialité</a>
                <span class="separator">•</span>
                <a href="#">Mentions légales</a>
            </div>
        </div>
    </div>

    <style>
        .site-footer {
            background: linear-gradient(to bottom, var(--color-surface) 0%, var(--color-blush) 100%);
            border-top: 1px solid rgba(212,175,55,0.12);
            color: var(--text-light);
            padding: var(--space-12) 0 var(--space-8);
            margin-top: auto;
        }

        .footer-container {
            max-width: 1520px;
            margin: 0 auto;
            padding: 0 var(--space-6);
        }

        .footer-main {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: var(--space-10);
            margin-bottom: var(--space-12);
        }

        @media (max-width: 768px) {
            .footer-main {
                grid-template-columns: 1fr;
                text-align: center;
            }
        }

        .footer-brand {
            max-width: 380px;
        }

        .footer-logo {
            height: 52px;
            margin-bottom: var(--space-5);
            display: block;
            transition: transform 0.6s var(--ease-dreamy);
        }

        .footer-logo:hover {
            transform: scale(1.05);
        }

        .footer-slogan {
            font-size: 1.05rem;
            line-height: 1.8;
            opacity: 0.88;
        }

        .footer-links-group {
            display: flex;
            gap: var(--space-12);
            justify-content: flex-end;
        }

        @media (max-width: 768px) {
            .footer-links-group {
                justify-content: center;
            }
        }

        .footer-column h4 {
            font-family: var(--font-display);
            font-size: 1.35rem;
            color: var(--text);
            margin-bottom: var(--space-5);
            font-weight: 600;
        }

        .footer-column ul {
            list-style: none;
        }

        .footer-column a {
            color: var(--text-light);
            text-decoration: none;
            font-size: 0.98rem;
            line-height: 2.5;
            display: block;
            transition: var(--transition-smooth);
        }

        .footer-column a:hover {
            color: var(--gold);
            transform: translateX(8px);
        }

        .footer-bottom {
            text-align: center;
            padding-top: var(--space-8);
            border-top: 1px solid rgba(212,175,55,0.1);
            font-size: 0.92rem;
            color: var(--text-lighter);
        }

        .footer-legal a {
            color: inherit;
            text-decoration: none;
            margin: 0 var(--space-3);
            transition: color var(--transition-fast);
        }

        .footer-legal a:hover {
            color: var(--gold);
        }

        .separator {
            opacity: 0.6;
        }

        /* Animation d'apparition douce */
        .reveal-lux {
            opacity: 0;
            animation: luxuryReveal 1.6s var(--ease-luxe-out) forwards;
        }
    </style>
</footer>