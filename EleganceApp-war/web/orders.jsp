<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mes Commandes • Élégance</title>
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@400;700&family=Inter:wght@300;400;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
    <style>
        :root {
            --gold: #d4af37;
            --text: #3f2c22;
            --bg: #fdf8f9;
            --card-bg: rgba(255, 255, 255, 0.8);
            --radius: 20px;
        }
        body {
            font-family: 'Inter', sans-serif;
            background: linear-gradient(135deg, var(--bg) 0%, #fceef2 100%);
            color: var(--text);
            margin: 0;
            min-height: 100vh;
        }
        .container {
            max-width: 1000px;
            margin: 4rem auto;
            padding: 0 2rem;
        }
        h1 {
            font-family: 'Playfair Display', serif;
            font-size: 3rem;
            text-align: center;
            margin-bottom: 3rem;
            color: var(--text);
        }
        .order-card {
            background: var(--card-bg);
            backdrop-filter: blur(15px);
            border: 1px solid rgba(212, 175, 55, 0.2);
            border-radius: var(--radius);
            padding: 2rem;
            margin-bottom: 2rem;
            box-shadow: 0 10px 30px rgba(212, 175, 55, 0.08);
            display: grid;
            grid-template-columns: auto 1fr auto auto;
            align-items: center;
            gap: 2rem;
            transition: transform 0.3s ease;
        }
        .order-card:hover {
            transform: translateY(-5px);
            border-color: var(--gold);
        }
        .order-icon {
            font-size: 2rem;
            color: var(--gold);
            background: rgba(212, 175, 55, 0.1);
            width: 60px;
            height: 60px;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 15px;
        }
        .order-info h3 {
            margin: 0 0 0.5rem 0;
            font-family: 'Playfair Display', serif;
        }
        .order-info p {
            margin: 0;
            opacity: 0.7;
            font-size: 0.9rem;
        }
        .order-total {
            font-weight: 700;
            color: var(--gold);
            font-size: 1.2rem;
        }
        .status-badge {
            padding: 0.5rem 1.2rem;
            border-radius: 999px;
            font-size: 0.8rem;
            font-weight: 600;
            text-transform: uppercase;
        }
        .status-pending { background: #fff8e1; color: #f57c00; }
        .status-completed { background: #e8f5e9; color: #2e7d32; }
        
        .empty-state {
            text-align: center;
            padding: 5rem 2rem;
        }
        .empty-state i {
            font-size: 5rem;
            color: var(--gold);
            margin-bottom: 2rem;
            opacity: 0.3;
        }
        .btn-luxe {
            display: inline-block;
            background: var(--gold);
            color: white;
            padding: 1rem 2.5rem;
            border-radius: 999px;
            text-decoration: none;
            font-weight: 600;
            margin-top: 2rem;
            box-shadow: 0 10px 20px rgba(212, 175, 55, 0.2);
            transition: all 0.3s ease;
        }
        .btn-luxe:hover {
            transform: translateY(-3px);
            box-shadow: 0 15px 30px rgba(212, 175, 55, 0.3);
        }
    </style>
</head>
<body>
    <%@ include file="header.jsp" %>

    <div class="container">
        <h1>Mon Historique</h1>

        <c:choose>
            <c:when test="${not empty orders}">
                <c:forEach var="order" items="${orders}">
                    <div class="order-card">
                        <div class="order-icon">
                            <i class="fas fa-shopping-bag"></i>
                        </div>
                        <div class="order-info">
                            <h3>Commande #${order.id}</h3>
                            <p>Passée le <fmt:formatDate value="${order.orderDateAsDate}" pattern="dd/MM/yyyy HH:mm" /></p>
                        </div>
                        <div class="order-total">
                            <fmt:formatNumber value="${order.totalAmount}" type="number" /> CFA
                        </div>
                        <div>
                            <span class="status-badge ${order.status == 'PENDING' ? 'status-pending' : 'status-completed'}">
                                ${order.status}
                            </span>
                        </div>
                    </div>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <div class="empty-state">
                    <i class="fas fa-receipt"></i>
                    <h2>Vous n'avez pas encore passé de commande</h2>
                    <p>Découvrez notre collection d'exception et trouvez la pièce qui vous ressemble.</p>
                    <a href="${pageContext.request.contextPath}/home" class="btn-luxe">Explorer la boutique</a>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

    <%@ include file="footer.jsp" %>
</body>
</html>
