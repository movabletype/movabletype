use strict;
use warnings;

use Test::More;

BEGIN {
    eval { require Test::PerlTidy }
        or plan skip_all => 'Test::PerlTidy is not installed';
}

Test::PerlTidy::run_tests(
    path       => '.',
    perltidyrc => './.perltidyrc',
    exclude    => [ qr/\/L10N\//, 'build/', qr/extlib\//, qr/t\// ],
    mute       => 1,
);

