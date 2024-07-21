# Utiliser l'image Debian
FROM debian:latest

# Installer OpenSSH et rsyslog
RUN apt-get update && apt-get install -y openssh-server rsyslog

# Créer des utilisateurs pour chaque répertoire avec des mots de passe et enregistrer leurs UID/GID
RUN useradd -u 1001 -m -d /home/designer -s /usr/sbin/nologin designer && echo "designer:password" | chpasswd \
    && useradd -u 1002 -m -d /home/dev -s /usr/sbin/nologin dev && echo "dev:password" | chpasswd \
    && useradd -u 1003 -m -d /home/developer -s /usr/sbin/nologin developer && echo "developer:password" | chpasswd \
    && useradd -u 1004 -m -d /home/graphiste -s /usr/sbin/nologin graphiste && echo "graphiste:password" | chpasswd \
    && useradd -u 1005 -m -d /home/user -s /usr/sbin/nologin user && echo "user:password" | chpasswd

# Créer le répertoire pour les clés SSH et générer une clé de serveur SSH
RUN mkdir -p /var/run/sshd && ssh-keygen -A

# Configuration d'OpenSSH pour SFTP
COPY sshd_config /etc/ssh/sshd_config

# Script de démarrage
COPY start_services.sh /usr/local/bin/start_services.sh
RUN chmod +x /usr/local/bin/start_services.sh

# Expose le port 22 pour SFTP
EXPOSE 22

# Commande pour démarrer les services
CMD ["/usr/local/bin/start_services.sh"]
