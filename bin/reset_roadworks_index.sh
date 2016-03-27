#!/bin/bash
set -e

es=$($(dirname $0)/service_address.sh elasticsearch 9200)
index=roadworks

echo "Remove existing index (this will fail if it doesn't already exist)"
curl -XDELETE $es/$index?pretty

index_config=`dirname $0`/../config/roadworks_index.json
if [ -e $index_config ]
then
  echo "Setting index config from file: $index_config"
  curl -XPUT $es/$index?pretty -d @$index_config
else
  echo "Cannot find config/roadworks_index.json"
  exit 1
fi

mapping_config=`dirname $0`/../config/roadworks_mapping.json
if [ -e $mapping_config ]
then
  echo "Setting mapping config from file: $mapping_config"
  curl -XPUT $es/$index/_mapping/closure?pretty -d @$mapping_config
else
  echo "Cannot find config/roadworks_mapping.json"
  exit 1
fi
