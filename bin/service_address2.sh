#!/bin/bash
set -e

if [ $# -ne 2 ]
then
  echo "Usage: $0 service_name internal_port"
  exit 1
fi

id=$(docker-compose ps -q $1)
docker inspect $id | jq -r --arg port $2 '.[].NetworkSettings.Ports["\($port)/tcp"][]|"\(.HostIp):\(.HostPort)"'
