#!/bin/bash
set -e

es=localhost:`docker-compose port elasticsearch 9200 | cut -d: -f2`

if [ $# == 0 ]
then
  site=en.wikiquote.org
  index=enwikiquote
elif [ $# == 2 ]
then
  site=$1
  index=$2
else
  echo "Usage: $0 [site=en.wikiquote.org, index=enwikiquote]"
  exit 1
fi

curl -XDELETE $es/$index?pretty

curl -s 'https://'$site'/w/api.php?action=cirrus-settings-dump&format=json&formatversion=2' |
  jq '{
    analysis: .content.page.index.analysis,
    number_of_shards: 1,
    number_of_replicas: 0
  }' |
  curl -XPUT $es/$index?pretty -d @-

curl -s 'https://'$site'/w/api.php?action=cirrus-mapping-dump&format=json&formatversion=2' |
  jq .content |
  sed 's/"index_analyzer"/"analyzer"/' |
  sed 's/"position_offset_gap"/"position_increment_gap"/' |
  curl -XPUT $es/$index/_mapping/page?pretty -d @-
