#!/usr/bin/env bash

DATABASE='./etc/journals.db'
SCHEMA='./etc/schema.sql'
CSV2DB='./etc/csv2db.sql'

rm -rf $DATABASE
cat $SCHEMA | sqlite3 $DATABASE
cat $CSV2DB | sqlite3 $DATABASE
