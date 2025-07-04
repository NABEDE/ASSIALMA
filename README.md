# ATIN_CENTOS-1.0

**ATIN_CENTOS-1.0** est un assistant interactif pour les administrateurs système et réseau sous CentOS/RHEL.  
Il automatise et simplifie les principales tâches d’exploitation, d’audit, de sécurité et de maintenance sur vos serveurs Linux.

---

## Sommaire

- [Fonctionnalités](#fonctionnalités)
- [Prérequis](#prérequis)
- [Installation](#installation)
- [Utilisation](#utilisation)
- [Aperçu du Menu](#aperçu-du-menu)
- [Structure du projet](#structure-du-projet)
- [Contribuer](#contribuer)
- [Contact](#contact)

---

## Fonctionnalités

- Mise à jour complète du système et nettoyage intelligent
- Gestion avancée des services (démarrage, arrêt, redémarrage, état)
- Administration des utilisateurs (ajout, suppression)
- Gestion du pare-feu (firewalld)
- Audit de sécurité rapide (SELinux, fail2ban, SSH root…)
- Génération de rapports système détaillés (CPU, mémoire, uptime, logs…)
- Sauvegarde et restauration de fichiers/répertoires
- Automatisation de l’installation de serveurs web, SGBD, langages…
- Gestion avancée du réseau (interfaces, IP, DHCP…)
- Surveillance et analyse des ressources système

---

## Prérequis

- **Système** : CentOS 8/Stream ou distribution compatible RHEL
- **Accès root** ou `sudo` pour l’installation et l’exécution
- Connexion Internet (pour certaines actions)
- Paquets recommandés : `mailx`, `fail2ban`, `firewalld`, `dnf-utils`, etc.

---

## Installation

1. **Cloner le dépôt** :
   ```bash
   git clone https://github.com/NABEDE/ATIN_CENTOS-1.0.git
   cd ATIN_CENTOS-1.0/app/centos
   ```

2. **Rendre le script principal exécutable** :
   ```bash
   chmod +x install.sh
   ```

3. **Lancer l’assistant (avec droits root)** :
   ```bash
   sudo ./install.sh
   ```

---

## Utilisation

- Naviguez dans le menu interactif pour accéder à toutes les fonctionnalités.
- Les opérations nécessitant des privilèges administrateur sont sécurisées.
- Pour afficher l’aide :
  ```bash
  ./install.sh --help
  ```

---

## Aperçu du Menu

```text
=========== ATIN_CENTOS-1.0 ================
 1. Mettre à jour tous les paquets installés
 2. Nettoyer le cache et supprimer les orphelins
 3. Vérifier l'utilisation de l'espace disque
 4. Identifier les plus gros fichiers/répertoires
 5. Nettoyer les fichiers temporaires/vieux logs
 6. Gérer les services (démarrer, arrêter, état…)
 7. Gérer les services au démarrage système
 8. Ajouter/supprimer des règles de pare-feu
 9. Activer/désactiver des zones de pare-feu
10. Recharger la configuration du pare-feu
11. Installation auto de serveurs web, BDD, langages
12. Ajouter des dépôts tiers (EPEL, Remi…)
13. Afficher l’état des interfaces réseau
14. Changer l’IP ou configurer le DHCP
15. Rechercher erreurs/avertissements dans les logs
16. Archiver/purger les anciens logs
17. Vérifier l’état du swap
18. Créer/activer un fichier de swap
19. Générer des rapports système (CPU/mémoire…)
20. Stocker/envoyer ces rapports par e-mail
21. Gestion des utilisateurs (ajout/suppression)
22. Sauvegarder/restaurer un fichier/répertoire
23. Audit sécurité rapide
24. Générer un rapport complet système
25. Quitter
```

---

## Structure du projet

```
ATIN_CENTOS-1.0/
│
├── app/centos/
│   ├── install.sh           # Script principal (menu interactif)
│   └── ...
├── components/
│   ├── variables.sh         # Variables de configuration et couleurs
│   ├── logo.sh              # Affichage du logo
│   └── functions.sh         # Fonctions utilitaires et logiques du menu
└── ...
```

---

## Contribuer

Les contributions sont les bienvenues !  
Merci de créer une issue ou une pull request pour toute suggestion, bug ou amélioration.

---

## Contact

Auteur : Jérôme N.  
Ingénieur Système Réseau & Microservices Linux/Docker  
[Profil GitHub](https://github.com/NABEDE)

---

**ATIN_CENTOS-1.0 — Facilitez l’admin de vos serveurs CentOS/RHEL !**