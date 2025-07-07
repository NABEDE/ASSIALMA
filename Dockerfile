FROM almalinux:latest

# Mise à jour du système et installation des outils nécessaires
RUN dnf -y update && \
    dnf install -y sudo firewalld bash && \
    dnf clean all

# Définir le répertoire de travail
WORKDIR /home/app/ATIN_CENTOS-1.0/app/centos \
        /home/app/ATIN_CENTOS-1.0/components


# Copier les fichiers dans le containeur
COPY components/ /home/app/ATIN_CENTOS-1.0/components/


# Correction des droits et rendre les scripts exécutables
RUN find /home/app/ATIN_CENTOS-1.0/app -type f -name "*.sh" -exec chmod +x {} \;


# Par défaut, entrer dans bash
ENTRYPOINT ["/bin/bash"]

# Optionnel : lancer le script automatiquement
CMD ["./install.sh"]
