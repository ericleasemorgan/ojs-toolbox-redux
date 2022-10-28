#!/usr/bin/env bash

CORPORA='corpora'
HARVESTBIBLIOGRAPHICS='./bin/harvest-bibliogrpahics.pl'

# sanity check
if [[ -z $1 || -z $2 || -z $3 ]]; then

	echo "Usage: $0 <base url> <identifier> <key>" >&2
	exit
fi

# get input
BASEURL=$1
IDENTIFIER=$2
KEY=$3

# compute output, do the work (conditional), and done
OUTPUT="$CORPORA/$KEY/bibliographics/$( echo $IDENTIFIER | cut -d '/' -f2 ).tsv"
if [[ ! -e $OUTPUT ]]; then $HARVESTBIBLIOGRAPHICS "$BASEURL" "$IDENTIFIER" > $OUTPUT; fi
exit