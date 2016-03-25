#!/bin/bash

elastic_container=`docker-compose ps -q elasticsearch`
kibana_container=`docker-compose ps -q kibana`

if [ _$elastic_container != _ -a _$kibana_container != _ ]
then
  echo "Installing plugins"
  docker exec $elastic_container bin/plugin install analysis-icu
  docker exec $kibana_container kibana plugin --install elastic/sense
  docker-compose stop
  docker-compose start
else
  echo "Containers not found! Have you run: docker-compose up -d"
fi
