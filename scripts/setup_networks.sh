#!/bin/bash

# Création des réseaux Docker
docker network create --subnet=150.10.0.0/16 web_network
docker network create --subnet=192.168.10.0/24 internal_network

echo "Réseaux Docker créés avec succès."
