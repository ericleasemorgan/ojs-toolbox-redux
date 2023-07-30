#!/usr/bin/env bash

# tsv2catlog.sh - given a few configurations, output a catalog of MARC records

# Eric Lease Morgan <emorgan@nd.edu>
# (c) University of Notre Dame; distributed under a GNU Public License

# July 30, 2023 - first documentation


# configure
CLASSIFICATIONS='./classifications'
TSV2MARC='./bin/tsv2marc.pl'
CATALOG='./marc/catalog.marc'

# initialize
rm -rf $CATALOG
touch $CATALOG

# get and process classifications
IFS=$'\n'
CLASSIFICATIONS=( $( find $CLASSIFICATIONS -type f -name "*.tsv" ) )
for CLASSIFICATION in "${CLASSIFICATIONS[@]}"; do

	# re-initialize
	IFS=$'\t'
	
	# parse
	cat $CLASSIFICATION | while read TITLE KEY ROOT EXTENSION; do

		# debug
		echo "      title: $TITLE"     >&2
		echo "        key: $KEY"       >&2
		echo "       root: $ROOT"      >&2
		echo "  extension: $EXTENSION" >&2
		echo                           >&2
	
		# do the work
		$TSV2MARC $KEY $TITLE $ROOT >> $CATALOG;
	
	done

# fini
done
exit

