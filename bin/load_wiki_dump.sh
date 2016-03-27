#!/bin/bash

es=$($(dirname $0)/service_address.sh elasticsearch 9200)

if [ $# == 1 ]
then
  dump=$1
  index=enwikiquote
elif [ $# == 2 ]
then
  dump=$1
  index=$2
else
  echo "Usage: $0 dump_file [index_name=enwikiquote]"
  exit 1
fi

dump=$1
index=enwikiquote

chunks_dir=`mktemp -d`
echo "Using temp dir :$chunks_dir"
cd $chunks_dir
zcat $OLDPWD/$dump | split -a 10 -l 500 - $index

for file in *; do
  echo -n "${file}:  "
  took=$(curl -s -XPOST $es/$index/_bulk?pretty --data-binary @$file |
    grep took | cut -d':' -f 2 | cut -d',' -f 1)
  printf '%7s\n' $took
  [ "x$took" = "x" ] || rm $file
done

cd -
rm -r $chunks_dir
