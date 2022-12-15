#!/usr/bin/env bash

ls corpora | while read CODE; do

	COUNT=$( find ./corpora/$CODE/cache -name *.pdf | wc -l )
	echo -e "$CODE\t$COUNT"

done

