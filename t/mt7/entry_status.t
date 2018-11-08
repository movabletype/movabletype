use strict;
use warnings;

use FindBin;
use lib "$FindBin::Bin/../lib";    # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;

BEGIN {
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT::EntryStatus;

subtest 'status methods' => sub {
    is( MT::EntryStatus::HOLD(),      1, 'HOLD() is 1' );
    is( MT::EntryStatus::RELEASE(),   2, 'RELEASE() is 2' );
    is( MT::EntryStatus::REVIEW(),    3, 'REVIEW() is 3' );
    is( MT::EntryStatus::FUTURE(),    4, 'FUTURE() is 4' );
    is( MT::EntryStatus::JUNK(),      5, 'JUNK() is 5' );
    is( MT::EntryStatus::UNPUBLISH(), 6, 'REVIEW() is 6' );
};

subtest 'status_text method' => sub {
    is( MT::EntryStatus::status_text(1), 'Draft',     '1 returns Draft' );
    is( MT::EntryStatus::status_text(2), 'Publish',   '2 returns Publish' );
    is( MT::EntryStatus::status_text(3), 'Review',    '3 returns Review' );
    is( MT::EntryStatus::status_text(4), 'Future',    '4 returns Future' );
    is( MT::EntryStatus::status_text(5), 'Spam',      '5 returns Spam' );
    is( MT::EntryStatus::status_text(6), 'Unpublish', '6 returns Unpublish' );
};

subtest 'status_int method' => sub {
    is( MT::EntryStatus::status_int('Draft'),     1, 'Draft returns 1' );
    is( MT::EntryStatus::status_int('Publish'),   2, 'Publish returns 2' );
    is( MT::EntryStatus::status_int('Review'),    3, 'Review returns 3' );
    is( MT::EntryStatus::status_int('Future'),    4, 'Future returns 4' );
    is( MT::EntryStatus::status_int('Junk'),      5, 'Junk returns 5' );
    is( MT::EntryStatus::status_int('Spam'),      5, 'Spam returns 5' );
    is( MT::EntryStatus::status_int('Unpublish'), 6, 'Unpublish returns 6' );

    is( MT::EntryStatus::status_int('DRAFT'),     1, 'DRAFT returns 1' );
    is( MT::EntryStatus::status_int('PUBLISH'),   2, 'PUBLISH returns 2' );
    is( MT::EntryStatus::status_int('REVIEW'),    3, 'REVIEW returns 3' );
    is( MT::EntryStatus::status_int('FUTURE'),    4, 'Future returns 4' );
    is( MT::EntryStatus::status_int('JUNK'),      5, 'JUNK returns 5' );
    is( MT::EntryStatus::status_int('SPAM'),      5, 'SPAM returns 5' );
    is( MT::EntryStatus::status_int('UNPUBLISH'), 6, 'UNPUBLISH returns 6' );

    is( MT::EntryStatus::status_int('draft'),     1, 'draft returns 1' );
    is( MT::EntryStatus::status_int('publish'),   2, 'publish returns 2' );
    is( MT::EntryStatus::status_int('review'),    3, 'review returns 3' );
    is( MT::EntryStatus::status_int('future'),    4, 'future returns 4' );
    is( MT::EntryStatus::status_int('junk'),      5, 'junk returns 5' );
    is( MT::EntryStatus::status_int('spam'),      5, 'spam returns 5' );
    is( MT::EntryStatus::status_int('unpublish'), 6, 'unpublish returns 6' );
};

done_testing;

