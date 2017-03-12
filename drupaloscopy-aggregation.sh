#!/bin/bash
if [ "`grep "misc/drupal.js" page.html`" = "" ] || [ "`grep "modules/node/node.css" page.html`" = "" ]; then
	echo "{\"label\": \"CSS and JS Aggregation\", \"result\": \"YES\", \"style\": \"ok\"}"
else
	echo "{\"label\": \"CSS and JS Aggregation\", \"result\": \"NO - you should enable Aggregation for improve performances.\", \"style\": \"fail\"}"
fi
