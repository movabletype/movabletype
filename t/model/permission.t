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

use MT;
use MT::Permission;

$test_env->prepare_fixture('db');

subtest 'can_upload' => sub {
    my $perm = MT::Permission->new(author_id => 1, blog_id => 1);
    ok !$perm->permissions, 'has no permissions';

    $perm->can_upload(1);
    ok $perm->has('upload'), 'has upload permission after call "can_upload(1)"';

    $perm->can_upload(0);
    ok !$perm->has('upload'), 'has no upload permission after call "can_upload(0)"';
};

done_testing;
