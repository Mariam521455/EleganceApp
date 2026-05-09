# Diagramme de Classes - Application Élégance

## Diagramme de Classes UML Complet

```mermaid
classDiagram
    class Utilisateur {
        -Long id
        -String nomUtilisateur
        -String motDePasse
        -String role
        +Utilisateur()
        +Utilisateur(nom, motDePasse, role)
        +getId() Long
        +getNomUtilisateur() String
        +setNomUtilisateur(nom)
        +getMotDePasse() String
        +setMotDePasse(motDePasse)
        +getRole() String
        +setRole(role)
    }

    class Categorie {
        -Long id
        -String nom
        -List~Article~ articles
        +Categorie()
        +Categorie(nom)
        +getId() Long
        +getNom() String
        +setNom(nom)
        +getArticles() List~Article~
        +ajouterArticle(article)
        +supprimerArticle(article)
    }

    class Article {
        -Long id
        -String nom
        -String description
        -Double prix
        -String urlImage
        -Categorie categorie
        -Boolean active
        +Article()
        +Article(nom, description, prix, categorie)
        +getId() Long
        +getNom() String
        +setNom(nom)
        +getDescription() String
        +setDescription(description)
        +getPrix() Double
        +setPrix(prix)
        +getUrlImage() String
        +setUrlImage(urlImage)
        +getCategorie() Categorie
        +setCategorie(categorie)
        +getActive() Boolean
        +setActive(active)
    }

    class Commande {
        -Long id
        -Utilisateur utilisateur
        -LocalDateTime dateCommande
        -Double montantTotal
        -List~LigneCommande~ lignes
        +Commande()
        +Commande(utilisateur, date, montant)
        +getId() Long
        +getUtilisateur() Utilisateur
        +setUtilisateur(utilisateur)
        +getDateCommande() LocalDateTime
        +setDateCommande(dateCommande)
        +getMontantTotal() Double
        +setMontantTotal(montantTotal)
        +getLignes() List~LigneCommande~
        +ajouterLigne(ligne)
        +supprimerLigne(ligne)
        +calculerTotal() Double
    }

    class LigneCommande {
        -Long id
        -Article article
        -Integer quantite
        -Double prix
        -Commande commande
        +LigneCommande()
        +LigneCommande(article, quantite, prix)
        +getId() Long
        +getArticle() Article
        +setArticle(article)
        +getQuantite() Integer
        +setQuantite(quantite)
        +getPrix() Double
        +setPrix(prix)
        +getCommande() Commande
        +setCommande(commande)
        +getSousTotal() Double
    }

    class Panier {
        -List~LigneCommande~ articles
        +Panier()
        +ajouterArticle(article, quantite)
        +supprimerArticle(idArticle)
        +modifierQuantite(idArticle, quantite)
        +getArticles() List~LigneCommande~
        +getTotal() Double
        +vider()
        +estVide() Boolean
    }

    %% Relations entre entités
    Utilisateur ||--o{ Commande : "passe"
    Utilisateur ||--o{ Panier : "possède"
    Categorie ||--o{ Article : "contient"
    Article }o--|| Categorie : "appartient à"
    Commande ||--o{ LigneCommande : "contient"
    LigneCommande }o--|| Commande : "appartient à"
    LigneCommande }o--|| Article : "référence"
    Panier ||--o{ LigneCommande : "contient"
```

## Diagramme de Classes - Services et Servlets

```mermaid
classDiagram
    class UserServiceEJB {
        -EntityManager em
        -OrderServiceEJB orderService
        +usernameExists(username) Boolean
        +create(user) User
        +findById(id) User
        +findByUsername(username) User
        +findAll() List~User~
        +update(user) User
        +delete(id) void
        +authenticate(username, password) User
    }

    class ArticleServiceEJB {
        -EntityManager em
        +create(article) Article
        +findById(id) Article
        +findAll() List~Article~
        +findByCategory(categoryName) List~Article~
        +update(article) Article
        +delete(id) void
        +findAvailable() List~Article~
    }

    class CategoryServiceEJB {
        -EntityManager em
        +create(category) Category
        +findById(id) Category
        +findAll() List~Category~
        +findByName(name) Category
        +update(category) Category
        +delete(id) void
    }

    class OrderServiceEJB {
        -EntityManager em
        +create(order) Order
        +findById(id) Order
        +findByUser(user) List~Order~
        +findAll() List~Order~
        +update(order) Order
        +delete(id) void
        +createOrderFromCart(cart, user) Order
    }

    class HomeServlet {
        -ArticleServiceEJB articleService
        -CategoryServiceEJB categoryService
        +doGet(request, response) void
        -handleFlashMessages(session, request) void
    }

    class LoginServlet {
        -UserServiceEJB userService
        +doGet(request, response) void
        +doPost(request, response) void
        -authenticateUser(username, password) User
    }

    class CartServlet {
        -ArticleServiceEJB articleService
        +doGet(request, response) void
        +doPost(request, response) void
        -handleCartAction(action, request) void
        -updateCartInSession(cart, session) void
    }

    class AdminServlet {
        -ArticleServiceEJB articleService
        -CategoryServiceEJB categoryService
        -UserServiceEJB userService
        -OrderServiceEJB orderService
        +doGet(request, response) void
        +doPost(request, response) void
        -handleAdminAction(action, request) void
        -updateArticleFromRequest(request, article) void
    }

    %% Relations entre services et servlets
    HomeServlet ..> ArticleServiceEJB : "utilise"
    HomeServlet ..> CategoryServiceEJB : "utilise"
    LoginServlet ..> UserServiceEJB : "utilise"
    CartServlet ..> ArticleServiceEJB : "utilise"
    AdminServlet ..> ArticleServiceEJB : "utilise"
    AdminServlet ..> CategoryServiceEJB : "utilise"
    AdminServlet ..> UserServiceEJB : "utilise"
    AdminServlet ..> OrderServiceEJB : "utilise"
    
    UserServiceEJB ..> OrderServiceEJB : "dépend de"
```

## Vue Simplifiée - Architecture 3 Tiers

```mermaid
graph TB
    subgraph "Tier 1: Présentation"
        A[🌐 JSP Pages]
        B[🎨 CSS/JS]
        C[📱 Interface Client]
    end
    
    subgraph "Tier 2: Métier"
        D[🎮 Servlets]
        E[⚙️ EJB Services]
        F[🔄 Business Logic]
    end
    
    subgraph "Tier 3: Données"
        G[🗄️ JPA Entities]
        H[📊 Derby DB]
        I[🏗️ ORM]
    end
    
    A --> D
    B --> D
    C --> D
    D --> E
    E --> G
    F --> E
    G --> H
    I --> G
    
    style A fill:#e3f2fd
    style D fill:#e8f5e8
    style G fill:#fff3e0
```

## Relations Principales

```mermaid
erDiagram
    UTILISATEUR {
        bigint id PK
        varchar nom_utilisateur UK
        varchar mot_de_passe
        varchar role
    }
    
    CATEGORIE {
        bigint id PK
        varchar nom UK
    }
    
    ARTICLE {
        bigint id PK
        varchar nom
        text description
        double prix
        varchar url_image
        boolean active
        bigint categorie_id FK
    }
    
    COMMANDE {
        bigint id PK
        bigint utilisateur_id FK
        datetime date_commande
        double montant_total
    }
    
    LIGNE_COMMANDE {
        bigint id PK
        bigint article_id FK
        bigint commande_id FK
        int quantite
        double prix
    }
    
    UTILISATEUR ||--o{ COMMANDE : "passe"
    CATEGORIE ||--o{ ARTICLE : "contient"
    COMMANDE ||--o{ LIGNE_COMMANDE : "contient"
    ARTICLE ||--o{ LIGNE_COMMANDE : "référence"
```

## Instructions pour Exporter

1. **Copiez** le bloc de code Mermaid de votre choix
2. **Allez** sur [mermaid.live](https://mermaid.live)
3. **Collez** le code dans l'éditeur
4. **Cliquez** sur "Export as PNG" ou "Export as SVG"

Ou utilisez VS Code avec l'extension "Mermaid Preview" et faites un clic droit sur le diagramme → "Save as Image".
