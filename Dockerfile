FROM almalinux:latest

# Mise à jour et installation des outils de base
RUN dnf -y update
RUN dnf install -y nano iputils

# Créer l'arborescence des dossiers
RUN mkdir -p /app/almalinux
RUN mkdir -p /app/components

# Copier les fichiers dans les bons répertoires
COPY app/almalinux/install.sh /app/almalinux/
COPY components/functions.sh /components/
COPY components/logo.sh /components/
COPY components/variables.sh /components/

# Définir le dossier de travail
WORKDIR /app/almalinux

# Donner les droits d'exécution
RUN chmod +x install.sh

# Exécuter install.sh à l’exécution du conteneur (optionnel)
#CMD ["./install.sh"]
# ou simplement un shell :
#CMD ["/bin/bash"]

CMD ["bash", "-c", "cd /app/almalinux && exec /bin/bash"]

