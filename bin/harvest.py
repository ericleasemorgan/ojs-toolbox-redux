#!/usr/bin/env python

# harvest.py - given a key, cache remote content

# Eric Lease Morgan <emorgan@nd.edu>
# (c) University of Notre Dame; distributed under a GNU Public License

# December 26, 2022 - re-written because remote content is not always PDF
# December 27, 2022 - added allow_redirects to HEAD request; ought to trap for non-200 responses


# configure
CORPORA    = 'corpora'
CACHE      = 'cache'
EXTENSIONS = { 'text/html;charset=UTF-8':'.htm', 'text/html; charset=utf-8':'.htm', 'text/html;charset=utf-8':'.htm', 'text/html; charset=iso-8859-1':'.htm', 'text/html':'.htm', 'application/pdf':'.pdf', 'text/html; charset=UTF-8':'.htm', 'application/msword':'.doc', 'application/vnd.openxmlformats-officedocument.wordprocessingml.document':'.docx'}
DB         = './etc/##KEY##.db'
SQL        = 'SELECT identifier, url FROM bibliographics;'
POOL       = 12
UPDATE     = "UPDATE bibliographics SET extension = '##EXTENSION##' WHERE identifier IS '##IDENTIFIER##'; "
TIMEOUT    = 5

# require
from   multiprocessing import Pool
from   pathlib         import Path
import requests
import sqlite3
import sys

# given a key, identifier and url, cache a file
def cache( key, identifier, url ) :

	# check for bogus url
	if url == None : return
	if url == ''   : return

	# parse
	leaf = identifier.split( '/' )[ -1 ]
	
	# request just the head of the given url
	try    : response = requests.head( url, timeout=TIMEOUT, allow_redirects=True )
	except : return

	# based on the content type, denote a file extension
	type = response.headers[ 'Content-Type' ]
	if type in types : extension = EXTENSIONS[ type ]
	else :
		sys.stderr.write( 'Warning: type (' + type + ') not known. Call Eric.\n' )
		return
		
	# check to see if the file has already been cached
	file = corpora/key/CACHE/( key + '-' + leaf + extension )
	sys.stderr.write( str( file ) )
	if file.exists() :
		sys.stderr.write( ' exists\n' )
		return( [ identifier, extension ] )	
		
	# request the full document and save it
	sys.stderr.write( ' getting\n' )
	try    : response = requests.get( url, timeout=TIMEOUT, allow_redirects=True )
	except : return
	with open( file, 'wb' ) as handle : handle.write( response.content )

	# done
	return( [ identifier, extension ] )


# get input
if len( sys.argv ) != 2 : sys.exit( 'Usage: ' + sys.argv[ 0 ] + " <key>" )
key = sys.argv[ 1 ]

# begin
if __name__ == "__main__" :

	# initialize
	db                     = DB.replace( '##KEY##', key )
	connection             = sqlite3.connect( db )
	connection.row_factory = sqlite3.Row
	results                = connection.execute( SQL );
	types                  = EXTENSIONS.keys()
	corpora                = Path( CORPORA )
	pool                   = Pool( POOL )
	
	# submit the work in parallel; powerful
	results = pool.starmap( cache, [ [ key, result[ 'identifier' ], result[ 'url' ] ] for result in results ] )

	sys.stderr.write( 'Updating bibliographics with extensions.\n' )
	# process each result; create a list of updates
	for result in results :

		# skip null result values
		if result == None : continue
	
		# parse
		identifier = result[ 0 ]
		extension  = result[ 1 ]
	
		# create an update statement and execute it; ought to get speed up if this were a transaction
		update = UPDATE.replace( '##EXTENSION##', extension ).replace( '##IDENTIFIER##', identifier )
		connection.execute( update )
		connection.execute( 'commit' )
		
# done
exit()

