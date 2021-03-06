#!/bin/bash

set -e

# Call entrypoint.sh
docker-entrypoint.sh "$@"

sed -i '/WP_DEBUG/a define("WP_SITEURL", "http://".$_SERVER["HTTP_HOST"]);' wp-config.php
sed -i '/WP_DEBUG/a define("WP_HOME", "http://".$_SERVER["HTTP_HOST"]);' wp-config.php

# If HOST_UID is passed, change the permissions
if [ ! -z "$HOST_UID" ]; then
    usermod -u ${HOST_UID} www-data
    groupmod -g ${HOST_GID} www-data
    chown -R www-data:www-data .
fi

if [  -z "$ENABLE_OPCACHE" ]; then
    rm -f /usr/local/etc/php/conf.d/opcache.ini
fi

if [  -z "$ENABLE_XDEBUG" ]; then
    rm -f /usr/local/etc/php/conf.d/xdebug.ini
fi
exec "$@"
