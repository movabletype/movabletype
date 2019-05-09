use strict;
use warnings;

use Test::PerlTidy;

run_tests(
    path       => '.',
    perltidyrc => './.perltidyrc',
    exclude    => [ qr/\/L10N\//, 'build/', qr/extlib\//, qr/t\// ],
    mute       => 1,
);

