#!/bin/bash

# Crée les répertoires nécessaires si ils n'existent pas
mkdir -p /usr/local/apache2/htdocs/extranet.rainbowbank.com
mkdir -p /usr/local/apache2/htdocs/admin.rainbowbank.com

# Démarre Apache
httpd-foreground
