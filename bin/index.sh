#!/usr/bin/env bash

# index.sh- create full text index of a configured database

# Eric Lease Morgan <emorgan@nd.edu>
# (c) University of Notre Dame; distributed under a GNU Public License

# December 12, 2022 - first cut; based on other work


# configure
DB='./etc/ojs-journals.db'
DROPINDX='DROP TABLE IF EXISTS indx;'
CREATEINDX='CREATE VIRTUAL TABLE indx USING FTS5( identifier, author, title, date, abstract, url );'
INDEX='INSERT INTO indx SELECT identifier, author, title, date, abstract, url FROM bibliographics;';

# index; do the actual work
echo $DROPINDX   | sqlite3 $DB
echo $CREATEINDX | sqlite3 $DB
echo $INDEX      | sqlite3 $DB
exit
