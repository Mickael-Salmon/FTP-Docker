FROM debian:latest

# Installer vsftpd et openssl pour générer les certificats
RUN apt-get update && apt-get install -y vsftpd openssl net-tools iputils-ping ftp nano lftp

# Créer les dossiers nécessaires et générer des certificats SSL si nécessaire
RUN mkdir -p /var/run/vsftpd/empty \
    && mkdir -p /etc/ssl/private \
    && mkdir -p /etc/ssl/certs \
    && openssl req -newkey rsa:2048 -nodes -keyout /etc/ssl/private/ssl-cert-snakeoil.key -x509 -days 365 -out /etc/ssl/certs/ssl-cert-snakeoil.pem -subj "/C=FR/ST=ILE DE FRANCE/L=PARIS/O=RAINBOW BANK/OU=DIRECTION INFRASTRUCTURE ET LOGISTIQUE/CN=rainbowbank.com/emailAddress=admin@rainbowbank.com"

# Créer des groupes et des utilisateurs pour chaque répertoire avec des mots de passe et enregistrer leurs UID/GID
RUN groupadd developers \
    && groupadd designers \
    && useradd -u 1001 -m -g designers -s /bin/false designer && echo "designer:password" | chpasswd \
    && useradd -u 1002 -m -g developers -s /bin/false dev && echo "dev:password" | chpasswd \
    && useradd -u 1003 -m -g developers -s /bin/false developer && echo "developer:password" | chpasswd \
    && useradd -u 1004 -m -g designers -s /bin/false graphiste && echo "graphiste:password" | chpasswd \
    && useradd -u 1005 -m -s /bin/false user && echo "user:password" | chpasswd

# Copier les fichiers de configuration
COPY config/vsftpd.conf /etc/vsftpd/vsftpd.conf
COPY config/pam_vsftpd.conf /etc/pam.d/vsftpd

# Copier les certificats SSL
COPY ssl /etc/ssl

# Mettre à jour les permissions des fichiers de configuration et SSL
RUN chown root:root /etc/vsftpd/vsftpd.conf && chmod 644 /etc/vsftpd/vsftpd.conf \
    && chown root:root /etc/ssl/certs/ssl-cert-snakeoil.pem && chmod 600 /etc/ssl/certs/ssl-cert-snakeoil.pem \
    && chown root:root /etc/ssl/private/ssl-cert-snakeoil.key && chmod 600 /etc/ssl/private/ssl-cert-snakeoil.key

# Créer les répertoires de travail pour les utilisateurs
RUN mkdir -p /home/developer/extranet.rainbowbank.com && \
    mkdir -p /home/developer/admin.rainbowbank.com && \
    mkdir -p /home/designer/extranet/images && \
    mkdir -p /home/designer/admin/images

# Changer les propriétaires et ajuster les permissions
RUN chown -R developer:developers /home/developer/extranet.rainbowbank.com && \
    chown -R developer:developers /home/developer/admin.rainbowbank.com && \
    chown -R designer:designers /home/designer/extranet/images && \
    chown -R designer:designers /home/designer/admin/images && \
    chmod -R 755 /home/developer/extranet.rainbowbank.com && \
    chmod -R 755 /home/developer/admin.rainbowbank.com && \
    chmod -R 755 /home/designer/extranet/images && \
    chmod -R 755 /home/designer/admin/images

# Expose les ports
EXPOSE 20 21 21100-21110

# Commande pour démarrer vsftpd
CMD ["/usr/sbin/vsftpd", "/etc/vsftpd/vsftpd.conf"]
