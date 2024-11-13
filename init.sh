#!/bin/bash

sudo docker compose up -d
function install_magento_data {
  message="Waiting "
  unit=" seconds for container to warm up."
	secs=$((60))
	while [ $secs -gt 0 ]; do
		echo -ne "$message$secs$unit\033[0K\r"
		sleep 1
		: $((secs--))
	done
	CONTAINER_NAME=$(sudo docker ps | awk '{print $NF}' | grep -w web)
	local "$CONTAINER_NAME"
	sudo docker exec -it $CONTAINER_NAME install-magento
	sudo docker exec -it $CONTAINER_NAME install-sampledata

	echo "You can now visit the site:"
	echo "frontend: http://local.magento"
	echo "backend: http://local.magento/admin"
  echo "credentials:"
  cat ./env
}

install_magento_data
