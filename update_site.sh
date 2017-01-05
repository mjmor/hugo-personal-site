#!/bin/bash

SITE_ROOT="/var/www/maxwelljmorgan.net/html/"
PUBLIC_DIR="/home/mjmor/repos/hugo-personal-site/public/"

if git pull; then
    /home/mjmor/go/bin/hugo
    if [ ! -z "$SITE_ROOT" ]; then
        sudo find ${SITE_ROOT} ! -path "*/.well-known*" ! -path \
            ${SITE_ROOT} -type d -name "*" -exec rm -rf {} +
        sudo find ${SITE_ROOT} ! -path "*/.well-known*" ! -path \
            ${SITE_ROOT} -type f -name "*" -exec rm -rf {} +
    fi
    if [ ! -z "$PUBLIC_DIR" ]; then
        sudo cp -R ${PUBLIC_DIR}* $SITE_ROOT
    fi
    sudo systemctl reload nginx.service
fi
