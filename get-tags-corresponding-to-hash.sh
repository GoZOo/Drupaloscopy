#!/bin/bash

filename=$1
hash=$2

# Get tags from a filename correpsonding to a hash.
cat ../hashs-database/hashs/$filename | grep ".*:$hash" | sed 's/\(.*\):[^:]*$/\1/g'