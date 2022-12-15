#!/usr/bin/env bash

DB='./etc/ital.db'
SQL='./tmp/query.sql'

cat "$SQL" | sqlite3 $DB
