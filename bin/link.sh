#!/usr/bin/env bash

# link.sh - given a few configurations, create a bunch o' symboloic links

# Eric Lease Morgan <emorgan@nd.edu>
# (c) University of Notre Dame; distributed under a GNU Public License

# December 13, 2022 - first cut


# configure
CORPORA='corpora'
CACHE='/shared/sandbox/ojs-toolbox/corpora'
STACKS='/var/www/html/stacks/journals'
RMTEMPLATE='rm -rf ##STACKS##/##CODE##'
LINKTEMPLATE='ln -s ##CACHE##/##CODE##/cache ##STACKS##/##CODE##'

# find and process each journal
find $CORPORA -maxdepth 1 -type d | sort | while read JOURNAL; do

	# get the journal code
	CODE=$( basename $JOURNAL )
	
	# pass on the root directory
	if [[ $CODE == $CORPORA ]]; then continue; fi
	
	# create commands
	RM=$( echo $RMTEMPLATE | sed "s|##CODE##|$CODE|g" | sed "s|##STACKS##|$STACKS|g" )
	LINK=$( echo $LINKTEMPLATE | sed "s|##CACHE##|$CACHE|g" | sed "s|##CODE##|$CODE|g" | sed "s|##STACKS##|$STACKS|g" )

	# debug
	echo $CODE >&2
	echo $RM   >&2
	echo $LINK >&2
	echo       >&2

	# do the work
	$RM
	$LINK
	
done
exit
