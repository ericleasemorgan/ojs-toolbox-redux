#!/usr/bin/env bash

# consolidate.sh - given a few configurations, create a new database from the content of others

# Eric Lease Morgan <emorgan@nd.edu>
# (c) University of Notre Dame; distributed under and GNU Public License

# December 12, 2022 - first cut
# December 13, 2022 - added better identifier; see https://stackoverflow.com/questions/21388820/how-to-get-the-last-index-of-a-substring-in-sqlite


# configure
DB='./etc/ojs-journals.db'
SCHEMA='./etc/schema-journals.sql'
INSERT="ATTACH DATABASE './etc/##CODE##.db' AS addition; INSERT INTO main.bibliographics SELECT '##CODE##-'||REPLACE( identifier, RTRIM( identifier, REPLACE( identifier, '/', '' ) ), '' ) AS identifier, author, title, date, abstract, '##ROOT##/##CODE##/##CODE##-'||REPLACE( identifier, RTRIM( identifier, REPLACE( identifier, '/', '' ) ), '' )||extension FROM addition.bibliographics WHERE extension > '';DETACH DATABASE 'addition';"
CORPORA='corpora'
ROOT='https://distantreader.org/stacks/journals'
#EXTENSION='.pdf'

# initialize
rm -rf $DB
cat $SCHEMA | sqlite3 $DB

# find and process each journal
find $CORPORA -maxdepth 1 -type d | sort | while read JOURNAL; do

	# get the journal code
	CODE=$( basename $JOURNAL )
	
	# pass on the root directory
	if [[ $CODE == $CORPORA ]]; then continue; fi
	
	# debug
	echo $CODE >&2
	
	# create some SQL and do the work
	#SQL=$( echo $INSERT | sed "s|##CODE##|$CODE|g" | sed "s|##ROOT##|$ROOT|g" | sed "s|##EXTENSION##|$EXTENSION|g" )
	SQL=$( echo $INSERT | sed "s|##CODE##|$CODE|g" | sed "s|##ROOT##|$ROOT|g" )
	echo $SQL | sqlite3 $DB

done
exit



