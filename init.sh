#!/bin/bash

function install_magento_data {
	sudo sysctl -w vm.max_map_count=262144
	sudo docker compose up -d

	echo "Choose one of the following options:"
	echo "(1) Install Magento2 & Sample Data"
	echo "(2) Install Sample Data"
	echo "(3) Start Containers"
	read -rn 1 -p "Please provide option number, defaults to (3)." REPLY
	printf "\n"
	case "$REPLY" in
	1)
		start_container
		wait_for_warmup
		install_magento
		install_magento_data
		mount_volumes
		;;
	2)
		start_container
		wait_for_warmup
		install_magento_data
		mount_volumes
		;;
	*)
		start_container
		mount_volumes
		;;
	esac

	echo "You can now visit the site:"
	echo "frontend: http://local.magento"
	echo "backend: http://local.magento/admin"
	printf "\n"
	cat ./env
}

function start_container {
	sudo sysctl -w vm.max_map_count=262144
	sudo docker compose up -d
}

function wait_for_warmup {
	message="Waiting "
	unit=" seconds for container to warm up."
	secs=$((60))
	while [ $secs -gt 0 ]; do
		echo -ne "$message$secs$unit\033[0K\r"
		sleep 1
		: $((secs--))
	done
}

function install_sample_data {
	CONTAINER_NAME=$(sudo docker ps | awk '{print $NF}' | grep -w web)
	sudo docker exec -it "$CONTAINER_NAME" install-sampledata
}

function install_magento {
	CONTAINER_NAME=$(sudo docker ps | awk '{print $NF}' | grep -w web)
	sudo docker exec -it "$CONTAINER_NAME" install-magento
}

function mount_volumes {
	container_prefix="${CONTAINER_NAME%-web*}"
	sudo ln -sf "/var/lib/docker/volumes/${container_prefix}_magento-data/_data" "./"
}

install_magento_data
