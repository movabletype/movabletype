#!/usr/bin/perl

use strict;
use warnings;

BEGIN {
    $ENV{MT_CONFIG} = 'mysql-test.cfg';
}

use lib qw(t/lib lib extlib);
use Test::More;
use MT::Test qw( :app :db :data );

my $admin = MT::Author->load(1);

subtest 'search_replace' => sub {
    for my $blog_id ( 0, 1 ) {
        subtest 'blog_id=' . $blog_id => sub {
            my $app = _run_app(
                'MT::App::CMS',
                {   __test_user      => $admin,
                    __request_method => 'GET',
                    blog_id          => $blog_id,
                    __mode           => 'search_replace',
                }
            );
            my $out = delete $app->{__test_output};
            unlike( $out, qr/#formatted_text/,
                'The "boilerplate" tab is not displayed' );

            done_testing();
        };
    }

    done_testing();
};

subtest 'menu in website scope' => sub {
    my $website = MT->model('website')->load();
    my $app     = _run_app(
        'MT::App::CMS',
        {   __test_user => $admin,
            __mode      => 'dashboard',
            blog_id     => $website->id,
        },
    );
    my $out = delete $app->{__test_output};
    like( $out, qr/Boilerplate/,
        '"Boilerplate" menu is displayed in website scope' );

    done_testing();
};

done_testing();
