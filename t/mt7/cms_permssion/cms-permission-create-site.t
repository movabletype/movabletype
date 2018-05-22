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

MT::Test->init_app;

### Make test data
$test_env->prepare_fixture(sub {
    MT::Test->init_db;

    # Site
    my $site = MT::Test::Permission->make_website( name => 'my website' );

    # Author
    my $user = MT::Test::Permission->make_author(
        name     => 'aikawa',
        nickname => 'Ichiro Aikawa',
    );

    # Role
    my $create_site_role = MT::Test::Permission->make_role(
        name        => 'Create Child Site',
        permissions => "'create_site'",
    );

    require MT::Association;
    MT::Association->link( $user => $create_site_role => $site );

});

require MT::Website;
my $site             = MT::Website->load( { name => 'my website' } );

require MT::Author;
my $admin            = MT::Author->load(1);
my $user             = MT::Author->load( { name => 'aikawa' } );

require MT::Role;
my $create_site_role = MT::Role->load( { name => 'Create Child Site' } );

# Run
my ( $app, $out );
subtest 'mode = save (new)' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $user,
            __request_method => 'POST',
            __mode           => 'save',
            _type            => 'blog',
            name             => 'BlogName',
            parent_id        => $site->id,
            blog_id          => $site->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: save" );
    ok( $out !~ m!permission=1!i, "save (new) by permitted user" );

    MT::Association->unlink( $user => $create_site_role => $site );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $user,
            __request_method => 'POST',
            __mode           => 'save',
            _type            => 'blog',
            name             => 'BlogName',
            parent_id        => $site->id,
            blog_id          => $site->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: save" );
    ok( $out =~ m!permission=1!i, "save (new) by permitted user" );

    done_testing();
};

done_testing();
