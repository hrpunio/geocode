#!/usr/bin/perl
#
#
use strict;
use LWP::Simple; # from CPAN
use JSON qw( decode_json ); # from CPAN
use Getopt::Long;
#use Encode;

use utf8;
binmode(STDOUT, ":utf8");

my $format = "json"; #can also to 'xml'
my $myAPIkey = 'Dg2f4ucfIlSRpHWinr2yuzMSqS1j7w5V'; ## MapQuest
my $geocodeapi = "http://open.mapquestapi.com/geocoding/v1/address?key=$myAPIkey&location=";
my $addrLine = ''; 
my $postalCode = '';
my $logFile = '';
my $boundingBox = '';
my $country = 'PL';
my $maxResults = 1; ## podaj tylko pierwszy

my $USAGE="USAGE: $0 [-a ADDRESS] [-log FILENAME] [-country CODE] [-bb SWlat,SWlng|NElat,NElng] \n";

GetOptions( "a=s" => \$addrLine, "log=s" => \$logFile, "country=s" => \$country, "bb=s" => \$boundingBox,
            "max=i" => \$maxResults ) ;

if ($logFile) { open LOG, ">>$logFile" || die "Cannot log to $logFile\n" ;
 print STDERR "*** Logging JSON to $logFile ***\n" ; } else {
 print STDERR "*** Logging JSON OFF ***\n"; }

unless ($addrLine ) { print STDERR "$USAGE"; exit 0; }

my ($lat, $lng, $quality, $lname) = getLatLong($addrLine, $boundingBox);

printf "Lat/Lng/Name/Quality: %s %s %s %s\n", $lat, $lng, $lname, $quality;

if ($logFile) { close (LOG) ; }

### ### ### ### ### ### ### ###

sub getLatLong($){
  my $address = shift;
  my $bb = shift;

  my $url = $geocodeapi . "$address,$country" ; #
  if ($boundingBox ) { $bb =~ s/[\|,]/,/g; ## separatory zmień na odstępy
      $url .= "&boundingBox=$bb" ; }
  if ($maxResults ) { $url .= "&maxResults=$maxResults" ; }

  print STDERR "\n*** [URL: $url] ***\n";

  my $json = get($url);
  if ($logFile) { print LOG "##_comment_:\n##_comment_:$url\n$json\n"; }

  my $d_json = decode_json( $json );

  #if ( $d_json->{statuscode} eq '0' ) {
    my $loc_name =  $d_json->{results}->[0]->{providedLocation}->{location};
    my $lat = $d_json->{results}->[0]->{locations}->[0]->{latLng}->{lat};
    my $lng = $d_json->{results}->[0]->{locations}->[0]->{latLng}->{lng};
    my $quality = $d_json->{results}->[0]->{locations}->[0]->{geocodeQuality};

    return ($lat, $lng, $quality, $loc_name );
  #} else {
  #  return ( $d_json->{statuscode} )
  #}

}
