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
#use Test::More tests => 16;
use Test::More skip_all => 'MT::I18N functions were deprecated';

use utf8;

use Encode;
use MT;
use MT::Test;
use MT::Util;
my $mt = new MT;

MT->set_language('en_US');
require MT::I18N;

is(MT::I18N::const('LENGTH_ENTRY_TITLE_FROM_TEXT'), 5);

MT->config('PublishCharset', 'utf-8');
my $utf8_str = 'Iñtërnâtiônàlizætiøn';
is(length($utf8_str), 27); # make sure this is in bytes
is(MT::I18N::substr_text('this is a test', 0, 4), 'this');
is(MT::I18N::substr_text($utf8_str, 0, 4), 'Iñtë');
is(MT::I18N::length_text($utf8_str), 20);
is(MT::I18N::encode_text($utf8_str, undef, 'utf-8'), $utf8_str);
is(MT::Util::dirify($utf8_str), "internationalizaetion");

MT->config('PublishCharset', 'iso-8859-1');
my $latin1_str = $utf8_str;
Encode::from_to($latin1_str, 'utf-8', 'iso-8859-1');
is(length($latin1_str), 20);
is(MT::I18N::substr_text($latin1_str, 0, 4), substr($latin1_str, 0, 4));
is(MT::I18N::length_text($latin1_str), 20);
is(MT::I18N::encode_text($latin1_str, undef, 'utf-8'), $utf8_str);
is(MT::I18N::convert_high_ascii($latin1_str), 'Internationalizaetion');

MT->set_language('ja');
MT->config('UseJcodeModule', 0);
MT->config('PublishCharset', 'utf-8');

$utf8_str = 'サイバーショット、ネットウォークマンが当たる';
is(length($utf8_str), 66);
is(MT::I18N::substr_text($utf8_str, 0, 4), 'サイバー');
is(MT::I18N::length_text($utf8_str), 22);
is(MT::I18N::encode_text($utf8_str, undef, 'utf-8'), $utf8_str);
