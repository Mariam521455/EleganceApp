# EleganceApp

Projet d'application e-commerce "Elegance" développé avec Java EE (Jakarta EE).

## Structure du Projet

- **EleganceApp-ejb** : Contient la logique métier, les EJB (Enterprise JavaBeans) et les entités JPA.
- **EleganceApp-war** : Contient la couche web, les Servlets et les pages JSP.
- **src** : Code source principal.
- **pom.xml** / **build.xml** : Fichiers de configuration Maven et Ant pour la compilation.

## Prérequis

- JDK 11+
- Serveur d'application (GlassFish, Payara ou WildFly recommandé)
- Base de données (Derby/JavaDB par défaut, scripts SQL inclus)

## Installation

1. Clonez le dépôt :
   ```bash
   git clone https://github.com/Mariam521455/EleganceApp.git
   ```
2. Importez le projet dans NetBeans ou votre IDE favori.
3. Configurez la source de données JDBC dans votre serveur d'application.
4. Exécutez le script `create_tables_derby.sql` pour initialiser la base de données.
5. Déployez le projet.
