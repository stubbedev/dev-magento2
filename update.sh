#!/bin/bash

npm install
node update.js
COMPOSE_FILES=(./versions/*/docker-compose.*)
for CF in "${COMPOSE_FILES[@]}"; do
	if [ -f "$CF" ]; then
		sed -i '/version:/d' "$CF"
		sed -i '/image: mysql/a \    cap_add:\n\      - SYS_NICE' "$CF"
		sed -i '/OPENSEARCH_JAVA_OPTS/a \      - "OPENSEARCH_INITIAL_ADMIN_PASSWORD=jexqrwT$1b@@%Lg"' "$CF"
		# sed -i '/magento-data:\/var\/www\/html/a \      - ./app:/var/www/html:cached' "$CF"
	fi
done

read -rn 1 -p "Would you like to added 'local.magento' to your hosts file as an alias for localhost? [Y]es/(n)o." INSTALL_HOSTS_ALIAS
case "$INSTALL_HOSTS_ALIAS" in
Y | y | yes | Yes)
	sudo grep -qxF '127.0.0.1       local.magento' /etc/hosts || sudo echo '127.0.0.1       local.magento' >>/etc/hosts
	;;
*)
	printf "\n"
	echo "Skipping adding alias!"
	printf "\n"
	;;
esac

VERSION_DIRS=(./versions/*)
for VD in "${VERSION_DIRS[@]}"; do
	if [ -d "$VD" ]; then
		cp -f "./init.sh" "$VD"
		cp -f "./bash.sh" "$VD/bash"
		# cp -f "./composer.sh" "$VD/composer"
		# cp -f "./magento.sh" "$VD/magento"
		chmod a+x "$VD/init.sh"
		chmod a+x "$VD/bash"
		# chmod a+x "$VD/composer"
		# chmod a+x "$VD/magento"
		mkdir -p "$VD/app"
	fi
done

echo "cd into ./versions/\$VERSION you wish to run"
printf "\n"
echo "THEN RUN: ./init.sh"
