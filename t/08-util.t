# $Id$

use Test;
use MT;
use MT::Util qw( encode_html decode_html wday_from_ts format_ts dirify
                 convert_high_ascii encode_xml decode_xml substr_wref );
use MT::I18N qw( encode_text );
use strict;

my $mt = MT->new;
$mt->config('NoHTMLEntities', 1);

BEGIN { plan tests => 80 };

ok(substr_wref("Sabado", 0, 3), "Sab"); #1
ok(substr_wref("S&agrave;bado", 0, 3), "S&agrave;b"); #2
ok(substr_wref("S&agrave;bado", 0, 6), "S&agrave;bado"); #3

ok(convert_high_ascii("\xd8"), 'O'); #4
ok(convert_high_ascii("Febr\xf9ary"), 'February'); #5

my $str = '';
for (my $i = 0; $i < 256; $i++) {
    $str .= chr($i);
}
$mt->config('PublishCharset', 'iso-8859-1');
ok(dirify($str), '_abcdefghijklmnopqrstuvwxyz_abcdefghijklmnopqrstuvwxyzaaaaaaaeceeeeiiiinoooooouuuuyssaaaaaaaeceeeeiiiinoooooouuuuyy'); #6
$mt->config('PublishCharset', 'utf-8');
use bytes;
my $utf8_str = q{ÀÁÂÃÄÅĀĄĂÆÇĆČĈĊĎĐÈÉÊËĒĘĚĔĖĜĞĠĢĤĦÌÍÎÏĪĨĬĮİĲĴĶŁĽĹĻĿÑŃŇŅŊÒÓÔÕÖØŌŐŎŒŔŘŖŚŠŞŜȘŤŢŦȚÙÚÛÜŪŮŰŬŨŲŴÝŶŸŹŽŻàáâãäåāąăæçćčĉċďđèéêëēęěĕėƒĝğġģĥħìíîïīĩĭįıĳĵķĸłľĺļŀñńňņŉŋòóôõöøōőŏœŕřŗśšşŝșťţŧțùúûüūůűŭũųŵýÿŷžżźÞþßſÐð};
ok(dirify($utf8_str), 'aaaaaaaaaaecccccddeeeeeeeeegggghhiiiiiiiiiijjklllllnnnnnooooooooooerrrsssssttttuuuuuuuuuuwyyyzzzaaaaaaaaaaecccccddeeeeeeeeefgggghhiiiiiiiiiijjkklllllnnnnnnooooooooooerrrsssssttttuuuuuuuuuuwyyyzzzss'); #7

my $ts = '19770908153005';
ok(format_ts('%a', $ts), 'Thu'); #8
ok(format_ts('%A', $ts), 'Thursday'); #9
ok(format_ts('%b', $ts), 'Sep'); #10
ok(format_ts('%B', $ts), 'September'); #11
ok(format_ts('%d', $ts), '08'); #12
ok(format_ts('%e', $ts), ' 8'); #13
ok(format_ts('%H', $ts), '15'); #14
ok(format_ts('%I', $ts), '03'); #15
ok(format_ts('%j', $ts), '251'); #16
ok(format_ts('%k', $ts), '15'); #17
ok(format_ts('%l', $ts), ' 3'); #18
ok(format_ts('%m', $ts), '09'); #19
ok(format_ts('%M', $ts), '30'); #20
ok(format_ts('%p', $ts), 'PM'); #21
ok(format_ts('%S', $ts), '05'); #22
ok(format_ts('%x', $ts), 'September  8, 1977'); #23
ok(format_ts('%X', $ts), ' 3:30 PM'); #24
ok(format_ts('%y', $ts), '77'); #25
ok(format_ts('%Y', $ts), '1977'); #26

ok(encode_html('<foo>'), '&lt;foo&gt;'); #27
ok(encode_html('&gt;'), '&gt;'); #28
ok(encode_html('&gt;', 1), '&amp;gt;'); #29
ok(encode_html("foo & bar &baz"), "foo &amp; bar &amp;baz"); #30
ok(decode_html(encode_html('<foo>')), '<foo>'); #31
ok(encode_html(), ''); #32
ok(encode_html("&lt;"), "&lt;"); #33
ok(encode_html("&#x192;"), "&#x192;"); #34
ok(encode_html("&#X192;"), "&#X192;"); #35
ok(encode_html("&#192;"), "&#192;"); #36
ok(encode_html('"'), '&quot;'); #37
ok(encode_html('&'), '&amp;'); #38
ok(encode_html('>'), '&gt;'); #39
ok(encode_html('<'), '&lt;'); #40
ok(encode_html("<foo>\cM\n"), "&lt;foo&gt;\n"); #41

ok(wday_from_ts(1964,1,3) == 5); #42
ok(wday_from_ts(1995,11,13) == 1); #43
ok(wday_from_ts(1995,11,14) == 2); #44
ok(wday_from_ts(1995,11,15) == 3); #45
ok(wday_from_ts(1995,11,16) == 4); #46
ok(wday_from_ts(1995,11,17) == 5); #47
ok(wday_from_ts(1995,11,18) == 6); #48
ok(wday_from_ts(1995,11,19) == 0); #49
ok(wday_from_ts(1995,11,20) == 1); #50
ok(wday_from_ts(1995,2,28) == 2); #51
ok(wday_from_ts(1946,12,26) == 4); #52

my %xml_tests = (
    'foo' => 'foo', #53 #54 #55
    'x < y' => 'x &lt; y', #56 #57 #58
    'foo & bar' => 'foo &amp; bar', #59 #60 #61
    'foo\'s bar' => 'foo&apos;s bar', #62 #63 #64
    '<title>my title</title>' => #65 #66 #67 #68
        [ '<![CDATA[<title>my title</title>]]>',
          '&lt;title&gt;my title&lt;/title&gt;', ],
    '<foo>]]>' => #69 #70 #71 #72
        [ '<![CDATA[<foo>]]&gt;]]>',
          '&lt;foo&gt;]]&gt;', ],
    'x &lt; y' => #73 #74 #75 #76
        [ '<![CDATA[x &lt; y]]>',
          'x &amp;lt; y', ],
    'foob&aacute;r' => #77 #78 #79 #80
        [ '<![CDATA[foob&aacute;r]]>',
          'foob&amp;aacute;r', ],
);
 
for my $test (keys %xml_tests) {
    if (ref($xml_tests{$test}) eq 'ARRAY') {
        ok(encode_xml($test), $xml_tests{$test}[0]); #65 #69 #73 #77
        ok(decode_xml($xml_tests{$test}[0]), $test); #66 #70 #74 #78
        ok(decode_xml(encode_xml($test)), $test); #67 #71 #75 #79
        MT::ConfigMgr->instance->NoCDATA(1);
        ok(encode_xml($test), $xml_tests{$test}[1]); #68 #72 #76 #80
        MT::ConfigMgr->instance->NoCDATA(0);
    } else {
        ok(encode_xml($test), $xml_tests{$test}); #53 #56 #59 #62
        ok(decode_xml($xml_tests{$test}), $test); #54 #57 #60 #63
        ok(decode_xml(encode_xml($test)), $test); #55 #58 #61 #64
    }
}

=pod

my %dates = (
          '20021224103045'            => '20021224T10:30:45',
          '20021224T10:30:45'         => '20021224T10:30:45',
          '20021224T103045Z'          => '20021224T02:30:45',
          '20021224T10:30:45-0000'    => '20021224T02:30:45',
          '20021224T10:30:45+0030'    => '20021224T02:00:45',
          '2002-12-24T103045+02'      => '20021224T00:30:45',
          '2002-12-24T10:30:45-08:00' => '20021224T10:30:45',
          '20020615103045'            => '20020615T10:30:45',
          '20020615103045-08'         => '20020615T11:30:45',
          '20020615103045+02'         => '20020615T01:30:45',
          );
for my $date (keys %dates) {
    ok(parse_iso8601_date($date, -8, 'gmtime'), $dates{$date});
   #for my $tz ((":America/Los_Angeles", ":Europe/Helsinki")) {
   #    $ENV{"TZ"} = $tz;
   #    for my $lt (("localtime", "gmtime")) {
   #        my $fmt = $lt eq "localtime" ? " %18s " : "%20s";
   #        printf "%-25s -> $fmt %s\n", $i, parseISO8601Date($i, $lt), $tz;
   #    }
   #}
}

=cut
