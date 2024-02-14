#!/usr/bin/env perl
use LWP::Simple;
use Mojo::DOM;
use Term::ANSIColor;
use IO::Interactive qw(is_interactive);

use strict;

my $content = get('https://forecast.weather.gov/MapClick.php?lat=43.6099&lon=-83.8407&unit=0&lg=english&FcstType=text&TextType=1');

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
