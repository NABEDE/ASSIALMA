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

logo() {
cat <<EOF
${RED}        _   ____  ____  _      _    _ _     _    _ __  __     _    ${NC}
${RED}       / \ / ___||  _ \| |    / \  | | |   | |  | |  \/  |   / \   ${NC}
${YELLOW}      / _ \ |    | |_) | |   / _ \ | | |   | |  | | |\/| |  / _ \  ${NC}
${YELLOW}     / ___ \ |___|  _ <| |__ / ___ \| | |___| |__| | |  | | / ___ \ ${NC}
${YELLOW}    /_/   \_\____|_| \_\____/_/   \_\_|_____\____/|_|  |_|/_/   \_\ ${NC}
${YELLOW}   ================================================================ ${NC}
${YELLOW}      Assistant Système AlmaLinux / RHEL - by Jérôme N.            ${NC}
${YELLOW}   ================================================================ ${NC}
EOF
}