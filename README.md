# Réservations

L'outil de réservation des salles de **La Verrière**, espace de coworking : les membres consultent le planning du jour,
trouvent une salle selon sa capacité et ses équipements, réservent un créneau et gèrent leurs réservations.

- **Planning** : une journée, une ligne par salle, de 8h00 à 20h00 ; un clic sur un créneau libre ouvre la
  réservation, déjà remplie.
- **Salles** : les huit salles de l'espace, filtrables par capacité et par équipement, et le planning du jour de
  chacune.
- **Mes réservations** : les réservations à venir et passées du membre connecté, et l'annulation.

Règles de réservation : de 8h00 à 20h00 (heure de Paris), au quart d'heure, 4 heures au plus, pas de chevauchement dans
une même salle (une réservation peut commencer à l'heure où la précédente finit), pas plus de participants que de
places, pas de créneau passé. Une réservation s'annule par la personne qui l'a faite, avant son début.

Il n'y a pas encore d'authentification : on choisit son nom dans l'en-tête (« Connecté en tant que »), et ce choix est
gardé dans le navigateur.

## Prérequis

Node 24, pnpm 10, Docker avec Compose.

## Démarrer

```bash
make install     # dépendances, et .env depuis .env.example
make db-migrate  # démarre Postgres et crée les tables
make db-seed     # salles, membres et réservations d'exemple sur cette semaine et la suivante
make dev         # API et interface en mode développement
```

| Service   | Adresse               |
| --------- | --------------------- |
| Interface | http://localhost:3030 |
| API       | http://localhost:4030 |
| Postgres  | localhost:5435        |

## Structure

```
apps/
  api/                    API NestJS
    migrations/           migrations SQL, appliquées dans l'ordre par make db-migrate
    src/
      rooms/              salles : GET /api/rooms?capacity=&equipment=, GET /api/rooms/:id
      members/            membres : GET /api/members
      bookings/           réservations : règles, GET /api/bookings?date= ou ?memberId=, POST, DELETE /:id
      shared/             heure de Paris, erreurs de l'API, horloge
      scripts/            migrate.ts, seed.ts
      testing/            dépôts en mémoire et application de test
  web/                    interface Next.js
    src/
      app/                pages : planning (/), salles (/rooms, /rooms/:id), mes réservations (/my-bookings)
      components/ui/      composants de base (Button, Badge, Card, Dialog, Input, Select, Tabs, Toast…)
      components/         planning, salles, réservations, en-tête
      lib/                appels à l'API, calcul des créneaux, dates, messages d'erreur
```

L'API répond en JSON ; une erreur a la forme `{ statusCode, code, message, field? }`. Les routes qui modifient une
réservation identifient le membre par l'en-tête `X-Member-Id`.

## Commandes

| Commande          | Effet                                               |
| ----------------- | --------------------------------------------------- |
| `make help`       | liste les commandes                                 |
| `make up`         | démarre Postgres                                    |
| `make down`       | arrête Postgres                                     |
| `make dev`        | Postgres, API et interface en mode développement    |
| `make db-migrate` | applique les migrations en attente                  |
| `make db-seed`    | remplace les données par le jeu d'exemple           |
| `make test`       | tests unitaires (Vitest), sans base de données      |
| `make typecheck`  | vérifie les types                                   |
| `make build`      | construit l'API et l'interface                      |
| `make format`     | met en forme le code (Prettier)                     |
| `make clean`      | supprime le volume Postgres et les sorties de build |
