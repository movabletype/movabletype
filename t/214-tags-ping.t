#!/usr/bin/perl
use strict;
use warnings;
use lib qw( t/lib lib extlib ../lib ../extlib );
use MT::Test::Tags;


my $mt   = MT->instance;
my $ping = MT->model('tbping')->load(1);

local $MT::Test::Tags::PRERUN = sub {
    my ($stock) = @_;
    $stock->{ping} = $ping;
};
local $MT::Test::Tags::PRERUN_PHP
    = 'require_once("class.mt_tbping.php");' .
      '$tbping = new TBPing;' .
      '$pings  = $tbping->Find("' . $ping->id . '");' .
      '$stock["ping"] = $pings[0];';


run_tests_by_data();
__DATA__
-
  name: PingDate prints created-time of the ping.
  template: <MTPingDate>
  expected: "April  5, 2005 12:00 AM"
  stash:
    ping: $ping

-
  name: PingDate prints ID of the ping.
  template: <MTPingID>
  expected: 1
  stash:
    ping: $ping

-
  name: PingDate prints the title of the ping.
  template: <MTPingTitle>
  expected: Foo
  stash:
    ping: $ping

-
  name: PingDate prints the URL of the ping.
  template: <MTPingURL>
  expected: "http://example.com/"
  stash:
    ping: $ping

-
  name: PingDate prints the excerpt of the ping.
  template: <MTPingExcerpt>
  expected: Bar
  stash:
    ping: $ping

-
  name: PingDate prints the IP address of the ping.
  template: <MTPingIP>
  expected: 127.0.0.1
  stash:
    ping: $ping

-
  name: PingDate prints the blog name of the ping.
  template: <MTPingBlogName>
  expected: Example Blog
  stash:
    ping: $ping

-
  name: PingsSent and PingsSentURL prints all sent-pings of the entry.
  template: |
    <MTPingsSent><MTPingsSentURL>; </MTPingsSent>
  expected: |
    http://technorati.com/;
  stash:
    entry: $entry

-
  name: IfPingsActive prints the inner content if active.
  template: |
    <MTIfPingsActive>pings active</MTIfPingsActive>
  expected: pings active
  stash:
    entry: $entry

-
  name: IfPingsAccepted prints the inner content if accepted.
  template: |
    <MTIfPingsAccepted>pings accepted</MTIfPingsAccepted>
  expected: pings accepted
  stash:
    entry: $entry

-
  name: IfPingsAllowed prints the inner content if allowed in the blog.
  template: |
    <MTIfPingsAllowed>pings allowed</MTIfPingsAllowed>
  expected: pings allowed
  stash:
    entry: $entry

-
  name: EntryIfAllowPings prints the inner content if allowed in the entry.
  template: |
    <MTEntryIfAllowPings>entry allows pings</MTEntryIfAllowPings>
  expected: entry allows pings
  stash:
    entry: $entry

-
  name: Pings lists all the pings of the blog if there is neither the entry nor the category context.
  template: |
    <MTPings>
      <MTPingID />
    </MTPings>
  expected: |
    3
    1

-
  name: Pings lists all the pings of the entry if in the entry context.
  template: |
    <MTPings>
      <MTPingID />
    </MTPings>
  expected: |
    1
  stash:
    entry: $entry

-
  name: PingEntry prepare the entry context for the entry of onself.
  template: |
    <MTPings>
      <MTPingEntry><MTEntryClass>;</MTPingEntry>
    </MTPings>
  expected: |
    page;
    entry;

-
  name: PingsHeader and PingsFooter prints the header and the footer.
  template: |
    <MTPings>
      <MTPingsHeader><ul></MTPingsHeader>
        <li><MTPingTitle></li>
      <MTPingsFooter></ul></MTPingsFooter>
    </MTPings>
  expected: |
    <ul>
      <li>Trackbacking to a page</li>
      <li>Foo</li>
    </ul>

-
  name: IfPingsModerated prints the inner content if moderated.
  template: <MTIfPingsModerated>Moderated</MTIfPingsModerated>
  expected: Moderated


######## Pings
## category
## lastn
## sort_order

######## PingsHeader

######## PingsFooter

######## PingsSent

######## PingEntry

######## IfPingsAllowed

######## IfPingsAccepted

######## IfPingsActive

######## IfPingsModerated

######## EntryIfAllowPings

######## CategoryIfAllowPings

######## PingsSentURL

######## PingTitle

######## PingID

######## PingURL

######## PingExcerpt

######## PingBlogName

######## PingIP

######## PingDate
## format (optional)
## language (optional; defaults to blog language)
## utc (optional; default "0")
## relative (optional; default "0")

######## WebsitePingCount

######## BlogPingCount

######## EntryTrackbackCount

######## EntryTrackbackLink

######## EntryTrackbackData
## comment_wrap (optional; default "1")
## with_index (optional; default "0")

######## EntryTrackbackID

######## CategoryTrackbackLink

######## CategoryTrackbackCount

