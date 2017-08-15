#!/bin/bash

SITE_ROOT="/var/www/maxwelljmorgan.net/html/"
PUBLIC_DIR="/home/mjmor/repos/hugo-personal-site/public/"
HUGO_BIN="/usr/bin/hugo"

REPO_UPDATED=false
git pull
if [[ $? -eq 1 ]]; then REPO_UPDATED=true; echo "Website updated in repo"; fi
OVERRIDE=false
if [[ $# -eq 1 ]]; then OVERRIDE=true; echo "Website update override set"; fi
if $REPO_UPDATED || $OVERRIDE; then
    $HUGO_BIN
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
else
    echo "No update needed and no override used"; exit 1;
fi
