# Variables
API_DIR=api-node
AGENT_DIR=agent-rust
INFRA_DIR=deployments
DOCKER_BIN=podman  # On utilise podman comme convenu

# Couleurs pour le terminal
CYAN=\033[0;36m
NC=\033[0m

.PHONY: help install build dev clean infra-up infra-down

help:
	@echo "$(CYAN)Aether Project - Monorepo Management$(NC)"
	@echo "Usage: make [target]"
	@echo ""
	@echo "Targets:"
	@echo "  install    Installe les dépendances (Node & Rust)"
	@echo "  build      Compile l'agent Rust et l'API TS"
	@echo "  dev-api    Lance l'API en mode watch"
	@echo "  dev-agent  Lance l'agent Rust"
	@echo "  infra-up   Lance les services (Podman)"
	@echo "  clean      Nettoie les dossiers build/target"

install:
	@echo "$(CYAN)--> Installation des dépendances...$(NC)"
	cd $(API_DIR) && npm install
	# Rust installe au premier build

build:
	@echo "$(CYAN)--> Build de l'Agent (Release)...$(NC)"
	cd $(AGENT_DIR) && cargo build --release
	@echo "$(CYAN)--> Build de l'API (TypeScript)...$(NC)"
	cd $(API_DIR) && npx tsc

dev-api:
	cd $(API_DIR) && npx nodemon src/index.ts

dev-agent:
	cd $(AGENT_DIR) && cargo run

infra-up:
	cd $(INFRA_DIR) && $(DOCKER_BIN)-compose up -d

infra-down:
	cd $(INFRA_DIR) && $(DOCKER_BIN)-compose down

clean:
	rm -rf $(API_DIR)/dist
	rm -rf $(AGENT_DIR)/target
	rm -rf $(API_DIR)/node_modules
