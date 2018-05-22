#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";    # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;
use JSON;

BEGIN {
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT::Test;
use MT::Test::Permission;

MT::Test->init_app;

### Make test data
$test_env->prepare_fixture(
    sub {
        MT::Test->init_db;

        # Site
        my $site = MT::Test::Permission->make_website( name => 'my website' );

        # Author
        my $user = MT::Test::Permission->make_author(
            name     => 'aikawa',
            nickname => 'Ichiro Aikawa',
        );

        # Role
        my $manage_category_set_role = MT::Test::Permission->make_role(
            name        => 'Manage Category Set',
            permissions => "'manage_category_set'",
        );

        require MT::Association;
        MT::Association->link( $user => $manage_category_set_role => $site );
        my $category_set = MT::Test::Permission->make_category_set(
            blog_id => $site->id,
            name    => 'test category set',
        );
        my $category_set2 = MT::Test::Permission->make_category_set(
            blog_id => $site->id,
            name    => 'test category set2',
        );
        my $category = MT::Test::Permission->make_category(
            label           => 'test category',
            category_set_id => $category_set2->id
        );
    }
);

require MT::Website;
my $site = MT::Website->load( { name => 'my website' } );

require MT::Author;
my $admin = MT::Author->load(1);
my $user = MT::Author->load( { name => 'aikawa' } );

require MT::Role;
my $manage_category_set_role
    = MT::Role->load( { name => 'Manage Category Set' } );

require MT::CategorySet;
my $category_set  = MT::CategorySet->load( { name => 'test category set' } );

# Run
my ( $app, $out );
subtest 'mode = list' => sub {
    MT::Association->link( $user => $manage_category_set_role => $site );
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $user,
            __request_method => 'POST',
            __mode           => 'list',
            _type            => 'category_set',
            blog_id          => $site->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: list" );
    ok( $out !~ m!permission=1!i, "list by permitted user" );

    MT::Association->unlink( $user => $manage_category_set_role => $site );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $user,
            __request_method => 'POST',
            __mode           => 'list',
            _type            => 'category_set',
            blog_id          => $site->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: list" );
    ok( $out =~ m!permission=1!i, "list by non permitted user" );

    done_testing();
};
subtest 'mode = view ( new )' => sub {
    MT::Association->link( $user => $manage_category_set_role => $site );
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $user,
            __request_method => 'POST',
            __mode           => 'view',
            _type            => 'category_set',
            blog_id          => $site->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: view" );
    ok( $out !~ m!permission=1!i, "view by permitted user" );

    MT::Association->unlink( $user => $manage_category_set_role => $site );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $user,
            __request_method => 'POST',
            __mode           => 'view',
            _type            => 'category_set',
            blog_id          => $site->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: view" );
    ok( $out =~ m!permission=1!i, "view by non permitted user" );

    done_testing();
};

subtest 'mode = save' => sub {
    local $ENV{HTTP_X_REQUESTED_WITH} = 'XMLHttpRequest';
    MT::Association->link( $user => $manage_category_set_role => $site );
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $user,
            __request_method => 'POST',
            __mode           => 'bulk_update_category',
            datasource       => 'category',
            is_category_set  => 1,
            set_name         => 'category_set',
            blog_id          => $site->id,
            objects          => JSON::to_json(
                [   {   id       => 1,
                        parent   => 0,
                        label    => 'test_category',
                        basename => 'test_category'
                    }
                ]
            ),
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: save" );
    ok( $out !~ m!permission=1!i, "save by permitted user" );

    MT::Association->unlink( $user => $manage_category_set_role => $site );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $user,
            __request_method => 'POST',
            __mode           => 'bulk_update_category',
            datasource       => 'category',
            is_category_set  => 1,
            set_name         => 'category_set2',
            blog_id          => $site->id,
            objects          => JSON::to_json(
                [   {   id       => 2,
                        parent   => 0,
                        label    => 'test_category2',
                        basename => 'test_category2'
                    }
                ]
            ),
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: save" );
    ok( $out =~ m!permission=1!i, "save by non permitted user" );

    done_testing();
};

subtest 'mode = view ( edit )' => sub {
    MT::Association->link( $user => $manage_category_set_role => $site );
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $user,
            __request_method => 'POST',
            __mode           => 'view',
            _type            => 'category_set',
            blog_id          => $site->id,
            id               => $category_set->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: view" );
    ok( $out !~ m!permission=1!i, "edit by permitted user" );

    MT::Association->unlink( $user => $manage_category_set_role => $site );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $user,
            __request_method => 'POST',
            __mode           => 'view',
            _type            => 'category_set',
            blog_id          => $site->id,
            id               => $category_set->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: view" );
    ok( $out =~ m!permission=1!i, "edit by non permitted user" );

    done_testing();
};

subtest 'mode = delet' => sub {
    MT::Association->link( $user => $manage_category_set_role => $site );
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $user,
            __request_method => 'POST',
            __mode           => 'delete',
            _type            => 'category_set',
            blog_id          => $site->id,
            id               => $category_set->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: view" );
    ok( $out !~ m!permission=1!i, "edit by permitted user" );

    MT::Association->unlink( $user => $manage_category_set_role => $site );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $user,
            __request_method => 'POST',
            __mode           => 'view',
            _type            => 'category_set',
            blog_id          => $site->id,
            id               => $category_set->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: view" );
    ok( $out =~ m!permission=1!i, "edit by non permitted user" );

    done_testing();
};

done_testing();
