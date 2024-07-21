# Utiliser une image Debian de base
FROM debian:latest

# Mettre à jour le système et installer fail2ban, openssh-server, syslog-ng, iptables, vim et vsftpd
RUN apt-get update && \
    apt-get install -y fail2ban openssh-server syslog-ng iptables vim vsftpd && \
    mkdir /var/run/sshd && \
    touch /var/log/auth.log && \
    touch /var/log/vsftpd.log

# Copier la configuration personnalisée de fail2ban
COPY jail.local /etc/fail2ban/jail.local

# Configurer syslog-ng pour rediriger les logs SSH vers /var/log/auth.log
RUN echo '@version: 3.38' > /etc/syslog-ng/syslog-ng.conf && \
    echo 'source s_src { system(); internal(); };' >> /etc/syslog-ng/syslog-ng.conf && \
    echo 'destination d_auth { file("/var/log/auth.log"); };' >> /etc/syslog-ng/syslog-ng.conf && \
    echo 'destination d_vsftpd { file("/var/log/vsftpd.log"); };' >> /etc/syslog-ng/syslog-ng.conf && \
    echo 'filter f_auth { facility(auth, authpriv); };' >> /etc/syslog-ng/syslog-ng.conf && \
    echo 'log { source(s_src); filter(f_auth); destination(d_auth); };' >> /etc/syslog-ng/syslog-ng.conf

# Copier la configuration vsftpd
COPY config/vsftpd.conf /etc/vsftpd.conf

# Exposer les ports nécessaires pour FTP
EXPOSE 21 30000-30009

# Démarrer les services syslog-ng, SSH et fail2ban
CMD service syslog-ng start && service ssh start && service vsftpd start && fail2ban-client start && tail -f /var/log/auth.log
