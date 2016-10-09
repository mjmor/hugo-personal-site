#!/bin/bash

SITE_ROOT="/var/www/maxwelljmorgan.net/html/"
PUBLIC_DIR="/home/mjmor/repos/hugo-personal-site/public/"

if git pull; then
    /home/mjmor/go/bin/hugo
    if [ ! -z "$SITE_ROOT" ]; then
        sudo rm -rf ${SITE_ROOT}*
    fi
    if [ ! -z "$PUBLIC_DIR" ]; then
        sudo cp -R ${PUBLIC_DIR}* $SITE_ROOT && \
    fi
    sudo systemctl reload nginx.service
fi
