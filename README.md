Drupaloscopy is a command line shell and Unix scripting to identify Drupal sites and version providing an url.

Drupaloscopy can be used cloning this repository and launching ```drupaloscopy.sh``` or requesting service throught UI: [Drupaloscopy.com](http://drupaloscopy.com).

Script response is in JSON format.

## Requirements
Drush is required to know recommended version of Drupal.

## How to use on local ?
* Clone this repo
* Launch ```drupaloscopy.sh```script providing domain url as first argument. Ex: ```./drupaloscopy.sh http://drupal.org```

## How Drupaloscopy works ?
* Drupaloscopy can determine version of Drupal sites comparing the hash of JS and CSS files.

## My local drupaloscopy is not up to date with last drupal versions.
* Launch ```./update-hashs-base.sh```. This will download and generate hashs for missing drupal versions. It's recommended to launch this script in crontab to update frequently hash database.
* In Crontab: ```cd path/to/drupaloscopy; ./update-hashs-base.sh```
