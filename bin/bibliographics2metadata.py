#!/usr/bin/env python

# bibliographics2metadata.py - given journal code, output a CSV metadata file suitable for the Reader

# Eric Lease Morgan <emorgan@nd.edu>
# (c) University of Notre Dame; distributed under a GNU Public License

# November 16, 2022 - first cut, and waiting for a Snowagaddon


# configure
CORPORA   = 'corpora'
JOURNAL   = 'cjal'
TSV       = 'bibliographics.tsv'
EXTENSION = '.pdf'

# require
import pandas as pd
from pathlib import Path

# initialize
bibliographics = Path( CORPORA )/JOURNAL/TSV

# slurp up the bibiographics, duplicate a column, and munge it
bibliographics           = pd.read_csv( bibliographics, sep='\t' )
bibliographics[ 'file' ] = bibliographics.loc[ :, 'identifier' ].str.rsplit( '/' ).str[ 1 ] + EXTENSION

# ouput and done
print( bibliographics.to_csv( index=False ) )
exit()

