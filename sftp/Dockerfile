FROM atmoz/sftp

# Installer les outils nécessaires
RUN apt-get update && apt-get install -y \
    inetutils-tools \
    iputils-ping \
    curl \
    nano \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Ajouter l'entrée dans le fichier /etc/hosts
RUN echo "192.168.10.2 admin.rainbowbank.com" >> /etc/hosts

# Ajouter les groupes et les utilisateurs
RUN groupadd developers && \
    groupadd designers && \
    useradd -m -g developers -s /bin/bash dev_user && \
    useradd -m -g designers -s /bin/bash design_user && \
    echo "dev_user:password" | chpasswd && \
    echo "design_user:password" | chpasswd

# Configurer les permissions des répertoires
RUN mkdir -p /var/www/extranet.rainbowbank.com && \
    mkdir -p /var/www/admin.rainbowbank.com && \
    mkdir -p /var/www/extranet.rainbowbank.com/images && \
    mkdir -p /var/www/admin.rainbowbank.com/images && \
    chown root:root /var/www && \
    chmod 755 /var/www && \
    chown root:root /var/www/extranet.rainbowbank.com && \
    chmod 755 /var/www/extranet.rainbowbank.com && \
    chown root:root /var/www/admin.rainbowbank.com && \
    chmod 755 /var/www/admin.rainbowbank.com && \
    chown -R dev_user:developers /var/www/extranet.rainbowbank.com/* && \
    chown -R design_user:designers /var/www/extranet.rainbowbank.com/images && \
    chown -R dev_user:developers /var/www/admin.rainbowbank.com/* && \
    chown -R design_user:designers /var/www/admin.rainbowbank.com/images

# Configurer le chroot pour dev_user
RUN echo "Match User dev_user" >> /etc/ssh/sshd_config && \
    echo "ChrootDirectory /var/www" >> /etc/ssh/sshd_config && \
    echo "AllowTcpForwarding no" >> /etc/ssh/sshd_config && \
    echo "X11Forwarding no" >> /etc/ssh/sshd_config

# Configurer le chroot pour design_user
RUN echo "Match User design_user" >> /etc/ssh/sshd_config && \
    echo "ChrootDirectory /var/www" >> /etc/ssh/sshd_config && \
    echo "AllowTcpForwarding no" >> /etc/ssh/sshd_config && \
    echo "X11Forwarding no" >> /etc/ssh/sshd_config

# Exposer le port SSH
EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]
