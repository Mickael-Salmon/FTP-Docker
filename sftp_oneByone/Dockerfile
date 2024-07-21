# Utiliser l'image de base Debian
FROM debian:latest

# Mettre à jour les paquets et installer les outils nécessaires
RUN apt-get update && \
    apt-get install -y openssh-server && \
    mkdir /var/run/sshd

# Ajouter les utilisateurs avec des mots de passe pour SFTP
RUN useradd -m -d /home/ftpuser -s /bin/bash ftpuser && \
    echo "ftpuser:password" | chpasswd && \
    useradd -m -d /home/dev -s /bin/bash dev && \
    echo "dev:password" | chpasswd && \
    useradd -m -d /home/designer -s /bin/bash designer && \
    echo "designer:password" | chpasswd && \
    useradd -m -d /home/graphiste -s /bin/bash graphiste && \
    echo "graphiste:password" | chpasswd && \
    useradd -m -d /home/user -s /bin/bash user && \
    echo "user:password" | chpasswd

# Créer des répertoires pour SFTP et ajuster les permissions
RUN mkdir -p /home/ftpuser/upload && \
    chown root:root /home/ftpuser && \
    chmod 755 /home/ftpuser && \
    chown ftpuser:ftpuser /home/ftpuser/upload && \
    mkdir -p /home/dev/upload && \
    chown root:root /home/dev && \
    chmod 755 /home/dev && \
    chown dev:dev /home/dev/upload && \
    mkdir -p /home/designer/upload && \
    chown root:root /home/designer && \
    chmod 755 /home/designer && \
    chown designer:designer /home/designer/upload && \
    mkdir -p /home/graphiste/upload && \
    chown root:root /home/graphiste && \
    chmod 755 /home/graphiste && \
    chown graphiste:graphiste /home/graphiste/upload && \
    mkdir -p /home/user/upload && \
    chown root:root /home/user && \
    chmod 755 /home/user && \
    chown user:user /home/user/upload

# Ajouter les clés SSH pour chaque utilisateur
COPY dev_key.pub /home/dev/.ssh/authorized_keys
COPY ftpuser_key.pub /home/ftpuser/.ssh/authorized_keys
COPY designer_key.pub /home/designer/.ssh/authorized_keys
COPY graphiste_key.pub /home/graphiste/.ssh/authorized_keys
COPY user_key.pub /home/user/.ssh/authorized_keys

RUN mkdir -p /home/dev/.ssh && \
    chmod 700 /home/dev/.ssh && \
    touch /home/dev/.ssh/authorized_keys && \
    chmod 600 /home/dev/.ssh/authorized_keys && \
    chown -R dev:dev /home/dev/.ssh && \
    mkdir -p /home/ftpuser/.ssh && \
    chmod 700 /home/ftpuser/.ssh && \
    touch /home/ftpuser/.ssh/authorized_keys && \
    chmod 600 /home/ftpuser/.ssh/authorized_keys && \
    chown -R ftpuser:ftpuser /home/ftpuser/.ssh && \
    mkdir -p /home/designer/.ssh && \
    chmod 700 /home/designer/.ssh && \
    touch /home/designer/.ssh/authorized_keys && \
    chmod 600 /home/designer/.ssh/authorized_keys && \
    chown -R designer:designer /home/designer/.ssh && \
    mkdir -p /home/graphiste/.ssh && \
    chmod 700 /home/graphiste/.ssh && \
    touch /home/graphiste/.ssh/authorized_keys && \
    chmod 600 /home/graphiste/.ssh/authorized_keys && \
    chown -R graphiste:graphiste /home/graphiste/.ssh && \
    mkdir -p /home/user/.ssh && \
    chmod 700 /home/user/.ssh && \
    touch /home/user/.ssh/authorized_keys && \
    chmod 600 /home/user/.ssh/authorized_keys && \
    chown -R user:user /home/user/.ssh

# Configurer le SSHD pour SFTP
RUN echo "Match User ftpuser" >> /etc/ssh/sshd_config && \
    echo "ChrootDirectory /home/ftpuser" >> /etc/ssh/sshd_config && \
    echo "ForceCommand internal-sftp" >> /etc/ssh/sshd_config && \
    echo "AllowTcpForwarding no" >> /etc/ssh/sshd_config && \
    echo "PermitTunnel no" >> /etc/ssh/sshd_config && \
    echo "X11Forwarding no" >> /etc/ssh/sshd_config && \
    echo "Match User dev" >> /etc/ssh/sshd_config && \
    echo "ChrootDirectory /home/dev" >> /etc/ssh/sshd_config && \
    echo "ForceCommand internal-sftp" >> /etc/ssh/sshd_config && \
    echo "AllowTcpForwarding no" >> /etc/ssh/sshd_config && \
    echo "PermitTunnel no" >> /etc/ssh/sshd_config && \
    echo "X11Forwarding no" >> /etc/ssh/sshd_config && \
    echo "Match User designer" >> /etc/ssh/sshd_config && \
    echo "ChrootDirectory /home/designer" >> /etc/ssh/sshd_config && \
    echo "ForceCommand internal-sftp" >> /etc/ssh/sshd_config && \
    echo "AllowTcpForwarding no" >> /etc/ssh/sshd_config && \
    echo "PermitTunnel no" >> /etc/ssh/sshd_config && \
    echo "X11Forwarding no" >> /etc/ssh/sshd_config && \
    echo "Match User graphiste" >> /etc/ssh/sshd_config && \
    echo "ChrootDirectory /home/graphiste" >> /etc/ssh/sshd_config && \
    echo "ForceCommand internal-sftp" >> /etc/ssh/sshd_config && \
    echo "AllowTcpForwarding no" >> /etc/ssh/sshd_config && \
    echo "PermitTunnel no" >> /etc/ssh/sshd_config && \
    echo "X11Forwarding no" >> /etc/ssh/sshd_config && \
    echo "Match User user" >> /etc/ssh/sshd_config && \
    echo "ChrootDirectory /home/user" >> /etc/ssh/sshd_config && \
    echo "ForceCommand internal-sftp" >> /etc/ssh/sshd_config && \
    echo "AllowTcpForwarding no" >> /etc/ssh/sshd_config && \
    echo "PermitTunnel no" >> /etc/ssh/sshd_config && \
    echo "X11Forwarding no" >> /etc/ssh/sshd_config

# Exposer le port 22
EXPOSE 22

# Lancer le serveur SSH
CMD ["/usr/sbin/sshd", "-D"]
