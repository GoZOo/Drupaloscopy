#!/bin/sh

# First check the easy way : CHANGELOG.txt
# Find CHANGELOG depending of Drupal < 8 or Drupal 8 path.
changelogpath=$1/CHANGELOG.txt
if [ ! -z `../get-http-status.sh $changelogpath` ]; then
  # So check drupal 8 changelog path.
  changelogpath=$1/core/CHANGELOG.txt
  if [ ! -z `../get-http-status.sh $changelogpath` ]; then
    # No changelog is fount. Exit.
    exit
  fi
fi

curl --silent --location $changelogpath --output CHANGELOG.txt
if [ -f CHANGELOG.txt ] && [ "`cat CHANGELOG.txt | grep "<!DOCTYPE html"`" = "" ]
  then
  drupalversion=`cat CHANGELOG.txt | sed -n '/Drupal/{p;q;}' | sed -e 's/Drupal //' -e 's/,.*//'`
  if [ "`cat CHANGELOG.txt | grep "Drupal 7.13 xxxx-xx-xx"`"  != "" ]; then
    # webchick try to fool me
    # check if it's really 7.12
    drupalversion="7.12"
  fi

  echo $drupalversion
fi