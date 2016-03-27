#!/bin/bash
set -e

if [ $# -ne 2 ]
then
  echo "Usage: $0 service_name internal_port"
  exit 1
fi

# Check if docker-machine is installed
if hash docker-machine 2>/dev/null
then
  active=`docker-machine active 2>&1 || true`
else
  active="No active host found"
fi

# Get port from docker-compose
port=`docker-compose port $1 $2 | cut -d: -f2`

if [ "_$active" = _"No active host found" ]
then
  echo localhost:$port
else
  echo `docker-machine ip $active`:$port
fi

