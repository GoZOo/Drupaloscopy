#!/bin/bash
baseroot=`../find-baseroot.sh $1`

# First check if misc/drupal.js file exists. It should exist to be a drupal site.
if [ ! -z `../get-http-status.sh $1$baseroot/misc/drupal.js` ]; then
  exit;
fi

# First looking for drupal.js file will determine major version and limit the search.
# Get drupal.js site file and generate 
filename=`../generate-filename.sh $baseroot/misc/drupal.js`
curl --silent --location $1$baseroot/misc/drupal.js --output $filename
hashmiscdrupaljs=`../generate-hash.sh $filename`

# Search for versions corresponding to this hash.
../get-tags-corresponding-to-hash.sh $filename $hashmiscdrupaljs > site-drupaltags-candidates.txt

touch site-files-checked.txt

# Get the last version of the list.
for versiontocheck in $(tac site-drupaltags-candidates.txt); do
  # Do not check tag if it's not a candidate.
  if [[ `cat site-drupaltags-candidates.txt | grep "$versiontocheck"` = "" ]]; then
    continue
  fi

  while read filepath; do
    # Do not check a file that has already be checked.
    if [[ `cat site-files-checked.txt | grep "$filepath"` != "" ]]; then
      continue
    fi
    echo $filepath >> site-files-checked.txt

    # Pass if site hasn't this file.
    if [ ! -z `../get-http-status.sh $1/$filepath` ]; then
      cat site-drupaltags-candidates.txt | sed "/^$versiontocheck$/ d" > site-drupaltags-candidates-2.txt
      mv site-drupaltags-candidates-2.txt site-drupaltags-candidates.txt
      continue
    fi

    # Get and generate hash file.
    filename=`../generate-filename.sh $filepath`
    curl --silent --location $1/$filepath --output $filename
    hashfile=`../generate-hash.sh $filename`

    ../get-tags-corresponding-to-hash.sh $filename $hashfile > site-drupaltags-candidates-filtered.txt
    # Only keep this tags
    grep -x -f site-drupaltags-candidates-filtered.txt site-drupaltags-candidates.txt > site-drupaltags-candidates-updated.txt
    mv site-drupaltags-candidates-updated.txt site-drupaltags-candidates.txt

    # Exit if only 1 tag left.
    if [ `cat site-drupaltags-candidates.txt | wc -l` -eq 1 ]; then
      cat site-drupaltags-candidates.txt
      exit;
    fi
  done < ../hashs-database/diff-drupal-$versiontocheck.txt
done

cat site-drupaltags-candidates.txt
