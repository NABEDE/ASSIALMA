FROM almalinux:latest

# Mise à jour du système et installation des outils nécessaires
RUN dnf -y update && \
    dnf install -y sudo firewalld bash && \
    dnf clean all

# Définir le répertoire de travail
WORKDIR /home/app/almalinux \
        /home/components


# Copier les fichiers dans le containeur
COPY app/almalinux/ /home/app/almalinux/
COPY components/ /home/components/

# Entrer dans la partie components
RUN cd /home/app/almalinux

# Changer les accès du fichier install
RUN chmod +x install.sh


# Par défaut, entrer dans bash
ENTRYPOINT ["/bin/bash"]

# Optionnel : lancer le script automatiquement
CMD ["./install.sh"]
