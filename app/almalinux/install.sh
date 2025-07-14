#!/bin/bash
# =================================================================================================
# Assistant pour l'administration système sur AlmaLinux / RHEL
# Auteur : Jérôme N. | DevOps Linux & Docker | Ingénieur Système Réseau
# Date : 20 Juin 2025
# =================================================================================================

# -- Détection du chemin absolu du dossier courant --
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$SCRIPT_DIR/components"

# -- Fonction safe_source pour sourcer les fichiers critiques --
safe_source() {
    local file="$1"
    if [[ -f "$file" ]]; then
        source "$file"
    else
        echo "❌ Fichier requis introuvable : $file"
        exit 1
    fi
}

# -- Chargement sécurisé des composants --
safe_source "$ROOT_DIR/variables.sh"
safe_source "$ROOT_DIR/logo.sh"
safe_source "$ROOT_DIR/functions.sh"

# -- Gestion du signal d'interruption --
trap 'echo -e "\n${GREEN}👋 Fin de session (interruption utilisateur). Merci d’avoir utilisé ASSIALMA.${NC}"; exit 0' SIGINT

# -- Affichage du logo et vérifications --
logo
check_root
verification_os

# -- Boucle principale --
while true; do
    user_interaction

    read -rp "👉 Entrez le numéro de l'action à effectuer (1-25, '25' pour quitter, '--help' pour l'aide) : " input

    # Aide
    if [[ "$input" =~ ^(--help|-h|help)$ ]]; then
        show_help
        continue
    fi

    # Quitter
    if [[ "$input" == "25" ]]; then
        echo -e "${GREEN}👋 Merci d'avoir utilisé ASSIALMA. À bientôt !${NC}"
        break
    fi

    # Validation de l'entrée (active et améliorée)
    if ! [[ "$input" =~ ^[0-9]{1,2}$ ]] || (( input < 1 || input > 25 )); then
        echo -e "${RED}❌ Entrée invalide. Veuillez entrer un numéro entre 1 et 25.${NC}"
        continue
    fi

    # Appel dynamique
    switch_function "$input"

    # Relance
    read -rp "🔄 Voulez-vous effectuer une autre opération ? (o/n): " encore
    if [[ "$encore" =~ ^([nN]|[nN][oO]?)$ ]]; then
        echo -e "${GREEN}👋 Fin de session. Merci d’avoir utilisé ASSIALMA.${NC}"
        break
    fi
done

exit 0