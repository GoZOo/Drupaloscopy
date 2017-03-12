#!/bin/bash

# Update hashs for specific tag.
# First argument is project, second is tag, third is previous tag.
project=$1
TAG=$2
previoustag=$3

# Load diffs from git.
diffurl="http://cgit.drupalcode.org/$project/diff/?id=$previoustag&id2=$TAG&context=3&ignorews=0&dt=2"
curl --silent --location $diffurl --output diff-$project-$TAG.html

pattern="<a href='/$project/diff/[^']+'>[^<]+\.(js|css)</a>"
cat diff-$project-$TAG.html | egrep "$pattern" | sed 's/.*>\([^<]*\.\(js\|css\)\)<.*/\1/' > diff-$project-$TAG.txt

mv diff-$project-$TAG.txt ../hashs-database/
