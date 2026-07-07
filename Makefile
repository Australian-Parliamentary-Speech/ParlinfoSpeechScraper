#
# === Flags ===
#

MAKEFLAGS += --quiet

#
# === Variables ===
# 
# COLORS
RED = \033[31m
YELLOW = \033[33m
GREEN  = \033[32m
LIGHT  = \033[37m
DARK  = \033[90m
RESET  = \033[0m

ID := ParlinfoSpeechScraper

ifeq ($(OS),Windows_NT)
	CHECK_CMD = where $(1) >nul 2>nul
else
	CHECK_CMD = command -v $(1) >/dev/null 2>&1
endif

ifndef $(JULIA)
	JULIA=julia
endif

ifndef $(JULIA_CMD)
	JULIA_CMD=$(JULIA) --color=yes --startup-file=no
endif

#
# === Setup Commands ===
#

# --- Self-documenting help ---

.DEFAULT_GOAL := help

.PHONY: help

help: ## Show this help message
	@printf "Usage: ${LIGHT}make${RESET} [${YELLOW}target${RESET}]\n"
	@echo "Available targets:"
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "  ${YELLOW}%-15s${RESET} ${DARK}%s${RESET}\n", $$1, $$2}' $(MAKEFILE_LIST)

# --- Install ---

.PHONY: julia dependencies installcheck jl-init git-submodules install

julia:
	@printf "${DARK}Checking if Julia is installed${RESET}\n"
	@$(call CHECK_CMD,julia) 
	@if [ $$? -ne 0 ]; then printf "${RED}Julia is not available, please install julia from https://julialang.org/downloads/${RESET}\n"; exit 1; fi
	@printf "${DARK}Julia is installed${RESET}\n"

dependencies: julia

installcheck:
	@printf "${DARK}Checking dependencies${RESET}\n"
	@$(MAKE) dependencies

jl-init:
	@$(JULIA_CMD) -e "using Pkg; Pkg.instantiate()"

git-submodules:
	@printf "${DARK}%s${RESET}\n" "$$(git submodule update --init --recursive 2>&1)"

$(ID): # Ensure submodules exist
	@printf "${GREEN}Installing $(ID)${RESET}\n"
	@$(MAKE) git-submodules

install: installcheck ## Install ParlinfoSpeechScraper
	@$(MAKE) $(ID)
	@$(MAKE) jl-init

# --- Update ---

.PHONY: git-pull jl-update update

git-pull:
	@printf "${DARK}%s${RESET}\n" "$$(git pull --recurse-submodules 2>&1)"

jl-update:
	@$(JULIA_CMD) -e "using Pkg; Pkg.update()"

update: ## Update ParlinfoSpeechScraper
	@printf "${GREEN}Updating $(ID)${RESET}\n"
	@$(MAKE) git-pull
	@$(MAKE) git-submodules

# --- Setup ---

.PHONY: setup
setup: ## Setup (Install and Update) ParlinfoSpeechScraper
	@printf "${GREEN}Setting up $(ID)${RESET}\n"
	@$(MAKE) install
	@$(MAKE) update

#
# === Run Commands ===
#

# --- Run ---

.PHONY: run

run: ## Run ParlinfoSpeechScraper
	@printf "${GREEN}Running $(ID)${RESET}\n"
	bin/run $(filter-out $@, $(MAKECMDGOALS))

# Catchall to avoid collision between run args and targets
%:
	@true
