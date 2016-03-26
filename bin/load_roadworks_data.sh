#!/bin/bash
set -e

if [ $# != 1 ]
then
  echo "Missing argument: road_name"
  exit
fi

road=$1
elastic_url=localhost:`docker-compose port elasticsearch 9200 | cut -d: -f2`

curl -L data.gov.uk/data/api/service/transport/planned_road_works/road?road=$road |
  jq -c '.result[]|select(.expected_delay != "No Delay")|{"create" : {"_index": "roadworks", "_type": "closure"} },.' |
  curl -s -XPOST $elastic_url/_bulk --data-binary @- |
  jq '{successful:[.items[].create._shards.successful]|add, failed:[.items[].create._shards.failed]|add}'
