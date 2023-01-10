#!/usr/bin/env bash

SUBSET='./bin/subset.py'

for CLASSIFICATION in {A..Z}; do
    $SUBSET $CLASSIFICATION > ./classifications/classification-$CLASSIFICATION.tsv
done