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

subtest 'boilerplate listing screen scope' => sub {
    my $website = MT->model('website')->load();
    my $blog    = MT->model('blog')->load({ class => 'blog' });

    my @scope_suite = (
        {
            name    => 'system',
            params  => { blog_id => 0 },
            allowed => 0,
        },
        {
            name    => 'user',
            params  => {},
            allowed => 0,
        },
        {
            name    => 'website',
            params  => { blog_id => $website->id },
            allowed => 1,
        },
        {
            name    => 'blog',
            params  => { blog_id => $blog->id },
            allowed => 1,
        },
    );

    foreach my $scope (@scope_suite) {
        subtest $scope->{name} => sub {
            my $app = MT::Test::App->new;
            $app->login($admin);
            $app->get_ok({
                __mode => 'list',
                _type  => 'formatted_text',
                %{ $scope->{params} },
            });

            if ($scope->{allowed}) {
                ok !$app->last_location, 'The listing screen is accessible';
                is $app->page_title, 'Manage Boilerplates',
                    'The boilerplate listing screen is displayed';
            } else {
                my $location = $app->last_location;
                ok $location, 'The request is redirected';
                is $location ? $location->query_param('__mode') : undef,
                    'dashboard', 'Redirected to the dashboard';
                isnt $app->page_title, 'Manage Boilerplates',
                    'The boilerplate listing screen is not displayed';
            }
        };
    }
};

done_testing();
