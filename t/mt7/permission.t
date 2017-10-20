use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib"; # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;
BEGIN {
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT;
use MT::Test qw( :db );
use MT::Test::Permission;

subtest 'can_manage_content_types' => sub {
    my $user1 = MT::Test::Permission->make_author;

    $user1->is_superuser(1);
    $user1->save or die $user1->errstr;
    ok( $user1->can_manage_content_types,
        'return true when the user is superuser'
    );

    $user1->is_superuser(0);
    $user1->can_manage_content_types(1);
    $user1->save or die $user1->errstr;
    ok( $user1->can_manage_content_types,
        'return true when the user has permission' );

    $user1->can_manage_content_types(0);
    $user1->save or die $user1->errstr;
    ok( !$user1->can_manage_content_types,
        'return false after revoking permission from user' );
};

done_testing;

