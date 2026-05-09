<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page session="true" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Connexion - Élégance</title>

    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:ital,wght@0,400;0,700;1,400&family=Lato:wght@300;400;700&display=swap" rel="stylesheet">

    <link rel="stylesheet" href="css/elegance.css">

    <style>
        body {
            background: linear-gradient(to bottom, #fffafc 0%, #fceceb 100%);
            font-family: 'Lato', sans-serif;
            color: #2c2a28;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
        }

        .login-container {
            width: 100%;
            max-width: 400px;
            background: rgba(255,255,255,0.25);
            backdrop-filter: blur(16px);
            border-radius: 30px;
            padding: 2.5rem 2rem;
            box-shadow: 0 20px 50px rgba(212,175,55,0.2);
            text-align: center;
            position: relative;
        }

        .login-container h2 {
            font-family: 'Playfair Display', serif;
            font-size: 2rem;
            font-weight: 700;
            color: #d4af37;
            margin-bottom: 1.5rem;
        }

        .login-container form {
            display: flex;
            flex-direction: column;
            gap: 1rem;
        }

        .login-container label {
            text-align: left;
            font-weight: 500;
            color: #2c2a28;
            margin-bottom: 0.3rem;
        }

        .login-container input {
            padding: 0.9rem 1rem;
            border-radius: 20px;
            border: 1px solid rgba(212,175,55,0.4);
            background: rgba(255,255,255,0.6);
            outline: none;
            font-size: 1rem;
            transition: all 0.3s ease;
        }

        .login-container input:focus {
            border-color: #d4af37;
            box-shadow: 0 0 10px rgba(212,175,55,0.3);
        }

        .login-container button {
            margin-top: 1rem;
            padding: 1rem;
            border-radius: 40px;
            border: none;
            background: linear-gradient(135deg, #fceceb 0%, #d4af37 100%);
            color: #fff;
            font-weight: 700;
            font-size: 1.1rem;
            cursor: pointer;
            transition: all 0.3s ease;
            box-shadow: 0 10px 25px rgba(212,175,55,0.3);
        }

        .login-container button:hover {
            transform: translateY(-2px) scale(1.02);
            box-shadow: 0 20px 40px rgba(212,175,55,0.5);
        }

        .login-container p {
            margin-top: 1rem;
            font-size: 0.9rem;
            color: #6e6b68;
        }

        .login-container p a {
            color: #d4af37;
            text-decoration: none;
            font-weight: 600;
        }

        .login-container p a:hover {
            text-decoration: underline;
        }

        .error {
            color: #b00020;
            font-weight: 600;
            margin-bottom: 1rem;
        }

        @media (max-width: 480px) {
            .login-container {
                padding: 2rem 1.5rem;
            }
        }
    </style>
</head>
<body>
    <div class="login-container">
        <h2>Connexion</h2>

        <%-- Message d'erreur si login échoué --%>
        <c:if test="${not empty errorMessage}">
            <p class="error">${errorMessage}</p>
        </c:if>

        <form action="login" method="post">
            <label>Nom d'utilisateur</label>
            <input type="text" name="username" required>

            <label>Mot de passe</label>
            <input type="password" name="password" required>

            <button type="submit">Se connecter</button>
        </form>

        <p>Pas encore de compte ? <a href="register.jsp">Inscrivez-vous</a></p>
    </div>
</body>
</html>





