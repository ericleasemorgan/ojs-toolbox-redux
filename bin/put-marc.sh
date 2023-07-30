#!/usr/bin/env bash

# configure
MARC='./marc'

# sanity check
if [[ -z $1 ]]; then
	echo "Usage: $0 <key>" >&2
	exit
fi

# get input
KEY=$1

# initialize
MARC="$MARC/$KEY.marc"

# do the work and done
scp "$MARC" eric@catalog.infomotions.com:/home/eric/marc/$KEY.marc
exit
