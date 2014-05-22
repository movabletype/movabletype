#!/usr/bin/perl

use strict;
use warnings;

BEGIN {
    $ENV{MT_CONFIG} = 'mysql-test.cfg';
}

use Test::More;
use lib qw(lib extlib t/lib ../lib ../extlib);
use MT::Test qw(:app :db);
use MT::Test::Permission;
use MT::CMS::Page;

### Make test data

# Website
my $website        = MT::Test::Permission->make_website();
my $second_website = MT::Test::Permission->make_website();

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

my $admin = MT->model('author')->load(1);

# Role
my $manage_pages = MT::Test::Permission->make_role(
    name        => 'Manage Pages',
    permissions => "'manage_pages'",
);

my $designer = MT::Role->load( { name => MT->translate('Designer') } );

require MT::Association;
MT::Association->link( $aikawa, $manage_pages, $website );
MT::Association->link( $ukawa,  $designer,     $website );

MT::Association->link( $ichikawa, $manage_pages, $second_website );

# Run tests
subtest 'permission_filter methods check' => sub {
    my $app = MT->app;

    my $page = MT::Test::Permission->make_page(
        blog_id   => $website->id,
        author_id => $admin->id,
    );

    subtest 'admin' => sub {
        $app->user($admin);
        $app->blog($website);

        ok( MT::CMS::Page::can_save( undef, $app, $page ),
            "can_save with page by admin" );
        ok( MT::CMS::Page::can_save( undef, $app, $page ),
            "can_delete with page by admin" );

        ok( MT::CMS::Page::can_save( undef, $app, undef ),
            "can_save without page by admin" );
        ok( MT::CMS::Page::can_save( undef, $app, undef ),
            "can_delete without page by admin" );

        $app->blog($second_website);

        ok( MT::CMS::Page::can_save( undef, $app, undef ),
            "can_save without page by admin" );
        ok( MT::CMS::Page::can_save( undef, $app, undef ),
            "can_delete without page by admin" );

        done_testing();
    };

    subtest 'permitted user' => sub {
        $app->user($aikawa);
        $app->blog($second_website);

        ok( MT::CMS::Page::can_save( undef, $app, $page ),
            "can_save with page by permitted user"
        );
        ok( MT::CMS::Page::can_delete( undef, $app, $page ),
            "can_delete with page by permitted user"
        );

        $app->blog($website);

        ok( MT::CMS::Page::can_save( undef, $app, undef ),
            "can_save without page by permitted user"
        );
        ok( MT::CMS::Page::can_delete( undef, $app, undef ),
            "can_delete without page by permitted user"
        );

        done_testing();
    };

    subtest 'not permitted user' => sub {
        $app->blog($second_website);

        ok( !MT::CMS::Page::can_save( undef, $app, undef ),
            "can_save without page by a user permitted in other website" );
        ok( !MT::CMS::Page::can_delete( undef, $app, undef ),
            "can_delete without page by a user permitted in other website" );

        $app->user($ichikawa);
        $app->blog($website);

        ok( !MT::CMS::Page::can_save( undef, $app, undef ),
            "can_save without page by a user permitted in other website" );
        ok( !MT::CMS::Page::can_delete( undef, $app, undef ),
            "can_delete without page by a user permitted in other website" );

        $app->user($ukawa);

        ok( !MT::CMS::Page::can_save( undef, $app, $page ),
            "can_save with page by a user having other permission"
        );
        ok( !MT::CMS::Page::can_delete( undef, $app, $page ),
            "can_delete with page by a user having other permission"
        );

        ok( !MT::CMS::Page::can_save( undef, $app, undef ),
            "can_save without page by a user having other permission"
        );
        ok( !MT::CMS::Page::can_delete( undef, $app, undef ),
            "can_delete without page by a user having other permission"
        );

        done_testing();
    };

    done_testing();
};

done_testing();
