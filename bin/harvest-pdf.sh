#!/usr/bin/env bash

CORPORA='corpora'
CACHE='cache'

# sanity check
if [[ -z $1 || -z $2 ]]; then

	echo "Usage: $0 <key> <extension> <identifier> <url>" >&2
	exit
fi

# get input
KEY=$1
EXTENSION=$2
IDENTIFIER=$3
URL=$4

# compute output, do the work (conditionally), and done
OUTPUT="$CORPORA/$KEY/$CACHE/$KEY-$( echo $IDENTIFIER | cut -d '/' -f2 ).$EXTENSION"
if [[ ! -e $OUTPUT ]]; then wget -O $OUTPUT $URL; fi
exit