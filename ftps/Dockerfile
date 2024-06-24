FROM debian:latest

# Installer vsftpd et openssl pour générer les certificats
RUN apt-get update && apt-get install -y vsftpd openssl

# Créer les dossiers nécessaires et générer des certificats SSL si nécessaire
RUN mkdir -p /var/run/vsftpd/empty \
    && mkdir -p /etc/ssl/private \
    && mkdir -p /etc/ssl/certs \
    && openssl req -newkey rsa:2048 -nodes -keyout /etc/ssl/private/ssl-cert-snakeoil.key -x509 -days 365 -out /etc/ssl/certs/ssl-cert-snakeoil.pem -subj "/C=FR/ST=ILE DE FRANCE/L=PARIS/O=RAINBOW BANK/OU=DIRECTION INFRASTRUCTURE ET LOGISTIQUE/CN=rainbowbank.com/emailAddress=admin@rainbowbank.com"

# Copier les fichiers de configuration
COPY config/vsftpd.conf /etc/vsftpd/vsftpd.conf

# Mettre à jour les permissions des fichiers de configuration et SSL
RUN chown root:root /etc/vsftpd/vsftpd.conf && chmod 644 /etc/vsftpd/vsftpd.conf \
    && chown root:root /etc/ssl/certs/ssl-cert-snakeoil.pem && chmod 600 /etc/ssl/certs/ssl-cert-snakeoil.pem \
    && chown root:root /etc/ssl/private/ssl-cert-snakeoil.key && chmod 600 /etc/ssl/private/ssl-cert-snakeoil.key

# Expose les ports
EXPOSE 20 21 21100-21110

CMD ["/usr/sbin/vsftpd", "/etc/vsftpd/vsftpd.conf"]
