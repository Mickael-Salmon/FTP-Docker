FROM httpd:latest

# Installer curl et net-tools
RUN apt-get update && apt-get install -y curl net-tools

# Activer les modules nécessaires
RUN echo "LoadModule socache_shmcb_module modules/mod_socache_shmcb.so" >> /usr/local/apache2/conf/httpd.conf \
    && echo "LoadModule ssl_module modules/mod_ssl.so" >> /usr/local/apache2/conf/httpd.conf \
    && echo "LoadModule headers_module modules/mod_headers.so" >> /usr/local/apache2/conf/httpd.conf \
    && echo "LoadModule alias_module modules/mod_alias.so" >> /usr/local/apache2/conf/httpd.conf \
    && echo "ServerName localhost" >> /usr/local/apache2/conf/httpd.conf

# Copier les fichiers de configuration et les certificats
COPY ssl /usr/local/apache2/conf/ssl
COPY sites-enabled/httpd.conf /usr/local/apache2/conf/httpd.conf
COPY sites-enabled/httpd-vhosts.conf /usr/local/apache2/conf/extra/httpd-vhosts.conf

# Créer les répertoires nécessaires
RUN mkdir -p /usr/local/apache2/htdocs/extranet.rainbowbank.com /usr/local/apache2/htdocs/admin.rainbowbank.com
COPY www /usr/local/apache2/htdocs

# Exposer les ports nécessaires
EXPOSE 80 443 5501 5502
