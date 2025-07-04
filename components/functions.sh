#!/bin/bash
# Détecte le chemin du dossier où se trouve ce script, même si appelé depuis ailleurs
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Fonction utilitaire pour sourcer un fichier ou sortir proprement si absent
safe_source() {
    local file="$1"
    if [[ -f "$file" ]]; then
        source "$file"
    else
        echo "❌ Fichier requis introuvable : $file"
        exit 1
    fi
}

# Sourcing sécurisé des dépendances
safe_source "$SCRIPT_DIR/variables.sh"
safe_source "$SCRIPT_DIR/logo.sh"

# ---------- Fonctions utilitaires d'affichage et de logs ----------

info_msg()    { echo -e "${BLUE}$1${NC}" | tee -a "$LOG_FILE"; }
success_msg() { echo -e "${GREEN}$1${NC}" | tee -a "$LOG_FILE"; }
warn_msg()    { echo -e "${YELLOW}AVERTISSEMENT: $1${NC}" | tee -a "$LOG_FILE"; }
error_msg()   { echo -e "${RED}ERREUR: $1${NC}" | tee -a "$LOG_FILE" >&2; }
error_exit()  { error_msg "$1"; exit 1; }

log_action()  { echo "$(date '+%F %T') [ACTION] $1" >> "$LOG_FILE"; }
log_debug()   { [ "$DEBUG" = "1" ] && echo "$(date '+%F %T') [DEBUG] $1" >> "$LOG_FILE"; }

# ---------- Vérifications préalables ----------

check_root() {
    if [ "$EUID" -ne 0 ]; then
        error_exit "Ce script doit être exécuté en tant que root (sudo)."
    fi
}

verification_os() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        if [[ "$ID" == "centos" || "$ID_LIKE" == *"rhel"* ]]; then
            version=$(grep "^VERSION_ID=" /etc/os-release | cut -d '"' -f2)
            success_msg "Système détecté : CentOS (version $version)"
        else
            error_exit "Ce script est conçu uniquement pour CentOS ou dérivés RHEL. Système détecté : $ID"
        fi
    else
        error_exit "/etc/os-release introuvable. Impossible de détecter l'OS."
    fi
}

# ---------- Gestion du pare-feu ----------

check_firewalld() {
    if ! systemctl is-active --quiet firewalld; then
        info_msg "❌ firewalld n'est pas actif. Activation..."
        sudo systemctl start firewalld
        sudo systemctl enable firewalld
        success_msg "✅ firewalld est maintenant actif."
    fi
}

reload_firewalld() {
    sudo firewall-cmd --reload > /dev/null
}

# ---------- Fonctions améliorées ----------

# Sauvegarde/restauration simple d'un fichier ou dossier
backup_file() {
    local target="$1"
    local backup_dir="/var/backups/atin"
    mkdir -p "$backup_dir"
    local ts="$(date +%F_%H%M%S)"
    if [ -e "$target" ]; then
        cp -a "$target" "$backup_dir/$(basename "$target").bak.$ts"
        success_msg "✅ Sauvegarde de $target dans $backup_dir"
    else
        warn_msg "⚠️  Fichier/répertoire $target non trouvé pour la sauvegarde."
    fi
}

restore_file() {
    local backup_file="$1"
    local dest="$2"
    if [ -f "$backup_file" ]; then
        cp -a "$backup_file" "$dest"
        success_msg "✅ Restauration de $backup_file vers $dest"
    else
        error_msg "❌ Fichier de sauvegarde $backup_file introuvable."
    fi
}

# Gestion utilisateurs
add_user() {
    local user="$1"
    if id "$user" &>/dev/null; then
        warn_msg "L'utilisateur $user existe déjà."
    else
        sudo useradd -m "$user" && success_msg "Utilisateur $user créé."
    fi
}

del_user() {
    local user="$1"
    if id "$user" &>/dev/null; then
        sudo userdel -r "$user" && success_msg "Utilisateur $user supprimé."
    else
        warn_msg "L'utilisateur $user n'existe pas."
    fi
}

# Contrôle de sécurité rapide (fail2ban, SELinux, root login SSH, etc.)
security_audit() {
    info_msg "🔒 Audit de sécurité du système..."

    # Vérification du statut de SELinux
    if command -v getenforce >/dev/null; then
        selinux_status=$(getenforce)
        info_msg "SELinux : $selinux_status"
    else
        warn_msg "SELinux non détecté."
    fi

    # Vérification du mot de passe root SSH
    if grep -q "^PermitRootLogin" /etc/ssh/sshd_config 2>/dev/null; then
        ssh_root=$(grep "^PermitRootLogin" /etc/ssh/sshd_config | awk '{print $2}')
        if [ "$ssh_root" == "yes" ]; then
            warn_msg "Connexion root SSH autorisée ⚠️"
        else
            success_msg "Connexion root SSH désactivée."
        fi
    fi

    # Fail2ban
    if systemctl is-active fail2ban &>/dev/null; then
        success_msg "Fail2ban actif."
    else
        warn_msg "Fail2ban inactif ou non installé."
    fi
}

# Surveillance CPU/mémoire (simple)
monitoring_report() {
    info_msg "📊 État du système :"
    echo "Uptime : $(uptime -p)"
    echo "Usage CPU : $(top -bn1 | grep "Cpu(s)" | awk '{print $2 + $4}')%"
    echo "Usage RAM : $(free -h | awk '/Mem/ {print $3 " / " $2}')"
    echo "Processus principaux :"
    ps aux --sort=-%mem | head -n 6
}

# Notification mail (optionnelle)
send_mail() {
    local subject="$1"
    local body="$2"
    local dest="$3"
    if command -v mail >/dev/null; then
        echo "$body" | mail -s "$subject" "$dest"
        success_msg "✉️  Notification envoyée à $dest"
    else
        warn_msg "Mail non installé, notification non envoyée."
    fi
}

# Générer un rapport complet système
generate_full_report() {
    local report_file="/tmp/atin_system_report_$(date +%F_%H%M%S).txt"
    {
        echo "===== RAPPORT SYSTEME $(date) ====="
        hostnamectl
        echo ""
        df -hT
        echo ""
        free -h
        echo ""
        echo "Processus principaux :"
        ps aux --sort=-%mem | head -n 10
        echo ""
        echo "Utilisateurs connectés :"
        w
        echo ""
        echo "Derniers logs d'erreur :"
        journalctl -p err -n 20
    } > "$report_file"
    success_msg "✅ Rapport généré : $report_file"
}

# ---------- Menu utilisateur enrichi ----------

user_interaction() {
    echo -e "${RED}=========== ATIN_CENTOS-1.0 ================${NC}"
    logo
    echo " ===================================================="
    echo "1. Mettre à jour tous les paquets installés sur votre Système Centos"
    echo "2. Nettoyer le cache des paquets et supprimer les paquets orphelins"
    echo "3. Vérifier l'utilisation de l'espace disque"
    echo "4. Identifier les fichiers ou répertoires les plus volumineux"
    echo "5. Nettoyer les fichiers temporaires ou les vieux logs"
    echo "6. Démarrer, arrêter, redémarrer et vérifier l'état des services (systemctl)"
    echo "7. Gérer les services au démarrage du système"
    echo "8. Ajouter ou supprimer des règles de pare-feu"
    echo "9. Activer ou désactiver des zones de pare-feu"
    echo "10. Recharger les configurations du pare-feu"
    echo "11. Automatiser l'installation de serveurs web, bases de données, langages"
    echo "12. Gérer l'ajout de dépôts tiers (EPEL, Remi, etc.)"
    echo "13. Afficher l'état des interfaces réseau"
    echo "14. Changer l'adresse IP statique ou configurer le DHCP"
    echo "15. Rechercher des erreurs ou des avertissements dans les journaux"
    echo "16. Archiver ou purger les anciens fichiers journaux"
    echo "17. Vérifier l'état du swap"
    echo "18. Créer et activer un fichier de swap si nécessaire"
    echo "19. Générer des rapports système (CPU/mémoire, uptime, etc.)"
    echo "20. Stocker ces rapports dans un fichier ou les envoyer par e-mail"
    echo "21. Gestion des utilisateurs (ajout/suppression)"
    echo "22. Sauvegarder/restaurer un fichier/répertoire"
    echo "23. Audit sécurité rapide"
    echo "24. Générer un rapport complet du système"
    echo "25. Quitter"
}

# ---------- Fonctions supplémentaires ----------

show_help() {
    echo -e "${BLUE}Naviguez vers le dossier apps : cd app/centos${NC}"
    echo -e "${BLUE}Rendre exécutable le fichier install : chmod +x install.sh${NC}"
    echo -e "${BLUE}Utilisation: sudo ./install.sh${NC}"
    echo -e "${BLUE}Ce script va vous aider dans l'administration Système Centos.${NC}"
    echo -e "${BLUE}Options disponibles:${NC}"
    echo -e "${GREEN}--help${NC}    Affiche ce message d'aide."
    echo -e "${GREEN}--no-confirm${NC}  Exécute le script sans demander de confirmation."
    echo -e "\n${YELLOW}Assurez-vous d'avoir une connexion internet active.${NC}"
    exit 0
}

# ---------- Exemple d'intégration des nouvelles fonctions dans le switch ----------

switch_function() {
    case $number_for_assistance in
        # ... (toutes tes cases précédentes inchangées)
        21*)
            echo "👤 Gestion des utilisateurs"
            echo "1) Ajouter"
            echo "2) Supprimer"
            read -rp "Choix : " user_action
            read -rp "Nom d'utilisateur : " username
            case $user_action in
                1) add_user "$username" ;;
                2) del_user "$username" ;;
                *) warn_msg "Action inconnue." ;;
            esac
        ;;
        22*)
            echo "🗂️  Sauvegarder ou restaurer un fichier/répertoire"
            echo "1) Sauvegarder"
            echo "2) Restaurer"
            read -rp "Choix : " backup_action
            case $backup_action in
                1)
                    read -rp "Chemin à sauvegarder : " target
                    backup_file "$target"
                    ;;
                2)
                    read -rp "Fichier de sauvegarde : " backup
                    read -rp "Destination : " dest
                    restore_file "$backup" "$dest"
                    ;;
                *) warn_msg "Action inconnue." ;;
            esac
        ;;
        23*)
            security_audit
        ;;
        24*)
            generate_full_report
        ;;
        25*)
            info_msg "👋 Merci d'avoir utilisé ATIN_CENTOS. À bientôt !"
            exit 0
        ;;
        *)
            warn_msg "Choix non reconnu. Merci de sélectionner un élément du menu."
        ;;
    esac
}

# ---------- FIN DU FICHIER ----------