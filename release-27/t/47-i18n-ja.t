# test suite for MT::I18N modules

# english / utf-8
# english / latin-1
# french / utf-8
# french / latin-1
# japanese / utf-8
# japanese / shift_jis
# japanese / euc

# routines to test
#     substr_text
#     length_text
#     wrap_text
#     break_up_text
#     first_n_text
#     convert_high_ascii
#     const

use lib 't/lib', 'extlib', 'lib', '../lib', '../extlib';
use Test::More tests => 35;

use Encode;
use MT::Bootstrap;
use MT;
my $mt = new MT;

my ($utf8_str, $sjis_str, $euc_str, $utf8_substr, $euc_substr, $sjis_substr, $iso2022_str, $iso2022_substr);
$utf8_str = $euc_str = $iso2022_str = $sjis_str = 'サイバーショット、ネットウォークマンが当たる';
$iso2022_substr = $utf8_substr = $euc_substr = $sjis_substr = 'サイバー';
Encode::from_to($sjis_str, 'utf-8', 'shift_jis');
Encode::from_to($sjis_substr, 'utf-8', 'shift_jis');
Encode::from_to($euc_str, 'utf-8', 'euc-jp');
Encode::from_to($euc_substr, 'utf-8', 'euc-jp');
Encode::from_to($iso2022_str, 'utf-8', 'iso-2022-jp');
Encode::from_to($iso2022_substr, 'utf-8', 'iso-2022-jp');

MT->set_language('ja');
MT->config('UseJcodeModule', 0);

require MT::I18N;

is(MT::I18N::const('LENGTH_ENTRY_TITLE_FROM_TEXT'), 10);

MT->config('PublishCharset', 'utf-8');
is(length($utf8_str), 66);
is(MT::I18N::substr_text($utf8_str, 0, 4), $utf8_substr);
is(MT::I18N::length_text($utf8_str), 22);
is(lc $MT::I18N::ja::PKG, 'encode');
is(MT::I18N::encode_text($utf8_str, undef, 'utf-8'), $utf8_str);

MT->config('PublishCharset', 'Shift_JIS');
is(length($sjis_str), 44);
is(MT::I18N::substr_text($sjis_str, 0, 4), $sjis_substr);
is(MT::I18N::length_text($sjis_str), 22);
is(MT::I18N::encode_text($sjis_str, undef, 'utf-8'), $utf8_str);

MT->config('PublishCharset', 'euc-jp');
is(length($euc_str), 44);
is(MT::I18N::substr_text($euc_str, 0, 4), $euc_substr);
is(MT::I18N::length_text($euc_str), 22);
is(MT::I18N::encode_text($euc_str, undef, 'utf-8'), $utf8_str);

MT->config('PublishCharset', 'iso-2022-jp');
is(length($iso2022_str), 50);
is(MT::I18N::substr_text($iso2022_str, 0, 4), $iso2022_substr);
is(MT::I18N::length_text($iso2022_str), 22);
is(MT::I18N::encode_text($iso2022_str, undef, 'utf-8'), $utf8_str);

MT->config('UseJcodeModule', 1);
undef $MT::I18N::ja::PKG;

MT->config('PublishCharset', 'utf-8');
#binmode(STDOUT, 'utf-8');
#print "UTF-8: [$utf8_str]\n";
is(length($utf8_str), 66);
is(MT::I18N::substr_text($utf8_str, 0, 4), $utf8_substr);
is(MT::I18N::length_text($utf8_str), 22);
is(lc $MT::I18N::ja::PKG, 'jcode');
is(MT::I18N::encode_text($utf8_str, undef, 'utf-8'), $utf8_str);

MT->config('PublishCharset', 'Shift_JIS');
#binmode(STDOUT, 'Shift_JIS');
#print "Shift_JIS: [$sjis_str]\n";
is(length($sjis_str), 44);
is(MT::I18N::substr_text($sjis_str, 0, 4), $sjis_substr);
is(MT::I18N::length_text($sjis_str), 22);
is(MT::I18N::encode_text($sjis_str, undef, 'utf-8'), $utf8_str);

MT->config('PublishCharset', 'euc-jp');
#binmode(STDOUT, 'euc-jp');
#print "EUC-JP: [$euc_str]\n";
is(length($euc_str), 44);
is(MT::I18N::substr_text($euc_str, 0, 4), $euc_substr);
is(MT::I18N::length_text($euc_str), 22);
is(MT::I18N::encode_text($euc_str, undef, 'utf-8'), $utf8_str);

MT->config('PublishCharset', 'iso-2022-jp');
#binmode(STDOUT, 'iso-2022-jp');
#print "ISO-2022-JP: [  $iso2022_str  ]\n";
is(length($iso2022_str), 50);
is(MT::I18N::substr_text($iso2022_str, 0, 4), $iso2022_substr);
is(MT::I18N::length_text($iso2022_str), 22);
is(MT::I18N::encode_text($iso2022_str, undef, 'utf-8'), $utf8_str);
