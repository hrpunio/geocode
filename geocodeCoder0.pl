#!/usr/bin/perl
#
#
use strict;
use LWP::Simple; # from CPAN
use JSON qw( decode_json ); # from CPAN
use Getopt::Long;
use Encode;
##use utf8;

my $format = "json"; #can also to 'xml'
my $geocodeapi = "https://maps.googleapis.com/maps/api/geocode/";
my $addrLine = ''; 
my $postalCode = '';
my $logFile = '';
my $boundingBox = '';
my $country = 'PL';
my $aArea1 = '';  ## w przypadku Polski województwo
my $aArea2 = '';  ## w przypadku Polski powiat
my $dryModeRun = '';

my $USAGE="USAGE: $0 [-a ADDRESS] [-p POSTCODE] [-log FILENAME] [-bb SWlat,SWlng|NElat,NElng|] [-country CODE]"
     . "[-aa1 AAREA1] [-aa2 AAREA2] [-dryrun]\n";

## https://developers.google.com/maps/documentation/geocoding/intro
##
## region/bounds = prefers, more relevat if exists outside are included (ale region to tylko państwa ccTLD)
## components = excludes, more relevat if exists outside are excluded
GetOptions( "a=s" => \$addrLine, "p=s" => \$postalCode, "log=s" => \$logFile, "bb=s" => \$boundingBox,
    "country=s" => \$country, "aa1=s" => \$aArea1, "aa2=s" => \$aArea2, "dryrun" => \$dryModeRun, ) ;

if ($logFile) { open LOG, ">>$logFile" || die "Cannot log to $logFile\n" ;
 print STDERR "*** Logging JSON to $logFile ***\n" ; } else {
 print STDERR "*** Logging JSON OFF ***\n"; }

unless ($addrLine || $postalCode || $aArea1 ) { print STDERR "$USAGE"; exit 0; }

my @res = getLatLong("$addrLine", "$postalCode");
my $coords = "@res[0,1]";
my $bbox = "@res[2,3,4,5]";
my $accuracy = "@res[6]";
my $fa = "@res[7]";
my $addr_types = "@res[8]";

print "Lat/Lng: $coords Bbox: $bbox [$accuracy | $fa | $addr_types ]\n";

if ($logFile) { close (LOG) ; }

### ### ### ### ### ### ### ###

sub getLatLong($){
  my $address = shift;
  my $postal = shift;
  my $components = "&components=country:$country";
  my $comment;

  if ($postal) { $components .=  "|postal_code:$postal" }
  if ($aArea1) { $components .=  "|administrative_area:$aArea1" }
  if ($aArea2) { $components .=  "|administrative_area:$aArea2" }

  #my $url = $geocodeapi . $format . "?sensor=false" ;
  my $url = $geocodeapi . $format . "?$components" ; # sensor=false zbędne

  # jeżeli adres jest '' to &address= będzie pominięte:
  # ?components=country:PL|postal_code:81-825
  if ($address) { $url .= "&address=" . $address; $comment .= "$address" ; }
  if ($boundingBox) { $url .= "&bounds=$boundingBox" ; }

  if ( $addrLine ) { print STDERR "*** Address: $address [$country] *** "}
  if ( $postalCode ) { print STDERR "*** PostalCode: $postal [$country] *** "  ; $comment .= "|$postal"; }
  if ( $aArea1 ) { print STDERR "*** Adm.Area.1: $aArea1 [$country] *** " ; $comment .= "|$aArea1" ; }
  if ( $aArea2 ) { print STDERR "*** Adm.Area.2: $aArea2 [$country] *** " ; $comment .= "|$aArea2" ; }
  
  print STDERR "\n*** [URL: $url  ] ***\n";
  if ($dryModeRun) { exit } ## nie marnuj limitu *--*--*
  
  my $json = get($url);

  if ($logFile) { print LOG "##_comment_: $comment\n##_comment_:$url\n$json\n"; }

  my $d_json = decode_json( $json );

  if ( $d_json->{status} eq 'OK' ) {

    my $lat = $d_json->{results}->[0]->{geometry}->{location}->{lat};
    my $lng = $d_json->{results}->[0]->{geometry}->{location}->{lng};

    my $boundsNElat = $d_json->{results}->[0]->{geometry}->{bounds}->{northeast}->{lat};
    my $boundsNElon = $d_json->{results}->[0]->{geometry}->{bounds}->{northeast}->{lng};
    my $boundsSWlat = $d_json->{results}->[0]->{geometry}->{bounds}->{southwest}->{lat};
    my $boundsSWlon = $d_json->{results}->[0]->{geometry}->{bounds}->{southwest}->{lng};

    my $loc_type = $d_json->{results}->[0]->{geometry}->{location_type};
    ## UTF problem
    my $formatted_address = $d_json->{results}->[0]->{formatted_address};
    ## nie mam pojęcia czemu ale encode jest potrzebne ##:
    $formatted_address = encode("utf-8", $formatted_address);

    my $addr_t = $d_json->{results}->[0]->{types}->[0] . "/" . $d_json->{results}->[0]->{types}->[1];

    return ($lat, $lng, $boundsNElat, $boundsNElon, $boundsSWlat, $boundsSWlon, $loc_type, $formatted_address, $addr_t );
  } else {
    return ( $d_json->{status} )
  }

}
