#!/bin/bash

# Init variables.
drupalmajor=""
drupalversion=""
versionstatus=""
versionstylestatus="warning"

# Clear tmp and create new one.
tmpdirectory=tmp-`date '+%Y%m%d%H%M%S'`-$$
rm -Rf $tmpdirectory
mkdir $tmpdirectory
cd $tmpdirectory

# If drush cannot be found, use drush_script.
# File drush_script has to be created manually with path to drush.
drush="drush"
if [ -f ../drush_script ]; then
  drush=`cat ../drush_script`
fi

# Get Drupal major version from Drupal version.
getDrupalMajorFromDrupalVersion() {
  drupalmajor=`echo $drupalversion | cut -d'.' -f1`
}

getLastDrupalVersion ()
{
  # No lastdrupalversion for this major version yet
  if [ "${lastdrupalversion[$versionmajor]}" = "" ]; then
    lastdrupalversion[$drupalmajor]=`$drush rl drupal-$drupalmajor | sed -n '/Recommended/{p;q;}' | sed 's/.* *\([0-9]\.[0-9]*\) .*/\1/'`
  fi
}

drupalversion=`../find-version.sh $1`

# Version has been found.
baseroot=`../find-baseroot.sh $1`
if [ -z `../get-http-status.sh $1$baseroot/misc/drupal.js` ]; then 
  getDrupalMajorFromDrupalVersion
  ../setlog.sh "{\"label\": \"Drupal Site\", \"result\": \"YES\", \"style\": \"ok\"}"

  # Log if changelog is protected or not.
  if [ -z `../get-http-status.sh $1$baseroot/CHANGELOG.txt` ]; then
    ../setlog.sh "{\"label\": \".TXT files Protection\", \"result\": \"NO - Your .txt files are not protected and are readable. You should remove them or deny access.\", \"style\": \"fail\"}"
  else
    ../setlog.sh "{\"label\": \".TXT files Protection\", \"result\": \"YES\", \"style\": \"ok\"}"
  fi

  getLastDrupalVersion
  # Define if version is the recommended one.
  versionprefix=""
  if [ $drupalmajor -gt 7 ]; then
    versionprefix="$drupalmajor."
  fi

  if [[ "`echo $drupalversion | grep "^$versionprefix${lastdrupalversion[$drupalmajor]}$"`" = "" ]]; then
    versionstatus=" (NOT RECOMMENDED - RECOMMENDED: $versionprefix${lastdrupalversion[$drupalmajor]})"
    if [[ $versionprefix${lastdrupalversion[$drupalmajor]} = "" ]]; then
      versionstatus="NOT FOUND"
    elif [[ "`echo $drupalversion | grep "$versionprefix${lastdrupalversion[$drupalmajor]}"`" != "" ]]; then
      versionstylestatus="ok"
      versionstatus=" (MAY BE RECOMMENDED - RECOMMENDED: $versionprefix${lastdrupalversion[$drupalmajor]})"
    fi
  else
    versionstylestatus="ok"
  fi
  drupalversion=`echo $drupalversion | sed 's/ / or /g'`
  ../setlog.sh "{\"label\": \"Drupal Version\", \"result\": \"$drupalversion$versionstatus\", \"style\": \"$versionstylestatus\"}"

  # Get page.html to make search on it
  uri=( $(echo "$1" | sed 's~http://\([^/][^/]*\)\(.*\)~\1 \2~') )
  HOST=${uri[0]:=localhost}
  FILE=${uri[1]:=/}
  curl --silent --location http://$HOST$FILE --output page.html

  # Get page-header.log to make search on it
  curl --silent --location --head http://$HOST$FILE --output page-header-full.log
  sed -ne '/HTTP\/1.1 200 OK/,$p' page-header-full.log > page-header.log

  # Check if CSS and JS are aggregated
  ../setlog.sh "`../drupaloscopy-aggregation.sh`"

  # Check if CSS and JS are aggregated
  ../setlog.sh `../drupaloscopy-cache.sh`

  # Check if CSS and JS are aggregated
  ../setlog.sh "`../drupaloscopy-header.sh`"
else
  echo "$1" >> drupaloscopy-notfound.log
  ../setlog.sh "{\"label\": \"Drupal Site\", \"result\": \"NO\", \"style\": \"fail\"}"
fi

cat drupal-info.log

cd ..
rm -Rf $tmpdirectory