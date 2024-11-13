#!/bin/bash

sudo docker compose up -d
function install_magento_data {
  echo "======================================"
  echo "|          Waiting 60s               |"
  echo "======================================"
  sleep 60
  CONTAINER_NAME=$(sudo docker ps | awk '{print $NF}' | grep -w web)
  local "$CONTAINER_NAME"
  sudo docker exec -it "$CONTAINER_NAME" install-magento
  sudo docker exec -it "$CONTAINER_NAME" install-sampledata
}

install_magento_data
