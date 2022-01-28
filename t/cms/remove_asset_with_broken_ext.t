#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";    # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;

BEGIN {
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT;
use MT::Test;
use MT::Test::App;
use MT::Test::Fixture;

$test_env->prepare_fixture('db');

my $objs = MT::Test::Fixture->prepare({
    website => [{ name => 'test site' }],
    asset   => [qw/test.jpg test.(jpg/],
});

my $admin = MT::Author->load(1);
my $asset = $objs->{image}{'test.(jpg'};

subtest 'Remove asset with a broken extension' => sub {
    ok !!MT->model('asset')->load($asset->id), "asset still exists";

    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode      => 'delete',
        _type       => 'asset',
        action_name => 'delete',
        blog_id     => 0,
        return_args => '__mode%3Dlist%26blog_id%3D0%26_type%3Dasset%26does_act%3D1',
        id          => $asset->id,
    });
    ok !$app->generic_error, "no error";
    ok !MT->model('asset')->load($asset->id), "asset does not exist anymore";
};

done_testing;
