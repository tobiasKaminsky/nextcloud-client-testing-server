#!/bin/bash
set -euo pipefail

cd $(dirname "$0")

INSTANCE="nextcloud-$1"

docker-compose build --no-cache "$INSTANCE"
