#!/bin/bash
# =================================================================================================
# ASSIALMA
# Un assistant pour les administrateur système et réseau sur Almalinux/RHEL.
# Auteur : Jérôme N. | Développeur Microservices Linux & Docker | Ingénieur Système Réseau
# Date : 20 Juin 2025
# =================================================================================================

# -- Chargement des composants nécessaires --
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$SCRIPT_DIR/../.."

# Sourcing des composants
source "$ROOT_DIR/components/variables.sh"
source "$ROOT_DIR/components/logo.sh"
source "$ROOT_DIR/components/functions.sh"

# -- Affichage du logo --
logo

# -- Vérifications préalables --
check_root
verification_os

# -- Boucle principale du menu --
while true; do
    user_interaction
    echo ""
    read -rp "👉 Entrez le numéro de l'action à effectuer (ou '21' pour quitter): " number_for_assistance

    # Gestion des options d'aide
    if [[ "$number_for_assistance" =~ ^(--help|-h|help)$ ]]; then
        show_help
        continue
    fi

    # Appel du switch général (défini dans functions.sh)
    switch_function
    echo ""
    read -rp "🔄 Voulez-vous effectuer une autre opération ? (o/n): " encore
    [[ "$encore" =~ ^([Nn][Oo]?)$ ]] && { echo -e "${GREEN}A bientôt sur Almalinux !${NC}"; break; }
done

exit 0