#!/usr/bin/env perl

# harvest-identifiers.pl - given a base URL pointing to an (OJS) OAI repository, output rudimentary bibliogrpahic information


# configure
#use constant BASEURL => 'https://journals.library.ualberta.ca/istl/index.php/istl/oai';

# require
use Net::OAI::Harvester;
use strict;

# get input
if ( $#ARGV < 0 ) {
    print "Usage: $0 <base URL>\n";
    exit;
}

my $baseurl = $ARGV[ 0 ];

# initialize
my $harvester = Net::OAI::Harvester->new( 'baseURL' => $baseurl );
binmode( STDOUT, ':utf8' );
binmode( STDERR, ':utf8' );

# get all identifiers and then process each one
my $identifiers = $harvester->listAllIdentifiers( 'metadataPrefix' => 'oai_dc' );
while ( my $identifier = $identifiers->next() ) {

    # parse, debug, and output
    my $identifier = $identifier->identifier();
   	#warn "\t$identifier\n";
   	print "$identifier\n";
   		
}

# done
exit;


