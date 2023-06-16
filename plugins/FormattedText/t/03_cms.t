#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../../../t/lib";    # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;
BEGIN {
    $test_env = MT::Test::Env->new(
        DefaultLanguage => 'en_US',    ## for now
    );
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT::Test;
use MT::Test::App;

$test_env->prepare_fixture('db_data');

my $admin = MT::Author->load(1);

subtest 'search_replace' => sub {
    for my $blog_id (0, 1) {
        subtest 'blog_id=' . $blog_id => sub {
            my $app = MT::Test::App->new;
            $app->login($admin);
            $app->get_ok({
                blog_id => $blog_id,
                __mode  => 'search_replace',
            });
            $app->content_unlike(
                qr/#formatted_text/,
                'The "boilerplate" tab is not displayed'
            );
        };
    }
};

subtest 'menu in website scope' => sub {
    my $website = MT->model('website')->load();
    my $app     = MT::Test::App->new;
    $app->login($admin);
    $app->get_ok({
        __mode  => 'dashboard',
        blog_id => $website->id,
    });
    $app->content_like(
        qr/Boilerplate/,
        '"Boilerplate" menu is displayed in website scope'
    );
};

subtest 'boilerplate listing screen in system scope' => sub {
    plan 'skip_all';

    my $app = MT::Test::App->new;
    $app->login($admin);
    $app->get_ok({
        __mode  => 'list',
        _type   => 'formatted_text',
        blog_id => 0,
    });

    my $option = quotemeta('<label for="custom-prefs-blog_name">Website/Blog Name</label>');
    $app->content_like(
        qr/$option/,
        '"Website/Blog Name" option exists in boilerplate listing screen at system scope.'
    );

    my $column = quotemeta('<span class="col-label">Website/Blog Name</span>');
    $app->content_like(
        qr/$column/,
        '"Website/Blog Name" column exists in boilerplate listing screen at system scope.'
    );
};

done_testing();
