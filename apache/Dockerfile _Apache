FROM httpd:latest

# Expose les ports
EXPOSE 80 443 5501

# Commandes de débogage (facultatif, pour vérifier les volumes montés)
RUN ls -l /usr/local/apache2/conf/httpd.conf || true
RUN ls -l /usr/local/apache2/conf/extra/httpd-vhosts.conf || true
RUN ls -l /usr/local/apache2/logs || true

# Démarrez Apache pour appliquer les nouvelles configurations
CMD ["httpd-foreground"]
