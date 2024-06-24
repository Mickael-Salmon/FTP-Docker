#!/bin/bash

echo "Quel serveur web souhaitez-vous installer ?"
echo "1. Apache"
echo "2. NGINX"
read -p "Entrez votre choix (1 ou 2): " choice

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

echo "Configuration et déploiement du serveur FTP..."

# Construire et lancer le conteneur FTP
docker compose -f docker-compose-ftp.yml build
docker compose -f docker-compose-ftp.yml up -d

echo "Serveur FTP déployé et en cours d'exécution."

echo "Installation et configuration terminées."
