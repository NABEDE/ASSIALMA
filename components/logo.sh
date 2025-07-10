#!/bin/bash

# Récupère le chemin absolu du dossier où se trouve ce script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Fichier de variables à sourcer
VARIABLES_FILE="$SCRIPT_DIR/variables.sh"

# Sourcing sécurisé
if [[ -f "$VARIABLES_FILE" ]]; then
    source "$VARIABLES_FILE"
else
    echo "❌ Fichier de variables introuvable : $VARIABLES_FILE" >&2
    exit 1
fi

function logo {
    # Affichage du logo (inchangé)
    echo -e "${RED}*****${NC}"
    echo -e "${RED}*****${NC}"
    echo -e "${RED}*****${NC}${YELLOW}**********************************************${NC}"
    echo -e "${RED}*****${NC}${YELLOW}**********************************************${NC}"
    echo -e "${RED}*****${NC}${YELLOW}***********************************************${NC}"
    echo -e "${RED}*****${NC}${YELLOW}***********************************************${NC}"
    echo -e "${RED}*****${NC}********* ASSIALMA  ********************"
    echo -e "${RED}*****${NC}${YELLOW}************************************************${NC}"
    echo -e "${RED}*****${NC}${YELLOW}************************************************${NC}"
    echo -e "${RED}*****${NC}${YELLOW}************************************************${NC}"
    echo -e "${RED}*****${NC}${YELLOW}************************************************${NC}"
    echo -e "${RED}*****${NC}"
    echo -e "${RED}*****${NC}"
    echo -e "${RED}*****${NC}"
    echo -e "${RED}*****${NC}"
    echo -e "${RED}*****${NC}"
    echo -e "${RED}*****${NC}"
    echo -e "${RED}*****${NC}"
}