# Utiliser l'image de base Debian
FROM debian:latest

# Mettre à jour les paquets et installer les outils nécessaires
RUN apt-get update && \
    apt-get install -y openssh-server && \
    mkdir /var/run/sshd

# Ajouter un utilisateur avec un mot de passe pour SFTP
RUN useradd -m -d /home/ftpuser -s /bin/bash ftpuser && \
    echo "ftpuser:password" | chpasswd

# Créer un répertoire pour SFTP et ajuster les permissions
RUN mkdir -p /home/ftpuser/upload && \
    chown root:root /home/ftpuser && \
    chmod 755 /home/ftpuser && \
    chown ftpuser:ftpuser /home/ftpuser/upload

# Configurer le SSHD pour SFTP
RUN echo "Match User ftpuser" >> /etc/ssh/sshd_config && \
    echo "ChrootDirectory /home/ftpuser" >> /etc/ssh/sshd_config && \
    echo "ForceCommand internal-sftp" >> /etc/ssh/sshd_config && \
    echo "AllowTcpForwarding no" >> /etc/ssh/sshd_config && \
    echo "PermitTunnel no" >> /etc/ssh/sshd_config && \
    echo "X11Forwarding no" >> /etc/ssh/sshd_config

# Exposer le port 22
EXPOSE 22

# Lancer le serveur SSH
CMD ["/usr/sbin/sshd", "-D"]
