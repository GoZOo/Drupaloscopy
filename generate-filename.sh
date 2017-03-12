#!/bin/bash

# Generate filename from filepath.
echo "$1" | sed 's/^\///' | sed 's/\//___/g'