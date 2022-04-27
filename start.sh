#!/bin/bash
set -euo pipefail

cd $(dirname "$0")

INSTANCE="nextcloud-$1"

docker-compose down --remove-orphans --timeout 5
docker-compose up --detach "$INSTANCE"
