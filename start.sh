#!/bin/bash
set -euo pipefail

cd $(dirname "$0")

INSTANCE="nextcloud-$1"

PORT=${2:-80}

./stop.sh
PORT="$PORT" docker-compose up --detach "$INSTANCE"