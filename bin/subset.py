#!/usr/bin/env python

DATABASE       = './etc/journals.db'
SQL            = "select * from titles where home like '%index.php%' and classification like '##CLASSIFICATION##%';"

# require
import pandas as pd
import sqlite3
import requests
import sys

# get input
if len( sys.argv ) != 2 : sys.exit( 'Usage: ' + sys.argv[ 0 ] + " <classification>" )
classification = sys.argv[ 1 ]

# initialize
connection = sqlite3.connect( DATABASE )
query      = SQL.replace( '##CLASSIFICATION##', classification)

# get matching titles
titles = pd.read_sql_query( query, connection )

# create an oai url
titles[ 'oai' ] = titles[ 'home' ] + '/oai'

# process each title
identifiers = []
for index, row in titles.iterrows() :

	# re-initialize
	found        = False
	identifier   = row[ 'identifier' ]
	title        = row[ 'title' ]
	journal_code = row[ 'codes' ]
	url          = row[ 'oai' ]
	sys.stderr.write( url + '\t' )
	
	# try to get the response code for the oai url
	try :
		code = str( requests.get( url, timeout=10 ).status_code )
		if code == '200' : found = True
		
	# bummer!
	except :
		code = ''
		pass
	
	sys.stderr.write( code + '\n' )

	if found : print( '\t'.join( [ title, journal_code, url, 'PDF' ] ) )
		
# done
exit()
