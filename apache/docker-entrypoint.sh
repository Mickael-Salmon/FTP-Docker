#!/bin/bash
set -e

# Fixer les permissions des répertoires montés
chown -R www-data:www-data /usr/local/apache2/htdocs
chown -R www-data:www-data /usr/local/apache2/logs

# Démarrer Apache en mode foreground
exec "$@"
