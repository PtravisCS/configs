#!/usr/bin/env perl
use LWP::Simple;
use Getopt::Long;
use JSON::Parse ':all';
use Data::Dumper;
use Mojo::DOM;
use Term::ANSIColor;
use IO::Interactive qw(is_interactive);

use strict;

my $city = 'Essexville';
my $state = 'MI';
my $country = 'US';

# Currently unused
GetOptions ("city=s" => \$city,
						"state=s" => \$state,
						"country=s" => \$country);

my $resp = get("https://geocode.arcgis.com/arcgis/rest/services/World/GeocodeServer/findAddressCandidates?text=$city%20$state%20$country&f=json&magicKey=dHA9NCN0dj02NjIyYjk2NiNubT1Fc3NleHZpbGxlLCBNSSwgVVNBI3NjPVVTQTpQUkk6VklSOkdVTTpBU00jbG5nPTQxI2xuPVdvcmxk");
my $json = parse_json( $resp );

my $latitude = $json->{candidates}[0]->{location}->{y};
my $longitude = $json->{candidates}[0]->{location}->{x};

my $content = get("https://forecast.weather.gov/MapClick.php?lat=$latitude&lon=$longitude&unit=0&lg=english&FcstType=text&TextType=1");

my $dom = Mojo::DOM->new($content);
my $elements = $dom->find('td');

my $forecast = '';

for my $elem ($elements->each) {

  #my $forecast .= $elem =~ s/<br>/\n/r;
  #print $elem
  
  for my $el ($elem->find('a')->each) {
    $el->remove;
  }

  for my $el ($elem->find('div')->each) {
    $el->remove;
  }

  for my $el ($elem->find('hr')->each) {
    $el->remove;
  }

  for my $el ($elem->find('br')->each) {
    $el->remove;
  }

  for my $el ($elem->find('font')->each) {
    $el->remove;
  }

  $forecast .= $elem->content;

}

$forecast =~ s/\n\n/\n/g;
$forecast =~ s/Today/\nToday/g;
$forecast =~ s/This Afternoon:/\nThis Afternoon:/g;
$forecast =~ s/M.L.King Day:/\nM.L.King Day:/g;
$forecast =~ s/Juneteenth:/\nJuneteenth:/g;
$forecast =~ s/\&nbsp;/ /g;
$forecast =~ s/\&#39;/\'/g;
$forecast =~ s/\&#34;/\"/g;
$forecast =~ s/\&lt;/</g;
$forecast =~ s/\&gt;/>/g;
$forecast =~ s/(\&ndash;|\&mdash;)/-/g;
$forecast =~ s/\&deg;/°/g;
$forecast =~ s#[^a-zA-Z 0-9:\/,\.%\(\)\n<> \-\']#°#g;
if (is_interactive()) {
  $forecast =~ s/<b>/\e[1;36;40m/g;
  $forecast =~ s#</b>#\033[0m#g;
} else {
  $forecast =~ s/(<b>)/\*\*/g;
  $forecast =~ s#</b>#\*\*#g;
}
$forecast =~ s/2023/2023\n/;
$forecast =~ s/Visit your local NWS office at://g;
$forecast =~ s/Essexville/\nEssexville/g;
$forecast =~ s/MI°/MI /g;
$forecast =~ s/MI([0-9]{1,2}:[0-9]{2})/MI. $1/g;

print $forecast, "\n";
