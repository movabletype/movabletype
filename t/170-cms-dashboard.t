#!/usr/bin/perl

use strict;
use warnings;

use lib qw( lib extlib ../lib ../extlib t/lib );

BEGIN {
    $ENV{MT_CONFIG} = 'mysql-test.cfg';
}

use MT;
use MT::CMS::Dashboard;
use MT::Test qw( :cms :db );
use MT::Test::Permission;
use Test::More;

# Create test data
my $admin = MT::Author->load(1);
ok( $admin, 'Load user.' );

my $website = MT::Website->load(1);
ok( $website, 'Load website.' );

my $app = MT->instance;
$app->user($admin);

subtest 'Comment count in website dashboard widget' => sub {

    # Do tests
    my $param = MT::CMS::Dashboard::_build_favorite_websites_data($app);
    is( $param->[0]{website_comment_count},
        0, 'Favorite websites has no comment.' );

    my $entry = MT::Test::Permission->make_entry( blog_id => $website->id, );
    ok( $entry, 'Create entry.' );

    my $e_comment = MT::Test::Permission->make_comment(
        blog_id  => $website->id,
        entry_id => $entry->id,
    );
    ok( $e_comment, 'Create entry comment.' );

    $param = MT::CMS::Dashboard::_build_favorite_websites_data($app);
    is( $param->[0]{website_comment_count},
        1, 'Favorite website has 1 comment.' );

    my $page = MT::Test::Permission->make_page( blog_id => $website->id, );
    ok( $page, 'Create page.' );

    my $p_comment = MT::Test::Permission->make_comment(
        blog_id  => $website->id,
        entry_id => $page->id,
    );
    ok( $p_comment, 'Create page comment.' );

    $param = MT::CMS::Dashboard::_build_favorite_websites_data($app);
    is( $param->[0]{website_comment_count},
        2, 'Favorite website has 2 comments.' );
};

subtest 'Default widgets' => sub {
    my $expected = _expected_default_widgets();

    require MT::CMS::Dashboard;
    my $widgets = MT::CMS::Dashboard::_default_widgets($app);

    is_deeply( $widgets, $expected, 'Correct default widgets' );
};

done_testing;

sub _expected_default_widgets {
    my $expected = {
        'system' => {
            recent_websites => {
                order => 100,
                set   => 'main',
            },
        },
        user => {
            notification_dashboard => {
                order => 100,
                set   => 'main',
            },
            site_stats => {
                order => 200,
                set   => 'main',
            },
            favorite_blogs => {
                order => 300,
                set   => 'main',
                param => { tab => 'website' },
            },
            personal_stats => {
                order => 400,
                set   => 'sidebar',
            },
            mt_news => {
                order => 500,
                set   => 'sidebar',
            },
        },
        website => {
            site_stats => {
                order => 100,
                set   => 'main',
            },
            recent_blogs => {
                order => 200,
                set   => 'main',
            },
        },
        blog => {
            site_stats => {
                order => 100,
                set   => 'main',
            },
        },
    };
    if ( MT->component('Loupe') ) {
        $expected->{user}{welcome_to_loupe} = {
            order => 150,
            set   => 'main',
        };
    }
    $expected;
}

