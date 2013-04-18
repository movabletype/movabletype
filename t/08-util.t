# $Id: 08-util.t 3531 2009-03-12 09:11:52Z fumiakiy $

use utf8;
use lib 't/lib', 'extlib', 'lib', '../lib', '../extlib';
use Test::More;
use MT;
use MT::Test;
use MT::Util qw( start_end_day start_end_week start_end_month start_end_year
                 start_end_period week2ymd munge_comment
                 rich_text_transform html_text_transform encode_html decode_html
                 iso2ts ts2iso offset_time offset_time_list first_n_words
                 archive_file_for format_ts dirify remove_html
                 days_in wday_from_ts encode_js decode_js get_entry spam_protect
                 is_valid_email encode_php encode_url decode_url encode_xml
                 decode_xml is_valid_url is_url discover_tb convert_high_ascii 
                 mark_odd_rows dsa_verify perl_sha1_digest relative_date
                 perl_sha1_digest_hex dec2bin bin2dec xliterate_utf8 
                 start_background_task launch_background_tasks substr_wref
                 extract_urls extract_domain extract_domains is_valid_date
                 epoch2ts ts2epoch escape_unicode unescape_unicode
                 sax_parser trim ltrim rtrim asset_cleanup caturl multi_iter
                 weaken log_time make_string_csv browser_language sanitize_embed
                 extract_url_path break_up_text dir_separator deep_do
                 deep_copy canonicalize_path );
use MT::I18N qw( encode_text );
use strict;

my $mt = MT->new;
$mt->config('NoHTMLEntities', 1);

## Use done_testing()
## BEGIN { plan tests => 221 };

is(substr_wref("Sabado", 0, 3), "Sab");
is(substr_wref("S&agrave;bado", 0, 3), "S&agrave;b");
is(substr_wref("S&agrave;bado", 0, 6), "S&agrave;bado");

is(convert_high_ascii("\xd8"), 'O');
is(convert_high_ascii("Febr\xf9ary"), 'February');

my $str = '';
for (my $i = 0; $i < 256; $i++) {
    $str .= chr($i);
}
$mt->config('PublishCharset', 'iso-8859-1');
is(dirify($str), '_abcdefghijklmnopqrstuvwxyz_abcdefghijklmnopqrstuvwxyzaaaaaaaeceeeeiiiinoooooouuuuyssaaaaaaaeceeeeiiiinoooooouuuuyy');
$mt->config('PublishCharset', 'utf-8');

my $utf8_str = qq!\x{c0}\x{c1}\x{c2}\x{c3}\x{c4}\x{c5}\x{100}\x{104}\x{102}\x{c6}\x{c7}\x{106}\x{10c}\x{108}\x{10a}\x{10e}\x{110}\x{c8}\x{c9}\x{ca}\x{cb}\x{112}\x{118}\x{11a}\x{114}\x{116}\x{11c}\x{11e}\x{120}\x{122}\x{124}\x{126}\x{cc}\x{cd}\x{ce}\x{cf}\x{12a}\x{128}\x{12c}\x{12e}\x{130}\x{132}\x{134}\x{136}\x{141}\x{13d}\x{139}\x{13b}\x{13f}\x{d1}\x{143}\x{147}\x{145}\x{14a}\x{d2}\x{d3}\x{d4}\x{d5}\x{d6}\x{d8}\x{14c}\x{150}\x{14e}\x{152}\x{154}\x{158}\x{156}\x{15a}\x{160}\x{15e}\x{15c}\x{218}\x{164}\x{162}\x{166}\x{21a}\x{d9}\x{da}\x{db}\x{dc}\x{16a}\x{16e}\x{170}\x{16c}\x{168}\x{172}\x{174}\x{dd}\x{176}\x{178}\x{179}\x{17d}\x{17b}\x{e0}\x{e1}\x{e2}\x{e3}\x{e4}\x{e5}\x{101}\x{105}\x{103}\x{e6}\x{e7}\x{107}\x{10d}\x{109}\x{10b}\x{10f}\x{111}\x{e8}\x{e9}\x{ea}\x{eb}\x{113}\x{119}\x{11b}\x{115}\x{117}\x{192}\x{11d}\x{11f}\x{121}\x{123}\x{125}\x{127}\x{ec}\x{ed}\x{ee}\x{ef}\x{12b}\x{129}\x{12d}\x{12f}\x{131}\x{133}\x{135}\x{137}\x{138}\x{142}\x{13e}\x{13a}\x{13c}\x{140}\x{f1}\x{144}\x{148}\x{146}\x{149}\x{14b}\x{f2}\x{f3}\x{f4}\x{f5}\x{f6}\x{f8}\x{14d}\x{151}\x{14f}\x{153}\x{155}\x{159}\x{157}\x{15b}\x{161}\x{15f}\x{15d}\x{219}\x{165}\x{163}\x{167}\x{21b}\x{f9}\x{fa}\x{fb}\x{fc}\x{16b}\x{16f}\x{171}\x{16d}\x{169}\x{173}\x{175}\x{fd}\x{ff}\x{177}\x{17e}\x{17c}\x{17a}\x{de}\x{fe}\x{df}\x{17f}\x{d0}\x{f0}!;
is(dirify($utf8_str), 'aaaaaaaaaaecccccddeeeeeeeeegggghhiiiiiiiiiijjklllllnnnnnooooooooooerrrsssssttttuuuuuuuuuuwyyyzzzaaaaaaaaaaecccccddeeeeeeeeefgggghhiiiiiiiiiijjkklllllnnnnnnooooooooooerrrsssssttttuuuuuuuuuuwyyyzzzss');

my $ts = '19770908153005';
is(format_ts('%a', $ts), 'Thu');
is(format_ts('%A', $ts), 'Thursday');
is(format_ts('%b', $ts), 'Sep');
is(format_ts('%B', $ts), 'September');
is(format_ts('%d', $ts), '08');
is(format_ts('%e', $ts), ' 8');
is(format_ts('%H', $ts), '15');
is(format_ts('%I', $ts), '03');
is(format_ts('%j', $ts), '251');
is(format_ts('%k', $ts), '15');
is(format_ts('%l', $ts), ' 3');
is(format_ts('%m', $ts), '09');
is(format_ts('%M', $ts), '30');
is(format_ts('%p', $ts), 'PM');
is(format_ts('%S', $ts), '05');
is(format_ts('%x', $ts), 'September  8, 1977');
is(format_ts('%X', $ts), ' 3:30 PM');
is(format_ts('%y', $ts), '77');
is(format_ts('%Y', $ts), '1977');

is(encode_html('<foo>'), '&lt;foo&gt;');
is(encode_html('&gt;'), '&gt;');
is(encode_html('&gt;', 1), '&amp;gt;');
is(encode_html("foo & bar &baz"), "foo &amp; bar &amp;baz");
is(decode_html(encode_html('<foo>')), '<foo>');
is(encode_html(), '');
is(encode_html("&lt;"), "&lt;");
is(encode_html("&#x192;"), "&#x192;");
is(encode_html("&#X192;"), "&#X192;");
is(encode_html("&#192;"), "&#192;");
is(encode_html('"'), '&quot;');
is(encode_html('&'), '&amp;');
is(encode_html('>'), '&gt;');
is(encode_html('<'), '&lt;');
is(encode_html("<foo>\cM\n"), "&lt;foo&gt;\n");

ok(wday_from_ts(1964,1,3) == 5);
ok(wday_from_ts(1995,11,13) == 1);
ok(wday_from_ts(1995,11,14) == 2);
ok(wday_from_ts(1995,11,15) == 3);
ok(wday_from_ts(1995,11,16) == 4);
ok(wday_from_ts(1995,11,17) == 5);
ok(wday_from_ts(1995,11,18) == 6);
ok(wday_from_ts(1995,11,19) == 0);
ok(wday_from_ts(1995,11,20) == 1);
ok(wday_from_ts(1995,2,28) == 2);
ok(wday_from_ts(1946,12,26) == 4);

my %xml_tests = (
    'foo' => 'foo', #53 #54
    'x < y' => 'x &lt; y', #56 #57
    'foo & bar' => 'foo &amp; bar', #59 #60
    'foo\'s bar' => 'foo&apos;s bar', #62 #63
    '<title>my title</title>' => #65 #66 #67
        [ '<![CDATA[<title>my title</title>]]>',
          '&lt;title&gt;my title&lt;/title&gt;', ],
    '<foo>]]>' => #69 #70 #71
        [ '<![CDATA[<foo>]]&gt;]]>',
          '&lt;foo&gt;]]&gt;', ],
    'x &lt; y' => #73 #74 #75
        [ '<![CDATA[x &lt; y]]>',
          'x &amp;lt; y', ],
    'foob&aacute;r' => #77 #78 #79
        [ '<![CDATA[foob&aacute;r]]>',
          'foob&amp;aacute;r', ],
    '&#0; &#2; &#67; &#x2; &#x67; &#x19; &#25' =>
        '&amp;#0; &amp;#2; &#67; &amp;#x2; &#x67; &amp;#x19; &amp;#25',
);
 
for my $test (keys %xml_tests) {
    if (ref($xml_tests{$test}) eq 'ARRAY') {
        is(encode_xml($test), $xml_tests{$test}[0]); #65 #69 #73
        is(decode_xml($xml_tests{$test}[0]), $test); #66 #70 #74
        is(decode_xml(encode_xml($test)), $test); #67 #71 #75
        MT::ConfigMgr->instance->NoCDATA(1);
        is(encode_xml($test), $xml_tests{$test}[1]); #68 #72 #76
        MT::ConfigMgr->instance->NoCDATA(0);
    } else {
        is(encode_xml($test), $xml_tests{$test}); #53 #56 #59
        is(decode_xml($xml_tests{$test}), $test); #54 #57 #60
        is(decode_xml(encode_xml($test)), $test); #55 #58 #61
    }
}

### tests for trim
is(ltrim(' sunday'), 'sunday');
is(ltrim('  sunday monday'), 'sunday monday');
is(ltrim(' sunday monday tuesday '), 'sunday monday tuesday ');
is(ltrim('sunday'), 'sunday');
is(rtrim('sunday'), 'sunday');
is(rtrim('sunday '), 'sunday');
is(rtrim(' sunday monday '), ' sunday monday');
is(rtrim('sunday monday tuesday  '), 'sunday monday tuesday');
is(trim('sunday'), 'sunday');
is(trim(' sunday'), 'sunday');
is(trim(' sunday '), 'sunday');
is(trim(' sunday monday '), 'sunday monday');

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

### start_end_*
is(start_end_day('19770908153005'), '19770908000000', 'Want to get a scalar value from start_end_day()');
is_deeply([start_end_day('19770908153005')], ['19770908000000', '19770908235959'], 'Want to get a list value from start_end_day()');
is(start_end_week('19770908153005'), '19770904000000', 'Want to get a scalar value from start_end_week()');
is_deeply([start_end_week('19770908153005')], ['19770904000000', '19770910235959'], 'Want to get a list value from start_end_week()');
is(start_end_month('19770908153005'), '19770901000000', 'Want to get a scalar value from start_end_month()');
is_deeply([start_end_month('19770908153005')], ['19770901000000', '19770930235959'], 'Want to get a list value from start_end_month()');
is(start_end_year('19770908153005'), '19770101000000', 'Want to get a scalar value from start_end_year()');
is_deeply([start_end_year('19770908153005')], ['19770101000000', '19771231235959'], 'Want to get a list value from start_end_year()');
is(start_end_period('Individual', $ts), $ts, 'start_end_period() for Individual');
is(start_end_period('Daily', $ts), start_end_day($ts), 'start_end_period() for Daily');
is(start_end_period('Weekly', $ts), start_end_week($ts), 'start_end_period() for Weekly');
is(start_end_period('Monthly', $ts), start_end_month($ts), 'start_end_period() for Monthly');
is_deeply([week2ymd(1977, 36)], [1977,9, 4], 'week2ymd()');


### format text
my $content = <<__HTML__;
Foo

<div>Bar</div>

http://example.com/
__HTML__
is(rich_text_transform($content), $content, 'rich_text_transform()');

my $content_html_text_transformed = <<__HTML__;
<p>Foo</p>

<div>Bar</div>

<p>http://example.com/<br />
</p>
__HTML__
chomp($content_html_text_transformed);
is(html_text_transform($content), $content_html_text_transformed, 'html_text_transform()');

is(first_n_words($content, 2), 'Foo Bar', 'first_n_words()');


### time conversion
my $blog = $mt->model('blog')->new;
$blog->server_offset(0);
my $timestamp = '20021224103045';
my $epoch = 1040725845;
is(iso2ts($blog, '20021224T10:30:45'), '20021224103045', 'iso2ts()');
is(ts2iso($blog, '20021224103045'), '2002-12-24T10:30:45Z', 'ts2iso() (server_offset is 0)');
is(epoch2ts($blog, $epoch), $timestamp, 'epoch2ts() (server_offset is 0)');
is(ts2epoch($blog, $timestamp), $epoch, 'ts2epoch() (server_offset is 0)');
is(offset_time($epoch, $blog), $epoch, 'offset_time() (server_offset is 0)');
is(offset_time($epoch, $blog, '-'), $epoch, 'offset_time() (dir is "-" and server_offset is 0)');
is(offset_time_list($epoch, $blog), 'Tue Dec 24 10:30:45 2002', 'offset_time_list() (server_offset is 0)');
is(offset_time_list($epoch, $blog, '-'), 'Tue Dec 24 10:30:45 2002', 'offset_time_list() (dir is "-" and server_offset is 0)');

$blog->server_offset(1);
is(ts2iso($blog, $timestamp), '2002-12-24T09:30:45Z', 'ts2iso() (server_offset is 1)');
is(epoch2ts($blog, $epoch), '20021224113045', 'epoch2ts() (server_offset is 1)');
is(ts2epoch($blog, $timestamp), $epoch-60*60, 'ts2epoch() (server_offset is 1)');
is(offset_time($epoch, $blog), $epoch+60*60, 'offset_time() (server_offset is 1)');
is(offset_time($epoch, $blog, '-'), $epoch-60*60, 'offset_time() (dir is "-" and server_offset is 1)');
is(offset_time_list($epoch, $blog), 'Tue Dec 24 11:30:45 2002', 'offset_time_list() (server_offset is 1)');
is(offset_time_list($epoch, $blog, '-'), 'Tue Dec 24 09:30:45 2002', 'offset_time_list() (dir is "-" and server_offset is 1)');

$blog->server_offset(-1);
is(ts2iso($blog, $timestamp), '2002-12-24T11:30:45Z', 'ts2iso() (server_offset is -1)');
is(epoch2ts($blog, $epoch), '20021224093045', 'epoch2ts() (server_offset is -1)');
is(ts2epoch($blog, $timestamp), $epoch+60*60, 'ts2epoch() (server_offset is -1)');
is(offset_time($epoch, $blog), $epoch-60*60, 'offset_time() (server_offset is -1)');
is(offset_time($epoch, $blog, '-'), $epoch+60*60, 'offset_time() (dir is "-" and server_offset is -1)');
is(offset_time_list($epoch, $blog), 'Tue Dec 24 09:30:45 2002', 'offset_time_list() (server_offset is -1)');
is(offset_time_list($epoch, $blog, '-'), 'Tue Dec 24 11:30:45 2002', 'offset_time_list() (dir is "-" and server_offset is -1)');


### format relative date
$blog->server_offset(0);
my @relative_date_data = (
    {
        offset   => 0,
        style    => undef,
        expected => 'moments ago',
    },
    {
        offset   => 60*60+10,
        style    => undef,
        expected => '1 hour ago',
    },
    {
        offset   => 60*60*24+10,
        style    => undef,
        expected => '1 day ago',
    },
    {
        offset   => 60*60*24*7+10,
        style    => undef,
        expected => '2002/12/24',
    },

    {
        offset   => 0,
        style    => 2,
        expected => 'less than 1 minute ago',
    },
    {
        offset   => 60*60+10,
        style    => 2,
        expected => '1 hour ago',
    },
    {
        offset   => 60*60*24+10,
        style    => 2,
        expected => '1 day ago',
    },
    {
        offset   => 60*60*24*7+10,
        style    => 2,
        expected => '2002/12/24',
    },

    {
        offset   => 0,
        style    => 3,
        expected => '0 seconds',
    },
    {
        offset   => 60*60+10,
        style    => 3,
        expected => '1 hour',
    },
    {
        offset   => 60*60*24+10,
        style    => 3,
        expected => '1 day',
    },
    {
        offset   => 60*60*24*7+10,
        style    => 3,
        expected => '2002/12/24',
    },
);
for my $d (@relative_date_data) {
    is(relative_date($timestamp, $epoch+$d->{offset}, $blog, '%Y/%m/%d', $d->{style}), $d->{expected}, "relative_date() (offset:$d->{offset}, style:$d->{style})");
}

is(days_in(2, 2002), '28', 'days_in()');
is(days_in(2, 2000), '29', 'days_in() (leap year)');


### encode and decode
my $script_tag = "<script>alert('test');alert(\"test\");</script>";
my $script_tag_encoded = '\\<s\\cript\\>alert(\\\'test\\\');alert(\\"test\\");\\<\\/s\\cript\\>';
is(encode_js($script_tag), $script_tag_encoded, 'encode_js()');
is(decode_js($script_tag_encoded), $script_tag, 'decode_js()');
is(encode_php("\\\$\"\n\r\t"), "\\\\\$\"\n\r\t", 'encode_php()');
is(encode_php("\\\$\"\n\r\t", 'qq'), '\\\\\\$\\"\\n\\r\\t', 'encode_php() (qq)');
is(encode_php("\\\$\"\n\r\t", 'here'), '\\\\\\$"\\n\\r\\t', 'encode_php() (here)');
my $url = 'http://www.example.com/?foo=bar&baz=10%';
my $url_encoded = 'http%3A%2F%2Fwww.example.com%2F%3Ffoo%3Dbar%26baz%3D10%25';
is(encode_url($url), $url_encoded, 'encode_url()');
is(decode_url($url_encoded), $url, 'decode_url()');


### escape
is(spam_protect('foo+bar@example.com'), 'foo+bar&#64;example&#46;com', 'spam_protect()');


### validation
is(is_valid_email('foo+bar@example.com'), 'foo+bar@example.com', 'is_valid_email() for valid value');
is(is_valid_email('foo:bar@example.com'), '0', 'is_valid_email() for invalid value');

is(is_valid_url('http://www.example.com/'), 'http://www.example.com/', 'is_valid_url() normal url');
is(is_valid_url('http;//www.example.com/'), 'http://www.example.com/', 'is_valid_url() fixing typo (1)');
is(is_valid_url('http//www.example.com/'), 'http://www.example.com/', 'is_valid_url() fixing typo (2');
#is(is_valid_url('ftp://www.example.com/'), 'ftp://www.example.com/', 'is_valid_url() for ftp'); # Not support.
is(is_valid_url('https://www.example.com/'), 'https://www.example.com/', 'is_valid_url() ssl');
is(is_valid_url('https;//www.example.com/'), 'https://www.example.com/', 'is_valid_url() fixing typo(3)');
is(is_valid_url('http://www.example.com:8080/'), 'http://www.example.com:8080/', 'is_valid_url() port');
ok(is_url('http://www.example.com/?foo=bar&baz=10%'), 'is_url() normal url');
ok(is_url('https://www.example.com/?foo=bar&baz=10%'), 'is_url() ssl');
ok(is_url('http://www.example.com:8080/?foo=bar&baz=10%'), 'is_url() port');
ok(! is_url('not a url'), 'is_url() not a url');
ok(! is_url('not http://_'), 'is_url() invalid url');


### other utilities
my $tb_content = <<__HTML__;
<html>
<head>
    <!--
<rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
         xmlns:trackback="http://madskills.com/public/xml/rss/module/trackback/"
         xmlns:dc="http://purl.org/dc/elements/1.1/">
<rdf:Description
    rdf:about="http://example.com/2002/12/24/1/index.html"
    trackback:ping="http://example.com/mt/mt-tb.cgi/9999"
    dc:title="Foo"
    dc:identifier="http://example.com/2002/12/24/1/index.html"
    dc:subject="Bar"
    dc:description="Foo Bar Foo Bar ..."
    dc:creator="Baz"
    dc:date="2002-12-24T10:30:45Z" />
</rdf:RDF>
-->
</head>
<body>
</body>
</html>
__HTML__
is_deeply(
    discover_tb(
        'http://example.com/2002/12/24/1/index.html',
        undef, \$tb_content
    ),
    {
        'permalink'      => 'http://example.com/2002/12/24/1/index.html',
        'title'          => 'Foo',
        'ping_url'       => 'http://example.com/mt/mt-tb.cgi/9999',
        'dc:identifier'  => 'http://example.com/2002/12/24/1/index.html',
        'dc:title'       => 'Foo',
        'dc:date'        => '2002-12-24T10:30:45Z',
        'dc:subject'     => 'Bar',
        'dc:description' => 'Foo Bar Foo Bar ...',
        'dc:creator'     => 'Baz',
        'rdf:about'      => 'http://example.com/2002/12/24/1/index.html',
        'trackback:ping' => 'http://example.com/mt/mt-tb.cgi/9999',
    },
    'discover_tb()'
);

my @list = (
    {v => 1},
    {v => 2},
    {v => 3},
    {v => 4},
);

mark_odd_rows(\@list);
is_deeply(\@list, [{v=>1,is_odd=>1},{v=>2,is_odd=>''},{v=>3,is_odd=>1},{v=>4,is_odd=>''}], 'mark_odd_rows()');

is(xliterate_utf8('Ã'), 'A', 'xliterate_utf8()');

{
    require File::Temp;
    my ($fh, $file) = File::Temp::tempfile(undef, DIR => MT->config->TempDir);
    close($fh);
    unlink($file);

    start_background_task(sub {
        open(my $fh, '>', $file);
        close($fh);
    });
    CORE::sleep(1);
    is(-e $file, '1', 'start_background_task()');
    unlink($file) if $file;
}

my $urls_content   = <<__URLS__;
Foo
http://example.com/path/to/index.html
Bar
http://www.example.com/foo/bar/index.html
__URLS__
my $urls_extracted = {
  'example.com/path/to/index.html' => 'example.com',
  'example.com/foo/bar/index.html' => 'example.com'
};
is_deeply({extract_urls($urls_content)}, $urls_extracted, 'extract_urls()');
is(extract_domain('example.com/foo/bar/index.html'), 'example.com', 'extract_domain()');
is_deeply([extract_domains($urls_content)], ['example.com', 'example.com'], 'extract_domains()');

is(is_valid_date('2002-12-24 09:30:45'), '1', 'valid date for is_valid_date()');
is(is_valid_date('2002-12-24T09:30:45'), '0', 'invalid string for is_valid_date()');
is(is_valid_date('2002-12-24 99:99:99'), '0', 'invalid value for is_valid_date()');

# Japanese character "あ"
my $utf8_e38182 = Encode::decode('utf8', "\xe3\x81\x82");
is(escape_unicode(Encode::encode('utf8', $utf8_e38182)), '&#12354;', 'escape_unicode()');
is(unescape_unicode('&#12354;'), $utf8_e38182, 'unescape_unicode()');

isa_ok(sax_parser(), 'XML::LibXML::SAX', 'sax_parser()');
is(asset_cleanup('<form mt:asset-id="1" contenteditable="false"><img src="http://example.com/img/foo.jpg" /></form>'), '<span><img src="http://example.com/img/foo.jpg" /></span>', 'asset_cleanup()');
is(caturl('http://example.com/', 'foo', '/bar', 'baz/', '/foo/'), 'http://example.com/foo/bar/baz/foo/', 'caturl()');
{
    my $ref;
    {
        my $str = 'Foo';
        $ref = \$str;
        weaken($ref);
    }
    is($ref, undef, 'weaken()');
}

ok(log_time(), 'log_time()');
is(make_string_csv('Foo,Bar'), '"Foo,Bar"', 'make_string_csv()');

my %accept_languages = qw(
    en-us en-us
    ja-jp ja
    de-DE de
    es-ve es
    fr-ca fr
    nl-nl nl
);
while (my($env, $expected) = each(%accept_languages)) {
    $ENV{HTTP_ACCEPT_LANGUAGE} = $env;
    is(browser_language(), $expected, "browser_language() for \"$env\"");
}

MT->config('EmbedDomainWhitelist', 'example.com');
my $taint_embed = <<__HTML__;
Content
<a href="http://example.com/foo.html" onclick="alert('test');">Foo</a>
<script type="text/javascript">
alert('test');
</script>
__HTML__
my $sanitized_embed = <<__HTML__;
Content
<a href="http://example.com/foo.html">Foo</a>
<script type="text/javascript"></script>
__HTML__
is(sanitize_embed($taint_embed), $sanitized_embed, 'sanitize_embed()');

is(extract_url_path('http://www.example.com/foo/bar.html?baz'), '/foo/bar.html', 'extract_url_path() with query');
is(extract_url_path('http://www.example.com/foo/bar.html#baz'), '/foo/bar.html', 'extract_url_path() with fragment');
is(break_up_text('FooBarBaz', 2), 'Fo oB ar Ba z', 'break_up_text()');
ok(dir_separator(), 'dir_separator()');
{
    my @members = ();
    my $counter = 0;
    my $sub = sub {
        $counter++;
        push(@members, ${ $_[0] });
    };
    deep_do({
        key1 => 'Foo',
        key2 => ['Bar', 'Baz'],
        key3 => undef,
    }, $sub);
    is_deeply([sort(grep($_, @members))], ['Bar', 'Baz', 'Foo'], 'result of deep_do()');
    is($counter, 4, 'a subroutine called 4 times in deep_do()');
}


{
    # deep copied (simple data)
    foreach my $data (1, \1, [1], {1=>1}, sub{}) {
        my $copied = deep_copy($data, 1);
        is_deeply($data, $copied, 'deep copied:' . (ref $data || $data));
    }
}

{
    # deep copied (complex data)
    my $data   = [1, \2, {3 => 4, 5 => {6 => 7}}, [8, 9]];
    my $copied = deep_copy($data, 2);
    is_deeply($data, $copied, 'deep copied complex data');

    $data->[0] += 1;
    ok($data->[0] != $copied->[0], 'deep copied: depth: 1');

    $data->[2]{3} += 1;
    ok($data->[2]{3} != $copied->[2]{3}, 'deep copied: depth: 2');

    $data->[2]{5}{6} += 1;
    ok($data->[2]{5}{6} == $copied->[2]{5}{6}, 'not deep copied: depth: 3');
}

{
    # shallow copied
    my $data   = [1, \2, {3 => 4, 5 => {6 => 7}}, [8, 9]];
    my $copied = deep_copy($data, 0);
    is_deeply($data, $copied, 'shallow copied complex data');
    $data->[0]  += 1;
    ok($data->[0] = $copied->[0], 'not deep copied');
}

{
    my $path;
    $path= '/foo/bar/baz';
    is( canonicalize_path( $path ), '/foo/bar/baz', 'Already canonicalized(abs)' );
    $path= '/foo/bar/0/baz';
    is( canonicalize_path( $path ), '/foo/bar/0/baz', 'Contains a path named "0"' );
    $path= 't/../t/08-util.t';
    is( canonicalize_path( $path ), File::Spec->catdir( 't', '08-util.t' ), 'canonicalize relative path' );
    $path= '/foo/../bar/baz';
    is( canonicalize_path( $path ), '/bar/baz', 'canonicalize absolute path' );
    $path= 'baz';
    is( canonicalize_path( $path ), 'baz', 'only filename supplied' );
    $path= '../../baz';
    is( canonicalize_path( $path ), '../../baz', 'relative parent path' );
}

done_testing();
