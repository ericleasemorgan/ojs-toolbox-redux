#!/usr/bin/env python

# journal2carrel.py - given a journal code, create a study carrel

# Eric Lease Morgan <emorgan@nd.edu>
# (c) University of Notre Dame; distributed under a GNU Public License

# December 4, 2022 - first cut


JOURNAL = 'jsta'

# configure
CORPORA        = 'corpora'
CACHE          = 'cache'
METADATA       = 'metadata.csv'
BIBLIOGRAPHICS = 'bibliographics.tsv'
EXTENSION      = '.pdf'
TEMPLATE       = 'journal-##JOURNALCODE##-doaj'

# require
from pathlib import Path
import pandas as pd
import rdr

# initialize
journal        = JOURNAL

# slurp up the bibliographics and create a new column
bibliographics           = Path( CORPORA)/journal/BIBLIOGRAPHICS
bibliographics           = pd.read_csv( bibliographics, sep='\t' )
bibliographics[ 'file' ] = journal + '-' + bibliographics[ 'identifier' ].str.split( '/' ).str[ -1 ] + EXTENSION

# save
metadata = Path( CORPORA)/journal/CACHE/METADATA
bibliographics.to_csv( metadata, index=False )

# build a carrel
carrel    = TEMPLATE.replace( '##JOURNALCODE##', journal )
directory = str( Path( CORPORA )/journal/CACHE )
rdr.build( carrel, directory, erase=True, start=True )

# do a bit of modeling
rdr.cluster( carrel, type='dendrogram', save=True )
rdr.summarize( carrel )

# done
exit()
