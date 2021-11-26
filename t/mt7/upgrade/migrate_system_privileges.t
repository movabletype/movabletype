use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../../lib";    # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;

BEGIN {
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT::Test;
use MT::Test::Permission;
use MT::Test::Upgrade;

$test_env->prepare_fixture(sub {
    MT::Test->init_db;

    my $active_author = MT::Test::Permission->make_author(
        name   => 'active_author',
        status => MT::Author::ACTIVE(),
    );
    my $inactive_author = MT::Test::Permission->make_author(
        name   => 'inactive_author',
        status => MT::Author::INACTIVE(),
    );
});

subtest 'Upgrade inactive authors' => sub {
    my $active_author   = MT::Author->load({ name => 'active_author' });
    my $inactive_author = MT::Author->load({ name => 'inactive_author' });

    $active_author->can_sign_in_cms(0);
    $active_author->can_sign_in_data_api(0);
    $inactive_author->can_sign_in_cms(0);
    $inactive_author->can_sign_in_data_api(0);

    $active_author->save;
    $inactive_author->save;

    ok(!$active_author->can_sign_in_cms,        "Active author does not have sign_in_cms.");
    ok(!$active_author->can_sign_in_data_api,   "Active author does not have sign_in_data_api.");
    ok(!$inactive_author->can_sign_in_cms,      "Inactive author does not have sign_in_cms.");
    ok(!$inactive_author->can_sign_in_data_api, "Inactive author does not have sign_in_data_api.");

    MT::Test::Upgrade->upgrade(from => 7.0022);

    ok($active_author->can_sign_in_cms,        "Active author has sign_in_cms.");
    ok($active_author->can_sign_in_data_api,   "Active author has sign_in_data_api.");
    ok($inactive_author->can_sign_in_cms,      "Inactive author has sign_in_cms.");
    ok($inactive_author->can_sign_in_data_api, "Inactive author has sign_in_data_api.");
};

done_testing;
