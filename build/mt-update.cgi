#!/usr/bin/perl -w
use strict;

use lib '/home/btrott/dev/mt/lib';
use lib 'lib';

use MT;
use MT::Util qw( format_ts );
use MT::Donor;

my $POST_MAX = 500;
my $INCLUDE = "updates.html";
my $LOG = "updates.log";

my $mt = MT->new;

my $cl = $ENV{CONTENT_LENGTH};
response("Invalid content length: too long", 1) if $cl > $POST_MAX;
read STDIN, my($qs), $cl, 0;

my @p = $qs =~ m!<param><value>([^>]*)</value></param>!g or
    response("Invalid content format", 1);

my($name, $url, $key) = @p;
response("Invalid donor key '$key'", 1) unless $key;

my $donor = MT::Donor->load($key) or
    response("Invalid donor key '$key'", 1);
$donor->name($name);
$donor->url($url);
$donor->save;

my $iter = MT::Donor->load_iter({}, { sort => 'modified_on',
                                      direction => 'descend',
                                      limit => 10, });
{
    open FH, ">$INCLUDE" or
        die "Can't update local changes file: $!";
    while (my $donor = $iter->()) {
        printf FH qq(<a href="%s">%s</a> (%s)<br>\n),
            $donor->url, $donor->name, format_ts("%I:%S %P",
            $donor->modified_on);
    }
    close FH;
}

stamp_log( qq(%s "%s" %s\n), $donor->id, $donor->name, $donor->url );
response(<<MSG);
Thanks for the ping. Your site has been added to the Movable Type recently updated list.
MSG

sub stamp_log {
    open FH, ">>$LOG" or
        die "Can't open log file '$LOG': $!";
    printf FH scalar localtime, $ENV{REMOTE_ADDR}, $_[0], "\n";
    close FH;
}

sub response {
    my($message, $error) = @_;
    $error = 0 unless defined $error;
    if ($error) {
        stamp_log($message);
    }
    print <<XML;
Content-Type: text/xml

<?xml version="1.0"?>
<methodResponse>
  <params>
    <param>
      <value>
        <struct>
          <member>
            <name>flerror</name>
            <value>
              <boolean>$error</boolean>
            </value>
          </member>
          <member>
            <name>message</message>
            <value>$message</value>
          </member>
        </struct>
      </value>
    </param>
  </params>
</methodResponse>
XML
    exit;
}
