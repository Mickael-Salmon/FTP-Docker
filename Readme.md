# Configuration WEB/FTPS/SFTP/FAIL2BAN pour Rainbow Bank
# Scénario
## Scope du projet
L’objectif est de créer un prototype du serveur qui va héberger les sites.
Pour ça, il faut reprendre les arborescences de fichiers qui simulent l’arborescence des sources sur le serveur. Pour l’instant le développement n’a pas été fait, ça viendra plus tard. Pas besoin non plus de mettre en
place le DNS.

# Le serveur
- Préparation d’une machine virtuelle, capacité minimale 1 CPU, 1 024
ou 2 048 Mo de mémoire, 10 Go d’espace disque suffiront.
- Docker
- Deux pattes réseaux :
- une sur le 192.168.10.0/24 pour l’interne ;
- une pour simuler l’externe en 150.10.0.0/16, par exemple.
- Installation d’une distribution Debian ou Ubuntu, mais en version minimale, pas d’environnement de bureau. On est ici sur un projet serveur.

## 1. Le service web
- Installation du serveur HTTPD d'Apache. À faire avec les packages de la distribution, inutile de compiler la dernière version.
- Création de deux virtual hosts :
○ extranet.rainbowbank.com ;
○ admin.rainbowbank.com.
- Les deux vhosts doivent référencer deux arborescences de sources différentes. Recommandation : créer deux répertoires dans le /var/www (extranet.rainbowbank.com et admin.rainbowbank.com,par exemple).
- Le vhost extranet doit être accessible sur la patte réseau publique, le vhost admin uniquement sur la patte privée.
- Changement du port d’écoute pour le vhost admin en 5501 pour HTTP et 5502 pour le HTTPS, par exemple.
- Génération d’un certificat auto-signé wildcard pour les deux vhosts.
Pour ça, il faut utiliser les données de l’entreprise et l’adresse mail admin (FR, ILE DE FRANCE, PARIS, RAINBOW BANK, DIRECTION INFRASTRUCTURE ET LOGISTIQUE et admin@rainbowbankcom).
- Mise en place d’une redirection forcée des requêtes entrantes HTTP vers HTTPS pour les deux vhosts.
- Attention à créer deux fichiers de traces d’accès, un pour chaque vhost. Il est possible de garder le même fichier de trace pour les erreurs.
- Configurer les droits d’accès sur les répertoires sources du service HTTPD, il faut qu’ils soient sécurisés au maximum.
- Il faut cependant prévoir les droits d’écriture pour le vhost extranet dans le répertoire PDF, car les utilisateurs vont pouvoir charger des fichiers directement depuis le site.
→ Tester cette partie 2 également avec NGINX.
## 2. Le service FTP
- L’idée ici est de rendre accessibles les répertoires des sources des sites aux personnes qui en ont besoin.
- Les futurs développeurs vont avoir besoin d’accéder aux répertoires des codes sources des deux vhosts.
- Les graphistes doivent uniquement accéder aux répertoires des images des deux vhosts.
- Il faut bien évidemment refuser les connexions anonymes.
- Recommandation : créer des groupes Linux pour gérer ces droits et inventer deux comptes nominatifs de test : un pour un développeur et un pour un graphiste.
- Mise en place d’un cloisonnement via un chroot ou un jail sur ce service, pour bien le sécuriser.
- Le service FTP doit être uniquement accessible sur la patte privée.
## 3. Le filtrage
Un filtrage IP avec netfilter doit être appliqué sur le serveur en laissant passer le minimum de protocoles nécessaires sur les deux pattes réseau (il est possible de garder le flux SSH sur la patte interne pour l’administration du serveur).
## 4. La prévention sur la sécurité
Il faut mettre en place les mesures préventives suivantes en termes de sécurité :
- Utiliser des modules et des paramètres de configuration qui permettent de se prémunir contre les attaques DDoS ou slow connections.
- Appliquer des configurations Fail2Ban qui permettent d’ajouter automatiquement des règles de filtrage dans netfilter sur 3 mauvaises tentatives de connexion FTP d’affilée, et sur 3 requêtes sur un fichier de l’arborescence des sites (temps de ban de 5 minutes seulement pour vérifier que ça fonctionne)

## Introduction
Ce dépôt contient un "Proof of Concept" de la configuration des services Web, FTP, FTPS, et SFTP de Rainbow Bank, intégrés avec Fail2Ban pour la sécurité.

La configuration utilise Docker et Docker Compose pour créer et gérer les conteneurs nécessaires.

### Prérequis
- Docker
- Docker Compose
- Git

### Architecture
L'architecture se compose de six conteneurs principaux :

- site1 : Héberge le site web et fournit un accès HTTP/HTTPS.
- site2 : Héberge un autre site web et fournit un accès HTTP/HTTPS.
- ftps : Fournit un accès FTPS.
- sftp : Fournit un accès SFTP.
- fail2ban : Surveille et bannit les adresses IP basées sur les tentatives de connexion échouées pour sécuriser les services FTP/FTPS/SFTP.
- nginx : Fournit un serveur Nginx.

### Diagramme

## Installation

- Étape 1 : Cloner le dépôt

```
git clone https://github.com/Mickael-Salmon/FTP-Docker.git
```
```
cd rainbow-bank-ftp-setup
```

- Étape 2 : Configurer les répertoires et les permissions

Assurez-vous que les répertoires et permissions nécessaires sont configurés sur la machine hôte :

```
mkdir -p logs/apache2/site1
mkdir -p logs/apache2/site2
mkdir -p logs/pure-ftpd
mkdir -p logs/auth.log
touch logs/auth.log
chmod 600 logs/auth.log
```

- Étape 3 : Construire et démarrer les conteneurs

```
docker compose up --build
```

- Étape 4 : Vérifier le statut des conteneurs
Vérifiez que tous les conteneurs sont en cours d'exécution :

```
docker ps
```

#### Fichiers de Configuration
Fichier Docker Compose
Ce fichier définit les services, les réseaux et les volumes :

```
version: '3.8'

services:
  site1:
    build:
      context: ./site1
    container_name: site1
    networks:
      web_network:
        ipv4_address: 150.10.0.2
      internal_network:
        ipv4_address: 192.168.10.2
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - ./logs/apache2/site1:/usr/local/apache2/logs
      - ./site1/www:/usr/local/apache2/htdocs
      - ./site1/sites-enabled/httpd.conf:/usr/local/apache2/conf/httpd.conf
      - ./site1/sites-enabled/httpd-vhosts.conf:/usr/local/apache2/conf/extra/httpd-vhosts.conf
      - ./site1/ssl:/usr/local/apache2/conf/ssl

  site2:
    build:
      context: ./site2
    container_name: site2
    networks:
      web_network:
        ipv4_address: 150.10.0.3
      internal_network:
        ipv4_address: 192.168.10.3
    ports:
      - "8080:80"
      - "8443:443"
    volumes:
      - ./logs/apache2/site2:/usr/local/apache2/logs
      - ./site2/www:/usr/local/apache2/htdocs
      - ./site2/sites-enabled/httpd.conf:/usr/local/apache2/conf/httpd.conf
      - ./site2/sites-enabled/httpd-vhosts.conf:/usr/local/apache2/conf/extra/httpd-vhosts.conf
      - ./site2/ssl:/usr/local/apache2/conf/ssl

  ftps:
    build: ./ftps
    container_name: ftps
    ports:
      - "21:21"
      - "30000-30009:30000-30009"
    volumes:
      - ./ftps/config:/etc/pure-ftpd
      - ./ftps/home:/home
      - ./site1/www:/home/developer
      - ./site1/www/admin.rainbowbank.com/images:/home/designer/admin/images
      - ./site1/www/extranet.rainbowbank.com/images:/home/designer/extranet/images
    networks:
      - internal_network

  sftp:
    image: atmoz/sftp
    container_name: sftp_server
    networks:
      internal_network:
        ipv4_address: 192.168.10.4
    ports:
      - "22:22"
    volumes:
      - ./logs/sftp:/home/sftpuser/upload
    environment:
      SFTP_USERS: "sftpuser:password:1001"

  nginx:
    image: nginx:latest
    container_name: nginx
    networks:
      web_network:
        ipv4_address: 150.10.0.4
      internal_network:
        ipv4_address: 192.168.10.5
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - ./logs/nginx:/var/log/nginx
      - ./nginx/html:/usr/share/nginx/html
      - ./nginx/conf.d:/etc/nginx/conf.d
      - ./nginx/ssl:/etc/nginx/ssl

  fail2ban:
    build: ./fail2ban
    container_name: fail2ban
    networks:
      internal_network:
        ipv4_address: 192.168.10.6
      web_network:
        ipv4_address: 150.10.0.5
    volumes:
      - ./logs/apache2/site1:/var/log/apache2/site1
      - ./logs/apache2/site2:/var/log/apache2/site2
      - ./logs/pure-ftpd:/var/log/pure-ftpd
      - ./logs/auth.log:/var/log/auth.log

networks:
  web_network:
    driver: bridge
    ipam:
      config:
        - subnet: 150.10.0.0/16
  internal_network:
    driver: bridge
    ipam:
      config:
        - subnet: 192.168.10.0/24
```

### Dockerfile pour ftps

```
FROM debian:latest

RUN apt-get update && apt-get install -y vsftpd openssl net-tools iputils-ping ftp nano lftp

RUN mkdir -p /var/run/vsftpd/empty \
    && mkdir -p /etc/ssl/private \
    && mkdir -p /etc/ssl/certs \
    && openssl req -newkey rsa:2048 -nodes -keyout /etc/ssl/private/ssl-cert-snakeoil.key -x509 -days 365 -out /etc/ssl/certs/ssl-cert-snakeoil.pem -subj "/C=FR/ST=ILE DE FRANCE/L=PARIS/O=RAINBOW BANK/OU=DIRECTION INFRASTRUCTURE ET LOGISTIQUE/CN=rainbowbank.com/emailAddress=admin@rainbowbank.com"

RUN useradd -u 1001 -m -d /home/designer -s /bin/false designer && echo "designer:password" | chpasswd \
    && useradd -u 1002 -m -d /home/dev -s /bin/false dev && echo "dev:password" | chpasswd \
    && useradd -u 1003 -m -d /home/developer -s /bin/false developer && echo "developer:password" | chpasswd \
    && useradd -u 1004 -m -d /home/graphiste -s /bin/false graphiste && echo "graphiste:password" | chpasswd \
    && useradd -u 1005 -m -d /home/user -s /bin/false user && echo "user:password" | chpasswd

COPY config/vsftpd.conf /etc/vsftpd/vsftpd.conf
COPY config/pam_vsftpd.conf /etc/pam.d/vsftpd

COPY ssl /etc/ssl

RUN chown root:root /etc/vsftpd/vsftpd.conf && chmod 644 /etc/vsftpd/vsftpd.conf \
    && chown root:root /etc/ssl/certs/ssl-cert-snakeoil.pem && chmod 600 /etc/ssl/certs/ssl-cert-snakeoil.pem \
    && chown root:root /etc/ssl/private/ssl-cert-snakeoil.key && chmod 600 /etc/ssl/private/ssl-cert-snakeoil.key

RUN chown -R developer:developer /home/developer && \
    chown -R designer:designer /home/designer && \
    chmod -R 755 /home/developer && \
    chmod -R 755 /home/designer

EXPOSE 20 21 21100-21110

CMD ["/usr/sbin/vsftpd", "/etc/vsftpd/vsftpd.conf"]
Dockerfile pour fail2ban
Dockerfile
Copy code
FROM debian:latest

RUN apt-get update && \
    apt-get install -y fail2ban openssh-server syslog-ng iptables vim vsftpd pure-ftpd && \
    mkdir /var/run/sshd && \
    touch /var/log/auth.log && \
    touch /var/log/vsftpd.log && \
    touch /var/log/pure-ftpd.log

COPY jail.local /etc/fail2ban/jail.local

RUN echo '@version: 3.13' > /etc/syslog-ng/syslog-ng.conf && \
    echo 'source s_src { system(); internal(); };' >> /etc/syslog-ng/syslog-ng.conf && \
    echo 'destination d_auth { file("/var/log/auth.log"); };' >> /etc/syslog-ng/syslog-ng.conf && \
    echo 'filter f_auth { facility(auth, authpriv); };' >> /etc/syslog-ng/syslog-ng.conf && \
    echo 'log { source(s_src); filter(f_auth); destination(d_auth); };' >> /etc/syslog-ng/syslog-ng.conf

EXPOSE 22

CMD service syslog-ng start && service ssh start && service vsftpd start && fail2ban-client start && tail -f /var/log/auth.log
```

### Procédure de Test
- Étape 1 : Démarrer les Conteneurs

```
docker compose up -d
```

- Étape 2 : Vérifier les Logs
Pour vérifier les logs sur le conteneur fail2ban :

```
docker exec -it fail2ban /bin/bash
tail -f /var/log/auth.log
```

- Étape 3 : Tester les Connexions FTP, FTPS, et SFTP
Utilisez des outils comme ncftp pour tester les connexions.

### Tester FTP

```
ncftp -u dev -p password ftp://192.168.10.3
```

### Tester FTPS
```
lftp -e "set ssl:verify-certificate no; login dev password; ls" ftps://192.168.10.3
```

### Tester SFTP

```
sftp dev@192.168.10.4
```

### Étape 4 : Vérifier les Bans

- Pour voir les adresses IP bannies :
```
fail2ban-client status vsftpd
fail2ban-client status sftp
fail2ban-client status ssh
```
- Pour débannir une IP :

```
fail2ban-client set vsftpd unbanip <IP>
fail2ban-client set sftp unbanip <IP>
fail2ban-client set ssh unbanip <IP>
```

## Conclusion
Cette configuration assure des services WEB, FTP, FTPS, et SFTP sécurisés pour Rainbow Bank, avec Fail2Ban fournissant une couche de sécurité supplémentaire en bannissant les adresses IP après plusieurs tentatives de connexion échouées.