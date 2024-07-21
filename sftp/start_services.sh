#!/bin/bash

# Démarrer rsyslog
service rsyslog start

# Démarrer le serveur SSH
/usr/sbin/sshd -D
