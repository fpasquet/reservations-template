SHELL := /bin/bash
COMPOSE := docker compose

.PHONY: help install up down dev db-migrate db-seed build typecheck test format clean
.DEFAULT_GOAL := help

help: ## Liste les commandes
	@grep -E '^[a-z-]+:.*## ' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*## "} {printf "  \033[36m%-11s\033[0m %s\n", $$1, $$2}'

install: ## Installe les dépendances et crée .env s'il manque
	pnpm install
	@test -f .env || (cp .env.example .env && echo "Créé .env depuis .env.example")

up: ## Démarre Postgres (Docker Compose), attend qu'il soit prêt
	$(COMPOSE) up -d --wait

down: ## Arrête Postgres
	$(COMPOSE) down

dev: up ## Postgres, API (http://localhost:4030) et interface (http://localhost:3030) en mode développement
	pnpm dev

db-migrate: up ## Applique les migrations SQL de apps/api/migrations qui ne l'ont pas encore été
	pnpm --filter @reservations/api db:migrate

db-seed: up ## Remplace les données par le jeu d'exemple (salles, membres, réservations de la semaine et de la suivante)
	pnpm --filter @reservations/api db:seed

build: ## Construit l'API et l'interface
	pnpm build

typecheck: ## Vérifie les types
	pnpm typecheck

test: ## Tests unitaires
	pnpm test

format: ## Met en forme le code (Prettier)
	pnpm format

clean: ## Supprime le volume Docker et les sorties de build
	$(COMPOSE) down -v
	rm -rf apps/*/dist apps/*/.next .turbo
