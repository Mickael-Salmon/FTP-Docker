# Utiliser une image Debian de base
FROM debian:latest

# Mettre à jour le système et installer fail2ban, openssh-server, syslog-ng, iptables, et autres dépendances nécessaires
RUN apt-get update && \
    apt-get install -y fail2ban openssh-server syslog-ng iptables vim && \
    mkdir /var/run/sshd && \
    touch /var/log/auth.log

# Copier la configuration personnalisée de fail2ban
COPY jail.local /etc/fail2ban/jail.local

# Configurer syslog-ng pour rediriger les logs SSH vers /var/log/auth.log
RUN echo '@version: 3.13' > /etc/syslog-ng/syslog-ng.conf && \
    echo 'source s_src { system(); internal(); };' >> /etc/syslog-ng/syslog-ng.conf && \
    echo 'destination d_auth { file("/var/log/auth.log"); };' >> /etc/syslog-ng/syslog-ng.conf && \
    echo 'filter f_auth { facility(auth, authpriv); };' >> /etc/syslog-ng/syslog-ng.conf && \
    echo 'log { source(s_src); filter(f_auth); destination(d_auth); };' >> /etc/syslog-ng/syslog-ng.conf

# Exposer le port pour SSH
EXPOSE 22

# Démarrer les services syslog-ng, SSH et fail2ban
CMD service syslog-ng start && service ssh start && fail2ban-client start && tail -f /var/log/auth.log
