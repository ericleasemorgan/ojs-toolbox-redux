#!/usr/bin/env python

# bibliographics2metadata.py - given journal code, output a CSV metadata file suitable for the Reader

# Eric Lease Morgan <emorgan@nd.edu>
# (c) University of Notre Dame; distributed under a GNU Public License

# November 16, 2022 - first cut, and waiting for a Snowagaddon


# configure
CORPORA   = 'corpora'
TSV       = 'bibliographics.tsv'
EXTENSION = '.pdf'

# require
import pandas as pd
from pathlib import Path
import sys

# get input
if len( sys.argv ) != 2 : sys.exit( 'Usage: ' + sys.argv[ 0 ] + " <code>" )
code      = sys.argv[ 1 ]

# initialize
bibliographics = Path( CORPORA )/code/TSV

# slurp up the bibiographics, duplicate a column, and munge it
bibliographics           = pd.read_csv( bibliographics, sep='\t' )
bibliographics[ 'file' ] = code + '-' + bibliographics.loc[ :, 'identifier' ].str.rsplit( '/' ).str[ 1 ] + EXTENSION

# ouput and done
print( bibliographics.to_csv( index=False ) )
exit()

