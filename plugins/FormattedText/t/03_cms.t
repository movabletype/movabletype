#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../../../t/lib"; # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;
BEGIN {
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;
}

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

subtest 'boilerplate listing screen in system scope' => sub {
    plan 'skip_all';

    my $app = _run_app(
        'MT::App::CMS',
        {   __test_user => $admin,
            __mode      => 'list',
            _type       => 'formatted_text',
            blog_id     => 0,
        },
    );
    my $out = delete $app->{__test_output};

    my $option = quotemeta(
        '<label for="custom-prefs-blog_name">Website/Blog Name</label>');
    like( $out, qr/$option/,
        '"Website/Blog Name" option exists in boilerplate listing screen at system scope.'
    );

    my $column
        = quotemeta('<span class="col-label">Website/Blog Name</span>');
    like( $out, qr/$column/,
        '"Website/Blog Name" column exists in boilerplate listing screen at system scope.'
    );

    done_testing();
};

done_testing();
