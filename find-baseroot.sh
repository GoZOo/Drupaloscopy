#!/bin/bash

# Check if path if for drupal 8 or before.
if [ ! -z `../get-http-status.sh $1/misc/drupal.js` ]; then
  # It's not a drupal before 8, so check drupal 8.
  if [ ! -z `../get-http-status.sh $1/core/misc/drupal.js` ]; then
    # No file found. Exit.
    exit
  else
    # File is found, it means it's a drupal 8, so base root for files is /core.
    echo "/core"
    exit
  fi
fi
