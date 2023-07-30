#!/usr/bin/env perl

# tsv2marc.pl - given a few inputs, output a set of MARC records

# Eric Lease Morgan <emorgan@nd.edu>
# (c) University of Notre Dame; distributed under a GNU Public License

# July 30, 2023 - first documentation, but created a few weeks ago


# configure
use constant MAXIMUM        => 999;
use constant EXTENSION      => '.pdf';
use constant ROOT           => 'https://distantreader.org/stacks/journals';
use constant TSV            => './corpora/##KEY##/bibliographics.tsv';
use constant VERB           => 'GetRecord';
use constant METADATAPREFIX => 'oai_dc';

# require
use strict;
use MARC::Record;

# initialize
my $index    = 0;
my $record   = '';
my $key      = $ARGV[ 0 ];
my $journal  = $ARGV[ 1 ];
my $oai_root = $ARGV[ 2 ];

if ( ! $key || ! $journal || ! $oai_root ){
	warn "Usage: $0 <key> <journal> <oai root>\n";
	exit;
}

# open the given bibliographic file and process each line
my $tsv =  TSV;
$tsv    =~ s/##KEY##/$key/; 
open( my $handle, " < $tsv" ) or die "Can't open $tsv ($!); Call Eric.";
while( my $line = <$handle> )  {

	# increment
	$index++;
	next if $index == 1;
	
	# parse
	chop( $line );
	my @fields     = split( "\t", $line );
	my $identifier = $fields[ 0 ];
	my $author     = $fields[ 1 ];
	my $title      = $fields[ 2 ];
	my $date       = $fields[ 3 ];
	my $source     = $fields[ 4 ];
	my $publisher  = $fields[ 5 ];
	my $language   = $fields[ 6 ];
	my $doi        = $fields[ 7 ];
	my $url        = $fields[ 8 ];
	my $abstract   = $fields[ 9 ];
	
	# debug
	warn( "       index: $index\n" );
	warn( "  identifier: $identifier\n" );
	#warn( "      author: $author\n" );
	#warn( "       title: $title\n" );
	#warn( "        date: $date\n" );
	#warn( "      source: $source\n" );
	#warn( "   publisher: $publisher\n" );
	#warn( "    language: $language\n" );
	#warn( "         doi: $doi\n" );
	#warn( "         url: $url\n" );
	#warn( "    abstract: $abstract\n" );
	warn( "\n" );
	
	# re-initialize
	$record = MARC::Record->new();
	
	# doi
	my $doi = MARC::Field->new( '024', 7, '', ''=>$doi, '2'=>'doi' );
	$record->append_fields( $doi );

	# author
	my $author = MARC::Field->new( '100', 1, '', a=>$author );
	$record->append_fields( $author );

	# title
	my $_245 = MARC::Field->new( '245', '1', '4', a=>$title );
	$record->append_fields( $_245 );
	
	# abstract
	my $abstract = MARC::Field->new( '520', '3', '', a=>$abstract );
	$record->append_fields( $abstract );

	# _730
	my $_730 = MARC::Field->new( '730', ' ', ' ', a=>$journal );
	$record->append_fields( $_730 );

	# url, canonical
	$url = MARC::Field->new( '856', '4', '', u=>$url, z=>'canonical source' );
	$record->append_fields( $url );

	# url, local cache
	my $suffix = ( split( '/', $identifier ) )[ 1 ];
	$url = join( '/', ( ROOT, $key, $key . '-' . $suffix . EXTENSION ) );
	$url = MARC::Field->new( '856', '4', '', u=>$url, z=>'cached version' );
	$record->append_fields( $url );

	# url, oai
	$url = $oai_root . '?verb=' . VERB . "&identifier=$identifier" . '&metadataPrefix=' . METADATAPREFIX;
	$url = MARC::Field->new( '856', '4', '', u=>$url, z=>'OAI metadata' );
	$record->append_fields( $url );

	# _942
	my $_942 = MARC::Field->new( '942', ' ', ' ', '2'=>'dcc', 'c'=>'ARTICLE', 'n'=>'0' );
	$record->append_fields( $_942 );

	# _952
	my $_952 = MARC::Field->new( '952', ' ', ' ', '0'=>'0', '1'=>'0', '2'=>'ddc', '4'=>'0', '7'=>'0', 'a'=>'ININI', 'b'=>'ININI', 'd'=>'2023-07-28', 'l'=>'0', 'r'=>'2023-07-28 14:57:47', 'w'=>'2023-07-28', 'y'=>'ARTICLE' );
	$record->append_fields( $_952 );

	# output
	print $record->as_usmarc();

	# continue, conditionally
	if ( $index > MAXIMUM ) { last }
	
}

# clean up and done
close HANDLE;
exit;




