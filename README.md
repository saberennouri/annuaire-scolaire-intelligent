# Annuaire Scolaire Intelligent

Plateforme web destinée à centraliser, rechercher et consulter les informations relatives aux établissements scolaires.

## Présentation

Annuaire Scolaire Intelligent est un projet de modernisation d'un annuaire scolaire initialement développé en HTML.

L'objectif est de le faire évoluer progressivement vers une application web moderne, sécurisée, maintenable et évolutive.

Le projet sert également de support pratique d'apprentissage et de mise en œuvre des technologies Full Stack, DevOps et Intelligence Artificielle.

## Objectifs fonctionnels

- Consulter les établissements scolaires.
- Rechercher et filtrer les établissements.
- Organiser les établissements par délégation et type.
- Gérer les informations et les contacts autorisés.
- Contrôler les accès selon les rôles et permissions.
- Faciliter l'importation et la mise à jour des données.
- Étudier l'intégration d'un assistant IA documentaire.

## Architecture cible

```text
annuaire-scolaire-intelligent/
├── backend/       # API REST Spring Boot
├── frontend/      # Application Angular
├── database/      # Scripts et migrations SQL
├── infra/         # Docker, Nginx et configuration
├── docs/          # Documentation technique
├── legacy/        # Version HTML initiale
└── .github/       # Workflows GitHub Actions
```

## Technologies envisagées

| Domaine | Technologies |
|---|---|
| Backend | Java, Spring Boot, Spring Data JPA |
| Frontend | Angular, TypeScript |
| Base de données | MySQL |
| Sécurité | Spring Security, JWT |
| Tests | JUnit, Mockito, tests Angular |
| Documentation API | Swagger / OpenAPI |
| Conteneurisation | Docker, Docker Compose |
| CI/CD | GitHub Actions |
| Qualité | SonarQube |
| Supervision | Spring Actuator, Prometheus, Grafana |
| Intelligence artificielle | Spring AI, LLM, RAG |

## Installation

Les instructions d'installation du backend, du frontend et de l'environnement Docker seront ajoutées au fur et à mesure de leur implémentation.

## Organisation du développement

Le projet suit une progression en phases :

1. Préparation du projet et Git.
2. Conception de la base de données.
3. Développement du backend Spring Boot.
4. Fiabilisation et importation des données.
5. Sécurisation de l'application.
6. Développement du frontend Angular.
7. Tests et documentation.
8. Conteneurisation Docker.
9. Automatisation CI/CD.
10. Déploiement et supervision.
11. Intégration de l'intelligence artificielle.
12. Évolutions avancées.

## Gestion du code

- `main` : versions stables.
- `develop` : intégration des fonctionnalités.
- `feature/*` : développement des fonctionnalités.
- `fix/*` : corrections.

Les modifications importantes doivent être documentées et vérifiées avant leur intégration.

## État du projet

**Phase actuelle :** préparation du projet et organisation Git.

Les fonctionnalités seront marquées comme terminées uniquement après leur implémentation et leur validation.

## Auteur

Projet personnel de développement logiciel et d'apprentissage pratique.

## Licence et données

La licence et les conditions de diffusion des données seront définies avant toute publication de données réelles.

Aucune donnée personnelle ou information non autorisée ne doit être publiée dans ce dépôt.