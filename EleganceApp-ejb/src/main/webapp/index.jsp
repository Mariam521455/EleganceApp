<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html lang="fr">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Élégance - L'art de se sublimer</title>
        <link rel="stylesheet" href="css/elegance.css">
    </head>

    <body class="luxury-main">
        <header style="padding: 20px 0;">
            <div class="nav-container">
                <div class="logo-wrapper">
                    <img src="images/elegance-logo.png.PNG" alt="Élégance Logo" class="luxury-logo">
                </div>
                <nav class="nav-links">
                    <a href="login.jsp" class="nav-link">Se connecter</a>
                    <a href="register.jsp" class="nav-link text-gold">S'inscrire</a>
                </nav>
            </div>
        </header>

        <main class="hero-luxury">
            <div class="content-wrapper" style="max-width: 900px; margin: 0 auto; animation: fadeInUp 1s ease;">
                <span class="text-gold"
                    style="text-transform: uppercase; letter-spacing: 5px; font-weight: 700; font-size: 0.8rem; display: block; margin-bottom: 20px;">Maison
                    de Beauté</span>
                <h1 class="font-display">L'essence de la <br> <span class="text-gold italic">Féminité</span></h1>
                <p class="subtitle">Une collection exclusive de pièces d'exception, sélectionnées pour celles qui font
                    de l'élégance un art de vivre.</p>

                <div class="action-area" style="display: flex; justify-content: center; gap: 20px;">
                    <a href="home" class="btn-luxury">Explorer la Collection ✨</a>
                </div>
            </div>

            <!-- Float elements decorations -->
            <div
                style="position: absolute; bottom: 50px; left: 10%; opacity: 0.3; font-family: 'Playfair Display'; font-style: italic; font-size: 1.5rem;">
                Authenticité</div>
            <div
                style="position: absolute; top: 150px; right: 10%; opacity: 0.3; font-family: 'Playfair Display'; font-style: italic; font-size: 1.5rem;">
                Modernité</div>
        </main>

        <footer
            style="margin-top: auto; padding: 40px 0; background: rgba(255,255,255,0.5); border-top: 1px solid rgba(212,175,55,0.1);">
            <div class="nav-container" style="justify-content: center; opacity: 0.6; font-size: 0.9rem;">
                &copy; 2026 Élégance Paris — L'excellence au service de votre beauté.
            </div>
        </footer>
    </body>

    </html>