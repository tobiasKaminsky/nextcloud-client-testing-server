#!/bin/bash
#set -euo pipefail

cd $(dirname "$0")

INSTANCE="nextcloud-$1"

if [ $# -eq 2 ]; then
  P=$2 
else
  P=80
fi

./stop.sh
PORT="$P" docker-compose up --detach "$INSTANCE"
