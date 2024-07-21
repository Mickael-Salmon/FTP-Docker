FROM debian:latest

# Installer les dépendances nécessaires
RUN apt-get update && \
    apt-get install -y pure-ftpd net-tools iputils-ping ftp nano && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Ajouter les groupes et les utilisateurs
RUN groupadd developers && \
    groupadd designers && \
    useradd -u 1001 -g developers -m -s /bin/bash dev_user && \
    useradd -u 1002 -g designers -m -s /bin/bash design_user && \
    useradd -u 1003 -m -s /bin/bash ftpuser && \
    echo "dev_user:password" | chpasswd && \
    echo "design_user:password" | chpasswd && \
    echo "ftpuser:password" | chpasswd

# Créer les répertoires de travail pour les utilisateurs
RUN mkdir -p /home/ftpusers/dev_user/extranet.rainbowbank.com && \
    mkdir -p /home/ftpusers/dev_user/admin.rainbowbank.com && \
    mkdir -p /home/ftpusers/design_user/extranet.rainbowbank.com/images && \
    mkdir -p /home/ftpusers/design_user/admin.rainbowbank.com/images && \
    chown -R dev_user:developers /home/ftpusers/dev_user && \
    chown -R design_user:designers /home/ftpusers/design_user && \
    chown -R ftpuser:ftpuser /home/ftpusers

# Copier les contenus des répertoires
COPY admin.rainbowbank.com /home/ftpusers/admin.rainbowbank.com
COPY extranet.rainbowbank.com /home/ftpusers/extranet.rainbowbank.com

# Configurer pure-ftpd pour utiliser TLS
RUN mkdir -p /etc/ssl/private && \
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/ssl/private/pure-ftpd.pem \
    -out /etc/ssl/private/pure-ftpd.pem \
    -subj "/C=FR/ST=ILE DE FRANCE/L=PARIS/O=RAINBOW BANK/OU=DIRECTION INFRASTRUCTURE ET LOGISTIQUE/CN=rainbowbank.com/emailAddress=admin@rainbowbank.com" && \
    chmod 600 /etc/ssl/private/pure-ftpd.pem

# Créer le répertoire pour le fichier passwd de Pure-FTPd et initialiser le fichier passwd
RUN mkdir -p /etc/pure-ftpd/passwd && \
    touch /etc/pure-ftpd/passwd/pureftpd.passwd

# Ajouter les utilisateurs à Pure-FTPd et créer la base de données
RUN pure-pw useradd ftpuser -u 1003 -d /home/ftpusers -m -f /etc/pure-ftpd/passwd/pureftpd.passwd && \
    pure-pw useradd dev_user -u 1001 -g 1001 -d /home/ftpusers/dev_user -m -f /etc/pure-ftpd/passwd/pureftpd.passwd && \
    pure-pw useradd design_user -u 1002 -g 1002 -d /home/ftpusers/design_user -m -f /etc/pure-ftpd/passwd/pureftpd.passwd && \
    pure-pw mkdb /etc/pure-ftpd/pureftpd.pdb -F /etc/pure-ftpd/passwd/pureftpd.passwd

# Configurer pure-ftpd pour chroot et TLS
COPY pure-ftpd.conf /etc/pure-ftpd/pure-ftpd.conf

EXPOSE 21 30000-30009

CMD ["pure-ftpd", "/etc/pure-ftpd/pure-ftpd.conf"]
