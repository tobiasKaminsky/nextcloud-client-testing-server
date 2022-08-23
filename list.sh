#!/bin/bash

grep nextcloud docker-compose.yml | grep ":$" | sed s'/://'g | sed s'/nextcloud-//'g| sort
