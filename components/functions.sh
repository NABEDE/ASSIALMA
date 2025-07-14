#!/bin/bash
# Fonctions d'administration AlmaLinux/RHEL - version améliorée
# =================================================================================================
# Assistant pour l'administration système sur AlmaLinux / RHEL
# Auteur : Jérôme N. | DevOps Linux & Docker | Ingénieur Système Réseau
# Date : 20 Juin 2025
# =================================================================================================

# Chargement des dépendances avec sourcing sécurisé
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
safe_source() {
    local file="$1"
    if [[ -f "$file" ]]; then
        source "$file"
    else
        echo "❌ Fichier requis introuvable : $file"
        exit 1
    fi
}
safe_source "$SCRIPT_DIR/variables.sh"
safe_source "$SCRIPT_DIR/logo.sh"

# Centralisation des messages
msg() { local color="$1"; shift; echo -e "${color}$*${NC}" | tee -a "$LOG_FILE"; }
info_msg()    { msg "${BLUE}" "$@"; }
success_msg() { msg "${GREEN}" "$@"; }
warn_msg()    { msg "${YELLOW}AVERTISSEMENT:" "$@"; }
error_msg()   { msg "${RED}ERREUR:" "$@"; }
error_exit()  { error_msg "$@"; exit 1; }

log_action()  { echo "$(date '+%F %T') [ACTION] $*" >> "$LOG_FILE"; }
log_debug()   { [ "$DEBUG" = "1" ] && echo "$(date '+%F %T') [DEBUG] $*" >> "$LOG_FILE"; }

# Vérification root
check_root() {
    [ "$EUID" -ne 0 ] && error_exit "Ce script doit être exécuté en tant que root."
}

# Vérification OS
verification_os() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        case "$ID" in
            almalinux|centos|rocky) success_msg "OS compatible : $ID $(grep VERSION_ID /etc/os-release | cut -d '"' -f2)" ;;
            *) error_exit "Ce script est conçu uniquement pour AlmaLinux/CentOS/RHEL. Système détecté : $ID" ;;
        esac
    else
        error_exit "Fichier /etc/os-release introuvable."
    fi
}

# Vérification commande
require_cmd() { command -v "$1" >/dev/null 2>&1 || error_exit "La commande '$1' est requise mais absente."; }

# Gestion du pare-feu
check_firewalld() {
    require_cmd systemctl
    if ! systemctl is-active --quiet firewalld; then
        info_msg "Activation de firewalld..."
        systemctl start firewalld && systemctl enable firewalld
        success_msg "firewalld actif."
    fi
}

reload_firewalld() {
    require_cmd firewall-cmd
    firewall-cmd --reload > /dev/null
}

# Sauvegarde/restauration
backup_file() {
    local target="$1"
    local backup_dir="/var/backups/atin"
    mkdir -p "$backup_dir" || error_exit "Impossible d'accéder à $backup_dir"
    local ts="$(date +%F_%H%M%S)"
    [ -e "$target" ] || { warn_msg "Cible $target introuvable."; return 1; }
    cp -a "$target" "$backup_dir/$(basename "$target").bak.$ts" && success_msg "Sauvegarde de $target réussie."
}

restore_file() {
    local backup_file="$1" dest="$2"
    [ -f "$backup_file" ] || error_exit "Sauvegarde $backup_file introuvable."
    cp -a "$backup_file" "$dest" && success_msg "Restauration réussie."
}

# Ajout/suppression utilisateur
add_user() {
    local user="$1"
    id "$user" &>/dev/null && { warn_msg "Utilisateur $user déjà présent."; return 1; }
    useradd -m "$user" && success_msg "Utilisateur $user créé."
}

del_user() {
    local user="$1"
    id "$user" &>/dev/null || { warn_msg "Utilisateur $user absent."; return 1; }
    userdel -r "$user" && success_msg "Utilisateur $user supprimé."
}

# Audit sécurité
security_audit() {
    info_msg "Audit sécurité du système..."
    require_cmd getenforce
    selinux_status=$(getenforce)
    info_msg "SELinux : $selinux_status"
    ssh_root=$(grep "^PermitRootLogin" /etc/ssh/sshd_config | awk '{print $2}')
    [ "$ssh_root" = "yes" ] && warn_msg "Connexion root SSH autorisée !" || success_msg "Connexion root SSH désactivée."
    systemctl is-active fail2ban &>/dev/null && success_msg "Fail2ban actif." || warn_msg "Fail2ban inactif ou absent."
}

# Surveillance
monitoring_report() {
    info_msg "📊 État du système :"
    echo "Uptime : $(uptime -p)"
    echo "CPU : $(top -bn1 | grep 'Cpu(s)' | awk '{print $2 + $4}')%"
    echo "RAM : $(free -h | awk '/Mem/ {print $3 " / " $2}')"
    echo "Processus principaux :"
    ps aux --sort=-%mem | head -n 6
}

# Menu utilisateur enrichi
user_interaction() {
    echo -e "${RED}=========== ASSIALMA ================${NC}"
    logo
    echo " ===================================================="
    local i=1
    local options=(
        "Mettre à jour tous les paquets"
        "Nettoyer le cache et paquets orphelins"
        "Vérifier l'espace disque"
        "Identifier les plus gros fichiers/répertoires"
        "Nettoyer fichiers temporaires/logs"
        "Gérer les services (systemctl)"
        "Services au démarrage"
        "Règles de pare-feu"
        "Zones de pare-feu"
        "Recharger le pare-feu"
        "Installer serveurs web, DB, langages"
        "Ajouter dépôts tiers"
        "Interfaces réseau"
        "Configurer IP/DHCP"
        "Erreurs/journaux"
        "Archiver/purger logs"
        "État du swap"
        "Créer/activer swap"
        "Rapport monitoring"
        "Rapport fichier/email"
        "Gestion utilisateurs"
        "Sauvegarder/restaurer"
        "Audit sécurité"
        "Rapport complet"
        "Quitter"
    )
    for opt in "${options[@]}"; do
        echo "$i. $opt"
        ((i++))
    done
}

# Switch amélioré (exemple)
switch_function() {
    local input="$1"
    case "$input" in
        1) info_msg "Mise à jour..."; dnf update -y && success_msg "OK." ;;
        # ... reprendre chaque cas en factorisant au maximum et en validant les entrées ...
        25) info_msg "Merci d'avoir utilisé ASSIALMA !"; exit 0 ;;
        *) warn_msg "Choix inconnu. Veuillez sélectionner un numéro du menu." ;;
    esac
}

# Aide enrichie
show_help() {
    echo -e "${BLUE}Utilisation : cd app/almalinux && chmod +x install.sh && sudo ./install.sh${NC}"
    echo -e "${BLUE}Ce script propose un menu d'administration AlmaLinux.${NC}"
    echo -e "${GREEN}--help${NC} : affiche ce message\n${YELLOW}Connexion internet requise.${NC}"
    echo -e "${BLUE}Menu complet :${NC}"
    user_interaction
    exit 0
}

# ---------- FIN DU FICHIER ----------