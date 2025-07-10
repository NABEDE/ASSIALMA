FROM almalinux:latest

# Mise à jour du système et installation des outils nécessaires
RUN dnf -y update && \
    dnf install -y sudo firewalld bash && \
    dnf clean all

# Définir le répertoire de travail principal
WORKDIR /home/app/almalinux

# Copier les fichiers dans le conteneur
COPY app/almalinux/ /home/app/almalinux/
COPY components/ /home/components/

# Donner les droits d'exécution au script d'installation
RUN chmod +x /home/app/almalinux/install.sh

# Définir bash comme point d'entrée
ENTRYPOINT ["/bin/bash"]

# Lancer le script automatiquement si on ne passe pas de commande
CMD ["-c", "./install.sh"]
