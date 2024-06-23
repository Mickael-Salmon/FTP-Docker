#!/bin/bash

echo "Quel serveur web souhaitez-vous installer ?"
echo "1. Apache"
echo "2. NGINX"
read -p "Entrez votre choix (1 ou 2): " choice

# # Créer les réseaux Docker
# docker network create --subnet=192.168.10.0/24 internal_net || true
# docker network create --subnet=150.10.0.0/16 external_net || true

# # Génération des certificats SSL
# echo "Génération des certificats SSL..."
# openssl req -newkey rsa:2048 -nodes -keyout wildcard.key -x509 -days 365 -out wildcard.crt -subj "/C=FR/ST=ILE DE FRANCE/L=PARIS/O=RAINBOW BANK/OU=DIRECTION INFRASTRUCTURE ET LOGISTIQUE/CN=rainbowbank.com/emailAddress=admin@rainbowbank.com"

# # Vérification de la génération des certificats
# if [ ! -f wildcard.crt ] || [ ! -f wildcard.key ]; then
#   echo "Erreur lors de la génération des certificats SSL."
#   exit 1
# fi

# mkdir -p apache/ssl nginx/ssl
# mv wildcard.crt apache/ssl/
# mv wildcard.key apache/ssl/
# cp wildcard.crt nginx/ssl/
# cp wildcard.key nginx/ssl/

# # Décompression des fichiers de projet
# echo "Décompression des fichiers de projet..."
# unzip -o extranet.rainbowbank.com.zip -d apache/www/extranet/
# unzip -o admin.rainbowbank.com.zip -d apache/www/admin/
# unzip -o extranet.rainbowbank.com.zip -d nginx/www/extranet/
# unzip -o admin.rainbowbank.com.zip -d nginx/www/admin/

# # Création du fichier httpd-vhosts.conf
# cat <<EOL > apache/sites-enabled/httpd-vhosts.conf
# ServerName 150.10.0.2

# <VirtualHost *:80>
#     ServerAdmin admin@rainbowbank.com
#     DocumentRoot "/usr/local/apache2/htdocs/extranet/extranet.rainbowbank.com"
#     ServerName extranet.rainbowbank.com
#     ErrorLog /usr/local/apache2/logs/extranet-error.log
#     CustomLog /usr/local/apache2/logs/extranet-access.log combined
#     <Directory "/usr/local/apache2/htdocs/extranet/extranet.rainbowbank.com">
#         AllowOverride All
#         Options -Indexes
#         Require all granted
#     </Directory>
# </VirtualHost>

# <VirtualHost *:5501>
#     ServerAdmin admin@rainbowbank.com
#     DocumentRoot "/usr/local/apache2/htdocs/admin/admin.rainbowbank.com"
#     ServerName admin.rainbowbank.com
#     ErrorLog /usr/local/apache2/logs/admin-error.log
#     CustomLog /usr/local/apache2/logs/admin-access.log combined
#     <Directory "/usr/local/apache2/htdocs/admin/admin.rainbowbank.com">
#         AllowOverride All
#         Options -Indexes
#         Require all granted
#     </Directory>
# </VirtualHost>
# EOL

if [ "$choice" -eq 1 ]; then
  # Construire et lancer les conteneurs Apache
  echo "Construction de l'image Docker pour Apache..."
  docker compose -f docker-compose-apache.yml build
  echo "Lancement des conteneurs Docker pour Apache..."
  docker compose -f docker-compose-apache.yml up -d
else
  # Construire et lancer les conteneurs NGINX
  echo "Construction de l'image Docker pour NGINX..."
  docker compose -f docker-compose-nginx.yml build
  echo "Lancement des conteneurs Docker pour NGINX..."
  docker compose -f docker-compose-nginx.yml up -d
fi

# # Construire et lancer les conteneurs FTP et Fail2Ban
# echo "Construction des images Docker personnalisées pour vsftpd et Fail2Ban..."
# docker compose -f docker-compose-ftp-fail2ban.yml build
# echo "Lancement des conteneurs Docker pour vsftpd et Fail2Ban..."
# docker compose -f docker-compose-ftp-fail2ban.yml up -d

echo "Installation et configuration terminées."
