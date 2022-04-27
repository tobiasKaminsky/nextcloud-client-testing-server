#!/bin/bash
set -euo pipefail
INSTANCE="nextcloud-$1"

docker-compose down --remove-orphans --timeout 5
docker-compose up --detach "$INSTANCE"
