#!/usr/bin/perl

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

use MT::Test;
use MT::Test::Permission;
use MT::Test::Fixture::CmsPermission::Common1;
use MT::Test::App;

### Make test data
$test_env->prepare_fixture('cms_permission/common1');

my $blog = MT::Blog->load({ name => 'my blog' });

my $aikawa = MT::Author->load({ name => 'aikawa' });

my $admin = MT::Author->load(1);

subtest 'mode = delete' => sub {
    my $role = MT::Test::Permission->make_role(
        name        => 'Create Post',
        permissions => "'create_post'",
    );
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode => 'delete',
        _type  => 'role',
        id     => $role->id,
    });
    $app->has_no_permission_error("delete by admin");

    $role = MT::Test::Permission->make_role(
        name        => 'Create Post',
        permissions => "'create_post'",
    );
    $app = MT::Test::App->new('MT::App::CMS');
    $app->login($aikawa);
    $app->post_ok({
        __mode => 'delete',
        _type  => 'role',
        id     => $role->id,
    });
    $app->has_permission_error("delete by non permitted user");
};

done_testing();
