use strict;
use warnings;

use Test::PerlTidy;

run_tests(
    path       => '.',
    perltidyrc => './.perltidyrc',
    exclude    => [ qr/\/L10N\//, 'build/', 'extlib/', 't/' ],
    mute       => 1,
);

