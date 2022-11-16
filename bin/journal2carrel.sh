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

# sanity check
if [[ -z $1 ]]; then
	echo "Usage: $0 <code>" >&2
	exit
fi

# get input
CODE=$1

# create metadata, do the work, and done
$BIBLIOGRAPHICS2METADATA $CODE > "./$CORPORA/$CODE/$CACHE/$METADATA"
rdr build $CODE "./$CORPORA/$CODE/$CACHE/" -s -e
rdr info $CODE
rdr cluster $CODE -v
rdr summarize $CODE
exit
