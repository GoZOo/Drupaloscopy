#!/bin/bash

# Check existing remote file

uri=( $(echo "$1" | sed 's~https*://\([^/][^/]*\)\(.*\)~\1 \2~') )
HOST=${uri[0]:=localhost}
FILE=${uri[1]:=/}
curl --silent --location --head  http://$HOST$FILE --output log
if [ ! -f log ]; then
  echo 500
  exit
fi

status=`cat log | sed -n '/HTTP\/1.[0-1] 40[34]/{p;q;}' | sed 's/.*\(40[34]\).*/\1/'`
echo $status