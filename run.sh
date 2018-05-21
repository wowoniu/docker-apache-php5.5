#!/bin/bash
chown www-data:www-data /app -R

source /etc/apache2/envvars
echo $APACHE_LOCK_DIR
#tail -F /var/log/apache2/* &
#exec apache2 -D FOREGROUND
apache2ctl -D FOREGROUND
