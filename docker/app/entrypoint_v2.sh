#!/bin/bash

cd /var/www
mkdir -p storage/app storage/app/public storage/app/upload storage/logs storage/framework storage/framework/sessions storage/framework/cache storage/framework/testing storage/framework/views storage/import

service php8.3-fpm start
service ssh start

/usr/bin/supervisord -n -c /etc/supervisord.conf
