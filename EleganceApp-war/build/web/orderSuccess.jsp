<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <!DOCTYPE html>
    <html lang="fr">

    <head>
        <meta charset="UTF-8">
        <title>Élégance - Commande Validée</title>
        <link rel="stylesheet" href="css/elegance.css">
        <style>
            .success-container {
                text-align: center;
                padding: 80px 20px;
                background: rgba(255, 255, 255, 0.8);
                border-radius: var(--border-radius);
                box-shadow: var(--shadow-card);
                max-width: 600px;
                margin: 50px auto;
                animation: fadeInUp 0.8s ease forwards;
            }

            .success-icon {
                font-size: 4rem;
                color: #28a745;
                margin-bottom: 20px;
            }

            h1 {
                font-family: 'Playfair Display', serif;
                color: var(--color-gold);
                margin-bottom: 20px;
            }

            p {
                font-size: 1.2rem;
                color: var(--color-text-secondary);
                margin-bottom: 40px;
            }

            .btn-home {
                padding: 15px 40px;
                background: var(--color-gold);
                color: white;
                text-decoration: none;
                border-radius: 50px;
                font-weight: 600;
                transition: var(--transition);
            }

            .btn-home:hover {
                transform: translateY(-3px);
                box-shadow: 0 10px 20px rgba(212, 175, 55, 0.3);
            }
        </style>
    </head>

    <body>

        <header>
            <div class="logo-wrapper">
                <a href="home">
                    <img src="images/elegance-logo.png" alt="Élégance Logo" class="luxury-logo">
                </a>
            </div>
        </header>

        <main>
            <div class="success-container">
                <div class="success-icon">✨</div>
                <h1>Commande Validée</h1>
                <p>Merci pour votre achat. Votre commande a bien été enregistrée et sera traitée avec le plus grand
                    soin.</p>
                <a href="home" class="btn-home">Retour à la boutique</a>
            </div>
        </main>

        <footer>&copy; 2026 Élégance — Tous droits réservés</footer>

    </body>

    </html>