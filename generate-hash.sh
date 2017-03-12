#!/bin/bash

# Generate hash from a file.
cat -n $1 | sha256sum | sed 's/ *-$//'