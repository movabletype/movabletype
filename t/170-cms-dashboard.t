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

done_testing;

