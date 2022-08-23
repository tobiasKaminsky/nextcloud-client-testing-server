#!/bin/bash
set -euo pipefail

cd $(dirname "$0")

yq -r '.services | keys | .[]' < docker-compose.yml  | sed -n 's/^nextcloud-//p' | sort
