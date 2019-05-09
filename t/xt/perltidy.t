use strict;
use warnings;

use Test::PerlTidy;
use version;

run_tests(
    path       => '.',
    perltidyrc => './.perltidyrc',
    exclude    => [ qr/\/L10N\//, 'build/', qr/extlib\//, qr/t\// ],
    mute       => 1,
    skip_all   => ( $^V < version->parse('5.14.0') ) ? 1 : 0,
);

