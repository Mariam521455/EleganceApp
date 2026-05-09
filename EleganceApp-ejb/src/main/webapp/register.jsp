<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
  <meta charset="UTF-8">
  <title>Inscription - Élégance</title>
  <link rel="stylesheet" href="css/elegance.css">
</head>
<body>
  <div class="login-container">
    <h2>Inscription</h2>
    <form action="register" method="post">
      <label>Nom d'utilisateur</label>
      <input type="text" name="username" required>

      <label>Mot de passe</label>
      <input type="password" name="password" required>

      <button type="submit">S'inscrire</button>
    </form>
    <p>
      Déjà inscrit ? <a href="login.jsp">Connectez-vous</a>
    </p>
    <c:if test="${param.error == 'exists'}">
        <p class="error">Ce nom d’utilisateur existe déjà.</p>
    </c:if>
  </div>
</body>
</html>



