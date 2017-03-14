#!/bin/bash

# Check existing remote file

uri=( $(echo "$1" | sed 's~https*://\([^/][^/]*\)\(.*\)~\1 \2~') )
HOST=${uri[0]:=localhost}
FILE=${uri[1]:=/}
filename=`../generate-filename.sh status-$FILE`
if [ ! -f $filename ]; then
  curl --silent --location --head  http://$HOST$FILE --output $filename
  if [ ! -f $filename ]; then
    echo 500
    exit
  fi
fi

status=`cat $filename | sed -n '/HTTP\/1.[0-1] 40[34]/{p;q;}' | sed 's/.*\(40[34]\).*/\1/'`
echo $status
