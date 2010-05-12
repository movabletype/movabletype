# $Id: 08-util.t 3531 2009-03-12 09:11:52Z fumiakiy $

use utf8;
use lib 't/lib', 'extlib', 'lib', '../lib', '../extlib';
use Test::More;
use MT;
use MT::Test;
use MT::Util qw( encode_html decode_html wday_from_ts format_ts dirify
                 convert_high_ascii encode_xml decode_xml substr_wref
                 trim ltrim rtrim remove_html );
use MT::I18N qw( encode_text );
use strict;

my $mt = MT->new;
$mt->config('NoHTMLEntities', 1);

BEGIN { plan tests => 104 };

is(substr_wref("Sabado", 0, 3), "Sab"); #1
is(substr_wref("S&agrave;bado", 0, 3), "S&agrave;b"); #2
is(substr_wref("S&agrave;bado", 0, 6), "S&agrave;bado"); #3

is(convert_high_ascii("\xd8"), 'O'); #4
is(convert_high_ascii("Febr\xf9ary"), 'February'); #5

my $str = '';
for (my $i = 0; $i < 256; $i++) {
    $str .= chr($i);
}
$mt->config('PublishCharset', 'iso-8859-1');
is(dirify($str), '_abcdefghijklmnopqrstuvwxyz_abcdefghijklmnopqrstuvwxyzaaaaaaaeceeeeiiiinoooooouuuuyssaaaaaaaeceeeeiiiinoooooouuuuyy'); #6
$mt->config('PublishCharset', 'utf-8');

my $utf8_str = qq!\x{c0}\x{c1}\x{c2}\x{c3}\x{c4}\x{c5}\x{100}\x{104}\x{102}\x{c6}\x{c7}\x{106}\x{10c}\x{108}\x{10a}\x{10e}\x{110}\x{c8}\x{c9}\x{ca}\x{cb}\x{112}\x{118}\x{11a}\x{114}\x{116}\x{11c}\x{11e}\x{120}\x{122}\x{124}\x{126}\x{cc}\x{cd}\x{ce}\x{cf}\x{12a}\x{128}\x{12c}\x{12e}\x{130}\x{132}\x{134}\x{136}\x{141}\x{13d}\x{139}\x{13b}\x{13f}\x{d1}\x{143}\x{147}\x{145}\x{14a}\x{d2}\x{d3}\x{d4}\x{d5}\x{d6}\x{d8}\x{14c}\x{150}\x{14e}\x{152}\x{154}\x{158}\x{156}\x{15a}\x{160}\x{15e}\x{15c}\x{218}\x{164}\x{162}\x{166}\x{21a}\x{d9}\x{da}\x{db}\x{dc}\x{16a}\x{16e}\x{170}\x{16c}\x{168}\x{172}\x{174}\x{dd}\x{176}\x{178}\x{179}\x{17d}\x{17b}\x{e0}\x{e1}\x{e2}\x{e3}\x{e4}\x{e5}\x{101}\x{105}\x{103}\x{e6}\x{e7}\x{107}\x{10d}\x{109}\x{10b}\x{10f}\x{111}\x{e8}\x{e9}\x{ea}\x{eb}\x{113}\x{119}\x{11b}\x{115}\x{117}\x{192}\x{11d}\x{11f}\x{121}\x{123}\x{125}\x{127}\x{ec}\x{ed}\x{ee}\x{ef}\x{12b}\x{129}\x{12d}\x{12f}\x{131}\x{133}\x{135}\x{137}\x{138}\x{142}\x{13e}\x{13a}\x{13c}\x{140}\x{f1}\x{144}\x{148}\x{146}\x{149}\x{14b}\x{f2}\x{f3}\x{f4}\x{f5}\x{f6}\x{f8}\x{14d}\x{151}\x{14f}\x{153}\x{155}\x{159}\x{157}\x{15b}\x{161}\x{15f}\x{15d}\x{219}\x{165}\x{163}\x{167}\x{21b}\x{f9}\x{fa}\x{fb}\x{fc}\x{16b}\x{16f}\x{171}\x{16d}\x{169}\x{173}\x{175}\x{fd}\x{ff}\x{177}\x{17e}\x{17c}\x{17a}\x{de}\x{fe}\x{df}\x{17f}\x{d0}\x{f0}!;
is(dirify($utf8_str), 'aaaaaaaaaaecccccddeeeeeeeeegggghhiiiiiiiiiijjklllllnnnnnooooooooooerrrsssssttttuuuuuuuuuuwyyyzzzaaaaaaaaaaecccccddeeeeeeeeefgggghhiiiiiiiiiijjkklllllnnnnnnooooooooooerrrsssssttttuuuuuuuuuuwyyyzzzss'); #7

my $ts = '19770908153005';
is(format_ts('%a', $ts), 'Thu'); #8
is(format_ts('%A', $ts), 'Thursday'); #9
is(format_ts('%b', $ts), 'Sep'); #10
is(format_ts('%B', $ts), 'September'); #11
is(format_ts('%d', $ts), '08'); #12
is(format_ts('%e', $ts), ' 8'); #13
is(format_ts('%H', $ts), '15'); #14
is(format_ts('%I', $ts), '03'); #15
is(format_ts('%j', $ts), '251'); #16
is(format_ts('%k', $ts), '15'); #17
is(format_ts('%l', $ts), ' 3'); #18
is(format_ts('%m', $ts), '09'); #19
is(format_ts('%M', $ts), '30'); #20
is(format_ts('%p', $ts), 'PM'); #21
is(format_ts('%S', $ts), '05'); #22
is(format_ts('%x', $ts), 'September  8, 1977'); #23
is(format_ts('%X', $ts), ' 3:30 PM'); #24
is(format_ts('%y', $ts), '77'); #25
is(format_ts('%Y', $ts), '1977'); #26

is(encode_html('<foo>'), '&lt;foo&gt;'); #27
is(encode_html('&gt;'), '&gt;'); #28
is(encode_html('&gt;', 1), '&amp;gt;'); #29
is(encode_html("foo & bar &baz"), "foo &amp; bar &amp;baz"); #30
is(decode_html(encode_html('<foo>')), '<foo>'); #31
is(encode_html(), ''); #32
is(encode_html("&lt;"), "&lt;"); #33
is(encode_html("&#x192;"), "&#x192;"); #34
is(encode_html("&#X192;"), "&#X192;"); #35
is(encode_html("&#192;"), "&#192;"); #36
is(encode_html('"'), '&quot;'); #37
is(encode_html('&'), '&amp;'); #38
is(encode_html('>'), '&gt;'); #39
is(encode_html('<'), '&lt;'); #40
is(encode_html("<foo>\cM\n"), "&lt;foo&gt;\n"); #41

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
        is(encode_xml($test), $xml_tests{$test}[0]); #65 #69 #73 #77
        is(decode_xml($xml_tests{$test}[0]), $test); #66 #70 #74 #78
        is(decode_xml(encode_xml($test)), $test); #67 #71 #75 #79
        MT::ConfigMgr->instance->NoCDATA(1);
        is(encode_xml($test), $xml_tests{$test}[1]); #68 #72 #76 #80
        MT::ConfigMgr->instance->NoCDATA(0);
    } else {
        is(encode_xml($test), $xml_tests{$test}); #53 #56 #59 #62
        is(decode_xml($xml_tests{$test}), $test); #54 #57 #60 #63
        is(decode_xml(encode_xml($test)), $test); #55 #58 #61 #64
    }
}

### tests for trim
is(ltrim(' sunday'), 'sunday'); #81
is(ltrim('  sunday monday'), 'sunday monday'); #82
is(ltrim(' sunday monday tuesday '), 'sunday monday tuesday '); #83
is(ltrim('sunday'), 'sunday'); #84
is(rtrim('sunday'), 'sunday'); #85
is(rtrim('sunday '), 'sunday'); #86
is(rtrim(' sunday monday '), ' sunday monday'); #87
is(rtrim('sunday monday tuesday  '), 'sunday monday tuesday'); #88
is(trim('sunday'), 'sunday'); #89
is(trim(' sunday'), 'sunday'); #90
is(trim(' sunday '), 'sunday'); #91
is(trim(' sunday monday '), 'sunday monday'); #92

is(remove_html('<![CDATA[foo]]>'), '<![CDATA[foo]]>', "remove html preserves CDATA");
is(remove_html('<![CDATA[]]><script>alert("foo")</script><![CDATA[]]>'), '<![CDATA[]]>alert("foo")<![CDATA[]]>', "remove html prevents abuse");
is(remove_html('<![CDATA[one]]><script>alert("foo")</script><![CDATA[two]]>'), '<![CDATA[one]]>alert("foo")<![CDATA[two]]>', "remove html prevents abuse, saves plain text");
is(remove_html('<![CDATA[<foo>]]><script>alert("foo")</script><![CDATA[two]]>'), '<![CDATA[&lt;foo>]]>alert("foo")<![CDATA[two]]>', "remove html prevents abuse, saves plain text, escapes inner < characters");

is(MT::Util::to_json({'foo' => 2}), '{"foo":2}');
is(MT::Util::to_json({'foo' => 1}), '{"foo":1}');
is(MT::Util::to_json({'foo' => 0}), '{"foo":0}');
is(MT::Util::to_json({'foo' => 'hoge'}), '{"foo":"hoge"}');
is(MT::Util::to_json({'foo' => 'ho1ge'}), '{"foo":"ho1ge"}');
is(MT::Util::to_json(['foo', 'bar', 'baz']), '["foo","bar","baz"]');
is(MT::Util::to_json(['foo', 1, 'bar', 2, 3, 4]), '["foo",1,"bar",2,3,4]');
is(MT::Util::to_json(['foo', 1, 'bar', { hoge => 1, moge => 'a' }]), '["foo",1,"bar",{"hoge":1,"moge":"a"}]');

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
