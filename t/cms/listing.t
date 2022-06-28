#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../../t/lib";    # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;

BEGIN {
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT;
use MT::Test;
use MT::Test::Permission;
use MT::Test::App;

$test_env->prepare_fixture('db');

MT::Test::Permission->make_website(name => 'my website & <test1>', description => 'my website & <test2>');

subtest '_availableRowsOption' => sub {
    require MT::CMS::Common;
    is(10, MT::CMS::Common::_availableRowsOption(10, 10, 20, 30), 'right option');
    is(20, MT::CMS::Common::_availableRowsOption(20, 10, 20, 30), 'right option');
    is(30, MT::CMS::Common::_availableRowsOption(30, 10, 20, 30), 'right option');
    is(10, MT::CMS::Common::_availableRowsOption(11, 10, 20, 30), 'right option');
    is(20, MT::CMS::Common::_availableRowsOption(19, 10, 20, 30), 'right option');
    is(30, MT::CMS::Common::_availableRowsOption(29, 10, 20, 30), 'right option');
    is(30, MT::CMS::Common::_availableRowsOption(31, 10, 20, 30), 'right option');
    is(10, MT::CMS::Common::_availableRowsOption(undef, 10, 20, 30), 'right option');
};

subtest 'move site modal initial' => sub {
    my $app = MT::Test::App->new;
    $app->login(MT::Author->load(1));

    $app->get_ok({
        __mode      => 'itemset_action',
        _type       => 'website',
        action_name => 'move_blogs',
        blog_id     => 0,
        return_args => '__mode=list',
        does_act    => 1,
        id          => 5,
        dialog      => 1,
    });
    ok($app->content =~ /&amp; &lt;test1&gt;/, 'name is escaped');
    ok($app->content =~ /&amp; &lt;test2&gt;/, 'description is escaped');
};

subtest 'move site modal search' => sub {
    my $app = MT::Test::App->new;
    $app->login(MT::Author->load(1));

    $app->post_ok({
        __mode => 'itemset_action',
        _type => 'blog',
        action_name => 'move_blogs',
        blog_id => 0,
        return_args => '__mode%3Dlist%26blog_id%3D0%26_type%3Dwebsite%26does_act%3D1',
        id => 5,
        dialog => 1,
        json => 1,
        search_type => 'website',
        search => 'my website',
    });
    ok($app->content =~ /&amp; &lt;test1&gt;/, 'name is escaped');
    ok($app->content =~ /&amp; &lt;test2&gt;/, 'description is escaped');
};

done_testing;
