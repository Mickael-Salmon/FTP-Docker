FROM debian:latest

# Installer les outils nécessaires
RUN apt-get update && apt-get install -y \
    inetutils-tools \
    iputils-ping \
    curl \
    lftp \
    nano \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Définir le répertoire de travail
WORKDIR /root

# Commande par défaut pour garder le conteneur en cours d'exécution
CMD ["tail", "-f", "/dev/null"]
