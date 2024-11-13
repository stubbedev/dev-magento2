#!/bin/bash

npm install
node update.js
COMPOSE_FILES=(./versions/*/docker-compose.*)
for CF in "${COMPOSE_FILES[@]}"; do
  if [ -f "$CF" ]; then
    sed -i '/version:/d' "$CF"
    sed -i '/image: mysql/a \    cap_add:\n\      - SYS_NICE' "$CF"
    sed -i '/OPENSEARCH_JAVA_OPTS/a \      - "OPENSEARCH_INITIAL_ADMIN_PASSWORD=jexqrwT$1b@@%Lg"' "$CF"
  fi
done


