#!/usr/bin/env bash

# journal2carrel.sh - given a journal code, create a study carrel

# Eric Lease Morgan <emorgan@nd.edu>
# (c) University of Notre Dame; distributed under a GNU Public License

# November 16, 2022 - first cut


# configure
BIBLIOGRAPHICS2METADATA='./bin/bibliographics2metadata.py'
CORPORA='corpora'
CACHE='cache'
METADATA='metadata.csv'
JOURNALS='./etc/journals.tsv'

# sanity check
if [[ -z $1 ]]; then
	echo "Usage: $0 <code>" >&2
	exit
fi

# get input
CODE=$1

# find the name of the journal
IFS=$'\t'
FOUND=0
while read TITLE ABBREVIATION URL TYPE; do
	
	# check for code
	if [[ $ABBREVIATION == $CODE ]]; then
		FOUND=1
		break
	fi
	
# loop through the journal list; upside-down, if you ask me
done < <( cat $JOURNALS )

# trap for not found
if [[ $FOUND == 0 ]]; then
	echo "Error: $CODE not found in $JOURNALS. Exiting." >&2
	exit
fi

# debug
echo "Processing $TITLE" >&2

# normalize
TITLE=$( echo $TITLE | tr '[:upper:]' '[:lower:]' | tr ' ' '-' | sed "s/,//g" )

# create metadata and make a carrel
$BIBLIOGRAPHICS2METADATA $CODE > "./$CORPORA/$CODE/$CACHE/$METADATA"
rdr build $TITLE "./$CORPORA/$CODE/$CACHE/" -s -e

# do the briefest of modeling, and done
rdr info $TITLE
rdr cluster $TITLE -v
rdr summarize $TITLE
exit
