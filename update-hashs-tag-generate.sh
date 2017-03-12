#!/bin/bash

project=$1
TAG=$2
filepath=$3

destination="../hashs-database/hashs"

filename=`../generate-filename.sh $filepath`

if [ -f $destination/$filename ]; then
  # Generate hash only if is missing from file.
  if [ "`cat $destination/$filename | grep "^$TAG:"`" != "" ]; then
    exit
  fi
else
  # Create empty file if it doesn't exist yet.
  touch $destination/$filename
fi

if [ ! -f $filepath ]; then
  # Download file.
  gitfilepath="http://cgit.drupalcode.org/$project/plain/$filepath?h=$TAG"
  curl --silent --location $gitfilepath --output $filename
  filehash=`../generate-hash.sh $filename`  
else
  filehash=`../generate-hash.sh $filepath`  
fi

# Store hash and tag to corresponding file.
echo "$TAG:$filehash" >> $destination/$filename
