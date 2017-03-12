#!/bin/bash

if [ "`grep "Vary: .*Accept-Encoding" page-header.log`" = "" ]; then
  echo "{\"label\": \"Compression GZIP\", \"result\": \"NO - you should authorized gzip compression to save world wide web (and bandwidth).\", \"style\": \"fail\"}"
else
  echo "{\"label\": \"Compression GZIP\", \"result\": \"Yes - World Wide Web thanks you.\", \"style\": \"ok\"}"
fi