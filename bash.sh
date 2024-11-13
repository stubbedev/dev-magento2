#!/bin/bash

CONTAINER_NAME=$(sudo docker ps | awk '{print $NF}' | grep -w web)
sudo docker exec -it "$CONTAINER_NAME" bash
