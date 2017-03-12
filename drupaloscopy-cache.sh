#!/bin/bash
if [ "`grep "X-Drupal-Cache: MISS" page-header.log`" = "" ]; then
  echo "{\"label\": \"Cache Drupal\", \"result\": \"YES - Drupal cache is enabled.\", \"style\": \"ok\"}"
else
  echo "{\"label\": \"Cache Drupal\", \"result\": \"NO - You should enable Drupal cache for better performances.\", \"style\": \"fail\"}"
fi

if [ "`grep "X-Cached-By: Boost" page-header.log`" != "" ] || [ "`grep "Page cached by Boost" page.html`" != "" ]; then
  echo "\n{\"label\": \"Cache Boost\", \"result\": \"Drupal use <a href='http://drupal.org/projects/boost'>Boost</a> module to improve performances.\", \"style\": \"ok\"}"
fi

if [ "`grep "X-Varnish" page-header.log`" != "" ]; then
	if [ "`grep "X-Cache: MISS" page-header.log`" = "" ]; then
  	echo "\n{\"label\": \"Varnish\", \"result\": \"Varnish is used.\", \"style\": \"ok\"}"
  else
  	echo "\n{\"label\": \"Varnish\", \"result\": \"Varnish is present but is disabled.\", \"style\": \"fail\"}"
  fi
fi

if [ "`grep "Cache-Control: .*no-cache" page-header.log`" = "" ]; then
  echo "\n{\"label\": \"Cache Control\", \"result\": \"YES - Cache control is used. Server thanks you.\", \"style\": \"ok\"}"
else
  echo "\n{\"label\": \"Cache Control\", \"result\": \"NO - Cache control could preserve your server from unecessary requests. See <a href='http://en.wikipedia.org/wiki/Cache-Control#Controlling_Web_caches'>Cache-control on Wikipedia</a> for more details.\", \"style\": \"fail\"}"
fi