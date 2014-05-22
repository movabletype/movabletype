#!/usr/bin/perl

use strict;
use warnings;

use lib qw( lib extlib ../lib ../extlib t/lib );

BEGIN {
    $ENV{MT_CONFIG} = 'mysql-test.cfg';
}

use MT;
use MT::Test qw( :cms :db );
use MT::Test::Permission;
use Test::More;

# Create records
my $admin = MT::Author->load(1);
ok($admin);

my $app = MT->instance;
$app->user($admin);

my $website = MT::Website->load();
my $blog = MT::Test::Permission->make_blog( parent_id => $website->id, );

# Do tests
my $param = {};

subtest '5 websites and 5 blogs' => sub {
    foreach ( 0 .. 3 ) {
        my $w = MT::Test::Permission->make_website();
        my $b = MT::Test::Permission->make_blog( parent_id => $website->id, );

        $app->add_to_favorite_websites( $w->id );
        $app->add_to_favorite_blogs( $b->id );
    }
    is( MT::Website->count, 5, 'There are 5 websites.' );
    is( MT::Blog->count,    5, 'There are 5 blogs.' );
    is( scalar @{ $admin->favorite_websites },
        4, 'Administrator has 4 favorite_websites.' );
    is( scalar @{ $admin->favorite_blogs },
        4, 'Administrator has 4 favorite_blogs.' );

    subtest 'in system scope' => sub {
        $app->build_blog_selector($param);

        ok( $param->{selector_hide_website_chooser},
            'selector_hide_website_chooser is true.'
        );
        ok( $param->{fav_website_loop}, 'There is fav_website_loop.' );
        is( scalar @{ $param->{fav_website_loop} },
            5, 'fav_website_loop has 5 data.' );

        ok( $param->{selector_hide_blog_chooser},
            'selector_haide_blog_chooser is true.'
        );
        ok( $param->{fav_blog_loop}, 'There is fav_blog_loop.' );
        is( scalar @{ $param->{fav_blog_loop} },
            5, 'fav_blog_loop has 5 data.' );
    };

    subtest 'in website scope' => sub {
        $app->blog($website);
        $param = {};
        $app->build_blog_selector($param);

        ok( $param->{selector_hide_website_chooser},
            'selector_hide_website_chooser is true.'
        );
        ok( $param->{fav_website_loop}, 'There is fav_website_loop.' );
        is( scalar @{ $param->{fav_website_loop} },
            4, 'fav_website_loop has 4 data.' );

        ok( $param->{selector_hide_blog_chooser},
            'selector_haide_blog_chooser is true.'
        );
        ok( $param->{fav_blog_loop}, 'There is fav_blog_loop.' );
        is( scalar @{ $param->{fav_blog_loop} },
            5, 'fav_blog_loop has 5 data.' );
    };

    subtest 'in blog scope' => sub {
        $app->blog($blog);
        $param = {};
        $app->build_blog_selector($param);

        ok( $param->{selector_hide_website_chooser},
            'selector_hide_website_chooser is true.'
        );
        ok( $param->{fav_website_loop}, 'There is fav_website_loop.' );
        is( scalar @{ $param->{fav_website_loop} },
            4, 'fav_website_loop has 4 data.' );

        ok( $param->{selector_hide_blog_chooser},
            'selector_haide_blog_chooser is true.'
        );
        ok( $param->{fav_blog_loop}, 'There is fav_blog_loop.' );
        is( scalar @{ $param->{fav_blog_loop} },
            4, 'fav_blog_loop has 4 data.' );
    };
};

subtest '6 websites and 6 blogs' => sub {
    my $w = MT::Test::Permission->make_website();
    my $b = MT::Test::Permission->make_blog( parent_id => $website->id, );
    $app->add_to_favorite_websites( $w->id );
    $app->add_to_favorite_blogs( $b->id );

    is( MT::Website->count, 6, 'There are 6 websites.' );
    is( MT::Blog->count,    6, 'There are 6 blogs.' );
    is( scalar @{ $admin->favorite_websites },
        6, 'Administrator has 6 favorite_websites.' );
    is( scalar @{ $admin->favorite_blogs },
        6, 'Administrator has 6 favorite_blogs.' );

    subtest 'in system scope' => sub {
        $param = {};
        delete $app->{_blog};
        $app->build_blog_selector($param);

        ok( !$param->{selector_hide_website_chooser},
            'selector_hide_website_chooser is false.'
        );
        ok( $param->{fav_website_loop}, 'There is fav_website_loop.' );
        is( scalar @{ $param->{fav_website_loop} },
            5, 'fav_website_loop has 5 data.' );

        ok( !$param->{selector_hide_blog_chooser},
            'selector_hide_blog_chooser is false.'
        );
        ok( $param->{fav_blog_loop}, 'There is fav_blog_loop.' );
        is( scalar @{ $param->{fav_blog_loop} },
            5, 'fav_blog_loop has 5 data.' );

    };
    subtest 'in website scope' => sub {
        $param = {};
        $app->blog($website);
        $app->build_blog_selector($param);

        ok( !$param->{selector_hide_website_chooser},
            'selector_hide_website_chooser is false.'
        );
        ok( $param->{fav_website_loop}, 'There is fav_website_loop.' );
        is( scalar @{ $param->{fav_website_loop} },
            4, 'fav_website_loop has 4 data.' );

        ok( !$param->{selector_hide_blog_chooser},
            'selector_hide_blog_chooser is false.'
        );
        ok( $param->{fav_blog_loop}, 'There is fav_blog_loop.' );
        is( scalar @{ $param->{fav_blog_loop} },
            5, 'fav_blog_loop has 5 data.' );
    };
    subtest 'in blog scope' => sub {
        $param = {};
        $app->blog($blog);
        $app->build_blog_selector($param);

        ok( !$param->{selector_hide_website_chooser},
            'selector_hide_website_chooser is false.'
        );
        ok( $param->{fav_website_loop}, 'There is fav_website_loop.' );
        is( scalar @{ $param->{fav_website_loop} },
            4, 'fav_website_loop has 4 data.' );

        ok( !$param->{selector_hide_blog_chooser},
            'selector_hide_blog_chooser is false.'
        );
        ok( $param->{fav_blog_loop}, 'There is fav_blog_loop.' );
        is( scalar @{ $param->{fav_blog_loop} },
            4, 'fav_blog_loop has 4 data.' );
    };
};

subtest '11 websites and 11 blogs' => sub {
    foreach ( 0 .. 4 ) {
        my $w = MT::Test::Permission->make_website();
        my $b = MT::Test::Permission->make_blog( parent_id => $website->id, );
        $app->add_to_favorite_websites( $w->id );
        $app->add_to_favorite_blogs( $b->id );
    }

    is( MT::Website->count, 11, 'There are 11 websites.' );
    is( MT::Blog->count,    11, 'There are 11 blogs.' );
    is( scalar @{ $admin->favorite_websites },
        10, 'Administrator has 10 favorite_websites.' );
    is( scalar @{ $admin->favorite_blogs },
        10, 'Administrator has 10 favorite_blogs.' );

    subtest 'in system scope' => sub {
        $param = {};
        delete $app->{_blog};
        $app->build_blog_selector($param);

        ok( !$param->{selector_hide_website_chooser},
            'selector_hide_website_chooser is false.'
        );
        ok( $param->{fav_website_loop}, 'There is fav_website_loop.' );
        is( scalar @{ $param->{fav_website_loop} },
            5, 'fav_website_loop has 5 data.' );

        ok( !$param->{selector_hide_blog_chooser},
            'selector_hide_blog_chooser is false.'
        );
        ok( $param->{fav_blog_loop}, 'There is fav_blog_loop.' );
        is( scalar @{ $param->{fav_blog_loop} },
            5, 'fav_blog_loop has 5 data.' );
    };
    subtest 'in website scope' => sub {
        $param = {};
        $app->blog($website);
        $app->build_blog_selector($param);

        ok( !$param->{selector_hide_website_chooser},
            'selector_hide_website_chooser is false.'
        );
        ok( $param->{fav_website_loop}, 'There is fav_website_loop.' );
        is( scalar @{ $param->{fav_website_loop} },
            4, 'fav_website_loop has 4 data.' );

        ok( !$param->{selector_hide_blog_chooser},
            'selector_hide_blog_chooser is false.'
        );
        ok( $param->{fav_blog_loop}, 'There is fav_blog_loop.' );
        is( scalar @{ $param->{fav_blog_loop} },
            5, 'fav_blog_loop has 5 data.' );
    };
    subtest 'in blog scope' => sub {
        $param = {};
        $app->blog($blog);
        $app->build_blog_selector($param);

        ok( !$param->{selector_hide_website_chooser},
            'selector_hide_website_chooser is false.'
        );
        ok( $param->{fav_website_loop}, 'There is fav_website_loop.' );
        is( scalar @{ $param->{fav_website_loop} },
            4, 'fav_website_loop has 4 data.' );

        ok( !$param->{selector_hide_blog_chooser},
            'selector_hide_blog_chooser is false.'
        );
        ok( $param->{fav_blog_loop}, 'There is fav_blog_loop.' );
        is( scalar @{ $param->{fav_blog_loop} },
            4, 'fav_blog_loop has 4 data.' );
    };
};

subtest 'default widgets' => sub {
    my $expected = _expected_default_widgets();
    foreach (qw( system user website blog )) {
        my $got = $app->default_widgets_for_dashboard($_);
        is_deeply( $got, $expected->{$_},
            'Got correct widgets of ' . $_ . '.' );
    }

    $app->default_widgets_for_dashboard('dummy');
    ok( defined $app->request('default_widget:dummy'),
        'Cached widget data when data is empty.'
    );
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

