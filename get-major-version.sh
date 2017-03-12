#!/bin/bash

# Get major version form tag.
echo $1 | sed 's/^\([^\.]*\)\..*/\1/'