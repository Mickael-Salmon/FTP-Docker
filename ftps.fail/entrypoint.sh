#!/bin/bash
set -e

# Recréer la base de données Pure-FTPd
pure-pw mkdb /etc/pure-ftpd/pureftpd.pdb -F /etc/pure-ftpd/passwd/pureftpd.passwd

# Démarrer le serveur Pure-FTPd
exec pure-ftpd /etc/pure-ftpd/pure-ftpd.conf
