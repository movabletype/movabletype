#!/usr/bin/perl

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

use MT::Test;
use MT::Test::Permission;

MT::Test->init_app;

### Make test data
$test_env->prepare_fixture(sub {
    MT::Test->init_db;

    # Website
    my $website = MT::Test::Permission->make_website();

    # Blog
    my $blog = MT::Test::Permission->make_blog(
        parent_id => $website->id,
        name => 'my blog',
    );

    # Author
    my $aikawa = MT::Test::Permission->make_author(
        name     => 'aikawa',
        nickname => 'Ichiro Aikawa',
    );

    my $admin = MT::Author->load(1);

    # Role
    require MT::Role;
    my $site_admin
        = MT::Role->load( { name => MT->translate('Site Administrator') } );

    require MT::Association;
    MT::Association->link( $aikawa => $site_admin => $blog );
});

my $blog = MT::Blog->load( { name => 'my blog' } );

my $aikawa = MT::Author->load( { name => 'aikawa' } );

my $admin = MT::Author->load(1);

# Run
my ( $app, $out );

subtest 'mode = delete' => sub {
    my $role = MT::Test::Permission->make_role(
        name        => 'Create Post',
        permissions => "'create_post'",
    );
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'delete',
            _type            => 'role',
            id               => $role->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: delete" );
    ok( $out !~ m!permission=1!i, "delete by admin" );

    $role = MT::Test::Permission->make_role(
        name        => 'Create Post',
        permissions => "'create_post'",
    );
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'delete',
            _type            => 'role',
            id               => $role->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: delete" );
    ok( $out =~ m!permission=1!i, "delete by non permitted user" );

    done_testing();
};

done_testing();
