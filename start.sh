#!/bin/bash
set -euo pipefail

cd $(dirname "$0")

INSTANCE="nextcloud-$1"

./stop.sh
docker-compose up --detach "$INSTANCE"
