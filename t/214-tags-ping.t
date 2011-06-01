#!/usr/bin/perl
use strict;
use warnings;
use lib qw( t/lib lib extlib ../lib ../extlib );
use MT::Test::Tags;
run_tests_by_data();
__DATA__
-
  name: test item 120
  template: <MTPings lastn="1"><MTPingDate></MTPings>
  expected: "April  5, 2005 12:00 AM"

-
  name: test item 121
  template: <MTPings lastn="1"><MTPingID></MTPings>
  expected: 1

-
  name: test item 122
  template: <MTPings lastn="1"><MTPingTitle></MTPings>
  expected: Foo

-
  name: test item 123
  template: <MTPings lastn="1"><MTPingURL></MTPings>
  expected: "http://example.com/"

-
  name: test item 124
  template: <MTPings lastn="1"><MTPingExcerpt></MTPings>
  expected: Bar

-
  name: test item 125
  template: <MTPings lastn="1"><MTPingIP></MTPings>
  expected: 127.0.0.1

-
  name: test item 126
  template: <MTPings lastn="1"><MTPingBlogName></MTPings>
  expected: Example Blog

-
  name: test item 140
  template: <MTPings lastn="1"><MTPingDate></MTPings>
  expected: "April  5, 2005 12:00 AM"

-
  name: test item 141
  template: |
    <MTEntries lastn="1">
      <MTPingsSent><MTPingsSentURL>; </MTPingsSent>
    </MTEntries>
  expected: |
    http://technorati.com/;

-
  name: test item 207
  template: |
    <MTEntries lastn='1'>
      <MTIfPingsActive>pings active</MTIfPingsActive>
    </MTEntries>
  expected: pings active

-
  name: test item 208
  template: |
    <MTEntries lastn='1'>
      <MTIfPingsAccepted>pings accepted</MTIfPingsAccepted>
    </MTEntries>
  expected: pings accepted

-
  name: test item 209
  template: |
    <MTEntries lastn='1'>
      <MTIfPingsAllowed>pings allowed</MTIfPingsAllowed>
    </MTEntries>
  expected: pings allowed

-
  name: test item 213
  template: |
    <MTEntries lastn='1'>
      <MTEntryIfAllowPings>entry allows pings</MTEntryIfAllowPings>
    </MTEntries>
  expected: entry allows pings

-
  name: test item 345
  template: |
    <MTPings>
      <MTPingEntry><MTEntryClass>;</MTPingEntry>
    </MTPings>
  expected: |
    page;
    entry;

-
  name: test item 523
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
  name: test item 548
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

