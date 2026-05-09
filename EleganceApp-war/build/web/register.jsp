<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Inscription - Élégance</title>

    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@700&family=Lato:wght@300;400;700&display=swap" rel="stylesheet">

    <style>
        body {
            background: linear-gradient(135deg, #fffafc 0%, #f7e6e3 100%);
            font-family: 'Lato', sans-serif;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
        }

        .login-container {
            max-width: 430px;
            width: 100%;
            background: rgba(255,255,255,0.35);
            backdrop-filter: blur(18px);
            padding: 2.8rem 2.2rem;
            border-radius: 32px;
            box-shadow: 0 25px 60px rgba(212,175,55,0.25);
        }

        h2 {
            text-align: center;
            font-family: 'Playfair Display', serif;
            color: #d4af37;
            margin-bottom: 0.3rem;
        }

        .subtitle {
            text-align: center;
            font-size: 0.9rem;
            color: #6e6b68;
            margin-bottom: 1.8rem;
        }

        .field {
            margin-bottom: 1.2rem;
        }

        label {
            font-weight: 600;
            font-size: 0.9rem;
            display: block;
            margin-bottom: 0.3rem;
        }

        input {
            width: 100%;
            padding: 0.95rem 1.1rem;
            border-radius: 22px;
            border: 1px solid rgba(212,175,55,0.45);
            background: rgba(255,255,255,0.85);
            outline: none;
            font-size: 1rem;
        }

        input:focus {
            border-color: #d4af37;
            box-shadow: 0 0 10px rgba(212,175,55,0.35);
        }

        /* Règles visuelles */
        .rules {
            font-size: 0.8rem;
            margin-top: 0.5rem;
        }

        .rule {
            color: #b00020;
            transition: color 0.3s ease;
        }

        .rule.valid {
            color: #2e7d32;
            font-weight: 600;
        }

        .error {
            background: rgba(176,0,32,0.1);
            color: #b00020;
            padding: 0.6rem 0.9rem;
            border-radius: 12px;
            font-size: 0.85rem;
            margin-bottom: 1rem;
        }

        button {
            width: 100%;
            margin-top: 1.5rem;
            padding: 1rem;
            border-radius: 40px;
            border: none;
            background: linear-gradient(135deg, #e6c76a 0%, #d4af37 100%);
            color: white;
            font-weight: 700;
            font-size: 1.05rem;
            cursor: pointer;
            box-shadow: 0 12px 28px rgba(212,175,55,0.35);
        }

        button:disabled {
            background: #ccc;
            cursor: not-allowed;
            box-shadow: none;
        }

        p {
            text-align: center;
            margin-top: 1.2rem;
            font-size: 0.9rem;
        }

        a {
            color: #d4af37;
            font-weight: 700;
            text-decoration: none;
        }
    </style>
</head>

<body>

<div class="login-container">
    <h2>Inscription</h2>
    <div class="subtitle">Création rapide et sécurisée</div>

    <c:if test="${param.error == 'exists'}">
        <div class="error">Ce nom d’utilisateur existe déjà.</div>
    </c:if>

    <form id="registerForm" action="${pageContext.request.contextPath}/register" method="post">
        <div class="field">
            <label>Nom d'utilisateur</label>
            <input type="text" name="username" required>
        </div>

        <div class="field">
            <label>Mot de passe</label>
            <input type="password" id="password" name="password" required>

            <div class="rules">
                <div id="ruleLength" class="rule">• Au moins 6 caractères</div>
                <div id="ruleNumber" class="rule">• Contient un chiffre</div>
            </div>
        </div>

        <div class="field">
            <label>Confirmer le mot de passe</label>
            <input type="password" id="confirmPassword" required>
            <div id="ruleMatch" class="rule">• Les mots de passe correspondent</div>
        </div>

        <button type="submit" id="submitBtn" disabled>Créer mon compte</button>
    </form>

    <p>Déjà inscrite ? <a href="${pageContext.request.contextPath}/login">Connexion</a></p>
</div>

<script>
    const password = document.getElementById("password");
    const confirmPassword = document.getElementById("confirmPassword");
    const submitBtn = document.getElementById("submitBtn");

    const ruleLength = document.getElementById("ruleLength");
    const ruleNumber = document.getElementById("ruleNumber");
    const ruleMatch = document.getElementById("ruleMatch");

    function validatePassword() {
        let validLength = password.value.length >= 6;
        let hasNumber = /\d/.test(password.value);
        let match = password.value === confirmPassword.value && password.value !== "";

        ruleLength.classList.toggle("valid", validLength);
        ruleNumber.classList.toggle("valid", hasNumber);
        ruleMatch.classList.toggle("valid", match);

        submitBtn.disabled = !(validLength && hasNumber && match);
    }

    password.addEventListener("input", validatePassword);
    confirmPassword.addEventListener("input", validatePassword);
</script>

</body>
</html>

