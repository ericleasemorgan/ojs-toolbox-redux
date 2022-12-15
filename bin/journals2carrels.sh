#!/usr/bin/env bash

# journals2carrels.sh - process all journal corpora

# Eric Lease Morgan <emorgan@nd.edu>
# (c) University of Notre Dame; distributed under a GNU Public License

# November 16, 2022 - first cut


# configure
CORPORA='./corpora'
JOURNAL2CARREL='./bin/journal2carrel.sh'

# process each item in the corpus
find $CORPORA -maxdepth 1 -type d | sort | while read DIRECTORY; do

	# pass on the given directory
	if [[ $DIRECTORY == $CORPORA ]]; then continue; fi
	
	# parse out the journal code and do the work
	CODE=$( echo $DIRECTORY | cut -d '/' -f3 )
	$JOURNAL2CARREL $CODE
	
done
exit
