#!/usr/bin/env bash

CORPORA='corpora'

if [[ -z $1 ]]; then
	echo "Usage: $0 <key>" >&2
	exit
fi

KEY=$1

rm -rf ./etc/$KEY.db
#rm -rf $KEY
mkdir -p ./$CORPORA/$KEY
