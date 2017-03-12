#!/bin/bash

filepath=$1
project=$2
majorversion=$3

echo $filepath >> ../hashs-database/files-$project-$majorversion.txt