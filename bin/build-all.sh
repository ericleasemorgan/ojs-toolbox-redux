#!/usr/bin/env bash

# configure
BUILD='./bin/build-one.sh'
CLASSIFICATIONS='./classifications'

# process each classsification
find $CLASSIFICATIONS -name *.tsv | sort | while read FILE; do

	# do the work
	$BUILD $FILE
	
done
exit
