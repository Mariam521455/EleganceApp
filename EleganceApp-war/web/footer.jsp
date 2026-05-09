<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

        <footer class="site-footer reveal-lux">
            <div class="footer-container">
                <!-- Zone principale centered -->
                <div class="footer-main">
                    <div class="footer-brand">
                        <a href="${pageContext.request.contextPath}/home">
                            <img src="${pageContext.request.contextPath}/images/elegance-logo.png"
                                alt="Élégance Boutique" class="footer-logo"
                                onerror="this.src='https://via.placeholder.com/180x52/d4af37/ffffff?text=Élégance'">
                        </a>
                        <p class="footer-slogan">
                            L'élégance n'est pas une tendance.<br>
                            C'est une façon d'être.
                        </p>
                        <!-- Newsletter Section Centered -->
                        <div class="footer-newsletter">
                            <h4 class="footer-title">Newsletter</h4>
                            <form
                                onsubmit="event.preventDefault(); alert('Merci pour votre inscription ! ✨'); this.reset();">
                                <input type="email" placeholder="Votre email..." required>
                                <button type="submit" class="premium-btn">S'abonner</button>
                            </form>
                        </div>
                    </div>
                </div>

                <!-- Bas du footer : copyright + mentions légales -->
                <div class="footer-bottom">
                    <p class="copyright">
                        © <%= java.time.Year.now().getValue() %> Élégance Paris — Tous droits réservés
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
                /* ── Footer premium Élégance (Simplified) ─────────────────────────── */
                .site-footer {
                    background: linear-gradient(to bottom, rgba(255, 255, 255, 0.95) 0%, var(--color-blush) 100%);
                    border-top: 1px solid var(--color-border);
                    color: var(--color-text-light);
                    padding: var(--space-12) 0 var(--space-8);
                    margin-top: auto;
                }

                .footer-container {
                    max-width: 800px;
                    /* Reduced width for focus */
                    margin: 0 auto;
                    padding: 0 var(--space-6);
                    text-align: center;
                }

                .footer-main {
                    margin-bottom: var(--space-10);
                }

                .footer-brand {
                    display: flex;
                    flex-direction: column;
                    align-items: center;
                    gap: var(--space-5);
                }

                .footer-logo {
                    height: 52px;
                    display: block;
                    transition: transform 0.6s var(--ease-dreamy);
                }

                .footer-logo:hover {
                    transform: scale(1.05);
                }

                .footer-slogan {
                    font-size: 1.1rem;
                    line-height: 1.6;
                    opacity: 0.9;
                    font-style: italic;
                    color: var(--color-text);
                }

                .footer-newsletter {
                    margin-top: var(--space-6);
                    width: 100%;
                    max-width: 450px;
                }

                .footer-title {
                    font-family: var(--font-display);
                    font-size: 1rem;
                    margin-bottom: var(--space-3);
                    text-transform: uppercase;
                    letter-spacing: 1px;
                    color: var(--color-gold);
                }

                .footer-newsletter form {
                    display: flex;
                    gap: 0.5rem;
                }

                .footer-newsletter input {
                    padding: 0.8rem 1.2rem;
                    border-radius: 999px;
                    border: 1px solid var(--color-border);
                    background: white;
                    flex: 1;
                    outline: none;
                    transition: border-color 0.3s;
                }

                .footer-newsletter input:focus {
                    border-color: var(--color-gold);
                }

                .footer-newsletter button {
                    padding: 0.8rem 1.5rem;
                    white-space: nowrap;
                }

                .footer-bottom {
                    padding-top: var(--space-6);
                    border-top: 1px solid rgba(0, 0, 0, 0.05);
                    /* Lighter border */
                    font-size: 0.85rem;
                    color: var(--color-text-lighter);
                    display: flex;
                    flex-direction: column;
                    gap: 10px;
                }

                .footer-legal a {
                    color: inherit;
                    text-decoration: none;
                    margin: 0 var(--space-3);
                    transition: color 0.35s;
                }

                .footer-legal a:hover {
                    color: var(--color-gold);
                }

                .separator {
                    opacity: 0.4;
                }

                /* Animation d'apparition douce (déjà dans ton global) */
                .reveal-lux {
                    opacity: 0;
                    animation: luxuryReveal 1.6s var(--ease-luxe-out) forwards;
                }
            </style>
            <!-- Global Scripts for AJAX Interactions (Cart & Favorites) -->
            <script src="https://cdnjs.cloudflare.com/ajax/libs/axios/1.7.7/axios.min.js"></script>
            <script src="${pageContext.request.contextPath}/js/elegance.js"></script>
        </footer>