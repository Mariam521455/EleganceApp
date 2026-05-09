# Diagrammes UML de l'Application Élégance

Ce document présente les diagrammes d'architecture réels de votre projet, générés sous forme d'images haute définition.

---

## 1. Diagramme de Cas d'Utilisation (Projet Réel)

Ce diagramme illustre les interactions réelles entre les Clients, l'Administrateur et les fonctionnalités implémentées dans votre application Jakarta EE.

![Diagramme de Cas d'Utilisation Réel](/C:/Users/USER/.gemini/antigravity/brain/3f34308e-8f1b-4788-9c11-3345625c836e/elegance_use_case_diagram_1768952478468.png)

---

## 2. Diagramme de Classes (Architecture Technique)

Ce diagramme présente l'architecture technique en couches (Entités, Services EJB, et Contrôleurs Servlet) telle qu'elle est structurée dans votre code source.

![Diagramme d'Architecture Technique](/C:/Users/USER/.gemini/antigravity/brain/3f34308e-8f1b-4788-9c11-3345625c836e/elegance_class_architecture_diagram_v2_1768952499757.png)

---

> [!TIP]
> Ces diagrammes reflètent fidèlement votre infrastructure Jakarta EE, avec une séparation claire entre la logique métier (EJB) et la présentation (Servlets).
---

## 3. Diagramme de Cas d'Utilisation (Personnalisé)

Ce diagramme regroupe toutes les fonctionnalités spécifiques demandées pour le Client et l'Administrateur.

![Diagramme de Cas d'Utilisation Personnalisé](/C:/Users/USER/.gemini/antigravity/brain/3f34308e-8f1b-4788-9c11-3345625c836e/custom_use_case_diagram_v3_1768952812124.png)
---

## 4. Diagramme de Classes (Spécifié avec Verbes)

Comme demandé, voici le diagramme de classes détaillé incluant les attributs, les méthodes et les verbes d'action pour chaque relation.

```mermaid
classDiagram
    class Utilisateur {
        -int id
        -String nomUtilisateur
        -String motDePasse
        -String role
        +SeConnecter()
        +SeDeconnecter()
    }

    class Categorie {
        -int id
        -String nom
        -List articles
        +AjouterArticle()
    }

    class Article {
        -int id
        -String nom
        -String description
        -double prix
        -String urlImage
        -boolean active
        +AfficherDetails()
    }

    class Commande {
        -int id
        -Date dateCommande
        -double montantTotal
        -List lignes
        +CalculerTotal()
    }

    class LigneCommande {
        -int id
        -int quantite
        -double prix
        +CalculerSousTotal()
    }

    class Panier {
        -List articles
        +AjouterArticle()
        +Vider()
    }

    %% Relations avec verbes
    Utilisateur "1" -- "*" Commande : (passe)
    Utilisateur "1" -- "1" Panier : (possède)
    Categorie "1" -- "*" Article : (contient)
    Article "*" -- "1" Categorie : (appartient à)
    Commande "1" -- "*" LigneCommande : (contient)
    LigneCommande "*" -- "1" Article : (référence)
    Panier "1" -- "*" LigneCommande : (contient)

    style Utilisateur fill:#fff,stroke:#d4af37,stroke-width:2px
    style Article fill:#fff,stroke:#d4af37,stroke-width:2px
    style Categorie fill:#fff,stroke:#d4af37,stroke-width:2px
    style Commande fill:#fff,stroke:#d4af37,stroke-width:2px
    style LigneCommande fill:#fff,stroke:#d4af37,stroke-width:2px
    style Panier fill:#fff,stroke:#d4af37,stroke-width:2px
```

> [!NOTE]
> En raison d'une limite temporaire sur l'outil de génération d'images haute définition, j'ai utilisé la syntaxe **Mermaid**. C'est le standard industriel pour intégrer des diagrammes UML dynamiques et parfaitement lisibles directement dans vos documents Markdown.
