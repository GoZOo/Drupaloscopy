#!/bin/bash

# Update release list by major version.
versionmajor=$1
database="../hashs-database"
baseroot=""

# Download list of released for this major version.
urlreleasehistory="https://updates.drupal.org/release-history/drupal/$versionmajor.x"
curl --silent --location $urlreleasehistory --output release-history-$versionmajor.x.xml

# Be sure file already exists for this major version.
versionlist=release-history-$versionmajor.x.txt
if [ ! -e "$database/$versionlist" ]; then
  touch $database/$versionlist
fi

# Read XML release-history file.
read_dom () {
  local IFS=\>
  read -d \< ENTITY TAG
}

# Be sure to start from a clean file.
if [ -e release-history-$versionmajor.x.txt ]; then
  rm release-history-$versionmajor.x.txt
fi

while read_dom; do
  if [[ $ENTITY = "tag" ]]; then
    # Do not take developpement releases finishing by x.
    if [[ `echo "$TAG" | grep ".x$"` = "" ]]; then
      echo $TAG >> release-history-$versionmajor.x.txt
    fi
  fi
done < release-history-$versionmajor.x.xml

if [ $versionmajor -gt 7 ]; then
  baseroot="core/"
fi

# Set first tag
if [ $versionmajor -eq 8 ]; then
  previoustag="8.0-alpha2"
fi

temppath=`pwd`
# Revert file so we start by first tag for this major release.
`tac release-history-$versionmajor.x.txt > release-history-$versionmajor.x.ordered.txt`
while read TAG; do
  #../update-hashs-tag-generate.sh drupal $TAG "${baseroot}misc/drupal.js"
  if [ `cat $database/$versionlist | grep "$TAG" | wc -l` -eq 0 ]; then
    cd $temppath/..
    # Download files
    echo "Download drupal-$TAG.tar.gz"
    curl --silent --location https://ftp.drupal.org/files/projects/drupal-$TAG.tar.gz --output drupal-$TAG.tar.gz
    echo "Decompress drupal-$TAG.tar.gz"
    tar zxf drupal-$TAG.tar.gz
    rm drupal-$TAG.tar.gz
    find drupal-$TAG -type f -name "*.js" | sed 's/drupal-[^\/]*\///g' > drupal-$TAG/files-list-to-hash.txt
    find drupal-$TAG -type f -name "*.css" | sed 's/drupal-[^\/]*\///g' >> drupal-$TAG/files-list-to-hash.txt
    cd drupal-$TAG

    echo "Generate hashs for js and css files"
    while read filepath; do
      ../update-hashs-tag-generate.sh drupal $TAG $filepath
    done < files-list-to-hash.txt

    cd ..
    rm -Rf drupal-$TAG
    cd $temppath

    # Update drupal hash tag lists.
    ../update-hashs-tag.sh drupal $TAG $previoustag
    # Add tag to drupal versions list.
    echo "$TAG" >> $database/$versionlist
  fi
  previoustag=$TAG
done < release-history-$versionmajor.x.ordered.txt
