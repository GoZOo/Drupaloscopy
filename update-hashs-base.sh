#!/bin/bash

# This file has to be runned in cron to update css/js scripts hash logs for every versions.

versionmajor=8
baseroot="/core"

# Create tmp.
tmpdirectory=tmp-`date '+%Y%m%d%H%M%S'`-$$
mkdir $tmpdirectory
cd $tmpdirectory

# Create hashs-database folder if is missing.
databasefolder="hashs-database"
if [ ! -d "../$databasefolder" ]; then
  mkdir ../$databasefolder
fi

# Create hashs-database/hashs folder if is missing.
if [ ! -d "../$databasefolder/hashs" ]; then
  mkdir ../$databasefolder/hashs
fi

# For each major version from 8 to 5.
while [ $versionmajor -gt 4 ]; do
  # Drupal versions higher than 8 have js/css files under core/
  # others have files under /.
  if [ $versionmajor -lt 8 ]; then
    baseroot=""
  fi

  ../update-release-history.sh $versionmajor

  versionmajor=$[$versionmajor-1]
done

cd ..
rm -Rf $tmpdirectory
