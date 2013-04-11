#!/usr/bin/perl

BEGIN {
    $ENV{MT_CONFIG} = 'mysql-test.cfg';
}

use lib 't/lib', 'lib', 'extlib', '../lib', '../extlib';
use MT::Test qw( :app :db );
use MT::Test::Permission;
use MT::Association;
use MT::Util;
use Test::More;

### Make test data

# Website
my $website        = MT::Test::Permission->make_website();
my $second_website = MT::Test::Permission->make_website();

# Blog
my $blog = MT::Test::Permission->make_blog( parent_id => $website->id, );
my $second_blog
    = MT::Test::Permission->make_blog( parent_id => $second_website->id, );

# Author
my $aikawa = MT::Test::Permission->make_author(
    name     => 'aikawa',
    nickname => 'Ichiro Aikawa',
);

my $ichikawa = MT::Test::Permission->make_author(
    name     => 'ichikawa',
    nickname => 'Jiro Ichikawa',
);

my $ukawa = MT::Test::Permission->make_author(
    name     => 'ukawa',
    nickname => 'Saburo Ukawa',
);

my $egawa = MT::Test::Permission->make_author(
    name     => 'egawa',
    nickname => 'Shiro Egawa',
);

my $ogawaa = MT::Test::Permission->make_author(
    name     => 'ogawa',
    nickname => 'Goro Ogawa',
);

my $admin = MT->model('author')->load(1);

# Role
my $create_post = MT::Test::Permission->make_role(
    name        => 'Create Post',
    permissions => "'create_post'",
);

my $designer = MT::Role->load( { name => MT->translate('Designer') } );

MT::Association->link( $aikawa, $create_post, $website );
MT::Association->link( $ukawa,  $create_post, $blog );

MT::Association->link( $ichikawa, $create_post, $second_website );
MT::Association->link( $egawa,    $create_post, $second_blog );

# Run tests
my ( $app, $out );

subtest 'Test in website scope' => sub {
    subtest 'Menu visibility check' => sub {
        $app = _run_app(
            'MT::App::CMS',
            {   __test_user => $admin,
                __mode      => 'dashboard',
                blog_id     => $website->id
            }
        );
        $out = delete $app->{__test_output};
        ok( $out, "Request: website dashboard" );
        my $link
            = $app->uri
            . '?__mode=view&amp;_type=entry&amp;blog_id='
            . $website->id;
        $link = quotemeta $link;
        like( $out, qr/$link/,
            '"Entries New" menu in website scope exists if admin' );
        my $fav_action_entry = 'fav-action-entry';
        like( $out, qr/$fav_action_entry/, '"Entry" in compose menus exists if admin'  );

        $app = _run_app(
            'MT::App::CMS',
            {   __test_user => $aikawa,
                __mode      => 'dashboard',
                blog_id     => $website->id
            }
        );
        $out = delete $app->{__test_output};
        ok( $out, "Request: website dashboard" );
        like( $out, qr/$link/,
            '"Entries New" menu in website scope exists if permitted user' );
        like( $out, qr/$fav_action_entry/, '"Entry" in compose menus exists if permitted user' );

        $app = _run_app(
            'MT::App::CMS',
            {   __test_user => $ichikawa,
                __mode      => 'dashboard',
                blog_id     => $website->id
            }
        );
        $out = delete $app->{__test_output};
        ok( $out, "Request: website dashboard" );
        unlike( $out, qr/$link/,
            '"Entries New" menu in website scope does not exist if other website'
        );
        unlike( $out, qr/$fav_action_entry/, '"Entry" in compose menus exists if other website' );

        $app = _run_app(
            'MT::App::CMS',
            {   __test_user => $ukawa,
                __mode      => 'dashboard',
                blog_id     => $website->id
            }
        );
        $out = delete $app->{__test_output};
        ok( $out, "Request: website dashboard" );
        unlike( $out, qr/$link/,
            '"Entries New" menu in website scope does not exist if child blog'
        );
        unlike( $out, qr/$fav_action_entry/, '"Entry" in compose menus exists if child blog' );

        $app = _run_app(
            'MT::App::CMS',
            {   __test_user => $ekawa,
                __mode      => 'dashboard',
                blog_id     => $website->id
            }
        );
        $out = delete $app->{__test_output};
        ok( $out, "Request: website dashboard" );
        unlike( $out, qr/$link/,
            '"Entries New" menu in website scope does not exist if other blog'
        );
        unlike( $out, qr/$fav_action_entry/, '"Entry" in compose menus exists if other blog' );

        $app = _run_app(
            'MT::App::CMS',
            {   __test_user => $ogawa,
                __mode      => 'dashboard',
                blog_id     => $website->id
            }
        );
        $out = delete $app->{__test_output};
        ok( $out, "Request: website dashboard" );
        unlike( $out, qr/$link/,
            '"Entries New" menu in website scope does not exist if other permission'
        );
        unlike( $out, qr/$fav_action_entry/, '"Entry" in compose menus exists if other permission' );

        done_testing();
    };

    done_testing();
};

done_testing();
