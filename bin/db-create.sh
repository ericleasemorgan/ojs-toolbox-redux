#!/usr/bin/env bash

# db-create.sh

# configure
SCHEMA='./etc/schema-bibliographics.sql'

if [[ -z $1 ]]; then
	echo 'Usage: $0 <key>' >&2
	exit
fi

KEY=$1

DATABASE="./etc/$KEY.db"
# make sane, do the work, and done
rm -rf $DATABASE

cat $SCHEMA | sqlite3 $DATABASE
exit
