#!/bin/bash

apt-get update
apt-get install apache2 -y

a2ensite 000-default
service apache2 restart

INSTANCE_NAME=$(hostname)
echo '<!doctype html><html><body><h1>'$INSTANCE_NAME'</h1></body></html>' | tee /var/www/html/index.html
