#!/bin/bash

npm install
node update.js
COMPOSE_FILES=(./versions/*/docker-compose.*)
for CF in "${COMPOSE_FILES[@]}"; do
  if [ -f "$CF" ]; then
    sed -i '/version:/d' "$CF"
    sed -i '/image: mysql/a \    cap_add:\n\      - SYS_NICE' "$CF"
    sed -i '/OPENSEARCH_JAVA_OPTS/a \      - "OPENSEARCH_INITIAL_ADMIN_PASSWORD=jexqrwT$1b@@%Lg"' "$CF"
    sed -i '/magento-data:\/var\/www\/html/a \      - ./app:/var/www/html:cached' "$CF"
  fi
done

read -rn 1 -p "Would you like to added 'local.magento' to your hosts file as an alias for localhost? [Y]es/(n)o." INSTALL_HOSTS_ALIAS
case "$REPLY" in
  Y | y | yes | Yes)
    sudo grep -qxF '127.0.0.1       local.magento' /etc/hosts || sudo echo '127.0.0.1       local.magento' >> /etc/hosts
    ;;
  *)
    echo "Skipping adding alias!"
    ;;
esac

VERSION_DIRS=(./versions/*)
for VD in "${VERSION_DIRS[@]}"; do
  if [ -d "$VD" ]; then
    cp "./init.sh" "$VD"
    mkdir -p "$VD/app"
  fi
done

echo "cd into ./versions/VERSION you wish to run"
echo "then simply run sudo ./init.sh"

