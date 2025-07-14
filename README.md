# 🚀 ASSIALMA

**ASSIALMA** est un outil shell interactif conçu pour simplifier, automatiser et sécuriser l’administration de serveurs AlmaLinux et RHEL.  
Il aide les administrateurs système et réseau à gagner du temps, éviter les erreurs et centraliser les principales tâches d’administration.

---

## 📚 Sommaire

- [✨ Fonctionnalités](#-fonctionnalités)
- [📝 Prérequis](#-prérequis)
- [⚙️ Installation](#-installation)
- [💻 Utilisation](#-utilisation)
- [🧭 Aperçu du Menu](#-aperçu-du-menu)
- [🗂️ Structure du projet](#-structure-du-projet)
- [🤝 Contribution & Tests](#-contribution--tests)
- [📬 Contact](#-contact)
- [📄 Licence](#-licence)

---

## ✨ Fonctionnalités

- 🔄 Mise à jour complète du système et nettoyage intelligent
- 🛠️ Gestion avancée des services (démarrage, arrêt, redémarrage, état)
- 👤 Administration des utilisateurs (ajout, suppression)
- 🔥 Gestion du pare-feu (firewalld)
- 🛡️ Audit rapide de sécurité (SELinux, fail2ban, accès root SSH, etc.)
- 📊 Génération de rapports détaillés (CPU, mémoire, uptime, logs)
- 📦 Sauvegarde et restauration de fichiers/répertoires
- 🏗️ Installation automatisée de serveurs web, bases de données, langages, etc.
- 🌐 Gestion avancée du réseau (interfaces, IP, DHCP)
- 📈 Surveillance et analyse des ressources système

---

## 📝 Prérequis

- **Système** : AlmaLinux 8/9 ou distribution compatible RHEL
- **Droits root ou `sudo`** pour l’installation et l’exécution
- **Connexion Internet** (requis pour certaines actions)
- Paquets recommandés : `mailx`, `fail2ban`, `firewalld`, `dnf-utils`, etc.

---

## ⚙️ Installation

1. **Cloner le dépôt :**
    ```bash
    git clone https://github.com/NABEDE/ASSIALMA.git
    cd ASSIALMA/app/alma
    ```

2. **Rendre le script principal exécutable :**
    ```bash
    chmod +x install.sh
    ```

3. **Lancer l’assistant (avec droits root) :**
    ```bash
    sudo ./install.sh
    ```

---

## 💻 Utilisation

- Naviguez dans le menu interactif pour accéder à toutes les fonctionnalités.
- Les actions nécessitant des privilèges administrateur sont sécurisées.
- Pour afficher l’aide :
    ```bash
    ./install.sh --help
    ```

---

## 🧭 Aperçu du Menu

```text
=========== ASSIALMA ================
 1️⃣  Mettre à jour tous les paquets installés
 2️⃣  Nettoyer le cache et supprimer les paquets orphelins
 3️⃣  Vérifier l’utilisation de l’espace disque
 4️⃣  Identifier les plus gros fichiers/répertoires
 5️⃣  Nettoyer les fichiers temporaires/anciens logs
 6️⃣  Gérer les services (démarrer, arrêter, état, redémarrer)
 7️⃣  Gérer les services au démarrage du système
 8️⃣  Ajouter/supprimer des règles de pare-feu
 9️⃣  Activer/désactiver des zones de pare-feu
🔟  Recharger la configuration du pare-feu
1️⃣1️⃣ Installation auto de serveurs web, BDD, langages
1️⃣2️⃣ Ajouter des dépôts tiers (EPEL, Remi, etc.)
1️⃣3️⃣ Afficher l’état des interfaces réseau
1️⃣4️⃣ Changer l’IP ou configurer le DHCP
1️⃣5️⃣ Rechercher des erreurs/avertissements dans les logs
1️⃣6️⃣ Archiver/purger les anciens logs
1️⃣7️⃣ Vérifier l’état du swap
1️⃣8️⃣ Créer/activer un fichier de swap
1️⃣9️⃣ Générer des rapports système (CPU/mémoire...)
2️⃣0️⃣ Stocker/envoyer ces rapports par e-mail
2️⃣1️⃣ Gestion des utilisateurs (ajout/suppression)
2️⃣2️⃣ Sauvegarder/restaurer un fichier/répertoire
2️⃣3️⃣ Audit sécurité rapide
2️⃣4️⃣ Générer un rapport complet du système
2️⃣5️⃣ Quitter
```

---

## 🗂️ Structure du projet

```
ASSIALMA/
│
├── app/alma/
│   ├── install.sh           # Script principal interactif
│   └── ...
├── components/
│   ├── variables.sh         # Variables de configuration et couleurs
│   ├── logo.sh              # Affichage du logo
│   └── functions.sh         # Fonctions utilitaires et logiques du menu
├── Dockerfile               # Image Docker pour les tests
├── docker-compose.yml       # Docker Compose pour multi-conteneurs
└── README.md                # Documentation
```

---

## 🤝 Contribution & Tests

Les contributions sont les bienvenues !  
Merci d’ouvrir une issue ou une pull request pour toute suggestion, bug ou amélioration.

**Tests avec Docker**

```bash
# Construire
docker-compose up --build -d

# Lancer le conteneur créé
docker-compose exec assialma_test bash
```

---

## 📬 Contact

Auteur : Jérôme N.  
Ingénieur Système & Réseau Linux, Microservices & Docker  
[Profil GitHub](https://github.com/NABEDE)

---

## 📄 Licence

Ce projet est sous licence MIT. Voir le fichier `LICENSE` pour plus de détails.

---

**ASSIALMA — Simplifiez, sécurisez et optimisez l’administration de vos serveurs AlmaLinux/RHEL !** 🚀